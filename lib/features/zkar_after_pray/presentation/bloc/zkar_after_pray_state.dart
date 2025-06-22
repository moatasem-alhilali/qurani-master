part of 'zkar_after_pray_bloc.dart';

@immutable
class ZkarAfterPrayState extends Equatable {
  const ZkarAfterPrayState({
    this.data = const [],
    this.state = RequestState.initial,
  });
  final List<ZkarAfterPrayModel>? data;
  final RequestState state;

  ZkarAfterPrayState copyWith({
    List<ZkarAfterPrayModel>? data,
    RequestState? state,
  }) {
    return ZkarAfterPrayState(
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [data, state];
}
