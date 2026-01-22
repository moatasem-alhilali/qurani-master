part of '/quran.dart';

/// A dialog displayed on long click of an Ayah to provide options like bookmarking and copying text.
///
/// This widget shows a dialog at a specified position with options to bookmark the Ayah in different colors
/// or copy the Ayah text to the clipboard. The appearance and behavior are influenced by the state of QuranCtrl.
class AyahMenuDialog extends StatelessWidget {
  /// Creates a dialog displayed on long click of an Ayah to provide options like bookmarking and copying text.
  ///
  /// This widget shows a dialog at a specified position with options to bookmark the Ayah in different colors
  /// or copy the Ayah text to the clipboard. The appearance and behavior are influenced by the state of QuranCtrl.
  const AyahMenuDialog({
    required this.context,
    super.key,
    this.ayah,
    // this.ayahFonts,
    required this.position,
    required this.index,
    required this.pageIndex,
    required this.isDark,
    this.externalTafsirStyle,
    this.onDismiss,
  });

  /// The AyahModel that is the target of the long click event.
  ///
  /// This is for the original fonts.
  final AyahModel? ayah;

  /// The AyahFontsModel that is the target of the long click event.
  ///
  /// This is for the downloaded fonts.
  // final AyahFontsModel? ayahFonts;

  /// The position where the dialog should appear on the screen.
  ///
  /// This is typically the position of the long click event.
  final Offset position;
  final int index;
  final int pageIndex;
  final BuildContext context;
  final bool isDark;
  final TafsirStyle? externalTafsirStyle;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext overlayContext) {
    final rootContext = context;

    void close() {
      QuranCtrl.instance.state.isShowMenu.value = false;
      onDismiss?.call();
    }

    final themed = AyahLongClickTheme.of(overlayContext)?.style;
    final s = themed ??
        AyahMenuStyle.defaults(isDark: isDark, context: overlayContext);

    // الحصول على نمط الصوت / Get audio style
    final sAudio =
        AyahAudioStyle.defaults(isDark: isDark, context: overlayContext);

    // محاولة الحصول على نمط مدير التحميل من الثيم أولاً / Try to get download manager style from theme first
    final themedDownloadManager =
        AyahDownloadManagerTheme.of(overlayContext)?.style;
    final sDownloadManager = themedDownloadManager ??
        AyahDownloadManagerStyle.defaults(
            isDark: isDark, context: overlayContext);

    final List<Widget> customMenuItems = s.customMenuItems ?? const [];

    // الحصول على أبعاد الشاشة والهوامش الآمنة / Get screen dimensions and safe area
    final screenSize = MediaQuery.of(overlayContext).size;
    final padding = MediaQuery.of(overlayContext).padding;

    // حساب العرض الفعلي للحوار بناءً على المحتوى / Calculate actual dialog width based on content
    int itemsCount = 5 +
        customMenuItems
            .length; // عدد الأيقونات الأساسية (3 ألوان + نسخ + تفسير) / Basic icons count
    if (customMenuItems.isNotEmpty) itemsCount += customMenuItems.length;
    double dialogWidth = (itemsCount * 40) +
        (itemsCount * 16) +
        40; // عرض كل أيقونة + التباعد + الهوامش / Icon width + spacing + margins
    double dialogHeight = 80; // ارتفاع الحوار / Dialog height

    // حساب الموضع الأفقي مع التأكد من البقاء داخل الشاشة / Calculate horizontal position ensuring it stays within screen
    double left = position.dx - (dialogWidth / 2);

    // التحقق من الحواف اليسرى واليمنى / Check left and right edges
    if (left < padding.left + 10) {
      left = padding.left + 10; // هامش من الحافة اليسرى / Left margin
    } else if (left + dialogWidth > screenSize.width - padding.right - 10) {
      left = screenSize.width -
          padding.right -
          dialogWidth -
          10; // هامش من الحافة اليمنى / Right margin
    }

    // حساب الموضع العمودي مع التأكد من البقاء داخل الشاشة / Calculate vertical position ensuring it stays within screen
    double top = position.dy -
        dialogHeight +
        10; // زيادة المسافة إلى 10 بكسل / Increase distance to 10 pixels

    // التحقق من الحافة العلوية / Check top edge
    if (top < padding.top + 10) {
      top = position.dy +
          10; // إظهار الحوار تحت النقر مع مسافة أقل / Show dialog below tap with less distance
    }

    // التحقق من الحافة السفلية / Check bottom edge
    if (top + dialogHeight > screenSize.height - padding.bottom - 10) {
      top = screenSize.height -
          padding.bottom -
          dialogHeight -
          10; // هامش من الحافة السفلى / Bottom margin
    }
    final bookmarkCount = (s.showBookmarkButtons ?? true)
        ? (s.bookmarkColorCodes?.length ?? 3)
        : 0;
    itemsCount += bookmarkCount;
    if (s.showCopyButton ?? true) itemsCount += 1;
    if (s.showTafsirButton ?? true) itemsCount += 1;
    // لا نعيد إضافة عناصر custom ثانيةً لتجنّب مضاعفة الحساب

    return Obx(
      () => QuranCtrl.instance.state.isShowMenu.value
          ? Positioned(
              top: top,
              left: left,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(s.outerBorderRadius ?? 8.0)),
                    color: s.backgroundColor,
                    boxShadow: s.boxShadow),
                child: Container(
                  padding: s.padding ??
                      const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 2.0),
                  margin: s.margin ?? const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(s.borderRadius ?? 6.0)),
                    border: Border.all(
                      width: s.borderWidth ?? 2.0,
                      color: s.borderColor ??
                          Theme.of(overlayContext)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: () {
                      final List<Widget> widgets = [];
                      Widget divider() => overlayContext.verticalDivider(
                            height: s.dividerHeight,
                            color: s.dividerColor,
                          );

                      void addDividerIfNeeded() {
                        if (widgets.isNotEmpty) widgets.add(divider());
                      }

                      // عناصر إضافية مخصّصة (من الستايل ثم الاستدعاء)
                      if (customMenuItems.isNotEmpty) {
                        for (final item in customMenuItems) {
                          addDividerIfNeeded();
                          widgets.add(
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                close();
                              },
                              child: item,
                            ),
                          );
                        }
                      }

                      // زر تشغيل جميع الآيات
                      if (s.showPlayButton ?? true) {
                        addDividerIfNeeded();
                        widgets.add(
                          GestureDetector(
                            onTap: () {
                              close();

                              AudioCtrl.instance.playAyah(
                                rootContext,
                                ayah!.ayahUQNumber,
                                playSingleAyah: true,
                                ayahAudioStyle: sAudio,
                                ayahDownloadManagerStyle: sDownloadManager,
                                isDarkMode: isDark,
                              );
                              log('Second Menu Child Tapped: ${ayah!.ayahUQNumber}');
                            },
                            child: Icon(
                              s.playIconData,
                              color: s.playIconColor,
                              size: s.iconSize,
                            ),
                          ),
                        );
                      }

                      // زر تشغيل جميع الآيات
                      if ((s.showPlayAllButton ?? true) && !kIsWeb) {
                        addDividerIfNeeded();
                        widgets.add(
                          GestureDetector(
                            onTap: () {
                              close();

                              AudioCtrl.instance.playAyah(
                                rootContext,
                                ayah!.ayahUQNumber,
                                playSingleAyah: false,
                                ayahAudioStyle: sAudio,
                                ayahDownloadManagerStyle: sDownloadManager,
                                isDarkMode: isDark,
                              );
                              log('Second Menu Child Tapped: ${ayah!.ayahUQNumber}');
                            },
                            child: Icon(
                              s.playAllIconData,
                              color: s.playAllIconColor,
                              size: s.iconSize,
                            ),
                          ),
                        );
                      }

                      // زر التفسير
                      if (s.showTafsirButton ?? true) {
                        addDividerIfNeeded();
                        widgets.add(
                          GestureDetector(
                            onTap: () {
                              close();

                              showTafsirOnTap(
                                context: rootContext,
                                isDark: isDark,
                                ayahNum: (QuranCtrl.instance.state.fontsSelected
                                                .value ==
                                            1 ||
                                        QuranCtrl.instance.state.fontsSelected
                                                .value ==
                                            2 ||
                                        QuranCtrl.instance.state.scaleFactor
                                                .value >
                                            1.3)
                                    ? ayah!.ayahNumber
                                    : ayah!.ayahNumber,
                                pageIndex: pageIndex,
                                ayahUQNum: (QuranCtrl.instance.state
                                                .fontsSelected.value ==
                                            1 ||
                                        QuranCtrl.instance.state.fontsSelected
                                                .value ==
                                            2 ||
                                        QuranCtrl.instance.state.scaleFactor
                                                .value >
                                            1.3)
                                    ? ayah!.ayahUQNumber
                                    : ayah!.ayahUQNumber,
                                ayahNumber: (QuranCtrl.instance.state
                                                .fontsSelected.value ==
                                            1 ||
                                        QuranCtrl.instance.state.fontsSelected
                                                .value ==
                                            2 ||
                                        QuranCtrl.instance.state.scaleFactor
                                                .value >
                                            1.3)
                                    ? ayah!.ayahNumber
                                    : ayah!.ayahNumber,
                                externalTafsirStyle: externalTafsirStyle,
                              );
                            },
                            child: Icon(
                              s.tafsirIconData,
                              color: s.tafsirIconColor,
                              size: s.iconSize,
                            ),
                          ),
                        );
                      }

                      // زر النسخ
                      if (s.showCopyButton ?? true) {
                        addDividerIfNeeded();
                        widgets.add(
                          GestureDetector(
                            onTap: () {
                              if (QuranCtrl
                                      .instance.state.fontsSelected.value ==
                                  1) {
                                Clipboard.setData(
                                    ClipboardData(text: ayah!.text));
                              } else {
                                Clipboard.setData(ClipboardData(
                                    text: QuranCtrl.instance
                                        .staticPages[ayah!.page - 1].ayahs
                                        .firstWhere((element) =>
                                            element.ayahUQNumber ==
                                            ayah!.ayahUQNumber)
                                        .text));
                              }
                              close();
                            },
                            child: Icon(
                              s.copyIconData,
                              color: s.copyIconColor,
                              size: s.iconSize,
                            ),
                          ),
                        );
                      }

                      // أزرار العلامات المرجعية
                      if (s.showBookmarkButtons ?? true) {
                        final colors = s.bookmarkColorCodes ??
                            const [
                              0xAAFFD354,
                              0xAAF36077,
                              0xAA00CD00,
                            ];
                        for (final colorCode in colors) {
                          widgets.add(
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: s.iconHorizontalPadding ?? 8.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (QuranCtrl.instance.state.fontsSelected.value == 1 ||
                                      QuranCtrl.instance.state.fontsSelected
                                              .value ==
                                          2 ||
                                      QuranCtrl.instance.state.scaleFactor
                                              .value >
                                          1.3) {
                                    BookmarksCtrl.instance.saveBookmark(
                                      surahName: QuranCtrl.instance
                                          .getSurahDataByAyah(ayah!)
                                          .arabicName,
                                      ayahNumber: ayah!.ayahNumber,
                                      ayahId: ayah!.ayahUQNumber,
                                      page: ayah!.page,
                                      colorCode: colorCode,
                                    );
                                  } else {
                                    BookmarksCtrl.instance.saveBookmark(
                                      surahName: ayah!.arabicName!,
                                      ayahNumber: ayah!.ayahNumber,
                                      ayahId: ayah!.ayahUQNumber,
                                      page: ayah!.page,
                                      colorCode: colorCode,
                                    );
                                  }
                                  close();
                                },
                                child: Icon(
                                  s.bookmarkIconData,
                                  color: Color(colorCode),
                                  size: s.iconSize,
                                ),
                              ),
                            ),
                          );
                        }
                      }

                      return widgets;
                    }(),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

Future<void> showAyahMenuDialog({
  required BuildContext context,
  required bool isDark,
  required AyahModel ayah,
  required Offset position,
  required int index,
  required int pageIndex,
  TafsirStyle? externalTafsirStyle,
}) async {
  final ctrl = QuranCtrl.instance;
  if (ctrl.state.isShowMenu.value) return;

  ctrl.state.isShowMenu.value = true;
  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    pageBuilder: (dialogContext, _, __) {
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            AyahMenuDialog(
              context: context,
              isDark: isDark,
              ayah: ayah,
              position: position,
              index: index,
              pageIndex: pageIndex,
              externalTafsirStyle: externalTafsirStyle,
              onDismiss: () {
                ctrl.showControlToggle();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        ),
      );
    },
  ).whenComplete(() {
    ctrl.state.isShowMenu.value = false;
  });
}
