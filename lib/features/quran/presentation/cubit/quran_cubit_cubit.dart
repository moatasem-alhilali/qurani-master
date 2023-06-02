import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/jsons/assets_text.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/quran/controller/db_helper.dart';
import 'package:quran_app/features/quran/controller/repository_quran.dart';

part 'quran_cubit_state.dart';

class QuranCubit extends Cubit<QuranCubitState> {
  QuranCubit() : super(QuranCubitInitial());
  //
  static QuranCubit get(context) => BlocProvider.of(context);
  int indexSurahRead = 1;
  int? currentAyahSelected;
  String? currentNameSurahRead;
  int? currentPageSurahRead = 1;
  int? indexAyahPage;

  //
  int currentPlayingAyaIndex = 0;

  PageController? pageController = PageController(initialPage: 0);

  bool isSurahReadAndListen = false;

  //method
  void changeScreenSurahRead() {
    isSurahReadAndListen = !isSurahReadAndListen;
    emit(ChangeScreenReadState());
    print(isSurahReadAndListen);
  }

  void setInDexAyahPage({required int index}) {
    indexAyahPage = index;
    emit(SetInDexAyahPageState());
  }

  //
  void changeIndexOfAyahSelectedRead(int index) {
    currentAyahSelected = index;

    emit(ChangeIndexOfAyahSelectedReadState());
  }

  //
  void mySetState() {
    emit(QuranToggleState());
  }

  void saveBookMark({required QuranBookMarkModel quranBookMarkModel}) async {
    try {
      int res = await ControllerQuran.saveBookMark(
          quranBookMarkModel: quranBookMarkModel);
      if (res >= 0) {
        emit(SaveBookMarkSuccessesState());
        getBookMark();
      } else {
        emit(SaveBookMarkErrorState());
      }
    } catch (e) {
      emit(SaveBookMarkErrorState());
      print(e);
    }
  }

  void getBookMark() async {
    try {
      quranBookMark = await ControllerQuran.getBookMark();

      emit(GetBookMarkSuccessesState());
    } catch (e) {
      emit(GetBookMarkErrorState());
      print(e);
    }
  }

  //search Surah Drawer
  void searchSurahDrawer({required String text}) {
    final suggestionList = nameOfQuranAyah.where(
      (p) {
        return p['name']!.contains(text);
      },
    ).toList();
    if (suggestionList.isEmpty) {
      emit(SearchSurahNoDataState());
    } else {
      emit(SearchSurahSuccessesState(data: suggestionList));
    }
  }

  //
  void initPlayerPlayAyah({
    required int surahNumber,
  }) async {
    emit(QuranInitAudioPlayerAyahLoadingState());

    try {
      await ControllerQuran.initPlayerPlayAyah(surahNumber: surahNumber);

      //
      emit(QuranInitAudioPlayerAyahSuccessState());
    } catch (e) {
      print(e);
      emit(QuranInitAudioPlayerAyahErrorState());
    }
  }

  //
  void playbackEventStream() {
    ControllerQuran.audioPlayerPlayAyah.playbackEventStream.listen((event) {
      currentPlayingAyaIndex =
          ControllerQuran.audioPlayerPlayAyah.currentIndex!;

      emit(PlaybackEventStreamState());
    }, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
  }
}
