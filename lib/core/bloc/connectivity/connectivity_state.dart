part of 'connectivity_bloc.dart';

abstract class ConnectivityState extends Equatable {
  final bool isConnected;

  const ConnectivityState({required this.isConnected});

  @override
  List<Object> get props => [isConnected];
}

class ConnectivityInitial extends ConnectivityState {
  const ConnectivityInitial({required super.isConnected});
}

class ConnectivityLoading extends ConnectivityState {
  const ConnectivityLoading() : super(isConnected: false);
}

class ConnectivitySuccess extends ConnectivityState {
  const ConnectivitySuccess({required super.isConnected});
}

class ConnectivityFailure extends ConnectivityState {
  final String error;

  const ConnectivityFailure({required this.error}) : super(isConnected: false);

  @override
  List<Object> get props => [isConnected, error];
}
