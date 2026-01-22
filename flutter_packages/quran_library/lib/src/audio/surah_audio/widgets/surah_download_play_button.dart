part of '../../audio.dart';

class SurahDownloadPlayButton extends StatelessWidget {
  final SurahAudioStyle? style;
  final int surahNumber;
  const SurahDownloadPlayButton(
      {super.key, this.style, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    final isSelected =
        AudioCtrl.instance.state.selectedSurahIndex.value == surahNumber - 1;
    return Container(
      width: 36.0,
      height: 36.0,
      decoration: BoxDecoration(
        color: isSelected
            ? (style?.primaryColor ?? Theme.of(context).colorScheme.primary)
            : (style?.primaryColor ?? Theme.of(context).colorScheme.primary)
                .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: GetBuilder<AudioCtrl>(
        id: 'surahDownloadManager_id',
        builder: (surahAudioCtrl) {
          final isDownloaded =
              surahAudioCtrl.state.isSurahDownloadedByNumber(surahNumber).value;
          return (isSelected &&
                  surahAudioCtrl.state.isDownloading.value &&
                  !isDownloaded)
              ? isDownloaded
                  ? const SizedBox.shrink()
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 35.0,
                          width: 35.0,
                          child: CircularProgressIndicator(
                            value: surahAudioCtrl.state.progress.value,
                            strokeWidth: 4.0,
                            color: context.theme.colorScheme.inversePrimary,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              style?.downloadProgressColor ??
                                  context.theme.colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.close,
                            color: style?.iconColor ?? Colors.black,
                            size: 28,
                          ),
                          onTap: () => surahAudioCtrl.cancelDownload(),
                        ),
                      ],
                    )
              : StreamBuilder<PlayerState>(
                  stream: surahAudioCtrl.state.audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    if ((processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) &&
                        isSelected) {
                      return SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: style?.downloadProgressColor ?? Colors.white,
                          ));
                    } else {
                      return GestureDetector(
                        onTap: () =>
                            surahAudioCtrl.downloadSurah(surahNum: surahNumber),
                        child: Icon(
                          isDownloaded
                              ? Icons.download_done
                              : Icons.cloud_download_outlined,
                          color: isSelected
                              ? Colors.white
                              : (style?.primaryColor ??
                                  Theme.of(context).colorScheme.primary),
                          size: 20.0,
                        ),
                      );
                    }
                  },
                );
        },
      ),
    );
  }
}
