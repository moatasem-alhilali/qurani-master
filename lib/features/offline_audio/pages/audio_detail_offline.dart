import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/models_public/position_data_model.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/offline_audio/model/quran_audio_offline.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/controller.dart';
import 'package:quran_app/core/shared/resources/assets_manager.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:rxdart/rxdart.dart';

class AudioDetailOffline extends StatelessWidget {
  AudioDetailOffline({super.key, required this.data});
  final QuranAudioModel data;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await AudioPlayerHelper.audioPlayerDetail.pause();

        return true;
      },
      child: BaseHome(
        customAppBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "السماع الى السورة",
                style: titleMedium(context),
              ),
              IconButton(
                onPressed: () async {
                  await AudioPlayerHelper.audioPlayerDetail.pause();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              height: SizeConfig.blockSizeVertical! * 70,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: SizeConfig.blockSizeVertical! * 70,
                      child: SvgPicture.asset(
                        data.imageReader!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  //!===============
                  BlocBuilder<AudioCubit, AudioCubitState>(
                    builder: (context, state) {
                      if (state is InitAudioAudioLoadingState) {
                        return const CircularProgressIndicator();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "القارئ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        data.nameReader!,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'السورة',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        " ${data.nameSurah!}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: StreamBuilder<PositionData>(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data;
                                    return ProgressBar(
                                      progressBarColor: Colors.red,
                                      baseBarColor:
                                          Colors.white.withOpacity(0.24),
                                      bufferedBarColor:
                                          Colors.white.withOpacity(0.24),
                                      thumbColor: Colors.white,
                                      barHeight: 8.0,
                                      thumbRadius: 5.0,
                                      timeLabelTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      timeLabelLocation:
                                          TimeLabelLocation.sides,
                                      progress: positionData?.position ??
                                          Duration.zero,
                                      buffered:
                                          positionData?.bufferedPosition ??
                                              Duration.zero,
                                      total: positionData?.duration ??
                                          Duration.zero,
                                      onSeek: AudioPlayerHelper
                                          .audioPlayerDetail.seek,
                                    );
                                  },
                                ),
                              ),
                              Controller(
                                audioPlayer:
                                    AudioPlayerHelper.audioPlayerDetail,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        AudioPlayerHelper.audioPlayerDetail.positionStream,
        AudioPlayerHelper.audioPlayerDetail.bufferedPositionStream,
        AudioPlayerHelper.audioPlayerDetail.durationStream,
        (position, bufferedPosition, duration) {
          return PositionData(
            position,
            bufferedPosition,
            duration ?? Duration.zero,
          );
        },
      );
}
