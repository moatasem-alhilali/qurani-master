import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/widgets/animated_snackbar_widget.dart';
import 'package:quran_app/core/widgets/filled_button_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/download_quran_audio_bloc/download_quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class SurahAudioListWidget extends StatefulWidget {
  const SurahAudioListWidget({
    required this.boxController,
    super.key,
  });
  final BoxController boxController;
  @override
  State<SurahAudioListWidget> createState() => _SurahAudioListWidgetState();
}

class _SurahAudioListWidgetState extends State<SurahAudioListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, readQuranState) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: readQuranState.surahs.length,
          itemBuilder: (context, index) {
            final data = readQuranState.surahs[index];
            return _ItemDownloaded(
              data: data,
              indexSurah: index,
              boxController: widget.boxController,
            );
          },
          separatorBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.only(
                left: 10,
                // right: 10,
              ),
              child: Divider(
                // color: context.onPrimary.withAlpha(50),
                height: 0.5,
              ),
            );
          },
        );
      },
    );
  }
}

class _ItemDownloaded extends StatefulWidget {
  const _ItemDownloaded({
    required this.boxController,
    super.key,
    this.data,
    this.indexSurah,
  });
  final NewSurahModel? data;
  final int? indexSurah;
  final BoxController boxController;
  @override
  State<_ItemDownloaded> createState() => _ItemDownloadedState();
}

class _ItemDownloadedState extends State<_ItemDownloaded> {
  int? current;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranAudioBloc, QuranAudioState>(
      builder: (context, state) {
        final currentPlaying =
            state.currentAudioData?.indexSurah == widget.indexSurah;

        return FilledButtonWidget(
          onPressed: () {
            final updateCurrent = state.currentAudioData?.copyWith(
              countSurahVerse: widget.data!.ayahCount.toString(),
              nameSurah: widget.data!.nameAr,
              indexSurah: widget.indexSurah,
            );
            //save
            context.read<QuranAudioBloc>().add(
                  ChangeCurrentAudioDataEvent(
                    currentAudioData: updateCurrent!,
                    reInitialize: false,
                  ),
                );

            context.read<QuranAudioBloc>().add(
                  SeekToAudioPlayerSourceEvent(
                    index: widget.indexSurah!,
                  ),
                );

            widget.boxController.openBox();
          },
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          borderRadius: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.data?.nameAr ?? '',
                    style: titleSmall(context).copyWith(
                      fontSize: 16.sp,
                      color: !currentPlaying ? null : context.primaryColor,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    '(${widget.data?.ayahCount})',
                    style: titleSmall(context).copyWith(
                      color: !currentPlaying ? null : context.primaryColor,
                    ),
                  ),
                ],
              ),
              BlocBuilder<DownloadQuranAudioBloc, DownloadQuranAudioState>(
                builder: (context, stateDownload) {
                  return PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<void>(
                          onTap: () async {
                            context.showCustomSnackbar(
                              'هل تريد تحميل السورة؟',
                              style: SnackBarType.warning,
                              actionLabel: 'تأكيد',
                              duration: const Duration(seconds: 3),
                              paddingBottom: 100,
                              onAction: () {
                                final surahs = state.surahInfoData;

                                final updateCurrent = CurrentQuranAudioModel(
                                  countSurahVerse:
                                      state.currentAudioData!.countSurahVerse,
                                  imageReader:
                                      state.currentAudioData!.imageReader,
                                  nameReader:
                                      state.currentAudioData!.nameReader,
                                  nameSurah: surahs[widget.indexSurah!].surah,
                                  identifier:
                                      state.currentAudioData!.identifier,
                                  indexSurah: widget.indexSurah! + 1,
                                );
                                if (context.mounted) {
                                  context.read<DownloadQuranAudioBloc>().add(
                                        StartDownloadQuranAudioEvent(
                                          currentAudioData: updateCurrent,
                                        ),
                                      );
                                }
                              },
                            );
                          },
                          child: Text(
                            'تحميل السورة',
                            style: context.bodyMedium,
                          ),
                        ),
                      ];
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
