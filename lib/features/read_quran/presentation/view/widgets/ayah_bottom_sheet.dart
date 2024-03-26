import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/models_public/position_data_model.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:rxdart/rxdart.dart';

class AyahBottomSheet extends StatelessWidget {
  AyahBottomSheet({
    super.key,
    required this.verseNumber,
    this.text,
    required this.audioPlayer,
    required this.surahNumber,
    required this.ayah,
  });
  final AudioPlayer audioPlayer;

  final int verseNumber;
  final int surahNumber;
  String? text;
  String? ayah;

  @override
  Widget build(BuildContext context) {
    return Container(
          height: SizeConfig.blockSizeVertical! * 60,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xff1e1e1e),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Text(
                  "السماع",
                  style: titleMedium(context).copyWith(color: FxColors.primary),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff2f2f2f),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SliderAudio(audioPlayer: audioPlayer),
                ),
                Text(
                  "الايه",
                  style: titleMedium(context).copyWith(color: FxColors.primary),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: const Color(0xff2f2f2f),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                  ayah??"",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      wordSpacing: 5,
                      color: Colors.white,
                      fontFamily: "quran",
                      fontSize: 20,
                      height: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "تفسير الأية",
                    style:
                        titleMedium(context).copyWith(color: FxColors.primary),
                  ),
                ),
                const Divider(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: const Color(0xff2f2f2f),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    text ?? "",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}

class SliderAudio extends StatelessWidget {
  const SliderAudio({
    super.key,
    required this.audioPlayer,
  });
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return ProgressBar(
                progressBarColor: Colors.red,
                baseBarColor: Colors.white.withOpacity(0.24),
                bufferedBarColor: Colors.white.withOpacity(0.24),
                thumbColor: Colors.white,
                barHeight: 10.0,
                thumbRadius: 10.0,
                timeLabelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                progress: positionData?.position ?? Duration.zero,
                buffered: positionData?.bufferedPosition ?? Duration.zero,
                total: positionData?.duration ?? Duration.zero,
                onSeek: audioPlayer.seek,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ControllerReader(
                audioPlayer: audioPlayer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        audioPlayer.positionStream,
        audioPlayer.bufferedPositionStream,
        audioPlayer.durationStream,
        (position, bufferedPosition, duration) {
          return PositionData(
            position,
            bufferedPosition,
            duration ?? Duration.zero,
          );
        },
      );
}

//

class ControllerReader extends StatelessWidget {
  const ControllerReader({Key? key, required this.audioPlayer})
      : super(key: key);
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: StreamBuilder<PlayerState>(
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;
          if (!(playing ?? false)) {
            return IconButton(
              onPressed: audioPlayer.play,
              icon: const Icon(Icons.play_arrow, size: 40),
            );
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
              onPressed: audioPlayer.pause,
              icon: const Icon(Icons.pause, size: 40),
            );
          } else {
            return const Icon(Icons.play_arrow_rounded, size: 40);
          }
        },
        stream: audioPlayer.playerStateStream,
      ),
    );
  }
}
