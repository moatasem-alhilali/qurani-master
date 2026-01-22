part of '../audio.dart';

class PlayAyahWidget extends StatelessWidget {
  final AyahAudioStyle? style;
  const PlayAyahWidget({super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = AudioCtrl.instance;
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final AyahAudioStyle effectiveStyle =
        style ?? AyahAudioStyle.defaults(isDark: dark, context: context);

    return SizedBox(
      width: 28,
      height: 28,
      child: StreamBuilder<PlayerState>(
        stream: audioCtrl.state.audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering ||
              (audioCtrl.state.isDownloading.value &&
                  audioCtrl.state.progress.value == 0)) {
            return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ));
          } else if (playerState != null && !playerState.playing) {
            return GestureDetector(
              child: CustomWidgets.customSvgWithColor(
                effectiveStyle.playIconPath ?? AssetsPath.assets.playArrow,
                height: effectiveStyle.playIconHeight!,
                ctx: context,
                color: effectiveStyle.playIconColor!,
              ),
              onTap: () async {
                // اضبط وضع التشغيل للآيات فقط
                audioCtrl.state.isPlayingSurahsMode = false;
                // عطّل مستمع وضع السور لتجنّب التداخل مع تشغيل الآيات
                audioCtrl.disableSurahAutoNextListener();
                // تعطيل حفظ موضع السورة عند تشغيل الآيات
                audioCtrl.disableSurahPositionSaving();
                // تجنّب استدعاءات مزدوجة
                if (!audioCtrl.state.audioPlayer.playing) {
                  await audioCtrl.playAyah(
                    context,
                    isDarkMode: dark,
                    audioCtrl.state.currentAyahUniqueNumber.value,
                    playSingleAyah: audioCtrl.state.playSingleAyahOnly,
                  );
                }
              },
            );
          }
          return GestureDetector(
            child: CustomWidgets.customSvgWithColor(
              effectiveStyle.pauseIconPath ?? AssetsPath.assets.pauseArrow,
              height: effectiveStyle.pauseIconHeight!,
              ctx: context,
              color: effectiveStyle.playIconColor!,
            ),
            onTap: () async {
              // Pause only, don't auto-toggle play again
              await audioCtrl.pausePlayer();
            },
          );
        },
      ),
    );
  }
}
