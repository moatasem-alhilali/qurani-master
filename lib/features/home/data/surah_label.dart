/// أسماء السور تأتي من مكتبة المصحف بصيغتين: بعضها مسبوق بكلمة «سُورَةُ»
/// وبعضها مجرّد. هذه الدالة توحّدهما فلا تظهر «سورة سورة الشعراء».
String surahLabel(String rawName) {
  final name = rawName.trim();
  if (name.isEmpty) return name;

  // نزع التشكيل قبل الفحص فقط — الاسم المعروض يبقى بتشكيله كما هو.
  final bare = name.replaceAll(RegExp('[ً-ْٰـ]'), '');
  if (bare.startsWith('سورة') || bare.startsWith('سوره')) {
    return name;
  }
  return 'سورة $name';
}
