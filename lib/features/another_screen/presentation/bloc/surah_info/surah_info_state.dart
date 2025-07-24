part of 'surah_info_bloc.dart';

class SurahInfoState {
  final RequestState state;
  final List<SurahInfoModel> data;
  SurahInfoState({this.state = RequestState.initial, this.data = const []});

  SurahInfoState copyWith({
    RequestState? state,
    List<SurahInfoModel>? data,
  }) {
    return SurahInfoState(state: state ?? this.state, data: data ?? this.data);
  }
}


