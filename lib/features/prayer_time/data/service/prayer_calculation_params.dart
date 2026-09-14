import 'package:adhan/adhan.dart';

/// المصدر الموحّد لإعدادات حساب مواقيت الصلاة في التطبيق.
///
/// يعتمد التطبيق تقويم **أم القرى** (جامعة أم القرى - مكة المكرمة):
/// زاوية الفجر 18.5 درجة، والعشاء بعد المغرب بـ 90 دقيقة.
///
/// يجب استخدام [PrayerCalculationParams.build] في كل مكان يتم فيه إنشاء
/// [PrayerTimes] حتى تبقى المواقيت متطابقة بين الشاشة والإشعارات
/// وودجات الشاشة الرئيسية ووضع الصامت.
class PrayerCalculationParams {
  const PrayerCalculationParams._();

  /// طريقة الحساب المعتمدة في التطبيق.
  static const CalculationMethod method = CalculationMethod.umm_al_qura;

  /// المذهب المعتمد لحساب وقت العصر.
  static const Madhab madhab = Madhab.shafi;

  /// تُنشئ نسخة جديدة من معاملات الحساب.
  ///
  /// ملاحظة: [CalculationParameters] كائن قابل للتعديل، لذلك نُرجع نسخة
  /// جديدة في كل استدعاء بدلاً من مشاركة نسخة واحدة.
  static CalculationParameters build() =>
      method.getParameters()..madhab = madhab;
}
