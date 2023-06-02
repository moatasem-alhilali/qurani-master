import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/Home/state.dart';

import 'package:quran_app/core/constant.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  //

  //-------------------------------------------------
  void onChangedSliderQuran(value) {
    fontSizeQuran = value;
    emit(SliderState());
  }

  void changeThemeMode() {
    isLightMode = !isLightMode;
    emit(ChangeThemeModeState());
  }

  void onChangedSliderTikr(value) {
    fontSizeAthkar = value;
    emit(SliderState());
  }

  void ChangedMasbahState() {
    ++masbahSize;
    emit(MasbahState());
  }

//Select Style Type

  void mySetState() {
    emit(ToggleState());
  }

//font state
  void fontState(String? name) {
    defaultNameQuran = name!;
    emit(FontState());
  }

//reset value
  void resetValueQuran() {
    defaultNameQuran = 'quran2';
    fontSizeQuran = 20;
    emit(ResetState());
  }

//reset value
  void resetValueThikr() {
    fontSizeAthkar = 16;
    emit(ResetState());
  }

  StreamSubscription? _subscription;

  //internet checker
  void checkConnection() async {
    //check if connect of internet
    Connectivity _connectivity = Connectivity();
    //check if connect of internet
    if (_connectivity.checkConnectivity() == ConnectivityResult.none) {
      ISCONNECTED = false;
    }
    _subscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        emit(ConnectedState());
        ISCONNECTED = true;
      } else {
        ISCONNECTED = false;
        emit(NoConnectedState());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription!.cancel();
    return super.close();
  }
}
