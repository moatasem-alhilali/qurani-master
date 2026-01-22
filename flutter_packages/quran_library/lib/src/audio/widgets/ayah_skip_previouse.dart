part of '../audio.dart';

class AyahSkipToPrevious extends StatelessWidget {
  final AyahAudioStyle? style;
  const AyahSkipToPrevious({super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final AyahAudioStyle effectiveStyle =
        style ?? AyahAudioStyle.defaults(isDark: dark, context: context);

    return SizedBox(
      height: 55,
      width: 55,
      child: StreamBuilder<SequenceState?>(
        stream: AudioCtrl.instance.state.audioPlayer.sequenceStateStream,
        builder: (context, snapshot) => IconButton(
          icon: Semantics(
            button: true,
            enabled: true,
            label: 'skipToPrevious'.tr,
            child: Icon(
              Icons.skip_next,
              color: effectiveStyle.playIconColor!,
              size: effectiveStyle.previousIconHeight!,
            ),
          ),
          onPressed: () => AudioCtrl.instance.skipPreviousAyah(
              context, AudioCtrl.instance.state.currentAyahUniqueNumber.value),
        ),
      ),
    );
  }
}
