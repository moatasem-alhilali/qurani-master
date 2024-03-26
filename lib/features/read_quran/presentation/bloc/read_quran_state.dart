part of 'read_quran_bloc.dart';

@immutable
class ReadQuranState {
  RequestState loadQuranState;
  ReadQuranState({
    this.loadQuranState=RequestState.defaults
  });
}
