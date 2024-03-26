import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/tasks_notification.dart';

import '../controllers/prayer_time_controller.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  PrayerTimeCubit() : super(PrayerTimeState());
  static PrayerTimeCubit get(context) => BlocProvider.of(context);

  void initPrayerTime() async {
    try {
      emit(PrayerTimeState(prayerState: RequestState.loading));
      await PrayerTimeController.initPrayerTimes();

      await doNotification();
      emit(PrayerTimeState(prayerState: RequestState.success));
    } catch (e) {
      emit(PrayerTimeState(prayerState: RequestState.error));

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
