import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/base_bloc.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/models_public/position_data_model.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/shared/export/export-shared.dart';

class ProgressWithController extends StatelessWidget {
  const ProgressWithController({
    super.key,
    required this.countVerse,
  });
  final String countVerse;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: StreamBuilder<PositionData>(
            stream: positionDataStreamOfOnlineListing,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return ProgressBar(
                progressBarColor: Colors.red,
                baseBarColor: Colors.white.withOpacity(0.24),
                bufferedBarColor: Colors.white.withOpacity(0.24),
                thumbColor: Colors.white,
                barHeight: 8.0,
                thumbRadius: 5.0,
                timeLabelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                timeLabelLocation: TimeLabelLocation.sides,
                progress: ISCONNECTED
                    ? positionData?.position ?? Duration.zero
                    : Duration.zero,
                buffered: ISCONNECTED
                    ? positionData?.bufferedPosition ?? Duration.zero
                    : Duration.zero,
                total: ISCONNECTED
                    ? positionData?.duration ?? Duration.zero
                    : Duration.zero,
                onSeek: ISCONNECTED
                    ? AudioPlayerHelper.audioPlayerOnlineListen.seek
                    : null,
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),

        //icon controller

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              Row(
                children: [
                  //next
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: FittedBox(
                      child: IconButton(
                        onPressed: () async {
                          if (ISCONNECTED) {
                            AudioCubit.get(context)
                                .playAudioNextOrPrevious(isNext: true);
                            //current
                            var currentAudioData =
                                AudioPlayerHelper.currentAudioData;
                            //update
                            CurrentAudioModel updateCurrent = CurrentAudioModel(
                              countSurahVerse: currentAudioData.countSurahVerse,
                              imageReader: currentAudioData.imageReader,
                              nameReader: currentAudioData.nameReader,
                              nameSurah: currentAudioData.nameSurah,
                              identifier: currentAudioData.identifier,
                              indexSurah: AudioPlayerHelper.currentSurah,
                            );
                            //save
                            AudioPlayerHelper.currentAudioData = updateCurrent;
                          }
                        },
                        icon: const Icon(
                          Icons.skip_next_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),

                  //!Controller audio
                  BlocBuilder<AudioCubit, AudioState>(
                    builder: (context, state) {
                      if (state is LoadingInitAudioPlayerState) {
                        return const CircularProgressIndicator();
                      }
                      if (state is NextPlayAudioLoadingState) {
                        return const CircularProgressIndicator();
                      }

                      return _ActionProgress(
                        currentIndex: 0,
                        itemIndex: 0,
                        audioPlayer: AudioPlayerHelper.audioPlayerOnlineListen,
                      );
                    },
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  //back
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: FittedBox(
                      child: IconButton(
                        onPressed: () async {
                          if (ISCONNECTED) {
                            if (AudioPlayerHelper
                                    .audioPlayerOnlineListen.currentIndex !=
                                0) {
                              //current
                              var currentAudioData =
                                  AudioPlayerHelper.currentAudioData;
                              //update
                              CurrentAudioModel updateCurrent =
                                  CurrentAudioModel(
                                countSurahVerse:
                                    currentAudioData.countSurahVerse,
                                imageReader: currentAudioData.imageReader,
                                nameReader: currentAudioData.nameReader,
                                nameSurah: currentAudioData.nameSurah,
                                identifier: currentAudioData.identifier,
                                indexSurah: AudioPlayerHelper.currentSurah,
                              );
                              //save
                              AudioPlayerHelper.currentAudioData =
                                  updateCurrent;
                              AudioCubit.get(context)
                                  .playAudioNextOrPrevious(isNext: false);
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.skip_previous_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Stream<PositionData> get positionDataStreamOfOnlineListing =>
    Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      AudioPlayerHelper.audioPlayerOnlineListen.positionStream,
      AudioPlayerHelper.audioPlayerOnlineListen.bufferedPositionStream,
      AudioPlayerHelper.audioPlayerOnlineListen.durationStream,
      (position, bufferedPosition, duration) {
        return PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        );
      },
    );

class _ActionProgress extends StatelessWidget {
  const _ActionProgress({
    Key? key,
    required this.audioPlayer,
    required this.currentIndex,
    required this.itemIndex,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final int currentIndex;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        return StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            final currentPlaying = currentIndex == itemIndex;

            if (!(playing ?? false) || !currentPlaying) {
              return CircleAvatar(
                radius: 18,
                backgroundColor: FxColors.primary,
                child: FittedBox(
                  child: IconButton(
                    onPressed: () {
                      audioPlayer.play();
                    },
                    icon: const Icon(Icons.play_arrow_outlined),
                  ),
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return CircleAvatar(
                radius: 18,
                backgroundColor: Colors.redAccent,
                child: FittedBox(
                  child: IconButton(
                    onPressed: audioPlayer.pause,
                    icon: const Icon(
                      Icons.stop_circle_outlined,
                    ),
                  ),
                ),
              );
            } else {
              return CircleAvatar(
                radius: 18,
                backgroundColor: FxColors.primary,
                child: const Icon(Icons.play_arrow_rounded),
              );
            }
          },
        );
      },
    );
  }
}
