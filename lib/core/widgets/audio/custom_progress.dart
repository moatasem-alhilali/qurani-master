import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/models_public/position_data_model.dart';
import 'package:quran_app/features/quran_audio/presentation/cubit/audio_cubit.dart';
import 'package:rxdart/rxdart.dart';

class ProgressAudio extends StatelessWidget {
  const ProgressAudio({
    required this.audioPlayer,
    super.key,
    this.isOffline = false,
  });
  final AudioPlayer audioPlayer;
  final bool isOffline;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
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
                barHeight: 8,
                thumbRadius: 5,
                timeLabelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                timeLabelLocation: TimeLabelLocation.sides,
                progress: positionData?.position ?? Duration.zero,
                buffered: positionData?.bufferedPosition ?? Duration.zero,
                total: positionData?.duration ?? Duration.zero,
                onSeek: audioPlayer.seek,
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        //icon controller

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                          AudioCubit.get(context)
                              .playAudioNextOrPrevious(isNext: true);
                        },
                        icon: const Icon(
                          Icons.skip_next_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  if (isOffline)
                    _ActionProgress(
                      audioPlayer: audioPlayer,
                      currentIndex: 0,
                      itemIndex: 0,
                      onPressed: () {},
                    ),
                  //!Controller audio
                  if (!isOffline)
                    BlocBuilder<AudioCubit, AudioState>(
                      builder: (context, state) {
                        if (state is LoadingInitAudioPlayerState) {
                          return const CircularProgressIndicator();
                        }
                        if (state is NextPlayAudioLoadingState) {
                          return const CircularProgressIndicator();
                        }

                        return _ActionProgress(
                          audioPlayer: audioPlayer,
                          currentIndex: 0,
                          itemIndex: 0,
                          onPressed: () {},
                        );
                      },
                    ),

                  const SizedBox(width: 20),

                  //back
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: FittedBox(
                      child: IconButton(
                        onPressed: () async {
                          if (audioPlayer.currentIndex != 0) {
                            AudioCubit.get(context)
                                .playAudioNextOrPrevious(isNext: false);
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

  Stream<PositionData> get positionDataStreamOfOnlineListing =>
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

class _ActionProgress extends StatelessWidget {
  const _ActionProgress({
    required this.audioPlayer,
    required this.currentIndex,
    required this.onPressed,
    required this.itemIndex,
    super.key,
  });

  final AudioPlayer audioPlayer;
  final int currentIndex;
  final int itemIndex;
  final void Function() onPressed;

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
                backgroundColor: context.primaryScheme,
                child: FittedBox(
                  child: IconButton(
                    onPressed: audioPlayer.play,
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
                backgroundColor: context.primaryScheme,
                child: const Icon(Icons.play_arrow_rounded),
              );
            }
          },
        );
      },
    );
  }
}
