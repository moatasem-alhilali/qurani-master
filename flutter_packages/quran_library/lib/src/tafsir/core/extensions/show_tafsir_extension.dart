part of '../../tafsir.dart';

/// GlobalKey للوصول إلى سياق التطبيق الرئيسي كحل طوارئ
/// GlobalKey to access main app context as emergency solution
final GlobalKey<NavigatorState> tafsirNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'tafsirNavigatorKey');

extension ShowTafsirExtension on void {
  /// دالة مساعدة لتهيئة بيانات التفسير
  /// Helper function to initialize tafsir data
  Future<void> _initializeTafsirData({
    required int ayahUQNum,
    required int pageIndex,
  }) async {
    try {
      log('بدء تهيئة بيانات التفسير', name: 'TafsirUi');

      TafsirCtrl tafsirCtrl = TafsirCtrl.instance;
      // QuranCtrl.instance.state.currentPageNumber.value = pageIndex + 1;

      // تحقق من أن التفسير أو الترجمة جاهزة
      // Check if tafsir or translation is ready
      if (tafsirCtrl.selectedTafsir.isTafsir) {
        // tafsirCtrl.closeAndReinitializeDatabase();
        await tafsirCtrl.fetchData(pageIndex + 1);
      } else {
        await tafsirCtrl.fetchTranslate();
      }

      log('تم تحميل بيانات التفسير بنجاح', name: 'TafsirUi');
    } catch (e) {
      log('خطأ في تهيئة التفسير: $e', name: 'TafsirUi');
      rethrow; // إعادة طرح الخطأ ليتم التعامل معه في واجهة المستخدم
    }
  }

  /// -------- [onTap] --------
  /// عرض تفسير الآية عند النقر عليها
  /// Shows Tafsir when an ayah is tapped
  Future<void> showTafsirOnTap({
    required BuildContext context,
    required int ayahNum,
    required int pageIndex,
    required int ayahUQNum,
    required int ayahNumber,
    bool? isDark,
    TafsirStyle? externalTafsirStyle,
  }) async {
    // شرح: هذا السطر لطباعة رسالة عند استدعاء الدالة للتأكد من تنفيذها
    // Explanation: This line logs when the function is called for debugging
    log('showTafsirOnTap called', name: 'TafsirUi');

    // تحديد قيمة isDark مبدئيًا إذا لم يتم تمريرها
    // Set default value for isDark if not passed
    final bool isDarkMode = isDark ?? false;
    // حل الـ tafsirStyle النهائي قبل عرض النافذة المنبثقة
    // Resolve final tafsirStyle before showing bottom sheet
    final TafsirStyle resolvedTafsirStyle = externalTafsirStyle ??
        (TafsirTheme.of(context)?.style ??
            TafsirStyle.defaults(
              isDark: isDarkMode,
              context: context,
            ));

    final String styleSource = externalTafsirStyle != null
        ? 'passed'
        : (TafsirTheme.of(context)?.style != null ? 'theme' : 'defaults');
    log('TafsirStyle source=$styleSource width=${resolvedTafsirStyle.widthOfBottomSheet} height=${resolvedTafsirStyle.heightOfBottomSheet}',
        name: 'TafsirUi');

    // عرض النافذة المنبثقة فوراً مع تحميل البيانات داخلها
    // Show bottom sheet immediately with data loading inside
    try {
      log('عرض نافذة التفسير مع تحميل البيانات بالتوازي', name: 'TafsirUi');

      log('resolvedTafsirStyle.widthOfBottomSheet = ${resolvedTafsirStyle.widthOfBottomSheet}',
          name: 'TafsirUi');

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isDismissible: true,
        constraints: BoxConstraints(
          maxHeight: resolvedTafsirStyle.heightOfBottomSheet ??
              MediaQuery.of(context).size.height * 0.9,
          maxWidth: resolvedTafsirStyle.widthOfBottomSheet ??
              MediaQuery.of(context).size.width,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext modalContext) {
          // تهيئة بيانات التفسير داخل النافذة المنبثقة
          // Initialize tafsir data inside the bottom sheet

          // عرض واجهة التفسير بعد تحميل البيانات
          // Show tafsir interface after data loading
          return ShowTafseer(
            context: modalContext,
            ayahUQNumber: ayahUQNum,
            ayahNumber: ayahNumber,
            pageIndex: pageIndex,
            isDark: isDarkMode,
            tafsirStyle: resolvedTafsirStyle,
          );
        },
      );

      log('تم عرض نافذة التفسير بنجاح', name: 'TafsirUi');
    } catch (e) {
      log('خطأ في عرض نافذة التفسير المنبثقة: $e', name: 'TafsirUi');
    }
  }
}
