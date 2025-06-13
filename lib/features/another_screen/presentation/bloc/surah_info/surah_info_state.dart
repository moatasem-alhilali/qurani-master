import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';

abstract class SurahInfoState {}

class SurahInfoInitial extends SurahInfoState {}

class SurahInfoLoading extends SurahInfoState {}

class SurahInfoLoaded extends SurahInfoState {
  final List<SurahInfoModel> data;

  SurahInfoLoaded(this.data);
}

class SurahInfoError extends SurahInfoState {
  final String message;

  SurahInfoError(this.message);
}
