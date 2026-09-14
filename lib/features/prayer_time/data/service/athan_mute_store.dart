import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:quran_app/core/notification/notification_orchestrator_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/features/setting_notification/data/repo/setting_notification_repo.dart';

/// حالة أذان كل صلاة، حاضرة في الذاكرة لحظةً بلحظة.
///
/// قاعدة البيانات تبقى المرجع الذي يقرأ منه المجدوِل وفلتر وقت الإطلاق —
/// هذا المخزن مرآة سريعة لها لا مصدر ثانٍ للحقيقة. الفائدة أن اللمسة على
/// الجرس تُغيّر [ValueNotifier] الخاص بتلك الصلاة فورًا، فيُعاد بناء
/// الأيقونة وحدها: لا `setState` على الصفّ، ولا إعادة بناء للشاشة، ولا
/// انتظار لقرص أو لقاعدة بيانات. الكتابة وإعادة الجدولة تجريان بعدها.
class AthanMuteStore {
  AthanMuteStore._();

  static final AthanMuteStore instance = AthanMuteStore._();

  /// الشروق ليس صلاة، فلا جرس له.
  static const _keyByPrayer = <Prayer, String>{
    Prayer.fajr: NotificationKeys.isNotificationAthanFagr,
    Prayer.dhuhr: NotificationKeys.isNotificationAthanDuhr,
    Prayer.asr: NotificationKeys.isNotificationAthanAsr,
    Prayer.maghrib: NotificationKeys.isNotificationAthanMagrib,
    Prayer.isha: NotificationKeys.isNotificationAthanIsha,
  };

  static String? keyFor(Prayer prayer) => _keyByPrayer[prayer];

  /// قيمة كل مفتاح كما هي في قاعدة البيانات.
  final Map<String, bool> _raw = {
    for (final key in NotificationKeys.athanKeys) key: true,
  };

  /// ما يظهر فعليًا للمستخدم = البوابة العامة ∧ مفتاح الصلاة.
  final Map<String, ValueNotifier<bool>> _effective = {
    for (final key in NotificationKeys.athanKeys)
      key: ValueNotifier<bool>(true),
  };

  final Map<String, Timer> _pending = {};

  bool _master = true;
  bool _hydrated = false;

  /// يُستمع إليه من كل جرس على حدة.
  ValueListenable<bool>? listenableFor(Prayer prayer) {
    final key = keyFor(prayer);
    return key == null ? null : _effective[key];
  }

  bool isEnabled(Prayer prayer) {
    final key = keyFor(prayer);
    return key == null || (_effective[key]?.value ?? true);
  }

  /// يقرأ الحالة المحفوظة مرة واحدة عند إقلاع التطبيق.
  Future<void> hydrate() async {
    if (_hydrated) return;
    _hydrated = true;

    try {
      final repo = sl<SettingNotificationRepo>();
      _master = await repo.getBool(NotificationKeys.isNotificationAllAthan);
      for (final key in NotificationKeys.athanKeys) {
        _raw[key] = await repo.getBool(key);
      }
      _recompute();
    } catch (_) {
      // تعذّرت القراءة: نُبقي القيم الافتراضية (مُفعّلة) ونسمح بإعادة
      // المحاولة لاحقًا بدل أن نقفل الميزة.
      _hydrated = false;
    }
  }

  /// يقلب حالة أذان صلاة واحدة. يرجع الحالة الجديدة فورًا.
  bool toggle(Prayer prayer) {
    final key = keyFor(prayer);
    if (key == null) return true;

    final next = !(_effective[key]?.value ?? true);

    // تشغيل صلاة والبوابة العامة مقفلة: نرفعها، وإلا بدت اللمسة بلا أثر.
    // بقية الصلوات تعود كلٌّ حسب مفتاحها هي، لا حسب هذه اللمسة.
    if (next && !_master) {
      _master = true;
      _schedulePersist(NotificationKeys.isNotificationAllAthan);
    }

    _raw[key] = next;
    _recompute();
    _schedulePersist(key);
    return next;
  }

  /// تُستدعى من مستودع الإعدادات بعد أي كتابة، فتبقى شاشة الإعدادات
  /// وقائمة المواقيت متطابقتين دون أن يعرف أحدهما بالآخر.
  void syncExternal(String key, bool enabled) {
    if (key == NotificationKeys.isNotificationAllAthan) {
      if (_master == enabled) return;
      _master = enabled;
      _recompute();
      return;
    }

    if (!_raw.containsKey(key) || _raw[key] == enabled) return;
    _raw[key] = enabled;
    _recompute();
  }

  void _recompute() {
    for (final key in NotificationKeys.athanKeys) {
      // ValueNotifier لا يُشعر المستمعين إلا عند تغيّر القيمة فعلًا،
      // فإعادة الحساب الزائدة لا تكلّف إعادة بناء.
      _effective[key]?.value = _master && (_raw[key] ?? true);
    }
  }

  /// يؤجّل الكتابة قليلًا حتى تندمج النقرات المتتابعة في كتابة واحدة،
  /// فلا تتراكم عمليات قاعدة بيانات وإعادة جدولة على نقرٍ سريع.
  void _schedulePersist(String key) {
    _pending[key]?.cancel();
    _pending[key] = Timer(const Duration(milliseconds: 350), () {
      _pending.remove(key);
      unawaited(_persist(key));
    });
  }

  Future<void> _persist(String key) async {
    try {
      final isMaster = key == NotificationKeys.isNotificationAllAthan;
      final value = isMaster ? _master : (_raw[key] ?? true);

      // يكتب في قاعدة البيانات، يمسح ذاكرة الإعدادات المؤقتة (١٠ ثوانٍ)،
      // ويلغي الإشعار المعلّق.
      await sl<SettingNotificationRepo>().toggle(key, value);

      // ثم يعيد التسليح: بدون هذه الخطوة يبقى رفع الكتم بلا أثر حتى
      // إعادة تشغيل التطبيق.
      final orchestrator = sl<NotificationOrchestratorService>();
      if (isMaster) {
        for (final athanKey in NotificationKeys.athanKeys) {
          await orchestrator.rescheduleAthanForKey(athanKey);
        }
      } else {
        await orchestrator.rescheduleAthanForKey(key);
      }
    } catch (_) {
      // فشل الحفظ لا يجوز أن يُسقط الواجهة؛ الحالة المعروضة تبقى كما
      // اختارها المستخدم وتُعاد المزامنة عند الإقلاع التالي.
    }
  }
}
