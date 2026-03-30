import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';

part 'young_muslim_event.dart';
part 'young_muslim_state.dart';

class YoungMuslimBloc extends Bloc<YoungMuslimEvent, YoungMuslimState> {
  YoungMuslimBloc({
    required YoungMuslimRepository repository,
  })  : _repository = repository,
        super(const YoungMuslimState()) {
    on<YoungMuslimStarted>(_onStarted);
    on<YoungMuslimRefreshed>(_onRefreshed);
    on<YoungMuslimSearchChanged>(_onSearchChanged);
    on<YoungMuslimFiltersChanged>(_onFiltersChanged);
    on<YoungMuslimCategoryRequested>(_onCategoryRequested);
    on<YoungMuslimVideoRequested>(_onVideoRequested);
    on<YoungMuslimFavoriteToggled>(_onFavoriteToggled);
    on<YoungMuslimWatchLaterToggled>(_onWatchLaterToggled);
  }

  final YoungMuslimRepository _repository;

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
    try {
      final dashboard = await _repository.getDashboard(
        query: state.query,
        filters: state.filters,
      );
      YoungMuslimCategoryDetailsEntity? categoryDetails = state.categoryDetails;
      YoungMuslimVideoDetailsEntity? videoDetails = state.videoDetails;

      if (state.categoryDetails != null) {
        categoryDetails = await _repository.getCategoryDetails(
          state.categoryDetails!.category.id,
          query: state.query,
          filters: state.filters,
        );
      }

      if (state.videoDetails != null) {
        videoDetails =
            await _repository.getVideoDetails(state.videoDetails!.video.id);
      }

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
    }
  }

  Future<void> _onSearchChanged(
    YoungMuslimSearchChanged event,
    Emitter<YoungMuslimState> emit,
  ) async {
    emit(state.copyWith(query: event.query));
    add(const YoungMuslimRefreshed());
  }

  Future<void> _onFiltersChanged(
    YoungMuslimFiltersChanged event,
    Emitter<YoungMuslimState> emit,
  ) async {
    emit(state.copyWith(filters: event.filters));
    add(const YoungMuslimRefreshed());
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
    emit(state.copyWith(actionState: RequestState.loading));
    try {
      await _repository.toggleFavorite(event.videoId);
      add(const YoungMuslimRefreshed());
    } catch (error) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onWatchLaterToggled(
    YoungMuslimWatchLaterToggled event,
    Emitter<YoungMuslimState> emit,
  ) async {
    emit(state.copyWith(actionState: RequestState.loading));
    try {
      await _repository.toggleWatchLater(event.videoId);
      add(const YoungMuslimRefreshed());
    } catch (error) {
      emit(
        state.copyWith(
          actionState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
