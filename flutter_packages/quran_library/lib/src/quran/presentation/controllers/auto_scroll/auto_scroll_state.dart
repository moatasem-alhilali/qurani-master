part of '/quran.dart';

/// حالة السكرول التلقائي
///
/// [AutoScrollState] holds all reactive variables for auto-scroll feature
class AutoScrollState {
  /// هل السكرول التلقائي مفعّل؟
  final RxBool isActive = false.obs;

  /// هل السكرول متوقف مؤقتًا (بضغطة على الشاشة)؟
  final RxBool isPaused = false.obs;

  /// سرعة السكرول (بكسل/فريم) — 0.3 بطيء جدًا، 5.0 سريع
  final RxDouble speed = 1.5.obs;

  /// شرط التوقف الحالي
  final Rx<AutoScrollStopCondition> stopCondition =
      AutoScrollStopCondition.manual.obs;

  /// عدد الصفحات المطلوب (عند اختيار pageCount)
  final RxInt targetPageCount = 10.obs;

  /// الصفحة التي بدأ منها السكرول التلقائي
  final RxInt startPage = 1.obs;

  /// الصفحة المعروضة حاليًا أثناء السكرول
  final RxInt currentScrollPage = 1.obs;

  /// صفحة التوقف المحسوبة (0 = بلا حد)
  final RxInt targetStopPage = 0.obs;

  void dispose() {
    isActive.close();
    isPaused.close();
    speed.close();
    stopCondition.close();
    targetPageCount.close();
    startPage.close();
    currentScrollPage.close();
    targetStopPage.close();
  }
}
