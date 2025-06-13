part of 'read_quran_bloc.dart';

@immutable
class ReadQuranState {
  RequestState loadQuranState;
  ReadQuranState({this.loadQuranState = RequestState.defaults});

  ReadQuranState copyWith({
    RequestState? loadQuranState,
  }) {
    return ReadQuranState(
      loadQuranState: loadQuranState ?? this.loadQuranState,
    );
  }

  @override
  bool operator ==(covariant ReadQuranState other) {
    if (identical(this, other)) return true;

    return other.loadQuranState == loadQuranState;
  }

  @override
  int get hashCode => loadQuranState.hashCode;
}
