import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/base_bloc.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';
import 'package:quran_app/features/quran_audio/ui/pages/audio_home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class SurahAudioOnly extends StatelessWidget {
  const SurahAudioOnly({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, state) {
        switch (state.loadQuranState) {
          case RequestState.defaults:
            return const SizedBox();

          case RequestState.loading:
            return const SizedBox();

          case RequestState.error:
            return const SizedBox();
          case RequestState.success:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BaseHeder(text: "الاستماع الى القرأن"),
                InkWell(
                  onTap: () {
                    navigateTo(const AudioHome(), context);
                  },
                  child: BlocBuilder<BaseBloc, BaseState>(
                    builder: (context, state) {
                      return BlocBuilder<AudioCubit, AudioState>(
                        builder: (context, state) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                            AudioPlayerHelper
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
                                              AudioPlayerHelper
                                                  .currentAudioData.nameReader!,
                                              style: titleSmall(context),
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
                                                      .surahs[AudioPlayerHelper
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
                                          audioPlayer: AudioPlayerHelper
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
