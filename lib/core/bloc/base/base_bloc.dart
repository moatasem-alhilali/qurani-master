import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/core/util/toast_manager.dart';

import 'package:quran_app/features/home/presentation/view/widgets/bottom_navigation_bar_widget.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc() : super(BaseState()) {
    //
    ToastServes.fToast = FToast();
    ToastServes.fToast!.init(NavigationService.context);

//
    on<SetStateBaseBlocEvent>(setStateBase);

    //
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




  @override
  Future<void> close() async {
    super.close();
  }
}
