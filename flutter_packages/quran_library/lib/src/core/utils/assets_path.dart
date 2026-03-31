part of '/quran.dart';

abstract class _AssetsPath {
  _AssetsPath._();
  String get surahSvgBanner;
  String get surahSvgBannerDark;
  String get ayahBookmarked;
  String get sajdaIcon;
  String get suraNum;
  String get playArrow;
  String get pauseArrow;
  String get checkMark;
  String get alert;
  String get backward;
  String get rewind;
  String get surahsAudio;
  String get buttomSheet;
  String get options;
  String get backArrow;
  String get exclamation;
}

class AssetsPath implements _AssetsPath {
  // 1. اجعل الـ constructor خاصًا
  AssetsPath._();

  // 2. أنشئ نسخة ثابتة (singleton) للوصول إليها بسهولة
  static final AssetsPath assets = AssetsPath._();

  // 3. حدد البادئة مرة واحدة
  static const String _prefix = "packages/quran_library/assets/svg/";

  // 4. الدالة السحرية noSuchMethod
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      // استخراج اسم الـ getter (مثل: playArrow)
      final getterName = invocation.memberName.toString().split('"')[1];

      // تحويل اسم المتغير من camelCase (playArrow) إلى اسم الملف
      // هذا المثال يفترض أن اسم الملف هو نفسه اسم المتغير مع .svg
      // إذا كان اسم الملف مختلفًا (مثل play-arrow.svg)، سنحتاج لتعديل بسيط
      final fileName = '$getterName.svg';

      // إذا كانت أسماء ملفاتك تستخدم الشرطة السفلية (snake_case)
      // final fileName = '${_camelToSnake(getterName)}.svg';

      // إرجاع المسار الكامل
      return '$_prefix$fileName';
    }
    return super.noSuchMethod(invocation);
  }
}
