part of '../tafsir.dart';
// ملاحظة هامة: يجب تضمين هذا الودجت ضمن Scaffold عند الاستدعاء حتى لا تظهر مشكلة "No Scaffold widget found"
// Important: This widget must be shown inside a Scaffold to avoid "No Scaffold widget found" error.

// مثال للاستخدام الصحيح:
// Example for correct usage:
// showModalBottomSheet(
//   context: context,
//   builder: (_) => Scaffold(body: ShowTafseer(...)),
// );

class ShowTafseer extends StatelessWidget {
  late final int ayahUQNumber;
  final int pageIndex;
  final BuildContext context;
  final int ayahNumber;
  final bool isDark;
  final TafsirStyle? tafsirStyle;

  ShowTafseer({
    super.key,
    required this.ayahUQNumber,
    required this.ayahNumber,
    required this.pageIndex,
    required this.context,
    required this.isDark,
    this.tafsirStyle,
  });

  final tafsirCtrl = TafsirCtrl.instance;
  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    // حلّ النمط: استخدام الممرّر ثم Theme ثم الافتراضي
    final TafsirStyle s = tafsirStyle ??
        (TafsirTheme.of(context)?.style ??
            TafsirStyle.defaults(isDark: isDark, context: context));
    // شرح: نتأكد أن عناصر tafsirStyle غير فارغة لتجنب الخطأ
    // Explanation: Ensure tafsirStyle widgets are not null to avoid null check errors
    final tafsirNameWidget = s.tafsirNameWidget ?? const SizedBox();
    final double deviceHeight = MediaQuery.maybeOf(context)?.size.height ?? 600;
    final double deviceWidth = MediaQuery.maybeOf(context)?.size.width ?? 400;
    final double sheetHeight = s.heightOfBottomSheet ?? (deviceHeight * 0.9);
    final double sheetWidth = s.widthOfBottomSheet ?? deviceWidth;
    // تحسين الشكل: إضافة شريط علوي أنيق مع زر إغلاق واسم التفسير
    // UI Enhancement: Add a modern top bar with close button and tafsir name
    // final stored = GetStorage()
    //         .read<List<dynamic>>(quran._StorageConstants().loadedFontPages)
    //         ?.cast<int>() ??
    //     const <int>[];
    return GetBuilder<TafsirCtrl>(
      id: 'actualTafsirContent',
      builder: (tafsirCtrl) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: sheetHeight,
            width: sheetWidth,
            padding: const EdgeInsets.only(bottom: 16.0),
            margin: EdgeInsets.symmetric(
                horizontal: s.horizontalMargin ?? 0.0,
                vertical: s.verticalMargin ?? 0.0),
            decoration: BoxDecoration(
              color: s.backgroundColor ??
                  (isDark ? const Color(0xff1E1E1E) : Colors.white),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8),
                // خط فاصل جمالي
                Container(
                  width: 60,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: s.dividerColor ?? Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // شريط علوي احترافي
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      tafsirNameWidget,
                      ChangeTafsirDialog(tafsirStyle: s, isDark: isDark),
                      Row(
                        children: [
                          Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey.shade300),
                          const SizedBox(width: 8),
                          s.fontSizeWidget ??
                              fontSizeDropDown(
                                height: 30.0,
                                tafsirStyle: s,
                                isDark: isDark,
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
                // محتوى التفسير
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                    child: TafsirPagesBuild(
                      pageIndex: pageIndex,
                      ayahUQNumber: ayahUQNumber,
                      tafsirStyle: s,
                      isDark: isDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
