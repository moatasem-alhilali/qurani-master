import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/features/read_quran/data/model/bookmark_ayahs.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';

part 'read_quran_event.dart';
part 'read_quran_state.dart';

class ReadQuranBloc extends Bloc<ReadQuranEvent, ReadQuranState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  //
  QuranReadHelper quranRH = QuranReadHelper();
  PageController pageController = PageController();
  bool toggle = false;

  //
  ReadQuranBloc() : super(ReadQuranState()) {
    on<LoadQuranEvent>(index);
    on<ToggleEvent>((event, emit) {
      toggle = !toggle;
      emit(ReadQuranState(loadQuranState: RequestState.success));
    });
    on<SetStateRBlocEvent>((event, emit) {
      emit(ReadQuranState(loadQuranState: RequestState.success));
    });
  }
  addBookmarkText(
    String surahName,
    int surahNum,
    pageNum,
    ayahNum,
    ayahUQNum,
    lastRead,
  ) async {
    try {
      final bookMark = BookmarksAyahs(
        null,
        surahName,
        surahNum,
        pageNum,
        ayahNum,
        ayahUQNum,
        lastRead,
      );
      await DBHelper.insert('bookmarkTextTable', bookMark.toJson());
    } catch (e) {
      print('Error');
    }
  }

  FutureOr<void> index(event, emit) async {
    emit(ReadQuranState(loadQuranState: RequestState.loading));
    try {
      await quranRH.loadQuran();
      emit(ReadQuranState(loadQuranState: RequestState.success));
    } catch (e) {
      emit(ReadQuranState(loadQuranState: RequestState.error));
    }
  }
}
