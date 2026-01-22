part of '../../audio.dart';

class SurahRepeatWidget extends StatelessWidget {
  SurahRepeatWidget({super.key, this.style});

  final surahAudioCtrl = AudioCtrl.instance;
  final SurahAudioStyle? style;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoopMode>(
      stream: surahAudioCtrl.state.audioPlayer.loopModeStream,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.off;
        List<IconData> icons = [
          Icons.repeat,
          Icons.repeat,
        ];
        const cycleModes = [
          LoopMode.off,
          LoopMode.all,
        ];
        final index = cycleModes.indexOf(loopMode);
        final baseColor = style?.playIconColor ??
            style?.primaryColor ??
            Theme.of(context).colorScheme.primary;
        return IconButton(
          iconSize: 30.w.clamp(16, 30),
          icon: Icon(icons[index]),
          color: index == 0 ? baseColor.withValues(alpha: .4) : baseColor,
          onPressed: () {
            // surahAudioCtrl.toggleSurahsMode(index == 0 ? false : true);
            surahAudioCtrl.state.audioPlayer.setLoopMode(cycleModes[
                (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
          },
        );
      },
    );
  }
}
