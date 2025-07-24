import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/download_surah_aduio_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/icon_play_toggle_audio_widget.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class SurahAudioListWidget extends StatefulWidget {
  const SurahAudioListWidget({
    super.key,
  });

  @override
  State<SurahAudioListWidget> createState() => _SurahAudioListWidgetState();
}

class _SurahAudioListWidgetState extends State<SurahAudioListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, readQuranState) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: readQuranState.surahs.length,
          itemBuilder: (context, index) {
            final data = readQuranState.surahs[index];
            return CardWidget(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              borderRadius: BorderRadius.circular(12),
              child: _ItemDownloaded(
                data: data,
                indexSurah: index,
              ),
            );
          },
        );
      },
    );
  }
}

class _ItemDownloaded extends StatefulWidget {
  _ItemDownloaded({super.key, this.data, this.indexSurah});
  NewSurahModel? data;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.data!.nameAr,
                  style: titleSmall(context).copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                const Gap(10),
                Text(
                  '(${widget.data!.ayahCount})',
                  style: titleSmall(context).copyWith(),
                ),
              ],
            ),
            Row(
              children: [
                _BaseActionProgress(
                  currentIndex: state.audioPlayerSource?.currentIndex ?? 0,
                  itemIndex: widget.indexSurah ?? 0,
                  surah: surahs[widget.indexSurah!],
                ),
                const Gap(10),
                DownloadSurahAudioWidget(indexSurah: widget.indexSurah),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _BaseActionProgress extends StatefulWidget {
  const _BaseActionProgress({
    required this.currentIndex,
    required this.itemIndex,
    required this.surah,
    super.key,
  });

  final int currentIndex;
  final int itemIndex;
  final SurahInfoModel surah;

  @override
  State<_BaseActionProgress> createState() => _BaseActionProgressState();
}

class _BaseActionProgressState extends State<_BaseActionProgress> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranAudioBloc, QuranAudioState>(
      builder: (context, state) {
        final currentPlaying = widget.currentIndex == widget.itemIndex;
        if (currentPlaying) {
          return IconPlayToggleAudioWidget(
            audioPlayer: state.audioPlayerSource ?? AudioPlayer(),
            radius: 18,
          );
        }
        return CircleAvatar(
          radius: 18,
          backgroundColor: context.primaryScheme,
          child: FittedBox(
            child: StyleButtonWrap(
              onTap: () {
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

                context.read<QuranAudioBloc>().add(
                      SeekToAudioPlayerSourceEvent(
                        index: widget.itemIndex,
                      ),
                    );
              },
              child: const Icon(Icons.play_arrow),
            ),
          ),
        );
      },
    );
  }
}
