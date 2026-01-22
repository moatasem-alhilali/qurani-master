part of '/quran.dart';

/// نمط مخصص لقسمَي أعلى/أسفل الصفحة (Top/Bottom) في المصحف.
///
/// الغرض الأساسي: نقل باراميترات المحتوى (juzName, sajdaName, surahName, topTitleChild)
/// من الودجتات إلى الثيم لسهولة التخصيص المركزي وتقليل تمرير القيم عبر الطبقات.
class TopBottomQuranStyle {
  /// نص اسم الجزء المستخدم في العنوان العلوي. مثال: "الجزء".
  final String? juzName;

  /// نص اسم السجدة المستخدم في القسم السفلي. مثال: "سجدة".
  final String? sajdaName;

  /// اسم السورة المعروض في الأعلى إن رغبت بتجاوز الاسم المستمد من البيانات.
  final String? surahName;

  /// ويدجت اختياري يسبق عنوان الأعلى (مثل شارة/عنوان مخصص).
  final Widget? customChild;

  /// اسم الحزب القابل للتغيير (يستبدل كلمة "الحزب" في العرض السفلي)
  final String? hizbName;

  /// لون اسم السورة في الأعلى
  final Color? surahNameColor;

  /// لون نص الجزء في الأعلى
  final Color? juzTextColor;

  /// لون نص الحزب/أرباعه في الأسفل
  final Color? hizbTextColor;

  /// لون رقم الصفحة في الأسفل
  final Color? pageNumberColor;

  /// لون إسم السجدة في الأسفل
  final Color? sajdaNameColor;

  const TopBottomQuranStyle({
    this.juzName,
    this.sajdaName,
    this.surahName,
    this.customChild,
    this.hizbName,
    this.surahNameColor,
    this.juzTextColor,
    this.hizbTextColor,
    this.pageNumberColor,
    this.sajdaNameColor,
  });

  TopBottomQuranStyle copyWith({
    String? juzName,
    String? sajdaName,
    String? surahName,
    Widget? topTitleChild,
    String? hizbName,
    Color? surahNameColor,
    Color? juzTextColor,
    Color? hizbTextColor,
    Color? pageNumberColor,
    Color? sajdaNameColor,
  }) {
    return TopBottomQuranStyle(
      juzName: juzName ?? this.juzName,
      sajdaName: sajdaName ?? this.sajdaName,
      surahName: surahName ?? this.surahName,
      customChild: topTitleChild ?? customChild,
      hizbName: hizbName ?? this.hizbName,
      surahNameColor: surahNameColor ?? this.surahNameColor,
      juzTextColor: juzTextColor ?? this.juzTextColor,
      hizbTextColor: hizbTextColor ?? this.hizbTextColor,
      pageNumberColor: pageNumberColor ?? this.pageNumberColor,
      sajdaNameColor: sajdaNameColor ?? this.sajdaNameColor,
    );
  }

  /// القيم الافتراضية للمحتوى.
  factory TopBottomQuranStyle.defaults({
    required bool isDark,
    required BuildContext context,
  }) {
    // مبدئياً، النصوص تعتمد على اللغة الافتراضية العربية المستخدمة حالياً في الودجتات.
    return const TopBottomQuranStyle(
      juzName: 'الجزء',
      sajdaName: 'سجدة',
      surahName: null,
      customChild: null,
      hizbName: 'الحزب',
      surahNameColor: Color(0xff77554B),
      juzTextColor: Color(0xff77554B),
      hizbTextColor: Color(0xff77554B),
      pageNumberColor: Color(0xff77554B),
      sajdaNameColor: Color(0xff77554B),
    );
  }
}
