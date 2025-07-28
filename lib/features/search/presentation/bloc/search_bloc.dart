import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/features/search/data/database/quran_search_datasource.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.repositoryImpl}) : super(const SearchState()) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        add(FetchAyaMoreEvent(text));
      }
    });
    textEditingController.addListener(() {
      add(SearchSurahEvent(textEditingController.text));
    });

    on<FetchAyaMoreEvent>(fetchAyaMore);
    on<SearchSurahEvent>(searchQuran);
    //
    // on<SearchMosoaaEvent>(searchMossos);
    // on<GetHistoryMosoaaEvent>(historySearchMosooaa);

    on<SetStateEvent>(
      (event, emit) {
        emit(state.copyWith());
      },
    );
  }
  final QuranSearchDataSource repositoryImpl;
  ScrollController scrollController = ScrollController();
  String text = '';
  int pageNumber = 1;
  int pageSize = 10;
  TextEditingController textEditingController = TextEditingController();

  FutureOr<void> searchQuran(
    SearchSurahEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(ayahState: RequestState.loading));
    text = event.text;

    final result = await repositoryImpl.searchAyahs(
      event.text,
      pageSize: pageSize,
      pageNumber: pageNumber,
    );

    emit(
      state.copyWith(
        ayahState: RequestState.success,
        ayaData: result,
        currentSearchTerm: event.text,
      ),
    );
  }

  FutureOr<void> fetchAyaMore(
    FetchAyaMoreEvent event,
    Emitter<SearchState> emit,
  ) async {
    pageNumber++;

    emit(state.copyWith(loadAyahState: RequestState.loading));
    final result = await repositoryImpl.searchAyahs(
      text,
      pageSize: pageSize,
      pageNumber: pageNumber,
    );
    if (result.isNotEmpty) {
      emit(
        state.copyWith(
          loadAyahState: RequestState.success,
          ayaData: [...state.ayaData, ...result],
          currentSearchTerm: text,
        ),
      );
    }

    emit(state.copyWith(loadAyahState: RequestState.initial));
  }
}
