import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/main.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc() : super(const ConnectivityInitial(isConnected: false)) {
    on<ConnectivityStarted>(_onStarted);
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<ForceCheckConnectivity>(_onForceCheck);
  }
  final Connectivity connectivity = sl.get<Connectivity>();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  Future<void> _onStarted(
    ConnectivityStarted event,
    Emitter<ConnectivityState> emit,
  ) async {
    emit(const ConnectivityLoading());

    // Set up continuous connectivity monitoring
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((result) {
      add(ConnectivityChanged(connectivityResult: result));
    });

    // Initial connectivity check
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      _updateConnectivityStatus(connectivityResult);
      emit(ConnectivitySuccess(isConnected: ISCONNECTED));
    } catch (e) {
      logger.e('Error checking initial connectivity: $e');
      emit(ConnectivityFailure(error: e.toString()));
    }
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    _updateConnectivityStatus(event.connectivityResult);
    emit(ConnectivitySuccess(isConnected: ISCONNECTED));
  }

  Future<void> _onForceCheck(
    ForceCheckConnectivity event,
    Emitter<ConnectivityState> emit,
  ) async {
    emit(const ConnectivityLoading());

    try {
      final connectivityResult = await connectivity.checkConnectivity();
      _updateConnectivityStatus(connectivityResult);
      emit(ConnectivitySuccess(isConnected: ISCONNECTED));
    } catch (e) {
      logger.e('Error during force connectivity check: $e');
      emit(ConnectivityFailure(error: e.toString()));
    }
  }

  void _updateConnectivityStatus(List<ConnectivityResult> connectivityResult) {
    final previousState = ISCONNECTED;

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn) ||
        connectivityResult.contains(ConnectivityResult.bluetooth)) {
      ISCONNECTED = true;
    } else {
      ISCONNECTED = false;
    }

    // Log only when connectivity state changes
    if (ISCONNECTED != previousState) {
      if (!ISCONNECTED) {
        logger.w('Connectivity lost - Switched to offline mode');
      } else {
        logger.i('Connectivity restored - Switched to online mode');
      }
    }
  }
}
