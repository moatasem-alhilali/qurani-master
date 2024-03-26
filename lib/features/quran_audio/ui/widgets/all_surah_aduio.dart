import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/base_bloc.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class AllSurahAudio extends StatefulWidget {
  const AllSurahAudio({
    super.key,
  });

  @override
  State<AllSurahAudio> createState() => _AllSurahAudioState();
}

class _AllSurahAudioState extends State<AllSurahAudio> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "سور أخرى",
                style: titleMedium(context),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: context.read<ReadQuranBloc>().quranRH.surahs.length,
              itemBuilder: (context, index) {
                var data = context.read<ReadQuranBloc>().quranRH.surahs[index];
                return Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: context.getHight(10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
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
  _ItemDownloaded({Key? key, this.data, this.indexSurah}) : super(key: key);
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${widget.indexSurah! + 1}',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.data!.arabicName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              "${widget.data!.ayahs.length}",
              style: const TextStyle(
                color: Colors.grey,
              ),
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
                    backgroundColor: FxColors.primary,
                    child: const Icon(Icons.play_arrow_rounded),
                  );
                }
                if (state is NextPlayAudioLoadingState) {
                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: FxColors.primary,
                    child: const Icon(Icons.play_arrow_rounded),
                  );
                }

                return BaseActionProgress(
                  currentIndex:
                      AudioPlayerHelper.audioPlayerOnlineListen.currentIndex ??
                          0,
                  itemIndex: widget.indexSurah ?? 0,
                  audioPlayer: AudioPlayerHelper.audioPlayerOnlineListen,
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
                var currentAudioData = AudioPlayerHelper.currentAudioData;

                CurrentAudioModel updateCurrent = CurrentAudioModel(
                  countSurahVerse: surahs[widget.indexSurah!].ayahs.length,
                  imageReader: currentAudioData.imageReader,
                  nameReader: currentAudioData.nameReader,
                  nameSurah: surahs[widget.indexSurah!].englishName,
                  identifier: currentAudioData.identifier,
                  indexSurah: widget.indexSurah! + 1,
                );
                //save
                AudioPlayerHelper.currentAudioData = updateCurrent;
                AudioPlayerHelper.audioPlayerOnlineListen
                    .seek(Duration.zero, index: widget.indexSurah);
                downloadAudio();
                setState(() {
                  current = null;
                });
              },
              icon: const Icon(Icons.download),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> downloadAudio() async {
    String urlAudioReader = "https://cdn.islamic.network/quran/audio-surah/128";
    //url
    String url =
        "$urlAudioReader/${AudioPlayerHelper.currentAudioData.identifier}/${AudioPlayerHelper.currentAudioData.indexSurah}.mp3";

    final description = AudioPlayerHelper.currentAudioData.nameReader ?? "";
    downloadService.download(url, description);
  }
}

class BaseActionProgress extends StatefulWidget {
  const BaseActionProgress({
    Key? key,
    required this.audioPlayer,
    required this.currentIndex,
    required this.itemIndex,
    required this.surah,
  }) : super(key: key);

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
                backgroundColor: FxColors.primary,
                child: FittedBox(
                  child: IconButton(
                    onPressed: () {
                      widget.audioPlayer
                          .seek(Duration.zero, index: widget.itemIndex);
                      widget.audioPlayer.play();

                      var currentAudioData = AudioPlayerHelper.currentAudioData;

                      CurrentAudioModel updateCurrent = CurrentAudioModel(
                        countSurahVerse: widget.surah.ayahs.length,
                        imageReader: currentAudioData.imageReader,
                        nameReader: currentAudioData.nameReader,
                        nameSurah: widget.surah.englishName,
                        identifier: currentAudioData.identifier,
                        indexSurah: widget.itemIndex + 1,
                      );
                      //save
                      AudioPlayerHelper.currentAudioData = updateCurrent;
                      AudioPlayerHelper.currentSurah = widget.itemIndex;

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
