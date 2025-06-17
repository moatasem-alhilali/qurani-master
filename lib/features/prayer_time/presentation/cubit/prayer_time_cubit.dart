import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/extensions/list_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/core/util/snack_bar.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/prayer_time/data/text/teme_prayer_text.dart';
import 'package:quran_app/main.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  PrayerTimeCubit({
    required this.prayerTimeService,
    required this.coordinatesService,
  }) : super(PrayerTimeState());
  final AdhanPrayerTimeService prayerTimeService;
  final DatabaseCoordinatesService coordinatesService;

  static PrayerTimeCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> initPrayerTime() async {
    emit(state.copyWith(prayerState: RequestState.loading));
    try {
      final list = await prayerTimeService.getTodayPrayerTimes();
      final current = prayerTimeService.getCurrentPrayer();
      final next = prayerTimeService.getNextPrayer();

      final listPrayerData = await buildPrayerData();

      emit(
        state.copyWith(
          prayerList: list,
          currentPrayer: current,
          nextPrayer: next,
          prayerState: RequestState.success,
          currentPrayerModel: listPrayerData.firstWhereOrNull(
            (p) => p.type == current?.type,
          ),
          nextPrayerModel: listPrayerData.firstWhereOrNull(
            (p) => p.type == next?.type,
          ),
        ),
      );
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(prayerState: RequestState.error));
    }
  }

  Future<void> updateLocation() async {
    emit(state.copyWith(prayerState: RequestState.loading));
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      await ServicesLocation.isLocationEnabled();

      if (!serviceEnabled && NavigationService.context.mounted) {
        SnackBarMessage.show(
          context: NavigationService.context,
          title: 'قم بتفعيل الموقع لمره واحده فقط',
          state: RequestState.error,
        );
        return;
      }

      final position = await ServicesLocation.determinePosition();

      await coordinatesService.setCoordinates(
        position.latitude,
        position.longitude,
      );

      if (NavigationService.context.mounted) {
        SnackBarMessage.show(
          context: NavigationService.context,
          title: 'تم تحديث الموقع بنجاح',
          state: RequestState.success,
        );
      }

      await initPrayerTime();
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(prayerState: RequestState.error));
    }
  }
}
