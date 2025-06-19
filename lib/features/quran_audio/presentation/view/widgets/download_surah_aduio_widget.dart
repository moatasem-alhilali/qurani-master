import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
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
            return StyleButtonWrap(
              onTap: () async {
                final result = await showDeleteConfirmationDialog<bool>(
                  context,
                  title: 'تحميل السورة',
                  message: 'هل تريد تحميل السورة؟',
                  icon: Icon(
                    Icons.download,
                    color: context.primaryScheme,
                  ),
                );
                if ((result ?? false) == true) {
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
                  if (context.mounted) {
                    context.read<DownloadQuranAudioBloc>().add(
                          StartDownloadQuranAudioEvent(
                            currentAudioData: updateCurrent,
                          ),
                        );
                  }
                }
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: context.primaryScheme,
                child: const FittedBox(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.download,
                      // color: context.primaryScheme,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
