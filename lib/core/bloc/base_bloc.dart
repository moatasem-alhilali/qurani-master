import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/services/update_serves.dart';

import 'package:quran_app/features/home/widgets/custom_bottom_navigation_bar2.dart';
import 'package:quran_app/main.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  static BaseBloc get(context) => BlocProvider.of(context);

  BaseBloc() : super(BaseState()) {
    try {
      InUpdateServes.checkUpdate();
    } catch (e) {
      logger.e(e);
    }
    on<SetStateBaseBlocEvent>(setState);
    on<ChangeScreenEvent>(_changeScreen);
  }

  FutureOr<void> setState(event, emit) {
    emit(BaseState());
  }

  FutureOr<void> _changeScreen(event, emit) {
    currentPage = event.current;
    emit(BaseState());
  }
}
