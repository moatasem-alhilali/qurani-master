import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// تشغيل Crashlytics و Analytics وربطهما بالتطبيق — في مكان واحد.
///
/// ## ما يُلتقط
///
/// **الأعطال (Crashlytics):**
/// - أخطاء إطار Flutter (البناء، الرسم، التخطيط) ← [FlutterError.onError].
/// - الأخطاء غير الملتقطة في الكود غير المتزامن ← [PlatformDispatcher.onError].
///   ويشمل ذلك أخطاء معالجات البلوك: bloc 8.1.1 يعيد رميها بعد `onError`،
///   فلا حاجة لالتقاطها في `BlocObserver` (كانت ستُسجَّل مرّتين).
/// - أخطاء العزل الرئيسي خارج سياق Flutter ← `Isolate.addErrorListener`.
/// - فشل تهيئة الخدمات عند الإقلاع ← [recordNonFatal]، ولو وقع قبل جاهزية
///   Crashlytics نفسها: يُحفظ ويُرسَل بعد التهيئة.
/// - أعطال أندرويد/iOS الأصلية ← تلقائيًا من SDK نفسه.
///
/// **الاستخدام (Analytics):**
/// - الأحداث التلقائية: أوّل فتح، الجلسات، تحديث التطبيق والنظام، مدّة التفاعل.
/// - كل شاشة يُنتقل إليها ← [navigatorObservers]. يشترط أن يحمل المسار اسمًا
///   (`RouteSettings.name`)؛ مسارات التطبيق كلّها بلا أسماء، فأُضيفت أسماؤها في
///   `navigator_manager.dart` وبقية مواضع التنقّل.
///
/// ## وضع التطوير
///
/// الجمع **مطفأ في debug**: أعطال التطوير وتنقّلات التجربة لا تختلط ببيانات
/// المستخدمين الحقيقيين، ولا يتغيّر عرض الأخطاء الأحمر المعتاد. يعمل في
/// release و profile.
abstract final class FirebaseMonitoring {
  static bool _ready = false;

  static final List<_PendingError> _pending = [];

  static List<NavigatorObserver> _navigatorObservers = const [];

  /// مراقبو التنقّل لـ `MaterialApp.navigatorObservers`.
  ///
  /// قائمة فارغة إن لم يُهيَّأ Firebase: `FirebaseAnalytics.instance` يرمي
  /// حينها، والتطبيق يجب أن يعمل بلا تحليلات لا أن يتوقّف.
  static List<NavigatorObserver> get navigatorObservers => _navigatorObservers;

  static bool get _collectionEnabled => !kDebugMode;

  /// يُنادى مرّة واحدة بعد `Firebase.initializeApp` وقبل `runApp`.
  static Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      // فشلت تهيئة Firebase (والخطأ مسجّل في main). لا تحليلات ولا تقارير،
      // لكن التطبيق يكمل عمله.
      return;
    }

    try {
      final crashlytics = FirebaseCrashlytics.instance;
      final analytics = FirebaseAnalytics.instance;

      await crashlytics.setCrashlyticsCollectionEnabled(_collectionEnabled);
      await analytics.setAnalyticsCollectionEnabled(_collectionEnabled);

      _navigatorObservers = [FirebaseAnalyticsObserver(analytics: analytics)];

      if (_collectionEnabled) {
        FlutterError.onError = crashlytics.recordFlutterFatalError;

        PlatformDispatcher.instance.onError = (error, stack) {
          crashlytics.recordError(error, stack, fatal: true);
          return true;
        };

        Isolate.current.addErrorListener(
          RawReceivePort((dynamic pair) async {
            final errorAndStack = pair as List<dynamic>;
            await crashlytics.recordError(
              errorAndStack.first,
              StackTrace.fromString(errorAndStack.last.toString()),
              fatal: true,
            );
          }).sendPort,
        );
      }

      _ready = true;
      await _flushPending();
    } catch (error) {
      debugPrint('FirebaseMonitoring: initialization failed: $error');
    }
  }

  /// يسجّل خطأ لم يُسقط التطبيق لكنه يستحق المتابعة.
  ///
  /// آمن النداء قبل [initialize]: يُحفظ الخطأ ويُرسَل حين تجهز Crashlytics.
  static Future<void> recordNonFatal(
    Object error,
    StackTrace stack, {
    required String reason,
  }) async {
    if (!_ready) {
      _pending.add(_PendingError(error, stack, reason));
      return;
    }
    if (!_collectionEnabled) return;

    try {
      await FirebaseCrashlytics.instance
          .recordError(error, stack, reason: reason);
    } catch (e) {
      debugPrint('FirebaseMonitoring: could not record "$reason": $e');
    }
  }

  static Future<void> _flushPending() async {
    final pending = List<_PendingError>.of(_pending);
    _pending.clear();
    for (final item in pending) {
      await recordNonFatal(item.error, item.stack, reason: item.reason);
    }
  }
}

final class _PendingError {
  const _PendingError(this.error, this.stack, this.reason);

  final Object error;
  final StackTrace stack;
  final String reason;
}
