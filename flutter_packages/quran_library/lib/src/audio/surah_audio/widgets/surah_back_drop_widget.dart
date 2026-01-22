part of '../../audio.dart';

/// ويدجت خلفية تشغيل الصوت مع تصميم متجاوب للوضعين الأفقي والعمودي
/// Background widget for audio playback with responsive design for portrait and landscape orientations
class SurahBackDropWidget extends StatelessWidget {
  final SurahAudioStyle? style;
  final bool? isDark;
  final String? languageCode;

  const SurahBackDropWidget(
      {super.key, this.style, this.isDark, this.languageCode});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
    final background =
        style?.backgroundColor ?? AppColors.getBackgroundColor(dark);

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        style?.borderRadius ?? 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: background.withValues(alpha: 0.22),
            width: 1.5,
          ),
        ),
        child: UiHelper.currentOrientation(
          // الوضع العمودي - Portrait Mode
          _buildPortraitLayout(context, size, dark),
          // الوضع الأفقي - Landscape Mode
          _buildLandscapeLayout(context, size, dark),
          context,
        ),
      ),
    );
  }

  /// بناء التخطيط للوضع العمودي
  /// Build layout for portrait mode
  Widget _buildPortraitLayout(BuildContext context, Size size, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // شرح: كارد آخر استماع مع تصميم محسن
          // Explanation: Last listen card with enhanced design
          _buildEnhancedCard(
            child: SurahLastListen(
              style: style,
              isDark: isDark,
              languageCode: languageCode,
            ),
            context: context,
            elevation: 10.0,
            isDark: isDark,
          ),

          const SizedBox(height: 16.0),

          // شرح: قائمة السور مع تحسينات التصميم
          // Explanation: Surah list with design improvements
          _buildEnhancedCard(
            child: SizedBox(
              height: size.height * 0.6,
              child: SurahAudioList(
                style: style,
                isDark: isDark,
                languageCode: languageCode,
              ),
            ),
            context: context,
            elevation: 14.0,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  /// بناء التخطيط للوضع الأفقي
  /// Build layout for landscape mode
  Widget _buildLandscapeLayout(BuildContext context, Size size, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شرح: قائمة السور في الجانب الأيسر (الوضع الأفقي)
          // Explanation: Surah list on the left side (landscape mode)
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                Expanded(
                  child: _buildEnhancedCard(
                    child: SurahAudioList(
                      style: style,
                      isDark: isDark,
                      languageCode: languageCode,
                    ),
                    context: context,
                    elevation: 12.0,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20.0),

          // شرح: آخر استماع والمعلومات في الجانب الأيمن
          // Explanation: Last listen and info on the right side
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 16.0),

                // شرح: كارد آخر استماع
                // Explanation: Last listen card
                Expanded(
                  child: _buildEnhancedCard(
                    child: Column(
                      children: [
                        SurahLastListen(
                          style: style,
                          isDark: isDark,
                          languageCode: languageCode,
                        ),
                        const Spacer(),
                        SurahPlayLandscapeWidget(
                            style: style,
                            isDark: isDark,
                            languageCode: languageCode),
                      ],
                    ),
                    context: context,
                    elevation: 10.0,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// بناء كارد محسن مع ظلال وتأثيرات
  /// Build enhanced card with shadows and effects
  Widget _buildEnhancedCard({
    required Widget child,
    required BuildContext context,
    double elevation = 8.0,
    required bool isDark,
  }) {
    final bool dark = isDark;
    final bg = style?.backgroundColor ?? AppColors.getBackgroundColor(dark);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.06),
            blurRadius: elevation,
            spreadRadius: 2.0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.04 : 0.02),
            blurRadius: elevation / 2,
            spreadRadius: 1.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                bg.withValues(alpha: 0.06),
                bg.withValues(alpha: 0.03),
              ],
            ),
            border: Border.all(
              color: bg.withValues(alpha: 0.18),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
