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
    emit(
      state.copyWith(
        loadState: RequestState.loading,
        errorMessage: null,
      ),
    );
    try {
      final session = await _repository.getPlayerSession(videoId);
      await _configureController(session);
      emit(
        state.copyWith(
          loadState: RequestState.success,
          session: session,
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
    final session = state.session;
    if (session == null) {
      return;
    }
    final video = session.video;

    final currentSecond = controller?.value.position.inSeconds ?? 0;
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
    final currentPosition = value.position;
    if (value.isDragging) {
      return;
    }

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
      emit(
        state.copyWith(
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
    this.autoPlayEnabled = true,
    this.completionTrigger = 0,
    this.errorMessage,
  });

  final RequestState loadState;
  final YoungMuslimPlayerSessionEntity? session;
  final bool autoPlayEnabled;
  final int completionTrigger;
  final String? errorMessage;

  YoungMuslimPlayerState copyWith({
    RequestState? loadState,
    YoungMuslimPlayerSessionEntity? session,
    bool? autoPlayEnabled,
    int? completionTrigger,
    String? errorMessage,
  }) {
    return YoungMuslimPlayerState(
      loadState: loadState ?? this.loadState,
      session: session ?? this.session,
      autoPlayEnabled: autoPlayEnabled ?? this.autoPlayEnabled,
      completionTrigger: completionTrigger ?? this.completionTrigger,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        loadState,
        session,
        autoPlayEnabled,
        completionTrigger,
        errorMessage,
      ];
}
