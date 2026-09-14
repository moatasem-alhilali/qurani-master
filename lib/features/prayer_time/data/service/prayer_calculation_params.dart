import 'package:adhan/adhan.dart';
import 'package:quran_app/core/util/hijri_date.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_calculation_settings.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_calculation_settings_store.dart';

/// المصدر الموحّد لإعدادات حساب مواقيت الصلاة في التطبيق.
///
/// الافتراضي هو تقويم **أم القرى**، ويستطيع المستخدم تغيير طريقة الحساب
/// والمذهب وبقية الخيارات من شاشة إعدادات أوقات الصلاة.
///
/// يجب استخدام [PrayerCalculationParams.build] في كل مكان يتم فيه إنشاء
/// [PrayerTimes] حتى تبقى المواقيت متطابقة بين الشاشة والإشعارات
/// وودجات الشاشة الرئيسية ووضع الصامت.
class PrayerCalculationParams {
  const PrayerCalculationParams._();

  static final PrayerCalculationSettingsStore _store =
      PrayerCalculationSettingsStore();

  /// الإعدادات المحفوظة حاليًا.
  static PrayerCalculationSettings load() => _store.load();

  /// تُنشئ معاملات الحساب من إعدادات المستخدم.
  ///
  /// [date] هو اليوم المراد حسابه، ويُستخدم لمعرفة ما إذا كان في رمضان
  /// لتطبيق تعديل العشاء. [settings] اختياري لتفادي إعادة القراءة من
  /// التخزين عند الحساب لعدة أيام أو مواقع في نفس العملية.
  static CalculationParameters build({
    DateTime? date,
    PrayerCalculationSettings? settings,
  }) {
    final resolved = settings ?? load();
    final params = resolved.method.getParameters()..madhab = resolved.madhab;

    if (resolved.isCustomMethod) {
      _applyCustomAngles(params, resolved);
    }

    // نستخدم القاعدة الفعلية لا المختارة: "زاوية الشفق" تُسقط الحساب مع
    // طريقة تحسب العشاء بفاصل زمني بلا زاوية مثل أم القرى.
    final highLatitudeRule = resolved.effectiveHighLatitudeOption.rule;
    if (highLatitudeRule != null) {
      params.highLatitudeRule = highLatitudeRule;
    }

    final manual = resolved.adjustments.clamped();
    params.adjustments = PrayerAdjustments(
      fajr: manual.fajr,
      sunrise: manual.sunrise,
      dhuhr: manual.dhuhr,
      asr: manual.asr,
      maghrib: manual.maghrib,
      isha: manual.isha + _ramadanIshaExtraMinutes(resolved, date),
    );

    return params;
  }

  /// يطبّق زوايا المستخدم على الإعداد المخصص.
  ///
  /// تبقى [CalculationParameters.ishaAngle] معرّفة دائمًا حتى في وضع
  /// الفاصل الزمني، لأن قاعدة "زاوية الشفق" تعتمد عليها.
  static void _applyCustomAngles(
    CalculationParameters params,
    PrayerCalculationSettings settings,
  ) {
    final custom = settings.customAngles.clamped();
    params
      ..fajrAngle = custom.fajrAngle
      ..ishaAngle = custom.ishaAngle
      ..maghribAngle = custom.maghribAngle
      ..ishaInterval =
          custom.ishaMode == PrayerIshaMode.interval ? custom.ishaInterval : 0;
  }

  /// تقويم أم القرى يضيف ٣٠ دقيقة على العشاء طوال شهر رمضان،
  /// فيصير الفاصل بعد المغرب ١٢٠ دقيقة بدل ٩٠.
  static int _ramadanIshaExtraMinutes(
    PrayerCalculationSettings settings,
    DateTime? date,
  ) {
    if (!settings.ramadanIshaAdjustmentEnabled ||
        !settings.supportsRamadanIshaAdjustment) {
      return 0;
    }
    final isRamadan = HijriDate.fromDate(date ?? DateTime.now()).isRamadan;
    return isRamadan ? PrayerCalculationSettings.ramadanIshaExtraMinutes : 0;
  }
}
