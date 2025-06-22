part of 'wird_bloc.dart';

@immutable
class WirdState extends Equatable {
  const WirdState({
    this.data = const [],
    this.state = RequestState.initial,
  });
  final List<WirdModel>? data;
  final RequestState state;

  WirdState copyWith({
    List<WirdModel>? data,
    RequestState? state,
  }) {
    return WirdState(
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [data, state];
}
