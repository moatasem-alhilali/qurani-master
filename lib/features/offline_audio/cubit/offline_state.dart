part of 'offline_cubit.dart';

@immutable
abstract class OfflineState {
  // double? progress;
  // bool? isDownloading;
  // bool? isComplete;

  // OfflineState({
  //   this.progress = 0.0,
  //   this.isDownloading = false,
  //   this.isComplete = false,
  // });

  // OfflineState copyWith({
  //   double? progress,
  //   bool? isDownloading,
  //   bool? isComplete,
  // }) {
  //   return OfflineState(
  //     progress: progress ?? this.progress,
  //     isDownloading: isDownloading ?? this.isDownloading,
  //     isComplete: isComplete ?? this.isComplete,
  //   );
  // }
}

class OfflineInitial extends OfflineState {}

//get offline audio state
class GetAudioOfflineLoadingState extends OfflineState {}

class GetAudioOfflineSuccessState extends OfflineState {}

class GetAudioOfflineErrorState extends OfflineState {}
//download state

class DownloadAudioOfflineLoadingState extends OfflineState {}

class DownloadAudioOfflineSuccessState extends OfflineState {}

class DownloadAudioOfflineErrorState extends OfflineState {}
