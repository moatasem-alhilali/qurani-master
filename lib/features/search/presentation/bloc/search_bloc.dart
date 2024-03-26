import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/search/data/model/aya.dart';
import 'package:quran_app/features/search/data/search_repository_imp.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepositoryImpl repositoryImpl;
  ScrollController scrollController = ScrollController();
  String text = "";
  int pageNumber = 1;
  int pageSize = 10;
  SearchBloc({required this.repositoryImpl}) : super(SearchState()) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        add(FetchAyaMoreEvent(text));
      }
    });

    on<FetchAyaMoreEvent>(fetchAyaMore);
    on<SearchQuranEvent>(searchQuran);
    //
    on<SearchMosoaaEvent>(searchMossos);
    on<GetHistoryMosoaaEvent>(historySearchMosooaa);

    on<SetStateEvent>(
      (event, emit) {
        emit(state.copyWith());
      },
    );
  }

  FutureOr<void> searchMossos(event, emit) async {
    emit(state.copyWith(searchMossoState: RequestState.loading));
    var result = await repositoryImpl.searchMosoaa(event.text);
    result.fold(
      (l) {
        emit(state.copyWith(searchMossoState: RequestState.error));
      },
      (r) {
        // emit(state.copyWith(
        //   searchMossoState: RequestState.success,
        //   result: r,
        // ));
        add(GetHistoryMosoaaEvent());
      },
    );
  }

  FutureOr<void> historySearchMosooaa(event, emit) async {
    // emit(state.copyWith(searchMossoState: RequestState.loading));
    var result = await repositoryImpl.historySearchMosoaa();
    result.fold(
      (l) {
        emit(state.copyWith(searchMossoState: RequestState.error));
      },
      (r) {
        emit(
          state.copyWith(
            searchMossoState: RequestState.success,
            historySearchMosoaa: r,
          ),
        );
      },
    );
    emit(
      state.copyWith(searchMossoState: RequestState.defaults),
    );
  }

  FutureOr<void> searchQuran(event, emit) async {
    emit(state.copyWith(ayahState: RequestState.loading));
    text = event.text;
    var result =
        await repositoryImpl.searchQuran(event.text, pageSize, pageNumber);
    result.fold(
      (l) {
        emit(state.copyWith(ayahState: RequestState.error));
      },
      (r) {
        emit(
          state.copyWith(
            ayahState: RequestState.success,
            ayaData: r,
          ),
        );
        // logger.d(r.length);
      },
    );
  }

  FutureOr<void> fetchAyaMore(event, emit) async {
    pageNumber++;

    emit(state.copyWith(loadAyahState: RequestState.loading));
    var result = await repositoryImpl.searchQuran(text, pageSize, pageNumber);
    result.fold(
      (l) {
        emit(state.copyWith(loadAyahState: RequestState.error));
      },
      (r) {
        if (r.isNotEmpty) {
          emit(
            state.copyWith(
              loadAyahState: RequestState.success,
              ayaData: [...state.ayaData, ...r],
            ),
          );
        }
        // logger.d(state.ayaData.length);
      },
    );
    emit(state.copyWith(loadAyahState: RequestState.defaults));
  }
}
