import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/controller.dart';
import 'package:quran_app/features/search_ayah/controller/search_controller.dart';
import 'package:quran_app/features/search_ayah/model/search_ayah_model.dart';

part 'serch_ayah_state.dart';

class SearchAyahCubit extends Cubit<SerchAyahState> {
  SearchAyahCubit() : super(SerchAyahInitial());
  static SearchAyahCubit get(context) => BlocProvider.of(context);

  //event
  void searchAyahInAllSurah({required String ayh}) async {
    emit(SerchAyahQuranNoDataState());

    final result = await SearchController.searchWords(ayh);
    if (result.isEmpty) {
      emit(SerchAyahQuranNoDataState());
    } else {
      emit(SerchAyahQuranSuccessState(resultAyah: result));
    }
  }

//
  void searchAyahInSurah({
    required int surahNumber,
    required String ayah,
  }) async {
    emit(SerchAyahInSurahNoDataState());

    final result = await SearchController.searchAyahInSurah(
        ayah: ayah, surahNumber: surahNumber);
    if (result.isEmpty) {
      emit(SerchAyahInSurahNoDataState());
    } else {
      emit(SearchAyahInSurahSuccessState(resultAyah: result));
    }
  }
}
