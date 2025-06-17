import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_audio/data/remote/audio_player_repo.dart';
import 'package:quran_app/features/quran_audio/presentation/cubit/audio_cubit.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class AllSurahAudioWidget extends StatefulWidget {
  const AllSurahAudioWidget({
    super.key,
  });

  @override
  State<AllSurahAudioWidget> createState() => _AllSurahAudioWidgetState();
}

class _AllSurahAudioWidgetState extends State<AllSurahAudioWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'سور أخرى',
                style: titleMedium(context).copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: context.read<ReadQuranBloc>().quranRH.surahs.length,
              itemBuilder: (context, index) {
                final data =
                    context.read<ReadQuranBloc>().quranRH.surahs[index];
                return CardWidget(
                  height: context.getHight(10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: _ItemDownloaded(
                    data: data,
                    indexSurah: index,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _ItemDownloaded extends StatefulWidget {
  _ItemDownloaded({super.key, this.data, this.indexSurah});
  Surah? data;
  int? indexSurah;

  @override
  State<_ItemDownloaded> createState() => _ItemDownloadedState();
}

class _ItemDownloadedState extends State<_ItemDownloaded> {
  DownloadService downloadService = DownloadService();
  @override
  void initState() {
    super.initState();
    downloadService.init();
  }

  @override
  void dispose() {
    downloadService.remove();
    super.dispose();
  }

  int? current;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              '${widget.indexSurah! + 1}',
              style: titleSmall(context).copyWith(
                fontSize: 16.sp,
              ),
            ),
            const Gap(10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data!.arabicName,
                  style: titleSmall(context).copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  '${widget.data!.ayahs.length}',
                  style: titleSmall(context).copyWith(),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            BlocBuilder<AudioCubit, AudioState>(
              builder: (context, state) {
                final surahs = context.read<ReadQuranBloc>().quranRH.surahs;

                if (state is LoadingInitAudioPlayerState) {
                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: context.primaryScheme,
                    child: const Icon(Icons.play_arrow_rounded),
                  );
                }
                if (state is NextPlayAudioLoadingState) {
                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: context.primaryScheme,
                    child: const Icon(Icons.play_arrow_rounded),
                  );
                }

                return BaseActionProgress(
                  currentIndex:
                      AudioPlayerRepo.audioPlayerOnlineListen.currentIndex ?? 0,
                  itemIndex: widget.indexSurah ?? 0,
                  audioPlayer: AudioPlayerRepo.audioPlayerOnlineListen,
                  surah: surahs[widget.indexSurah!],
                );
              },
            ),
            IconButton(
              onPressed: () async {
                final surahs = context.read<ReadQuranBloc>().quranRH.surahs;

                //current
                setState(() {
                  current = widget.indexSurah;
                });
                final currentAudioData = AudioPlayerRepo.currentAudioData;

                final updateCurrent = CurrentAudioModel(
                  countSurahVerse: surahs[widget.indexSurah!].ayahs.length,
                  imageReader: currentAudioData.imageReader,
                  nameReader: currentAudioData.nameReader,
                  nameSurah: surahs[widget.indexSurah!].englishName,
                  identifier: currentAudioData.identifier,
                  indexSurah: widget.indexSurah! + 1,
                );
                //save
                AudioPlayerRepo.currentAudioData = updateCurrent;
                AudioPlayerRepo.audioPlayerOnlineListen
                    .seek(Duration.zero, index: widget.indexSurah);
                downloadAudio();
                setState(() {
                  current = null;
                });
              },
              icon: Icon(
                Icons.download,
                color: context.primaryScheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> downloadAudio() async {
    const urlAudioReader = 'https://cdn.islamic.network/quran/audio-surah/128';
    //url
    final url =
        '$urlAudioReader/${AudioPlayerRepo.currentAudioData.identifier}/${AudioPlayerRepo.currentAudioData.indexSurah}.mp3';

    final description = AudioPlayerRepo.currentAudioData.nameReader ?? '';
    downloadService.download(url, description);
  }
}

class BaseActionProgress extends StatefulWidget {
  const BaseActionProgress({
    required this.audioPlayer,
    required this.currentIndex,
    required this.itemIndex,
    required this.surah,
    super.key,
  });

  final AudioPlayer audioPlayer;
  final int currentIndex;
  final int itemIndex;
  final Surah surah;

  @override
  State<BaseActionProgress> createState() => _BaseActionProgressState();
}

class _BaseActionProgressState extends State<BaseActionProgress> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        return StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            final currentPlaying = widget.currentIndex == widget.itemIndex;

            if (!(playing ?? false) || !currentPlaying) {
              return CircleAvatar(
                radius: 18,
                backgroundColor: context.primaryScheme,
                child: FittedBox(
                  child: IconButton(
                    onPressed: () {
                      widget.audioPlayer
                          .seek(Duration.zero, index: widget.itemIndex);
                      widget.audioPlayer.play();

                      final currentAudioData = AudioPlayerRepo.currentAudioData;

                      final updateCurrent = CurrentAudioModel(
                        countSurahVerse: widget.surah.ayahs.length,
                        imageReader: currentAudioData.imageReader,
                        nameReader: currentAudioData.nameReader,
                        nameSurah: widget.surah.englishName,
                        identifier: currentAudioData.identifier,
                        indexSurah: widget.itemIndex + 1,
                      );
                      //save
                      AudioPlayerRepo.currentAudioData = updateCurrent;
                      AudioPlayerRepo.currentSurah = widget.itemIndex;

                      BlocProvider.of<BaseBloc>(context)
                          .add(SetStateBaseBlocEvent());
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
                    onPressed: () {
                      widget.audioPlayer.pause();
                    },
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
