part of '../../audio.dart';

class SurahOnlinePlayButton extends StatelessWidget {
  final SurahAudioStyle? style;
  SurahOnlinePlayButton({super.key, this.style});

  final surahAudioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final primary =
        style?.primaryColor ?? Theme.of(context).colorScheme.primary;
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primary.withValues(alpha: 0.25),
            primary.withValues(alpha: 0.10),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 50,
        width: 50,
        child: StreamBuilder<PlayerState>(
          stream: surahAudioCtrl.state.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            if (processingState == ProcessingState.buffering) {
              return const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    constraints: BoxConstraints(
                      maxHeight: 20,
                      maxWidth: 20,
                    ),
                    strokeWidth: 2,
                  ));
            } else if (playerState != null && !playerState.playing) {
              return IconButton(
                icon: CustomWidgets.customSvgWithColor(
                  style?.playIconPath ?? AssetsPath.assets.playArrow,
                  height: style?.playIconHeight ?? 38,
                  ctx: context,
                  color: style?.playIconColor ??
                      Theme.of(context).colorScheme.primary,
                ),
                onPressed: () async {
                  surahAudioCtrl.playSurah(
                      context: context,
                      surahNumber:
                          surahAudioCtrl.state.currentAudioListSurahNum.value);
                },
              );
            } else if (processingState != ProcessingState.completed ||
                !playerState!.playing) {
              return IconButton(
                icon: CustomWidgets.customSvgWithColor(
                  style?.pauseIconPath ?? AssetsPath.assets.pauseArrow,
                  height: style?.pauseIconHeight ?? 38,
                  ctx: context,
                  color: style?.playIconColor ??
                      Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  surahAudioCtrl.state.isPlaying.value = false;
                  surahAudioCtrl.state.audioPlayer.pause();
                },
              );
            } else {
              return IconButton(
                icon: Semantics(
                    button: true,
                    enabled: true,
                    label: 'replaySurah'.tr,
                    child: Icon(
                      Icons.replay,
                      color: style?.playIconColor ??
                          Theme.of(context).colorScheme.primary,
                    )),
                iconSize: style?.playIconHeight ?? 38.0,
                onPressed: () => surahAudioCtrl.state.audioPlayer.seek(
                    Duration.zero,
                    index: surahAudioCtrl
                        .state.audioPlayer.effectiveIndices.first),
              );
            }
          },
        ),
      ),
    );
  }
}
