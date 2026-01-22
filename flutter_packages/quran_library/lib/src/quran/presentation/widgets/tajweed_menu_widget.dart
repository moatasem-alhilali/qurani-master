part of '/quran.dart';

class TajweedMenuWidget extends StatelessWidget {
  final String languageCode;
  final bool isDark;
  TajweedMenuWidget(
      {super.key, required this.languageCode, required this.isDark});
  final quranCtrl = QuranCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final rule =
        quranCtrl.getTajweedRulesListForLanguage(languageCode: languageCode);

    final TajweedMenuStyle defaults = TajweedMenuTheme.of(context)?.style ??
        TajweedMenuStyle.defaults(isDark: isDark, context: context);
    return GetBuilder<QuranCtrl>(
        id: 'isShowControl',
        builder: (quranCtrl) {
          final visible = quranCtrl.isShowControl.value;
          return visible && QuranCtrl.instance.state.fontsSelected.value == 2
              ? Container(
                  height: defaults.height ?? 350,
                  width: defaults.width ?? 350,
                  padding: defaults.listPadding ?? const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: defaults.backgroundColor ??
                        AppColors.getBackgroundColor(isDark),
                    borderRadius:
                        BorderRadius.circular(defaults.borderRadius ?? 8),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: HeaderDialogWidget(
                          isDark: isDark,
                          title: defaults.headerTitle ?? 'أحكام التجويد',
                          titleColor: defaults.headerTitleColor,
                          closeIconColor: defaults.headerCloseIconColor,
                          backgroundGradient: defaults.headerBackgroundGradient,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin:
                              defaults.listMargin ?? const EdgeInsets.all(4.0),
                          padding: defaults.listPadding ??
                              const EdgeInsets.symmetric(vertical: 6.0),
                          decoration: BoxDecoration(
                            color: defaults.backgroundColor ??
                                AppColors.getBackgroundColor(isDark),
                            borderRadius: BorderRadius.circular(
                                defaults.listBorderRadius ?? 8),
                          ),
                          child: ListView.builder(
                            itemCount: rule.length,
                            itemBuilder: (context, i) {
                              final Color ruleColor = Color(
                                  isDark ? rule[i].darkColor : rule[i].color);
                              return Container(
                                margin: defaults.itemMargin ??
                                    const EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 8.0),
                                padding: defaults.itemPadding ??
                                    const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    ruleColor.withValues(
                                      alpha:
                                          defaults.itemGradientOpacity ?? 0.1,
                                    ),
                                    Colors.transparent,
                                  ]),
                                  borderRadius: BorderRadius.circular(
                                      defaults.itemBorderRadius ?? 8),
                                  border: Border.all(
                                    color: defaults.itemBorderColor ??
                                        Colors.teal.withValues(alpha: .2),
                                    width: defaults.itemBorderWidth ?? 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: defaults.swatchSize ?? 34,
                                      height: defaults.swatchSize ?? 34,
                                      decoration: BoxDecoration(
                                        color: ruleColor,
                                        borderRadius: BorderRadius.circular(
                                            defaults.swatchBorderRadius ?? 4),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        rule[i].text[languageCode] ??
                                            rule[i].text['ar']!,
                                        style: defaults.itemTextStyle ??
                                            TextStyle(
                                              color: AppColors.getTextColor(
                                                  isDark),
                                              fontSize: 16,
                                              fontFamily: 'cairo',
                                              fontWeight: FontWeight.w500,
                                              package: 'quran_library',
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink();
        });
  }
}
