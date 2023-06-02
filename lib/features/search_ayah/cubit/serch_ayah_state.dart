part of 'serch_ayah_cubit.dart';

@immutable
abstract class SerchAyahState {}

class SerchAyahInitial extends SerchAyahState {}

//
class SerchAyahQuranNoDataState extends SerchAyahState {}

class SerchAyahQuranSuccessState extends SerchAyahState {
  final List<SearchAyahResultModel> resultAyah;
  SerchAyahQuranSuccessState({required this.resultAyah});
}

//
class SerchAyahInSurahNoDataState extends SerchAyahState {}

class SearchAyahInSurahSuccessState extends SerchAyahState {
  final List<Map<dynamic, dynamic>> resultAyah;
  SearchAyahInSurahSuccessState({required this.resultAyah});
}
