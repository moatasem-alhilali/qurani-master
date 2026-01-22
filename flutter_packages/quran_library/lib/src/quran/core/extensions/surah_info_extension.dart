part of '/quran.dart';

/// An extension on the `void` type to provide additional functionality
/// related to Surah information.
///
/// This extension is intended to add methods and properties that
/// enhance the handling and manipulation of Surah data within the
/// application.
extension SurahInfoExtension on void {
  /// Displays a bottomSheet widget with information about a specific Surah.
  ///
  /// This method shows a dialog containing details about the Surah specified
  /// by the [surahNumber]. The dialog is displayed in the given [context].
  ///
  /// Example:
  /// ```dart
  /// surahInfoDialogWidget(context, 1); // Displays information about Surah Al-Fatiha
  /// ```
  ///
  /// [context]: The BuildContext in which to display the bottomSheet.
  /// [surahNumber]: The number of the Surah to display information about.
  void surahInfoBottomSheetWidget(BuildContext context, int surahNumber,
      {SurahInfoStyle? surahStyle,
      String? languageCode,
      Size? deviceWidth,
      bool isDark = false}) {
    final quranCtrl = QuranCtrl.instance;
    final surah = quranCtrl.surahsList[surahNumber];
    final double height = surahStyle?.bottomSheetHeight ??
        MediaQuery.maybeOf(context)?.size.height ??
        600;
    final double width = surahStyle?.bottomSheetWidth ??
        MediaQuery.maybeOf(context)?.size.width ??
        400;

    // محاولة الحصول على سياق صالح لعرض النافذة المنبثقة
    // Try to get a valid context for showing bottom sheet
    BuildContext? validContext;

    // التحقق من أن السياق المرسل صالح
    // Check if passed context is valid
    try {
      if (context.mounted && context.findRenderObject() != null) {
        validContext = context;
        log('السياق المرسل صالح', name: 'TafsirUi');
      } else {
        log('السياق المرسل غير صالح، محاولة استخدام بديل', name: 'TafsirUi');
      }
    } catch (e) {
      log('خطأ في التحقق من السياق المرسل: $e', name: 'TafsirUi');
    }

    // إذا كان السياق المرسل غير صالح، نحاول استخدام Get.context
    // If passed context is invalid, try using Get.context
    if (validContext == null) {
      try {
        if (Get.context != null) {
          log('استخدام Get.context كخيار احتياطي', name: 'TafsirUi');
          validContext = Get.context;
        }
      } catch (e) {
        log('خطأ في استخدام Get.context: $e', name: 'TafsirUi');
      }
    }

    // إذا لم نتمكن من الحصول على سياق صالح
    // If we couldn't get a valid context
    if (validContext == null) {
      log('لا يوجد سياق صالح لعرض التفسير، يُرجى التأكد من تمرير سياق من شاشة نشطة',
          name: 'TafsirUi');
      // إظهار رسالة عن طريق GetX في حالة عدم توفر سياق صالح
      // Show message via GetX if no valid context is available
      try {
        // Get.snackbar(
        //   'خطأ',
        //   'لا يمكن عرض التفسير، يرجى المحاولة مرة أخرى',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.white,
        //   colorText: Colors.white,
        // );
      } catch (_) {
        // تجاهل الأخطاء هنا لأننا في وضع معالجة الخطأ بالفعل
        // Ignore errors here as we're already handling errors
      }
      return;
    }
    showModalBottomSheet(
      context: validContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: height,
        maxWidth: width,
      ),
      // تحسين شكل الشاشة المنبثقة
      // Improve bottom sheet appearance
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext modalContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: height * .9,
          width: width,
          decoration: BoxDecoration(
            color: surahStyle?.backgroundColor ??
                (isDark ? const Color(0xff232323) : Colors.white),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
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
            children: [
              // خط فاصل جمالي علوي
              Container(
                width: 60,
                height: 5,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Flexible(
                child: Container(
                  height: height,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // عنوان السورة بشكل احترافي
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                AssetsPath.assets.suraNum,
                                height: 40,
                                width: 40,
                                colorFilter: ColorFilter.mode(
                                    surahStyle?.surahNameColor ??
                                        AppColors.getTextColor(isDark),
                                    BlendMode.srcIn),
                              ),
                              Transform.translate(
                                offset: const Offset(0, 1),
                                child: Text(
                                  '${surah.number}'
                                      .convertNumbersAccordingToLang(
                                          languageCode: languageCode ?? 'ar'),
                                  style: TextStyle(
                                      color: surahStyle?.surahNumberColor ??
                                          AppColors.getTextColor(isDark),
                                      fontFamily: "kufi",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      height: 2,
                                      package: "quran_library"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: surahStyle?.primaryColor
                                      ?.withValues(alpha: 0.08) ??
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text(
                              surah.number.toString(),
                              style: TextStyle(
                                color: surahStyle?.surahNameColor ??
                                    AppColors.getTextColor(isDark),
                                fontFamily: "surahName",
                                fontSize: 38,
                                package: "quran_library",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      // معلومات السورة
                      Container(
                        height: 38,
                        width: deviceWidth?.width ?? double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: surahStyle?.primaryColor ??
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: .10),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              width: 1,
                              color: surahStyle?.primaryColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: .30),
                            )),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Text(
                                  surah.revelationType.tr,
                                  style: TextStyle(
                                      color: surahStyle?.titleColor ??
                                          AppColors.getTextColor(isDark),
                                      fontFamily: "kufi",
                                      fontSize: 14,
                                      height: 2,
                                      package: "quran_library"),
                                ),
                              ),
                            ),
                            modalContext.verticalDivider(
                                height: 30,
                                color: AppColors.getTextColor(isDark)),
                            Expanded(
                              flex: 4,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Center(
                                  child: Text(
                                    '${surahStyle?.ayahCount ?? 'عدد الآيات'}: ${surah.ayahsNumber}'
                                        .convertNumbersAccordingToLang(
                                            languageCode: languageCode ?? 'ar'),
                                    style: TextStyle(
                                        color: surahStyle?.titleColor ??
                                            AppColors.getTextColor(isDark),
                                        fontFamily: "kufi",
                                        fontSize: 14,
                                        height: 2,
                                        package: "quran_library"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Flexible(
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // شريط التبويبات
                              Container(
                                height: 38,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                    color: surahStyle?.primaryColor ??
                                        Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: .10),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    border: Border.all(
                                      width: 1,
                                      color: surahStyle?.primaryColor ??
                                          Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: .30),
                                    )),
                                child: TabBar(
                                  unselectedLabelColor: Colors.grey,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  dividerColor: Colors.transparent,
                                  indicatorColor: surahStyle?.primaryColor ??
                                      Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: .20),
                                  indicatorWeight: 3,
                                  labelStyle: TextStyle(
                                    color: surahStyle?.titleColor ??
                                        AppColors.getTextColor(isDark),
                                    fontFamily: 'kufi',
                                    fontSize: 12,
                                    package: "quran_library",
                                  ),
                                  unselectedLabelStyle: TextStyle(
                                    color: surahStyle?.titleColor ??
                                        AppColors.getTextColor(isDark),
                                    fontFamily: 'kufi',
                                    fontSize: 12,
                                    package: "quran_library",
                                  ),
                                  indicator: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: surahStyle?.indicatorColor ??
                                        Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: .20),
                                  ),
                                  tabs: [
                                    Tab(
                                        text: surahStyle?.firstTabText ??
                                            'أسماء السورة'),
                                    Tab(
                                        text: surahStyle?.secondTabText ??
                                            'عن السورة'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: <Widget>[
                                    // تبويب أسماء السورة
                                    SingleChildScrollView(
                                      child: Container(
                                        width: width,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: surahStyle?.backgroundColor ??
                                              (isDark
                                                  ? const Color(0xff1E1E1E)
                                                  : Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.10),
                                              blurRadius: 8,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          border: Border.symmetric(
                                            horizontal: BorderSide(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.18),
                                              width: 1.2,
                                            ),
                                          ),
                                        ),
                                        child: ArabicJustifiedRichText(
                                          excludedWords: const ['محمد'],
                                          textSpan: TextSpan(
                                            children: [
                                              TextSpan(
                                                children: surah.surahNames
                                                    .customTextSpans(),
                                                style: TextStyle(
                                                  color: surahStyle
                                                          ?.textColor ??
                                                      AppColors.getTextColor(
                                                          isDark),
                                                  fontFamily: "naskh",
                                                  fontSize: 22,
                                                  height: 2,
                                                  package: "quran_library",
                                                ),
                                              ),
                                              TextSpan(
                                                children: surah
                                                    .surahNamesFromBook
                                                    .customTextSpans(),
                                                style: TextStyle(
                                                  color: surahStyle
                                                          ?.textColor ??
                                                      AppColors.getTextColor(
                                                          isDark),
                                                  fontFamily: "naskh",
                                                  fontSize: 18,
                                                  height: 2,
                                                  package: "quran_library",
                                                ),
                                              )
                                            ],
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
                                    // تبويب عن السورة
                                    SingleChildScrollView(
                                      child: Container(
                                        width: width,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: surahStyle?.backgroundColor ??
                                              (isDark
                                                  ? const Color(0xff1E1E1E)
                                                  : Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.10),
                                              blurRadius: 8,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          border: Border.symmetric(
                                            horizontal: BorderSide(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.18),
                                              width: 1.2,
                                            ),
                                          ),
                                        ),
                                        child: ArabicJustifiedRichText(
                                          excludedWords: const ['محمد'],
                                          textSpan: TextSpan(
                                            children: [
                                              TextSpan(
                                                children: surah.surahInfo
                                                    .customTextSpans(),
                                                style: TextStyle(
                                                  color: surahStyle
                                                          ?.textColor ??
                                                      AppColors.getTextColor(
                                                          isDark),
                                                  fontFamily: "naskh",
                                                  fontSize: 22,
                                                  height: 2,
                                                  package: "quran_library",
                                                ),
                                              ),
                                              TextSpan(
                                                children: surah
                                                    .surahInfoFromBook
                                                    .customTextSpans(),
                                                style: TextStyle(
                                                  color: surahStyle
                                                          ?.textColor ??
                                                      AppColors.getTextColor(
                                                          isDark),
                                                  fontFamily: "naskh",
                                                  fontSize: 18,
                                                  height: 2,
                                                  package: "quran_library",
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
