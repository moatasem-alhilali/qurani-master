import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/components/base_header_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_audio/data/remote/audio_player_repo.dart';
import 'package:quran_app/features/quran_audio/presentation/cubit/audio_cubit.dart';
import 'package:quran_app/features/quran_audio/presentation/view/pages/audio_quran_screen.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class SurahAudioOnly extends StatelessWidget {
  const SurahAudioOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, state) {
        switch (state.loadQuranState) {
          case RequestState.initial:
            return const SizedBox();

          case RequestState.loading:
            return const SizedBox();

          case RequestState.error:
            return const SizedBox();
          case RequestState.success:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BaseHederWidget(text: 'الاستماع الى القرأن'),
                InkWell(
                  onTap: () {
                    navigateTo(const AudioQuranScreen(), context);
                  },
                  child: BlocBuilder<BaseBloc, BaseState>(
                    builder: (context, state) {
                      return BlocBuilder<AudioCubit, AudioState>(
                        builder: (context, state) {
                          return CardWidget(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            AudioPlayerRepo
                                                .currentAudioData.imageReader!,
                                            fit: BoxFit.cover,
                                            height: context.getHight(8),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AudioPlayerRepo
                                                  .currentAudioData.nameReader!,
                                              style: titleMedium(context),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            BlocBuilder<AudioCubit, AudioState>(
                                              builder: (context, state) {
                                                return Text(
                                                  context
                                                      .read<ReadQuranBloc>()
                                                      .quranRH
                                                      .surahs[AudioPlayerRepo
                                                          .currentSurah]
                                                      .arabicName,
                                                  style: titleSmall(context),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    BlocBuilder<AudioCubit, AudioState>(
                                      builder: (context, state) {
                                        if (state
                                            is LoadingInitAudioPlayerState) {
                                          return const SizedBox();
                                        }
                                        if (state
                                            is NextPlayAudioLoadingState) {
                                          return const SizedBox();
                                        }

                                        return _ActionProgress(
                                          currentIndex: 0,
                                          itemIndex: 0,
                                          audioPlayer: AudioPlayerRepo
                                              .audioPlayerOnlineListen,
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                //
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
        }
      },
    ).animate().fade();
  }
}

class _ActionProgress extends StatelessWidget {
  const _ActionProgress({
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
