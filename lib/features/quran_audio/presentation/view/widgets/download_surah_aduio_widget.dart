import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/download_quran_audio_bloc/download_quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';

class DownloadSurahAudioWidget extends StatefulWidget {
  DownloadSurahAudioWidget({super.key, this.indexSurah});
  int? indexSurah;

  @override
  State<DownloadSurahAudioWidget> createState() =>
      _DownloadSurahAudioWidgetState();
}

class _DownloadSurahAudioWidgetState extends State<DownloadSurahAudioWidget> {
  int? current;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranAudioBloc, QuranAudioState>(
      builder: (context, stateQuranAudio) {
        return BlocBuilder<DownloadQuranAudioBloc, DownloadQuranAudioState>(
          builder: (context, stateDownload) {
            return IconButton(
              onPressed: () async {
                final surahs = stateQuranAudio.surahInfoData;

                final updateCurrent = CurrentQuranAudioModel(
                  countSurahVerse:
                      stateQuranAudio.currentAudioData!.countSurahVerse,
                  imageReader: stateQuranAudio.currentAudioData!.imageReader,
                  nameReader: stateQuranAudio.currentAudioData!.nameReader,
                  nameSurah: surahs[widget.indexSurah!].surah,
                  identifier: stateQuranAudio.currentAudioData!.identifier,
                  indexSurah: widget.indexSurah! + 1,
                );

                context.read<DownloadQuranAudioBloc>().add(
                      StartDownloadQuranAudioEvent(
                        currentAudioData: updateCurrent,
                      ),
                    );
              },
              icon: Icon(
                Icons.download,
                color: context.primaryScheme,
              ),
            );
          },
        );
      },
    );
  }
}
