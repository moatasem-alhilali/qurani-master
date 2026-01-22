part of '../../audio.dart';

class SurahSkipToNext extends StatelessWidget {
  final SurahAudioStyle? style;
  final String languageCode;
  SurahSkipToNext({super.key, this.style, this.languageCode = 'ar'});
  final audioCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      height: 50,
      width: 50,
      child: StreamBuilder<SequenceState?>(
        stream: audioCtrl.state.audioPlayer.sequenceStateStream,
        builder: (context, snapshot) => IconButton(
          icon: Semantics(
            button: true,
            enabled: true,
            label: 'next'.tr,
            child: Icon(
              isRtl ? Icons.skip_next : Icons.skip_previous,
              color:
                  style!.playIconColor ?? Theme.of(context).colorScheme.primary,
              size: style!.nextIconHeight ?? 38,
            ),
          ),
          onPressed: () async =>
              // languageCode != 'ar'
              //     ? await AudioCtrl.instance.playPreviousSurah()
              //     :
              await AudioCtrl.instance.playPreviousSurah(),
        ),
      ),
    );
  }
}
