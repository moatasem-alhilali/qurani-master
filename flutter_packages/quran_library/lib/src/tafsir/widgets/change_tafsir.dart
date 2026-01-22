part of '../tafsir.dart';

class ChangeTafsirDialog extends StatelessWidget {
  final TafsirStyle? tafsirStyle;
  final List<TafsirNameModel>? tafsirNameList;
  final int? pageNumber;
  final bool? isDark;
  ChangeTafsirDialog(
      {super.key,
      this.tafsirStyle,
      this.tafsirNameList,
      this.pageNumber,
      this.isDark = false});

  final tafsirCtrl = TafsirCtrl.instance;

  @override
  Widget build(BuildContext context) {
    // tafsirCtrl.initializeTafsirDownloadStatus();
    return Semantics(
      button: true,
      enabled: true,
      label: 'Change Tafsir',
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return DailogBuild(
                  tafsirStyle: tafsirStyle ??
                      TafsirStyle.defaults(isDark: isDark!, context: context),
                  pageNumber: pageNumber,
                  tafsirNameList: tafsirNameList,
                  isDark: isDark!,
                );
              });
        },
        child: Container(
          width: 160.h,
          // margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  tafsirNameList?[tafsirCtrl.radioValue.value].name ??
                      tafsirCtrl
                          .tafsirAndTranslationsItems[
                              tafsirCtrl.radioValue.value]
                          .name,
                  style: QuranLibrary().cairoStyle.copyWith(
                        color: tafsirStyle?.currentTafsirColor ??
                            const Color(0xffCDAD80),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down_rounded,
                  size: 24,
                  color: tafsirStyle?.currentTafsirColor ?? Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class DailogBuild extends StatelessWidget {
  const DailogBuild({
    super.key,
    this.tafsirStyle,
    required this.pageNumber,
    required this.tafsirNameList,
    required this.isDark,
  });

  final TafsirStyle? tafsirStyle;
  final int? pageNumber;
  final List<TafsirNameModel>? tafsirNameList;
  final bool? isDark;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TafsirCtrl>(
      id: 'tafsirs_menu_list',
      builder: (tafsirCtrl) {
        return Dialog(
          backgroundColor: tafsirStyle?.backgroundColor!,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: tafsirStyle?.changeTafsirDialogWidth ??
                  MediaQuery.of(context).size.width,
              maxHeight: tafsirStyle?.changeTafsirDialogHeight ??
                  MediaQuery.of(context).size.height * 0.9,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: HeaderDialogWidget(
                      title: tafsirStyle?.dialogHeaderTitle ?? 'تغيير التفسير',
                      isDark: isDark,
                      titleColor: tafsirStyle?.dialogHeaderTitleColor,
                      backgroundGradient:
                          tafsirStyle?.dialogHeaderBackgroundGradient,
                      closeIconColor: tafsirStyle?.dialogCloseIconColor,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          tafsirCtrl.tafsirAndTranslationsItems.length,
                          (index) {
                            return Column(
                              children: [
                                tafsirOrTranslateTitle(index),
                                TafsirItemWidget(
                                  tafsirIndex: index,
                                  pageNumber: pageNumber ??
                                      QuranCtrl.instance.state.currentPageNumber
                                          .value,
                                  tafsirNameList: tafsirNameList,
                                  tafsirStyle: tafsirStyle ??
                                      TafsirStyle.defaults(
                                          isDark: isDark!, context: context),
                                  isDark: isDark!,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget tafsirOrTranslateTitle(int index, {String? title}) {
    if (index == 0 || index == TafsirCtrl.instance.translationsStartIndex) {
      title ??=
          index == 0 ? tafsirStyle?.tafsirName! : tafsirStyle?.translateName!;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: tafsirStyle?.backgroundTitleColor!,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title!,
          style: QuranLibrary().cairoStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: tafsirStyle?.textTitleColor!),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class TafsirItemWidget extends StatelessWidget {
  TafsirItemWidget({
    super.key,
    required this.tafsirNameList,
    required this.tafsirStyle,
    required this.tafsirIndex,
    this.pageNumber,
    required this.isDark,
  });

  final List<TafsirNameModel>? tafsirNameList;
  final TafsirStyle tafsirStyle;
  final int tafsirIndex;
  final int? pageNumber;
  final bool isDark;
  final tafsirCtrl = TafsirCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TafsirCtrl>(
      id: 'tafsirs_menu_list',
      builder: (tafsirCtrl) {
        RxBool isDownloaded =
            (kIsWeb || tafsirCtrl.tafsirDownloadIndexList.contains(tafsirIndex))
                .obs;
        return InkWell(
          onTap: () async {
            if (!isDownloaded.value) return;
            await tafsirCtrl.handleRadioValueChanged(tafsirIndex,
                pageNumber: pageNumber);
            // GetStorage().write(_StorageConstants().radioValue, index);
            // tafsirCtrl.fetchTranslate();
            // tafsirCtrl.update(['tafsirs_menu_list']);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: tafsirCtrl.radioValue.value == tafsirIndex
                  ? (tafsirStyle.selectedTafsirColor ?? const Color(0xffCDAD80))
                      .withValues(alpha: 0.3)
                  : (tafsirStyle.unSelectedTafsirColor ??
                          const Color(0xffCDAD80))
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: tafsirCtrl.radioValue.value == tafsirIndex
                    ? (tafsirStyle.selectedTafsirBorderColor ??
                            const Color(0xffCDAD80))
                        .withValues(alpha: 0.5)
                    : tafsirStyle.unSelectedTafsirBorderColor ??
                        Colors.transparent,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Obx(
                  () {
                    return isDownloaded.value
                        ? tafsirCtrl.getIsRemovableItem(tafsirIndex)
                            ? IconButton(
                                icon: Icon(
                                  Icons.delete_forever_outlined,
                                  size: 22,
                                  color: tafsirStyle.downloadIconColor,
                                ),
                                onPressed: () async {
                                  tafsirCtrl.update(['tafsirs_menu_list']);
                                  await tafsirCtrl.deleteTafsirOrTranslation(
                                      itemIndex: tafsirIndex);
                                },
                              )
                            : Container(
                                height: 20,
                                width: 20,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: tafsirStyle
                                          .selectedTafsirBorderColor!,
                                      width: 2),
                                  color: Colors.white,
                                ),
                                child:
                                    tafsirCtrl.radioValue.value == tafsirIndex
                                        ? const Icon(
                                            Icons.done,
                                            size: 14,
                                            color: Colors.black,
                                          )
                                        : null,
                              )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              // مؤشر دوران أثناء مرحلة التهيئة وقبل ظهور التقدم
                              Obx(() {
                                final isThisItem = tafsirIndex ==
                                    tafsirCtrl.downloadIndex.value;
                                final preparing =
                                    tafsirCtrl.isPreparingDownload.value;
                                final startedNoProgress =
                                    tafsirCtrl.onDownloading.value &&
                                        tafsirCtrl.progress.value == 0.0;
                                final showInit = isThisItem &&
                                    (preparing || startedNoProgress);
                                return showInit
                                    ? SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color:
                                              tafsirStyle.selectedTafsirColor ??
                                                  const Color(0xffCDAD80),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }),
                              // مؤشر تقدم أثناء التحميل
                              Obx(
                                () => CircularProgressIndicator(
                                  strokeWidth: 2,
                                  backgroundColor: Colors.transparent,
                                  color: tafsirIndex ==
                                          tafsirCtrl.downloadIndex.value
                                      ? tafsirCtrl.onDownloading.value
                                          ? tafsirStyle.selectedTafsirColor ??
                                              const Color(0xffCDAD80)
                                          : Colors.transparent
                                      : Colors.transparent,
                                  value: tafsirCtrl.progress.value,
                                ),
                              ),
                              // زر التحميل يُخفى أثناء التهيئة أو عند بدء التحميل بدون تقدم
                              if (!kIsWeb)
                                Obx(
                                  () {
                                    final isThisItem = tafsirIndex ==
                                        tafsirCtrl.downloadIndex.value;
                                    final preparing =
                                        tafsirCtrl.isPreparingDownload.value;
                                    final startedNoProgress =
                                        tafsirCtrl.onDownloading.value &&
                                            tafsirCtrl.progress.value == 0.0;
                                    final hideIcon = isThisItem &&
                                        (preparing ||
                                            startedNoProgress ||
                                            tafsirCtrl.onDownloading.value);
                                    return Visibility(
                                      visible: !hideIcon,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cloud_download_outlined,
                                          size: 22,
                                          color: tafsirStyle.downloadIconColor,
                                        ),
                                        onPressed: () async {
                                          tafsirCtrl.downloadIndex.value =
                                              tafsirIndex;
                                          tafsirCtrl
                                              .update(['tafsirs_menu_list']);
                                          await tafsirCtrl
                                              .tafsirAndTranslationDownload(
                                                  tafsirIndex);
                                        },
                                      ),
                                    );
                                  },
                                ),
                            ],
                          );
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tafsirNameList?[tafsirIndex].name ??
                                tafsirCtrl
                                    .tafsirAndTranslationsItems[tafsirIndex]
                                    .name,
                            style: QuranLibrary().cairoStyle.copyWith(
                                  color: tafsirCtrl.radioValue.value ==
                                          tafsirIndex
                                      ? tafsirStyle.selectedTafsirTextColor!
                                      : tafsirStyle.unSelectedTafsirTextColor!,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            tafsirIndex >= 28
                                ? ''
                                : tafsirNameList?[tafsirIndex].bookName ??
                                    tafsirCtrl
                                        .tafsirAndTranslationsItems[tafsirIndex]
                                        .bookName,
                            style: QuranLibrary().cairoStyle.copyWith(
                                  color: tafsirCtrl.radioValue.value ==
                                          tafsirIndex
                                      ? tafsirStyle.selectedTafsirTextColor ??
                                          (AppColors.getTextColor(isDark))
                                      : tafsirStyle.unSelectedTafsirTextColor ??
                                          (isDark
                                              ? Colors.white
                                              : Colors.black),
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
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
