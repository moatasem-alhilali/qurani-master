part of '../../audio.dart';

class SurahSeekBar extends StatelessWidget {
  final String? languageCode;
  final SurahAudioStyle? style;
  const SurahSeekBar({super.key, this.languageCode, this.style});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioCtrl>(
        id: 'surahDownloadManager_id',
        builder: (c) => c.state.isDownloading.value
            ? PackageSliderWidget.downloading(
                currentPosition: c.state.downloadProgress.value.toInt(),
                filesCount: c.state.fileSize.value,
                horizontalPadding: 32.0)
            : StreamBuilder<PackagePositionData>(
                stream: c.positionDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    c.state.positionData?.value = snapshot.data!;
                    final positionData = snapshot.data!;

                    return PackageSliderWidget.player(
                      horizontalPadding: 32.0,
                      duration: positionData.duration,
                      position: c.state.lastPosition.value != 0
                          ? Duration(
                              seconds: c.state.lastPosition.value.toInt())
                          : positionData.position,
                      activeTrackColor: style!.seekBarActiveTrackColor ??
                          Theme.of(context).colorScheme.primary,
                      inactiveTrackColor:
                          style!.seekBarInactiveTrackColor ?? Colors.grey,
                      thumbColor: style!.seekBarThumbColor ??
                          Theme.of(context).colorScheme.primary,
                      timeContainerColor: style?.timeContainerColor,
                      // bufferedPosition: positionData.bufferedPosition,
                      onChangeEnd: (newPosition) {
                        c.state.audioPlayer.seek(newPosition);
                        // c.saveLastSurahListen(
                        //     c.state.currentAudioListSurahNum.value);
                        c.state.seekNextSeconds.value =
                            positionData.position.inSeconds;
                      },
                      textColor: style?.secondaryTextColor ?? Colors.white,
                      timeShow: true,
                      languageCode: languageCode,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ));
  }
}
