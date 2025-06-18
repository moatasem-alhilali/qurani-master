import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/services/download_service.dart';

part 'download_quran_audio_event.dart';
part 'download_quran_audio_state.dart';

class DownloadQuranAudioBloc
    extends Bloc<DownloadQuranAudioEvent, DownloadQuranAudioState> {
  DownloadQuranAudioBloc() : super(const DownloadQuranAudioState()) {
    on<StartDownloadQuranAudioEvent>(_startDownloadQuranAudioEvent);
  }
  DownloadService downloadService = DownloadService();
  final String urlAudioReader =
      'https://cdn.islamic.network/quran/audio-surah/128';

  //
  Future<void> _startDownloadQuranAudioEvent(
    StartDownloadQuranAudioEvent event,
    Emitter<DownloadQuranAudioState> emit,
  ) async {
    try {
      //url
      final url =
          '$urlAudioReader/${event.currentAudioData.identifier}/${event.currentAudioData.indexSurah}.mp3';

      final description = event.currentAudioData.nameReader ?? '';
      downloadService.download(url, description);
      emit(state.copyWith(loadState: RequestState.success));
    } catch (e) {
      emit(state.copyWith(loadState: RequestState.error));
    }
  }

  @override
  Future<void> close() {
    downloadService.remove();
    return super.close();
  }
}
