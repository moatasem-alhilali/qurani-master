import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/core/services/update_serves.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/toast_manager.dart';

import 'package:quran_app/features/home/presentation/view/widgets/custom_bottom_navigation_bar2.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc() : super(BaseState()) {
    //
    ToastServes.fToast = FToast();
    ToastServes.fToast!.init(NavigationService.context);

    InUpdateServes.checkUpdate();
//
    on<SetStateBaseBlocEvent>(setStateBase);

    //
    on<CheckInternetBaseBloc>(checkConnection);
    on<ChangeScreenEvent>(_changeScreen);
  }
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  static BaseBloc get(BuildContext context) => BlocProvider.of(context);

  FutureOr<void> setStateBase(event, emit) async {
    emit(BaseState());
  }

  FutureOr<void> _changeScreen(event, emit) {
    currentPage = event.current as int;
    emit(BaseState());
  }

  StreamSubscription? _subscription;

  //internet checker
  FutureOr<void> checkConnection(event, emit) async {
    //check if connect of internet
    final connectivity = Connectivity();
    //check if connect of internet
    if (connectivity.checkConnectivity() == ConnectivityResult.none) {
      ISCONNECTED = false;
    }
    _subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        emit(BaseState());
        ISCONNECTED = true;
      } else {
        ISCONNECTED = false;
        emit(BaseState());
      }
    });
  }

  @override
  Future<void> close() async {
    super.close();
    _subscription!.cancel();
  }
}
