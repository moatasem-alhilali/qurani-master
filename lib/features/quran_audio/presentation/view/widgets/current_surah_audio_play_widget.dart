import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/icon_play_toggle_audio_widget.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class CurrentSurahAudioPlayWidget extends StatelessWidget {
  const CurrentSurahAudioPlayWidget({
    required this.boxController,
    super.key,
  });
  final BoxController boxController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, readQuranState) {
        return readQuranState.loadQuranState.handle(
          onInitial: const SizedBox(),
          onLoading: const CircularProgressIndicator(),
          onError: const SizedBox(),
          onSuccess: () => BlocBuilder<QuranAudioBloc, QuranAudioState>(
            builder: (context, state) {
              return state.loadAudioSourceState.handle(
                onInitial: const SizedBox(),
                onLoading: ShimmerWidget(
                  child: _ItemWidget(
                    boxController: boxController,
                    currentAudioData: CurrentQuranAudioModel(
                      nameReader: 'Loading...',
                      imageReader: '',
                      indexSurah: 0,
                      identifier: '',
                      countSurahVerse: '0',
                      nameSurah: '',
                    ),
                  ),
                ),
                onError: const SizedBox(),
                onSuccess: () {
                  final currentAudioData = state.currentAudioData;

                  return _ItemWidget(
                    boxController: boxController,
                    currentAudioData: currentAudioData,
                  );
                },
              );
            },
          ),
        );
      },
    ).animate().fade();
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    required this.currentAudioData,
    required this.boxController,
    super.key,
  });
  final BoxController boxController;

  final CurrentQuranAudioModel? currentAudioData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranAudioBloc, QuranAudioState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (boxController.isBoxClosed) boxController.openBox();
          },
          child: ColoredBox(
            color: context.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: context.surfaceColor,
                          radius: 20,
                          child: Text(
                            currentAudioData?.nameReader?.substring(0, 1) ?? '',
                            style: context.titleMedium?.copyWith(
                              color: context.gray1,
                            ),
                          ),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentAudioData?.nameReader ?? '',
                              style: context.titleMedium?.copyWith(
                                  // color: context.gray1,
                                  ),
                            ),
                            // const Gap(5),
                            Text(
                              currentAudioData?.nameSurah ?? '',
                              style: context.titleSmall?.copyWith(
                                  // color: context.gray1,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(5),
                  Builder(
                    builder: (context) {
                      if (state.loadAudioSourceState == RequestState.loading) {
                        return const SizedBox();
                      }

                      return IconPlayToggleAudioWidget(
                        audioPlayer: state.audioPlayerSource ?? AudioPlayer(),
                        radius: 18,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionProgressWidget extends StatelessWidget {
  const _ActionProgressWidget({
    required this.audioPlayer,
    required this.currentIndex,
    required this.itemIndex,
    super.key,
  });

  final AudioPlayer audioPlayer;
  final int currentIndex;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranAudioBloc, QuranAudioState>(
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
                backgroundColor: context.primaryColor,
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
                backgroundColor: context.primaryColor,
                child: const Icon(Icons.play_arrow_rounded),
              );
            }
          },
        );
      },
    );
  }
}
