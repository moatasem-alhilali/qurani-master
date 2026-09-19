import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/services/firebase_monitoring.dart';
import 'package:quran_app/features/home/data/surah_label.dart';
import 'package:quran_app/features/home_widgets/data/home_widget_ids.dart';
import 'package:quran_app/features/home_widgets/data/home_widget_payload.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_calculation_params.dart';
import 'package:quran_app/l10n/l10n.dart';
import 'package:quran_library/quran_library.dart';
import 'package:workmanager/workmanager.dart';

/// نقطة دخول المزامنة في الخلفية (WorkManager على أندرويد، BGAppRefresh على iOS).
///
/// تعمل في عزل منفصل بلا واجهة: لا شيء من تهيئة `main` موجود هنا، فتُهيَّأ
/// الإضافات والتخزين يدويًا قبل الحساب.
@pragma('vm:entry-point')
void tamaneenaWidgetsBackgroundDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    DartPluginRegistrant.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await CacheConfig.loadConfig();
      try {
        await QuranLibrary.init();
      } catch (error) {
        // بلا مصحف تُحفظ آيات المزامنة السابقة؛ المواقيت لا تتأثّر.
        debugPrint('HomeWidgetSync: Quran unavailable in background: $error');
      }
      return await HomeWidgetSync.syncNow(reason: 'background:$task');
    } catch (error) {
      debugPrint('HomeWidgetSync: background sync failed: $error');
      return false;
    }
  });
}

/// يحسب بيانات الودجات ويكتبها ويطلب إعادة رسمها — على المنصّتين.
///
/// ## متى يُستدعى
///
/// - عند الإقلاع ([initialize]): مزامنة فورية + تسجيل مهمّة الخلفية.
/// - عند كل تحميل للمواقيت وتغيير الموقع أو إعدادات الحساب ([requestSync])،
///   من `PrayerTimeBloc`.
/// - في الخلفية كل 12 ساعة.
///
/// ما بين ذلك **لا شيء مطلوب منه**: الودجات تحمل 30 يومًا وتختار الصلاة
/// الحالية بنفسها، وأندرويد يوقظها عند كل حدّ صلاة بمنبّه، وiOS بجدول زمني.
abstract final class HomeWidgetSync {
  static Timer? _debounce;
  static Future<bool>? _inFlight;
  static bool _rerunRequested = false;
  static bool _backgroundRegistered = false;

  /// معرّفات المهامّ من التطبيق القديم. كانت إحداها دورية كل 15 دقيقة وتبقى
  /// مسجّلة على أجهزة المستخدمين بعد التحديث ما لم تُلغَ صراحةً.
  static const List<String> _legacyTasks = [
    'tamaneena.home_widgets.refresh',
    'tamaneena.home_widgets.prayer_refresh',
  ];

  static Future<void> initialize() async {
    await syncNow(reason: 'launch');
    await _registerBackgroundSync();
  }

  /// يجمع الطلبات المتلاحقة في مزامنة واحدة.
  ///
  /// البلوك يطلبها عند كل تحميل ورجوع للتطبيق وتغيير موقع؛ قد تأتي ثلاثة
  /// طلبات في ثانية واحدة.
  static void requestSync() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      unawaited(syncNow(reason: 'request'));
    });
  }

  /// مزامنة فورية. إن كانت واحدة تجري يُعاد التشغيل بعدها مرّة واحدة، حتى لا
  /// تُكتب بيانات محسوبة قبل آخر تغيير.
  static Future<bool> syncNow({required String reason}) {
    final running = _inFlight;
    if (running != null) {
      _rerunRequested = true;
      return running;
    }

    final future = _sync(reason).whenComplete(() {
      _inFlight = null;
      if (_rerunRequested) {
        _rerunRequested = false;
        unawaited(syncNow(reason: 'rerun'));
      }
    });
    _inFlight = future;
    return future;
  }

  static Future<bool> _sync(String reason) async {
    try {
      await HomeWidget.setAppGroupId(HomeWidgetIds.appGroupId);
      // لغة التطبيق المحفوظة — عزل الخلفية لا يرى LocaleCubit.
      // DateFormat يرمي في عزل الخلفية ما لم تُحمَّل بيانات اللغة؛ في الواجهة
      // تحمّلها Material Localizations، وفي الخلفية لا أحد.
      final language = L10nService.savedLanguage;
      await initializeDateFormatting(language.code);

      final location = await DatabaseCoordinatesService().getSavedLocation();
      final payload = HomeWidgetPayloadBuilder.build(
        now: DateTime.now(),
        location: location,
        settings: location == null ? null : PrayerCalculationParams.load(),
        versePool: await _loadVersePool(),
        previousVerses: await _readPreviousVerses(),
        language: language,
      );

      await HomeWidget.saveWidgetData<String>(
        HomeWidgetIds.payloadKey,
        jsonEncode(payload),
      );
      await _reloadNativeWidgets();

      debugPrint(
        'HomeWidgetSync[$reason]: ${(payload['days']! as List).length} days, '
        '${(payload['verses']! as List).length} verses',
      );
      return true;
    } catch (error, stack) {
      debugPrint('HomeWidgetSync[$reason] failed: $error');
      unawaited(
        FirebaseMonitoring.recordNonFatal(
          error,
          stack,
          reason: 'Home widget sync failed ($reason)',
        ),
      );
      return false;
    }
  }

  /// كل منصّة بأسمائها فقط — تمرير اسم iOS على أندرويد كان يرمي
  /// `ClassNotFoundException: …null` لكل ودجت في النسخة السابقة.
  static Future<void> _reloadNativeWidgets() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      for (final provider in HomeWidgetIds.androidProviders) {
        try {
          await HomeWidget.updateWidget(qualifiedAndroidName: provider);
        } catch (error) {
          debugPrint('HomeWidgetSync: update $provider failed: $error');
        }
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      for (final kind in HomeWidgetIds.iosKinds) {
        try {
          await HomeWidget.updateWidget(iOSName: kind);
        } catch (error) {
          debugPrint('HomeWidgetSync: reload $kind failed: $error');
        }
      }
    }
  }

  /// آيات قصيرة تتّسع لها الودجت، بالرسم الإملائي.
  ///
  /// الودجت ترسم بخطّ النظام — خطوط المصحف في التطبيق لا تُشحن داخل امتداد
  /// iOS — وعلامات الرسم العثماني تظهر به مكسورة، فيُستعمل `ayaTextEmlaey`.
  static Future<List<WidgetVerse>> _loadVersePool() async {
    try {
      final quran = QuranCtrl.instance;
      await quran.ensureCoreDataLoaded();

      return [
        for (final ayah in quran.state.allAyahs)
          if (_fitsWidget(ayah.ayaTextEmlaey) &&
              (ayah.arabicName ?? '').trim().isNotEmpty)
            WidgetVerse(
              text: '﴿${ayah.ayaTextEmlaey.trim()}﴾',
              source: '${surahLabel(ayah.arabicName!)} · '
                  '${HomeWidgetPayloadBuilder.arabicDigits('${ayah.ayahNumber}')}',
            ),
      ];
    } catch (error) {
      debugPrint('HomeWidgetSync: verse pool unavailable: $error');
      return const [];
    }
  }

  static bool _fitsWidget(String text) {
    final length = text.trim().length;
    return length >= 25 && length <= 110;
  }

  static Future<List<Map<String, Object?>>> _readPreviousVerses() async {
    try {
      final raw = await HomeWidget.getWidgetData<String>(
        HomeWidgetIds.payloadKey,
      );
      if (raw == null || raw.isEmpty) return const [];
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return [
        for (final verse in (decoded['verses'] as List<dynamic>? ?? const []))
          Map<String, Object?>.from(verse as Map),
      ];
    } catch (_) {
      return const [];
    }
  }

  static Future<void> _registerBackgroundSync() async {
    if (_backgroundRegistered) return;
    _backgroundRegistered = true;

    try {
      await Workmanager().initialize(tamaneenaWidgetsBackgroundDispatcher);
      for (final legacy in _legacyTasks) {
        await Workmanager().cancelByUniqueName(legacy);
      }
      await Workmanager().registerPeriodicTask(
        HomeWidgetIds.backgroundTask,
        HomeWidgetIds.backgroundTask,
        frequency: const Duration(hours: 12),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
        constraints: Constraints(networkType: NetworkType.notRequired),
      );
    } catch (error) {
      _backgroundRegistered = false;
      debugPrint('HomeWidgetSync: background registration failed: $error');
    }
  }
}
