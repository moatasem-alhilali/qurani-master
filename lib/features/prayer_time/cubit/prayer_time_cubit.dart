import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/core/local/cash.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/core/services/tasks_notification.dart';
import 'package:quran_app/core/util/snack_bar.dart';
import 'package:quran_app/main.dart';

import '../controllers/prayer_time_controller.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  PrayerTimeCubit() : super(PrayerTimeState());
  static PrayerTimeCubit get(context) => BlocProvider.of(context);
  void initPrayerTime() async {
    try {
      emit(PrayerTimeState(prayerState: RequestState.loading));
      await sl.get<PrayerTimesProvider>().initialize();

      await ServicesNotification.sendNotification();
      emit(PrayerTimeState(prayerState: RequestState.success));
    } catch (e) {
      emit(PrayerTimeState(prayerState: RequestState.error));

      print(e);
    }
  }

  void updateLocation() async {
    try {
      emit(PrayerTimeState(prayerState: RequestState.loading));
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      await ServicesLocation.isLocationEnabled();
      if (!serviceEnabled) {
        if (NavigationService.context.mounted) {
          SnackBarMessage.show(
            context: NavigationService.context,
            title: "قم بتفعيل الموقع لمره واحده فقط",
            state: RequestState.error,
          );
        }
      }
      if (serviceEnabled) {
        final position = await ServicesLocation.determinePosition();

        await CashHelper.setData(key: 'hasInitLocal', value: true);
        await DBHelper.delete('coordinates');
        await DBHelper.insert('coordinates', {
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
        if (NavigationService.context.mounted) {
          SnackBarMessage.show(
            context: NavigationService.context,
            title: "تمت العملية بنجاح",
            state: RequestState.success,
          );
        }
        initPrayerTime();
      }
      emit(PrayerTimeState(prayerState: RequestState.success));
    } catch (e) {
      emit(PrayerTimeState(prayerState: RequestState.error));

      logger.e(e);
    }
  }
  //
}
