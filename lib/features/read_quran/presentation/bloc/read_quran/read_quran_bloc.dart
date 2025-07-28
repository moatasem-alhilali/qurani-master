import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/read_quran/data/QuranReadHelperSqlite.dart';
import 'package:quran_app/features/read_quran/data/model/last_read_quran_info_model.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/main.dart';

part 'read_quran_event.dart';
part 'read_quran_state.dart';

class ReadQuranBloc extends Bloc<ReadQuranEvent, ReadQuranState> {
  ReadQuranBloc() : super(const ReadQuranState()) {
    on<LoadQuranEvent>(_loadQuran);
    on<ToggleEvent>(_toggle);
    on<SetStateRBlocEvent>(_emitState);
    on<SetLastPageReadEvent>(_setLastPageRead);
    on<JumpToPageEvent>(_jumpToPage);
    on<ToggleBoxEvent>(_toggleBox);
    on<ToggleHighBoxEvent>(_toggleHighBox);
    on<GetTafsirAyahEvent>(_getTafsirAyah);
    on<GetLastPageReadEvent>(_getLastPageRead);
    // on<GetCurrentPageAyahsSeparatedForBasmalahEvent>(
    //   _getCurrentPageAyahsSeparatedForBasmalah,
    // );
  }
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final PageController pageController = PageController();
  final BoxController boxController = BoxController();

  final QuranReadHelperSqlite quranReadHelperSqlite = QuranReadHelperSqlite();

  bool toggle = false;

  /// Loads Quran data using the helper
  Future<void> _loadQuran(
    LoadQuranEvent event,
    Emitter<ReadQuranState> emit,
  ) async {
    emit(state.copyWith(loadQuranState: RequestState.loading));
    try {
      final surahs = await quranReadHelperSqlite.getAllSurahs();
      final allAyahs = await quranReadHelperSqlite.getAllAyahs();
      // final pages = await quranReadHelperSqlite.getAllPages();
      final pages = List<List<NewAyahModel>>.generate(604, (pageIndex) {
        return allAyahs.where((ayah) => ayah.page == pageIndex + 1).toList();
      });

      emit(
        state.copyWith(
          loadQuranState: RequestState.success,
          surahs: surahs,
          pages: pages,
          allAyahs: allAyahs,
        ),
      );
    } catch (e, stackTrace) {
      logger.e('error in loadQuran: $e');
      logger.e('stackTrace: $stackTrace');
      emit(state.copyWith(loadQuranState: RequestState.error));
    }
  }

  /// Toggles internal view state
  void _toggle(ToggleEvent event, Emitter<ReadQuranState> emit) {
    toggle = !toggle;
    emit(state.copyWith(loadQuranState: RequestState.success));
  }

  /// Emits a fresh state manually
  void _emitState(SetStateRBlocEvent event, Emitter<ReadQuranState> emit) {
    emit(state.copyWith());
  }

  Future<void> _setLastPageRead(
    SetLastPageReadEvent event,
    Emitter<ReadQuranState> emit,
  ) async {
    final surahName = state.getSurahNameByPageIndex(event.page);
    final lastReadQuranInfo = LastReadQuranInfoModel(
      page: event.page.toString(),
      date: DateTime.now().toIso8601String(),
      surah: surahName,
    );
    final dataInfo = jsonEncode(lastReadQuranInfo.toJson());
    await CacheService().setString(
      CacheConfig.lastPageReadKey,
      dataInfo,
    );
    emit(state.copyWith(lastReadQuranInfo: lastReadQuranInfo));
  }

  void _jumpToPage(JumpToPageEvent event, Emitter<ReadQuranState> emit) {
    if (event.page != null) {
      pageController.jumpToPage(event.page!);
      add(ToggleBoxEvent());
    } else {
      if (state.lastReadQuranInfo != null) {
        pageController.jumpToPage(int.parse(state.lastReadQuranInfo!.page));
      }
    }
  }

  void _toggleBox(ToggleBoxEvent event, Emitter<ReadQuranState> emit) {
    boxController.isBoxOpen
        ? boxController.closeBox()
        : boxController.openBox();
  }

  void _toggleHighBox(
    ToggleHighBoxEvent event,
    Emitter<ReadQuranState> emit,
  ) {
    emit(state.copyWith(minusHeight: event.minusHeight));
  }

  Future<void> _getTafsirAyah(
    GetTafsirAyahEvent event,
    Emitter<ReadQuranState> emit,
  ) async {
    final tafsirAyah = await quranReadHelperSqlite.getTafsirForAyah(
      ayahNumber: event.ayah,
      surahId: event.surahNumber,
    );
    emit(state.copyWith(tafsirAyah: tafsirAyah));
  }

  Future<void> _getLastPageRead(
    GetLastPageReadEvent event,
    Emitter<ReadQuranState> emit,
  ) async {
    emit(state.copyWith(lastReadQuranInfoState: RequestState.loading));
    try {
      final lastPageRead =
          CacheService().getString(CacheConfig.lastPageReadKey);
      if (lastPageRead != null) {
        final lastReadQuranInfo = LastReadQuranInfoModel.fromJson(
          jsonDecode(lastPageRead) as Map<String, dynamic>,
        );
        emit(state.copyWith(lastReadQuranInfo: lastReadQuranInfo));
      }
    } catch (e) {
      logger.e('error in getLastPageRead: $e');
      emit(state.copyWith(lastReadQuranInfoState: RequestState.error));
    }
  }
}
