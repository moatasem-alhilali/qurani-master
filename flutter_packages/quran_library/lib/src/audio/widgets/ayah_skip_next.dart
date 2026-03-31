part of '../audio.dart';

class AyahSkipToNext extends StatelessWidget {
  final AyahAudioStyle? style;
  AyahSkipToNext({super.key, this.style});
  final audioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final AyahAudioStyle effectiveStyle =
        style ?? AyahAudioStyle.defaults(isDark: dark, context: context);

    return SizedBox(
      height: 55,
      width: 55,
      child: StreamBuilder<SequenceState?>(
        stream: audioCtrl.state.audioPlayer.sequenceStateStream,
        builder: (context, snapshot) => GestureDetector(
          child: Semantics(
            button: true,
            enabled: true,
            label: 'next'.tr,
            child: Icon(
              Icons.skip_previous,
              color: effectiveStyle.playIconColor!,
              size: effectiveStyle.nextIconHeight!,
            ),
          ),
          onTap: () async => await audioCtrl.skipNextAyah(
              context, audioCtrl.state.currentAyahUniqueNumber.value),
        ),
      ),
    );
  }
}
