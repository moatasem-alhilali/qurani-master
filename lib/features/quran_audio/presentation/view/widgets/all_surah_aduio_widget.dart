import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/models_public/surahs_model.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/download_surah_aduio_widget.dart';
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
  int? current;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranAudioBloc, QuranAudioState>(
      builder: (context, state) {
        final surahs = state.surahInfoData;

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
                BaseActionProgress(
                  currentIndex: state.audioPlayerSource?.currentIndex ?? 0,
                  itemIndex: widget.indexSurah ?? 0,
                  surah: surahs[widget.indexSurah!],
                ),
                DownloadSurahAudioWidget(indexSurah: widget.indexSurah),
              ],
            ),
          ],
        );
      },
    );
  }
}

class BaseActionProgress extends StatefulWidget {
  const BaseActionProgress({
    required this.currentIndex,
    required this.itemIndex,
    required this.surah,
    super.key,
  });

  final int currentIndex;
  final int itemIndex;
  final SurahInfoModel surah;

  @override
  State<BaseActionProgress> createState() => _BaseActionProgressState();
}

class _BaseActionProgressState extends State<BaseActionProgress> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranAudioBloc, QuranAudioState>(
      builder: (context, state) {
        return StreamBuilder<PlayerState>(
          stream: state.audioPlayerSource?.playerStateStream,
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
                      final updateCurrent = state.currentAudioData!.copyWith(
                        countSurahVerse: widget.surah.ayaatiha,
                        nameSurah: widget.surah.surah,
                        indexSurah: widget.itemIndex,
                      );
                      //save
                      context.read<QuranAudioBloc>().add(
                            ChangeCurrentAudioDataEvent(
                              currentAudioData: updateCurrent,
                              reInitialize: false,
                            ),
                          );

                      // state.audioPlayerSource?.seek(Duration.zero, index: widget.itemIndex + 1);

                      context.read<QuranAudioBloc>().add(
                            SeekToAudioPlayerSourceEvent(
                              index: widget.itemIndex,
                            ),
                          );
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
                      state.audioPlayerSource?.pause();
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
                child: const Icon(Icons.info),
              );
            }
          },
        );
      },
    );
  }
}
