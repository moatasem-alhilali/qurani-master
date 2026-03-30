import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoungMuslimPlayerCubit extends Cubit<YoungMuslimPlayerState> {
  YoungMuslimPlayerCubit({
    required YoungMuslimRepository repository,
  })  : _repository = repository,
        super(const YoungMuslimPlayerState());

  final YoungMuslimRepository _repository;
  YoutubePlayerController? controller;
  void Function()? _controllerListener;
  int _lastSavedSecond = 0;
  bool _processingCompletion = false;

  Future<void> initialize(String videoId) async {
    emit(state.copyWith(loadState: RequestState.loading));
    try {
      final session = await _repository.getPlayerSession(videoId);
      await _configureController(session);
      emit(
        state.copyWith(
          loadState: RequestState.success,
          session: session,
          currentVideo: session.video,
          currentPosition: Duration(seconds: session.resumeFromSeconds),
          duration: Duration(seconds: session.video.durationSeconds),
          autoPlayEnabled: state.autoPlayEnabled,
          completionTrigger: state.completionTrigger,
        ),
      );
      await _repository.markVideoOpened(videoId);
      await _repository.cancelResumeReminder(videoId);
    } catch (error) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> toggleAutoPlay() async {
    emit(state.copyWith(autoPlayEnabled: !state.autoPlayEnabled));
  }

  Future<void> playNextVideo() async {
    final nextVideo = state.session?.nextVideo;
    if (nextVideo == null) {
      return;
    }
    await initialize(nextVideo.id);
  }

  Future<void> playSelectedVideo(String videoId) async {
    await initialize(videoId);
  }

  Future<void> persistOnExit() async {
    final video = state.currentVideo;
    if (video == null) {
      return;
    }

    final currentSecond = state.currentPosition.inSeconds;
    if (video.isCompleted || currentSecond >= video.durationSeconds * 0.92) {
      await _repository.markVideoCompleted(video.id);
      await _repository.cancelResumeReminder(video.id);
      return;
    }

    if (currentSecond > 20) {
      await _repository.saveVideoProgress(
        videoId: video.id,
        positionSeconds: currentSecond,
        durationSeconds: video.durationSeconds,
      );
      await _repository.scheduleResumeReminder(video.id);
    } else {
      await _repository.cancelResumeReminder(video.id);
    }
  }

  Future<void> handlePostQuizAutoPlay() async {
    if (!state.autoPlayEnabled || state.session?.nextVideo == null) {
      return;
    }
    await playNextVideo();
  }

  Future<void> _configureController(
    YoungMuslimPlayerSessionEntity session,
  ) async {
    if (controller != null && _controllerListener != null) {
      controller!.removeListener(_controllerListener!);
    }
    controller?.dispose();

    controller = YoutubePlayerController(
      initialVideoId: session.video.youtubeVideoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        enableCaption: true,
        controlsVisibleAtStart: true,
        startAt: session.resumeFromSeconds > 5 ? session.resumeFromSeconds : 0,
        useHybridComposition: true,
      ),
    );

    _lastSavedSecond = session.resumeFromSeconds;
    _processingCompletion = false;

    _controllerListener = () {
      unawaited(_handleControllerChanged(session));
    };
    controller!.addListener(_controllerListener!);
  }

  Future<void> _handleControllerChanged(
    YoungMuslimPlayerSessionEntity session,
  ) async {
    final activeController = controller;
    if (activeController == null || isClosed) {
      return;
    }

    final value = activeController.value;
    final duration = value.metaData.duration.inSeconds > 0
        ? value.metaData.duration
        : Duration(seconds: session.video.durationSeconds);
    final currentPosition = value.position;

    emit(
      state.copyWith(
        currentPosition: currentPosition,
        duration: duration,
      ),
    );

    final currentSeconds = currentPosition.inSeconds;
    if (currentSeconds > 0 && (currentSeconds - _lastSavedSecond).abs() >= 8) {
      _lastSavedSecond = currentSeconds;
      await _repository.saveVideoProgress(
        videoId: session.video.id,
        positionSeconds: currentSeconds,
        durationSeconds: session.video.durationSeconds,
      );
    }

    if (value.playerState == PlayerState.ended && !_processingCompletion) {
      _processingCompletion = true;
      await _repository.markVideoCompleted(session.video.id);
      await _repository.cancelResumeReminder(session.video.id);
      final refreshedDetails =
          await _repository.getVideoDetails(session.video.id);
      emit(
        state.copyWith(
          currentVideo: refreshedDetails.video,
          completionTrigger: state.completionTrigger + 1,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    if (controller != null && _controllerListener != null) {
      controller!.removeListener(_controllerListener!);
    }
    controller?.dispose();
    return super.close();
  }
}

class YoungMuslimPlayerState extends Equatable {
  const YoungMuslimPlayerState({
    this.loadState = RequestState.initial,
    this.session,
    this.currentVideo,
    this.currentPosition = Duration.zero,
    this.duration = Duration.zero,
    this.autoPlayEnabled = true,
    this.completionTrigger = 0,
    this.errorMessage,
  });

  final RequestState loadState;
  final YoungMuslimPlayerSessionEntity? session;
  final YoungMuslimVideoEntity? currentVideo;
  final Duration currentPosition;
  final Duration duration;
  final bool autoPlayEnabled;
  final int completionTrigger;
  final String? errorMessage;

  double get progress {
    if (duration.inSeconds <= 0) {
      return 0;
    }
    return currentPosition.inSeconds / duration.inSeconds;
  }

  YoungMuslimPlayerState copyWith({
    RequestState? loadState,
    YoungMuslimPlayerSessionEntity? session,
    YoungMuslimVideoEntity? currentVideo,
    Duration? currentPosition,
    Duration? duration,
    bool? autoPlayEnabled,
    int? completionTrigger,
    String? errorMessage,
  }) {
    return YoungMuslimPlayerState(
      loadState: loadState ?? this.loadState,
      session: session ?? this.session,
      currentVideo: currentVideo ?? this.currentVideo,
      currentPosition: currentPosition ?? this.currentPosition,
      duration: duration ?? this.duration,
      autoPlayEnabled: autoPlayEnabled ?? this.autoPlayEnabled,
      completionTrigger: completionTrigger ?? this.completionTrigger,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        loadState,
        session,
        currentVideo,
        currentPosition,
        duration,
        autoPlayEnabled,
        completionTrigger,
        errorMessage,
      ];
}
