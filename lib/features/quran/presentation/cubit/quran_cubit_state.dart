part of 'quran_cubit_cubit.dart';

@immutable
abstract class QuranCubitState {}

class QuranCubitInitial extends QuranCubitState {}

class ChangeScreenReadState extends QuranCubitState {}

class SetInDexAyahPageState extends QuranCubitState {}

class QuranToggleState extends QuranCubitState {}

class ChangeIndexOfAyahSelectedReadState extends QuranCubitState {}

//add book mark state
class SaveBookMarkErrorState extends QuranCubitState {}

class SaveBookMarkSuccessesState extends QuranCubitState {}

// get book mark state
class GetBookMarkErrorState extends QuranCubitState {}

class GetBookMarkSuccessesState extends QuranCubitState {}

// search surah state
class SearchSurahNoDataState extends QuranCubitState {}

class SearchSurahSuccessesState extends QuranCubitState {
  final dynamic data;
  SearchSurahSuccessesState({required this.data});
}

//
class QuranInitAudioPlayerAyahLoadingState extends QuranCubitState {}

class QuranInitAudioPlayerAyahSuccessState extends QuranCubitState {}

class QuranInitAudioPlayerAyahErrorState extends QuranCubitState {}

//
class PlaybackEventStreamState extends QuranCubitState {}
