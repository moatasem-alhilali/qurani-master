part of 'hadith_40_bloc.dart';

@immutable
class Hadith40State extends Equatable {
  const Hadith40State({
    this.data = const [],
    this.state = RequestState.initial,
  });
  final List<Hadith40Model>? data;
  final RequestState state;

  Hadith40State copyWith({
    List<Hadith40Model>? data,
    RequestState? state,
  }) {
    return Hadith40State(
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [data, state];
}
