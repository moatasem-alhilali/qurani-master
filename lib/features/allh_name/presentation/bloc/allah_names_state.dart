part of 'allah_names_bloc.dart';

@immutable
class AllahNamesState extends Equatable {
  const AllahNamesState({
    this.data = const [],
    this.state = RequestState.initial,
  });
  final List<AllahNameModel>? data;
  final RequestState state;

  AllahNamesState copyWith({
    List<AllahNameModel>? data,
    RequestState? state,
  }) {
    return AllahNamesState(
      data: data ?? this.data,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [data, state];
}
