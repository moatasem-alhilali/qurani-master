part of 'ruqia_shareia_bloc.dart';

@immutable
class RuqiaShareiaState extends Equatable {
  const RuqiaShareiaState({
    this.data = const [],
    this.state = RequestState.initial,
  });
  final List<RuqiaShareiaModel>? data;
  final RequestState state;

  RuqiaShareiaState copyWith({
    List<RuqiaShareiaModel>? data,
    RequestState? state,
  }) {
    return RuqiaShareiaState(
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [data, state];
}
