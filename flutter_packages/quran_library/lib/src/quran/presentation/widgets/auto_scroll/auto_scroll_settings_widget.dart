part of '/quran.dart';

/// إعدادات السكرول التلقائي — تُضاف داخل FontsDownloadWidget
///
/// [AutoScrollSettingsWidget] settings section for auto-scroll:
/// stop condition selector, page count input, and initial speed slider.
class AutoScrollSettingsWidget extends StatelessWidget {
  const AutoScrollSettingsWidget({
    super.key,
    required this.isDark,
    required this.accent,
    required this.outlineColor,
    required this.textColor,
    this.autoScrollStyle,
  });

  final bool isDark;
  final Color accent;
  final Color outlineColor;
  final Color textColor;
  final AutoScrollStyle? autoScrollStyle;

  @override
  Widget build(BuildContext context) {
    final autoScrollCtrl = AutoScrollCtrl.instance;
    final style = autoScrollStyle ?? AutoScrollTheme.of(context)?.style;

    // ─── Resolve texts ──────────────────────────────────────────
    final titleText = style?.settingsTitleText ?? 'السكرول التلقائي';
    final stopLabel = style?.stopConditionLabelText ?? 'التوقف عند:';
    final pageCountLabel = style?.pageCountLabelText ?? 'عدد الصفحات:';
    final speedLabel = style?.speedLabelText ?? 'السرعة:';
    final slowText = style?.slowLabelText ?? 'بطيء';
    final fastText = style?.fastLabelText ?? 'سريع';
    final notesText =
        style?.notesLabelText ?? 'ضبط سرعة السكرول والتوقف التلقائي';

    // ─── Resolve styles ─────────────────────────────────────────
    final titleStyle = style?.settingsTitleStyle ??
        TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'cairo',
          color: style?.textColor ?? textColor,
          package: 'quran_library',
        );
    final subLabelStyle = style?.settingsSubLabelStyle ??
        TextStyle(
          fontSize: 13,
          fontFamily: 'cairo',
          color: (style?.textColor ?? textColor).withValues(alpha: .7),
          package: 'quran_library',
        );
    final resolvedChipBorderRadius = style?.chipBorderRadius ?? 10;
    final resolvedChipSelectedBg = style?.chipSelectedBackgroundColor ??
        AppColors.getBackgroundColor(isDark);
    final resolvedChipUnselectedBg = style?.chipUnselectedBackgroundColor ??
        AppColors.getBackgroundColor(isDark);
    final resolvedChipSelectedBorder = style?.chipSelectedBorderColor ?? accent;
    final resolvedChipUnselectedBorder =
        style?.chipUnselectedBorderColor ?? outlineColor;
    final resolvedPageCountBtnColor = style?.pageCountButtonColor ?? accent;
    final hintStyle = style?.sliderHintStyle ??
        TextStyle(
          fontSize: 11,
          fontFamily: 'cairo',
          color: (style?.textColor ?? textColor).withValues(alpha: .5),
          package: 'quran_library',
        );

    return Obx(() {
      final selectedCondition = autoScrollCtrl.state.stopCondition.value;
      final speed = autoScrollCtrl.state.speed.value;
      final pageCount = autoScrollCtrl.state.targetPageCount.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // الفاصل
            Center(
              child: Container(
                width: MediaQuery.sizeOf(context).width * .5,
                height: 1,
                color: outlineColor,
              ),
            ),
            const SizedBox(height: 12),
            // العنوان
            Center(
              child: Text(
                titleText,
                style: titleStyle,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              notesText,
              style: style?.notesStyle ??
                  TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'cairo',
                    color: style?.textColor ?? textColor,
                    height: 1.5,
                    package: 'quran_library',
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // شرط التوقف
            Text(
              stopLabel,
              style: subLabelStyle,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: AutoScrollStopCondition.values.map((condition) {
                final isSelected = selectedCondition == condition;
                final chipLabel =
                    style?.stopConditionLabels?[condition] ?? condition.labelAr;
                final chipStyle = style?.chipTextStyle != null
                    ? style!.chipTextStyle!.copyWith(
                        color: isSelected
                            ? accent
                            : (style.textColor ?? textColor),
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.normal,
                      )
                    : TextStyle(
                        fontSize: 12,
                        fontFamily: 'cairo',
                        color: isSelected ? accent : textColor,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.normal,
                        package: 'quran_library',
                      );
                return ChoiceChip(
                  elevation: 0,
                  pressElevation: 0,
                  selectedShadowColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  label: Text(chipLabel, style: chipStyle),
                  selected: isSelected,
                  selectedColor: resolvedChipSelectedBg,
                  backgroundColor: resolvedChipUnselectedBg,
                  side: BorderSide(
                    color: isSelected
                        ? resolvedChipSelectedBorder
                        : resolvedChipUnselectedBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(resolvedChipBorderRadius),
                  ),
                  onSelected: (_) {
                    autoScrollCtrl.updateStopCondition(condition);
                  },
                );
              }).toList(),
            ),

            // حقل عدد الصفحات (يظهر فقط عند اختيار pageCount)
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: selectedCondition == AutoScrollStopCondition.pageCount
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            pageCountLabel,
                            style: subLabelStyle,
                          ),
                          const SizedBox(width: 8),
                          _PageCountButton(
                            icon: Icons.remove,
                            color: resolvedPageCountBtnColor,
                            onTap: () {
                              if (pageCount > 1) {
                                autoScrollCtrl
                                    .updateTargetPageCount(pageCount - 1);
                              }
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              '$pageCount'.convertNumbersAccordingToLang(),
                              style: style?.pageCountValueStyle ??
                                  TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'cairo',
                                    color: accent,
                                    package: 'quran_library',
                                  ),
                            ),
                          ),
                          _PageCountButton(
                            icon: Icons.add,
                            color: resolvedPageCountBtnColor,
                            onTap: () {
                              if (pageCount < 604) {
                                autoScrollCtrl
                                    .updateTargetPageCount(pageCount + 1);
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // سرعة البداية
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  speedLabel,
                  style: subLabelStyle,
                ),
                const SizedBox(width: 4),
                Text(
                  speed.toStringAsFixed(1),
                  style: style?.speedLabelStyle ??
                      TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'cairo',
                        color: accent,
                        package: 'quran_library',
                      ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: style?.sliderActiveColor ?? accent,
                inactiveTrackColor:
                    style?.sliderInactiveColor ?? accent.withValues(alpha: .2),
                thumbColor: style?.sliderThumbColor ?? accent,
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: speed,
                min: 0.1,
                max: 5.0,
                onChanged: (v) => autoScrollCtrl.updateSpeed(v),
              ),
            ),
            // تسميات بطيء / سريع
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(slowText, style: hintStyle),
                  Text(fastText, style: hintStyle),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    });
  }
}

class _PageCountButton extends StatelessWidget {
  const _PageCountButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: .3)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
