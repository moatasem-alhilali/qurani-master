part of '/quran.dart';

/// شريط التحكم بسرعة السكرول التلقائي — يظهر أسفل الشاشة عند التفعيل
///
/// [AutoScrollSpeedSlider] bottom overlay with play/pause, speed slider,
/// current speed label, and close button.
class AutoScrollSpeedSlider extends StatelessWidget {
  const AutoScrollSpeedSlider({
    super.key,
    required this.isDark,
    required this.autoScrollStyle,
    required this.languageCode,
  });

  final bool isDark;
  final AutoScrollStyle autoScrollStyle;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final autoScrollCtrl = AutoScrollCtrl.instance;
    final style = AutoScrollTheme.of(context)?.style ?? autoScrollStyle;
    AutoScrollStyle.defaults(isDark: isDark, context: context);

    return Obx(() {
      if (!autoScrollCtrl.state.isActive.value) {
        return const SizedBox.shrink();
      }

      // إخفاء الشريط أثناء التمرير النشط — يظهر فقط عند الإيقاف المؤقت
      if (!autoScrollCtrl.state.isPaused.value) {
        return const SizedBox.shrink();
      }

      final speed = autoScrollCtrl.state.speed.value;

      return Align(
        alignment: Alignment.centerLeft,
        child: SafeArea(
          child: Container(
            width: 65,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: style.overlayBackgroundColor ??
                  AppColors.getBackgroundColor(isDark).withValues(alpha: .92),
              borderRadius: BorderRadius.circular(style.borderRadius ?? 16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .15),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // زر إغلاق
                _AutoScrollIconButton(
                  icon: Icons.close,
                  color: style.iconColor ?? AppColors.getTextColor(isDark),
                  onTap: () => autoScrollCtrl.stopAutoScroll(),
                ),
                // Slider
                SizedBox(
                  height: 150,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: style.sliderActiveColor ??
                            Theme.of(context).colorScheme.primary,
                        inactiveTrackColor: style.sliderInactiveColor ??
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: .3),
                        thumbColor: style.sliderThumbColor ??
                            Theme.of(context).colorScheme.primary,
                        trackHeight: 4,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 8),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 16),
                      ),
                      child: Slider(
                        value: speed,
                        min: 0.05,
                        max: 5.0,
                        onChanged: (v) => autoScrollCtrl.updateSpeed(v),
                      ),
                    ),
                  ),
                ),
                // رقم السرعة
                SizedBox(
                  width: 36,
                  child: Text(
                    speed.toStringAsFixed(1).convertNumbersAccordingToLang(
                        languageCode: languageCode),
                    textAlign: TextAlign.center,
                    style: style.speedLabelStyle ??
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'cairo',
                          color: Theme.of(context).colorScheme.primary,
                          package: 'quran_library',
                        ),
                  ),
                ),
                // زر Play — الشريط يظهر فقط أثناء الإيقاف المؤقت
                GestureDetector(
                  child: CustomWidgets.customSvgWithColor(
                    AssetsPath.assets.playArrow,
                    height: 24,
                    ctx: context,
                    color: style.activeIconColor ??
                        Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    QuranCtrl.instance.isShowControl.value = false;
                    autoScrollCtrl.togglePause();
                    QuranCtrl.instance.update(['isShowControl']);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _AutoScrollIconButton extends StatelessWidget {
  const _AutoScrollIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }
}
