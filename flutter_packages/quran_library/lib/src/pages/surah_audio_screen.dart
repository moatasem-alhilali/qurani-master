part of '../audio/audio.dart';

class SurahAudioScreen extends StatelessWidget {
  final SurahAudioStyle? style;
  final bool? isDark;
  final String? languageCode;

  const SurahAudioScreen(
      {super.key, this.style, this.isDark, this.languageCode = 'ar'});

  @override
  Widget build(BuildContext context) {
    final surahCtrl = AudioCtrl.instance;
    final bool dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
    // استخدام نمط موحد افتراضي إذا لم يُمرر
    final s = style ?? SurahAudioStyle.defaults(isDark: dark, context: context);

    final background = s.backgroundColor ?? AppColors.getBackgroundColor(dark);
    final textColor = s.textColor ?? AppColors.getTextColor(dark);
    final size = MediaQuery.sizeOf(context);

    // surahCtrl.loadLastSurahAndPosition();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) {
          return;
        }
        surahCtrl.state.audioPlayer.stop();
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: Column(
            children: [
              if (s.withAppBar ?? true)
                AppBarWidget(
                    background: background, s: s, textColor: textColor),
              Expanded(
                child: UiHelper.currentOrientation(
                    PortraitWidget(
                        surahCtrl: surahCtrl,
                        size: size,
                        style: s,
                        dark: dark,
                        languageCode: languageCode),
                    SurahBackDropWidget(
                        style: s, isDark: dark, languageCode: languageCode),
                    context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.background,
    required this.s,
    required this.textColor,
  });

  final Color background;
  final SurahAudioStyle s;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(s.borderRadius ?? 16),
          bottomRight: Radius.circular(s.borderRadius ?? 16),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: IconButton(
              onPressed: () {
                AudioCtrl.instance.state.audioPlayer.stop();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: s.backIconColor,
              ),
              color: s.backIconColor ?? textColor,
              iconSize: 24,
            ),
          ),
          Text(
            'الإستماع للسور',
            style: QuranLibrary().cairoStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 1.7,
                ),
          ),
        ],
      ),
    );
  }
}

class PortraitWidget extends StatelessWidget {
  const PortraitWidget({
    super.key,
    required this.surahCtrl,
    required this.size,
    required this.style,
    required this.dark,
    required this.languageCode,
  });

  final AudioCtrl surahCtrl;
  final Size size;
  final SurahAudioStyle? style;
  final bool dark;
  final String? languageCode;

  @override
  Widget build(BuildContext context) {
    final bg =
        style?.audioSliderBackgroundColor ?? AppColors.getBackgroundColor(dark);
    final borderColor =
        (style?.backgroundColor ?? AppColors.getBackgroundColor(dark))
            .withValues(alpha: 0.15);
    return Stack(
      children: [
        SurahBackDropWidget(
            style: style, isDark: dark, languageCode: languageCode),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                // عند السحب للأعلى يفتح السلايدر، وعند السحب للأسفل يغلق
                // On vertical drag: up opens, down closes
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta != null) {
                    if (details.primaryDelta! < -8) {
                      // سحب للأعلى: فتح السلايدر
                      // Drag up: open
                      Future.delayed(
                        const Duration(milliseconds: 10),
                        () {
                          surahCtrl.state.isSheetOpen.value = true;
                          surahCtrl.update(['change_sheet_state']);
                        },
                      );
                    } else if (details.primaryDelta! > 8) {
                      // سحب للأسفل: إغلاق السلايدر
                      // Drag down: close

                      surahCtrl.state.isSheetOpen.value = false;
                      surahCtrl.update(['change_sheet_state']);
                    }
                  }
                },
                child: Container(
                  width: UiHelper.currentOrientation(
                      size.width, size.width * .5, context),
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(
                          0,
                          -5,
                        ), // changes position of shadow
                      ),
                    ],
                  ),
                  child: GetBuilder<AudioCtrl>(
                    id: 'change_sheet_state',
                    builder: (surahCtrl) => AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      alignment: Alignment.bottomCenter,
                      child: AnimatedCrossFade(
                        // مطابقة مدة الأنيميشن مع السلايدر لتجنب overflow
                        // Match animation duration with slider to avoid overflow
                        duration: const Duration(milliseconds: 200),
                        reverseDuration: const Duration(
                          milliseconds: 200,
                        ),
                        secondCurve: Curves.linear,
                        firstChild: SurahCollapsedPlayWidget(
                            style: style,
                            isDark: dark,
                            languageCode: languageCode),
                        secondChild: PlaySurahsWidget(
                            style: style,
                            isDark: dark,
                            languageCode: languageCode),
                        crossFadeState: !surahCtrl.state.isSheetOpen.value
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // SlidingPanel(
        //   controller: surahCtrl.state.panelController,
        //   config: SlidingPanelConfig(
        //     anchorPosition: 100,
        //     expandPosition: UiHelper.currentOrientation(
        //         size.height * .7, size.height * .8, context),
        //   ),
        //   pageContent:
        //   panelContent:
        // ),
      ],
    );
  }
}
