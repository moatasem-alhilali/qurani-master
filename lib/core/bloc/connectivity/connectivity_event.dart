part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityStarted extends ConnectivityEvent {
  const ConnectivityStarted();
}

class ConnectivityChanged extends ConnectivityEvent {
  final List<ConnectivityResult> connectivityResult;

  const ConnectivityChanged({required this.connectivityResult});

  @override
  List<Object> get props => [connectivityResult];
}

class ForceCheckConnectivity extends ConnectivityEvent {
  const ForceCheckConnectivity();
}
