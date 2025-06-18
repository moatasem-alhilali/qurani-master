part of 'download_quran_audio_bloc.dart';

@immutable
abstract class DownloadQuranAudioEvent {}

class SetStateDownloadQuranAudioEvent extends DownloadQuranAudioEvent {}

class StartDownloadQuranAudioEvent extends DownloadQuranAudioEvent {
  StartDownloadQuranAudioEvent({
    required this.currentAudioData,
  });
  final CurrentQuranAudioModel currentAudioData;
}
