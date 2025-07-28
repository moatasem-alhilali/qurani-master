// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'random_ayah_bloc.dart';

@immutable
class RandomAyahState {
  final RequestState loadState;
  final NewAyahModel? randomAyah;
  final String? errorMessage;

  const RandomAyahState({
    this.loadState = RequestState.initial,
    this.randomAyah,
    this.errorMessage,
  });

  RandomAyahState copyWith({
    RequestState? loadState,
    NewAyahModel? randomAyah,
    String? errorMessage,
  }) {
    return RandomAyahState(
      loadState: loadState ?? this.loadState,
      randomAyah: randomAyah ?? this.randomAyah,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return 'RandomAyahState(loadState: $loadState, randomAyah: $randomAyah, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RandomAyahState &&
        other.loadState == loadState &&
        other.randomAyah == randomAyah &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return loadState.hashCode ^ randomAyah.hashCode ^ errorMessage.hashCode;
  }
}
