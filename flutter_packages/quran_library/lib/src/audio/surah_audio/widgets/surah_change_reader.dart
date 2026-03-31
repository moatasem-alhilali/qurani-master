part of '../../audio.dart';

class SurahChangeSurahReader extends StatelessWidget {
  final SurahAudioStyle? style;
  final bool isDark;
  SurahChangeSurahReader({super.key, this.style, this.isDark = false});
  final surahAudioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final bool dark = isDark;
    final s = style ?? SurahAudioStyle.defaults(isDark: dark, context: context);

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor:
              s.dialogBackgroundColor ?? AppColors.getBackgroundColor(dark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(s.dialogBorderRadius ?? 12.0),
          ),
          alignment: Alignment.center,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  s.dialogHeight ?? MediaQuery.of(context).size.height * 0.7,
              maxWidth:
                  s.dialogWidth ?? MediaQuery.of(context).size.width * 0.6,
            ),
            child: _buildDialog(context, s, dark),
          ),
        ),
      ),
      child: _buildTitle(s, dark),
    );
  }

  Widget _buildDialog(BuildContext context, SurahAudioStyle s, bool dark) {
    final Color activeColor = s.dialogSelectedReaderColor ??
        s.primaryColor ??
        Theme.of(context).colorScheme.primary;
    final Color inactiveColor =
        s.dialogUnSelectedReaderColor ?? AppColors.getTextColor(dark);
    final double itemFontSize = s.readerNameInItemFontSize ?? 14;
    final Color textColor =
        s.dialogReaderTextColor ?? AppColors.getTextColor(dark);

    final int selectedIndex = surahAudioCtrl.state.surahReaderIndex.value;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          HeaderDialogWidget(
            title: s.dialogHeaderTitle ?? 'تغيير القارئ',
            isDark: dark,
            backgroundGradient: s.dialogHeaderBackgroundGradient,
            titleColor: s.dialogHeaderTitleColor,
            closeIconColor: s.dialogCloseIconColor,
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          // List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: ReadersConstants.activeSurahReaders.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: AppColors.getTextColor(dark).withValues(alpha: 0.08),
              ),
              itemBuilder: (context, index) {
                final info = ReadersConstants.activeSurahReaders[index];
                final bool isSelected = selectedIndex == index;
                final Color itemColor =
                    isSelected ? activeColor : inactiveColor;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: ListTile(
                    minTileHeight: 44,
                    dense: true,
                    selected: isSelected,
                    focusColor: itemColor.withValues(alpha: 0.12),
                    splashColor: itemColor.withValues(alpha: 0.12),
                    selectedColor: itemColor,
                    selectedTileColor: itemColor.withValues(alpha: 0.12),
                    tileColor: itemColor.withValues(alpha: 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: Text(
                      info.name.tr,
                      style: QuranLibrary().cairoStyle.copyWith(
                            color: textColor,
                            fontSize: itemFontSize,
                          ),
                    ),
                    trailing: _SelectionIndicator(
                        isSelected: isSelected,
                        color: s.dialogSelectedReaderColor ?? activeColor),
                    onTap: () =>
                        surahAudioCtrl.changeSurahReadersOnTap(context, index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(SurahAudioStyle s, bool dark) {
    final Color textColor = s.textColor ?? AppColors.getTextColor(dark);
    final double fontSize = s.readerNameFontSize ?? 16;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GetBuilder<AudioCtrl>(
          id: 'change_surah_reader',
          builder: (surahAudioCtrl) => Text(
            ReadersConstants
                .activeSurahReaders[surahAudioCtrl.state.surahReaderIndex.value]
                .name
                .tr,
            style: QuranLibrary().cairoStyle.copyWith(
                  color: textColor,
                  fontSize: fontSize,
                ),
          ),
        ),
        const SizedBox(width: 4),
        Semantics(
          button: true,
          enabled: true,
          label: 'Change Reader'.tr,
          child: Icon(
            Icons.keyboard_arrow_down_outlined,
            size: fontSize.clamp(16, 20),
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  final bool isSelected;
  final Color? color;
  const _SelectionIndicator({required this.isSelected, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: color ?? Theme.of(context).colorScheme.primary, width: 2),
      ),
      child: isSelected
          ? Icon(
              Icons.done,
              size: 14,
              color: color ?? Theme.of(context).colorScheme.primary,
            )
          : null,
    );
  }
}
