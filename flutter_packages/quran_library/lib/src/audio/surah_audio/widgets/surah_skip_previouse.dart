part of '../../audio.dart';

class SurahSkipToPrevious extends StatelessWidget {
  final SurahAudioStyle? style;
  final String languageCode;
  const SurahSkipToPrevious(
      {super.key, this.style, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      height: 50,
      width: 50,
      child: StreamBuilder<SequenceState?>(
        stream: AudioCtrl.instance.state.audioPlayer.sequenceStateStream,
        builder: (context, snapshot) => IconButton(
          icon: Semantics(
            button: true,
            enabled: true,
            label: 'skipToPrevious'.tr,
            child: Icon(
              isRtl ? Icons.skip_previous : Icons.skip_next,
              color:
                  style?.playIconColor ?? Theme.of(context).colorScheme.primary,
              size: style?.previousIconHeight ?? 38,
            ),
          ),
          onPressed: () async =>
              // languageCode != 'ar'
              //     ? await AudioCtrl.instance.playNextSurah()
              //     :
              await AudioCtrl.instance.playNextSurah(),
        ),
      ),
    );
  }
}
