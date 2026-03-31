import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'young_muslim_event.dart';
part 'young_muslim_state.dart';

class YoungMuslimBloc extends Bloc<YoungMuslimEvent, YoungMuslimState> {
  YoungMuslimBloc({
    required YoungMuslimRepository repository,
  })  : _repository = repository,
        super(const YoungMuslimState()) {
    on<YoungMuslimStarted>(_onStarted);
    on<YoungMuslimRefreshed>(_onRefreshed);
    on<YoungMuslimSearchChanged>(
      _onSearchChanged,
      transformer: _debounce(const Duration(milliseconds: 280)),
    );
    on<YoungMuslimFiltersChanged>(_onFiltersChanged);
    on<YoungMuslimCategoryRequested>(_onCategoryRequested);
    on<YoungMuslimVideoRequested>(_onVideoRequested);
    on<YoungMuslimFavoriteToggled>(_onFavoriteToggled);
    on<YoungMuslimWatchLaterToggled>(_onWatchLaterToggled);
  }

  final YoungMuslimRepository _repository;

  static EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  Future<void> _onStarted(
    YoungMuslimStarted event,
    Emitter<YoungMuslimState> emit,
  ) async {
    emit(state.copyWith(loadState: RequestState.loading));
    try {
      final dashboard = await _repository.getDashboard();
      emit(
        state.copyWith(
          loadState: RequestState.success,
          dashboard: dashboard,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshed(
    YoungMuslimRefreshed event,
    Emitter<YoungMuslimState> emit,
  ) async {
    await _refreshCurrentData(emit);
  }

  Future<void> _refreshCurrentData(
    Emitter<YoungMuslimState> emit,
  ) async {
    try {
      final dashboardFuture = _repository.getDashboard(
        query: state.query,
        filters: state.filters,
      );
      final categoryFuture = state.categoryDetails == null
          ? Future<YoungMuslimCategoryDetailsEntity?>.value(null)
          : _repository.getCategoryDetails(
              state.categoryDetails!.category.id,
              query: state.query,
              filters: state.filters,
            );
      final videoFuture = state.videoDetails == null
          ? Future<YoungMuslimVideoDetailsEntity?>.value(null)
          : _repository.getVideoDetails(state.videoDetails!.video.id);

      final dashboard = await dashboardFuture;
      final results = await Future.wait<Object?>([
        categoryFuture,
        videoFuture,
      ]);
      final categoryDetails = results[0] as YoungMuslimCategoryDetailsEntity?;
      final videoDetails = results[1] as YoungMuslimVideoDetailsEntity?;

      emit(
        state.copyWith(
          loadState: RequestState.success,
          dashboard: dashboard,
          categoryDetails: categoryDetails,
          videoDetails: videoDetails,
          actionState: RequestState.success,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
      await _refreshCurrentData(emit);
    }
  }

  Future<void> _onSearchChanged(
    YoungMuslimSearchChanged event,
    Emitter<YoungMuslimState> emit,
  ) async {
    final query = event.query.trim();
    if (query == state.query) {
      return;
    }
    emit(state.copyWith(query: query));
    await _refreshCurrentData(emit);
  }

  Future<void> _onFiltersChanged(
    YoungMuslimFiltersChanged event,
    Emitter<YoungMuslimState> emit,
  ) async {
    if (event.filters == state.filters) {
      return;
    }
    emit(state.copyWith(filters: event.filters));
    await _refreshCurrentData(emit);
  }

  Future<void> _onCategoryRequested(
    YoungMuslimCategoryRequested event,
    Emitter<YoungMuslimState> emit,
  ) async {
    emit(state.copyWith(categoryState: RequestState.loading));
    try {
      final categoryDetails = await _repository.getCategoryDetails(
        event.categoryId,
        query: state.query,
        filters: state.filters,
      );
      emit(
        state.copyWith(
          categoryState: RequestState.success,
          categoryDetails: categoryDetails,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          categoryState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onVideoRequested(
    YoungMuslimVideoRequested event,
    Emitter<YoungMuslimState> emit,
  ) async {
    emit(state.copyWith(videoState: RequestState.loading));
    try {
      final videoDetails = await _repository.getVideoDetails(event.videoId);
      emit(
        state.copyWith(
          videoState: RequestState.success,
          videoDetails: videoDetails,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          videoState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onFavoriteToggled(
    YoungMuslimFavoriteToggled event,
    Emitter<YoungMuslimState> emit,
  ) async {
    emit(
      _patchVideoState(
        videoId: event.videoId,
        favorite: _resolveFavoriteValue(event.videoId),
      ).copyWith(
        actionState: RequestState.success,
        errorMessage: null,
      ),
    );
    try {
      await _repository.toggleFavorite(event.videoId);
      await _refreshCurrentData(emit);
    } catch (error) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
      await _refreshCurrentData(emit);
    }
  }

  Future<void> _onWatchLaterToggled(
    YoungMuslimWatchLaterToggled event,
    Emitter<YoungMuslimState> emit,
  ) async {
    emit(
      _patchVideoState(
        videoId: event.videoId,
        watchLater: _resolveWatchLaterValue(event.videoId),
      ).copyWith(
        actionState: RequestState.success,
        errorMessage: null,
      ),
    );
    try {
      await _repository.toggleWatchLater(event.videoId);
      await _refreshCurrentData(emit);
    } catch (error) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  bool _resolveFavoriteValue(String videoId) {
    if (state.videoDetails?.video.id == videoId) {
      return !state.videoDetails!.video.isFavorite;
    }
    for (final video
        in state.dashboard?.searchResults ?? const <YoungMuslimVideoEntity>[]) {
      if (video.id == videoId) {
        return !video.isFavorite;
      }
    }
    for (final video
        in state.categoryDetails?.videos ?? const <YoungMuslimVideoEntity>[]) {
      if (video.id == videoId) {
        return !video.isFavorite;
      }
    }
    return true;
  }

  bool _resolveWatchLaterValue(String videoId) {
    if (state.videoDetails?.video.id == videoId) {
      return !state.videoDetails!.video.isWatchLater;
    }
    for (final video
        in state.dashboard?.searchResults ?? const <YoungMuslimVideoEntity>[]) {
      if (video.id == videoId) {
        return !video.isWatchLater;
      }
    }
    for (final video
        in state.categoryDetails?.videos ?? const <YoungMuslimVideoEntity>[]) {
      if (video.id == videoId) {
        return !video.isWatchLater;
      }
    }
    return true;
  }

  YoungMuslimState _patchVideoState({
    required String videoId,
    bool? favorite,
    bool? watchLater,
  }) {
    YoungMuslimVideoEntity mapVideo(YoungMuslimVideoEntity video) {
      if (video.id != videoId) {
        return video;
      }
      return video.copyWith(
        isFavorite: favorite ?? video.isFavorite,
        isWatchLater: watchLater ?? video.isWatchLater,
      );
    }

    return state.copyWith(
      dashboard: _patchDashboard(state.dashboard, mapVideo),
      categoryDetails: _patchCategoryDetails(state.categoryDetails, mapVideo),
      videoDetails: _patchVideoDetails(state.videoDetails, mapVideo),
    );
  }

  YoungMuslimDashboardEntity? _patchDashboard(
    YoungMuslimDashboardEntity? dashboard,
    YoungMuslimVideoEntity Function(YoungMuslimVideoEntity video) mapVideo,
  ) {
    if (dashboard == null) {
      return null;
    }
    return YoungMuslimDashboardEntity(
      categories: dashboard.categories,
      series: dashboard.series,
      continueWatching: dashboard.continueWatching.map(mapVideo).toList(),
      recentlyWatched: dashboard.recentlyWatched.map(mapVideo).toList(),
      favorites: dashboard.favorites.map(mapVideo).toList(),
      watchLater: dashboard.watchLater.map(mapVideo).toList(),
      suggestions: dashboard.suggestions.map(mapVideo).toList(),
      searchResults: dashboard.searchResults.map(mapVideo).toList(),
      rewardsSummary: dashboard.rewardsSummary,
      achievements: dashboard.achievements,
    );
  }

  YoungMuslimCategoryDetailsEntity? _patchCategoryDetails(
    YoungMuslimCategoryDetailsEntity? details,
    YoungMuslimVideoEntity Function(YoungMuslimVideoEntity video) mapVideo,
  ) {
    if (details == null) {
      return null;
    }
    return YoungMuslimCategoryDetailsEntity(
      category: details.category,
      series: details.series,
      videos: details.videos.map(mapVideo).toList(),
    );
  }

  YoungMuslimVideoDetailsEntity? _patchVideoDetails(
    YoungMuslimVideoDetailsEntity? details,
    YoungMuslimVideoEntity Function(YoungMuslimVideoEntity video) mapVideo,
  ) {
    if (details == null) {
      return null;
    }
    return YoungMuslimVideoDetailsEntity(
      video: mapVideo(details.video),
      category: details.category,
      series: details.series,
      similarVideos: details.similarVideos.map(mapVideo).toList(),
      nextVideo:
          details.nextVideo == null ? null : mapVideo(details.nextVideo!),
      videoQuiz: details.videoQuiz,
      seriesQuiz: details.seriesQuiz,
      rewardsSummary: details.rewardsSummary,
      achievements: details.achievements,
    );
  }
}
