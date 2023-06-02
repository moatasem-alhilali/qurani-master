import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/services/tasks_notification.dart';

import '../controllers/prayer_time_controller.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  PrayerTimeCubit() : super(PrayerTimeInitial());
  static PrayerTimeCubit get(context) => BlocProvider.of(context);

  void initPrayerTime() async {
    emit(PrayerTimeLoadingState());
    try {
      // if (!PrayerTimeController.isGetTheTimePrayer) {
      await PrayerTimeController.initPrayerTimes();
      // }
      await doNotification();
      emit(PrayerTimeSuccessState());
    } catch (e) {
      print(e);
    }
  }

  //

  //do Notification
  Future<void> doNotification() async {
    try {
      print("سوف يقوم بتنبيهك");
      await ServicesNotification.sendNotification();
    } catch (e) {
      print("خطأ في الاشعارات");
      print(e);
    }
  }
}
