// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'prayer_time_bloc.dart';

const _unset = Object();

enum PrayerLocationStatus {
  initial,
  resolving,
  ready,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  error,
}

class PrayerTimeState {
  final RequestState prayerState;
  final List<PrayerInfoModel> prayerList;
  final PrayerInfoModel? currentPrayer;
  final PrayerInfoModel? nextPrayer;
  //
  final TimePrayerModel? currentPrayerModel;
  final TimePrayerModel? nextPrayerModel;
  final PrayerLocationSelection? selectedLocation;
  final PrayerLocationStatus locationStatus;
  final String? locationStatusMessage;

  PrayerTimeState({
    this.prayerState = RequestState.initial,
    this.prayerList = const [],
    this.currentPrayer,
    this.nextPrayer,
    this.currentPrayerModel,
    this.nextPrayerModel,
    this.selectedLocation,
    this.locationStatus = PrayerLocationStatus.initial,
    this.locationStatusMessage,
  });

  PrayerTimeState copyWith({
    RequestState? prayerState,
    List<PrayerInfoModel>? prayerList,
    Object? currentPrayer = _unset,
    Object? nextPrayer = _unset,
    Object? currentPrayerModel = _unset,
    Object? nextPrayerModel = _unset,
    Object? selectedLocation = _unset,
    PrayerLocationStatus? locationStatus,
    Object? locationStatusMessage = _unset,
  }) {
    return PrayerTimeState(
      prayerState: prayerState ?? this.prayerState,
      prayerList: prayerList ?? this.prayerList,
      currentPrayer: identical(currentPrayer, _unset)
          ? this.currentPrayer
          : currentPrayer as PrayerInfoModel?,
      nextPrayer: identical(nextPrayer, _unset)
          ? this.nextPrayer
          : nextPrayer as PrayerInfoModel?,
      currentPrayerModel: identical(currentPrayerModel, _unset)
          ? this.currentPrayerModel
          : currentPrayerModel as TimePrayerModel?,
      nextPrayerModel: identical(nextPrayerModel, _unset)
          ? this.nextPrayerModel
          : nextPrayerModel as TimePrayerModel?,
      selectedLocation: identical(selectedLocation, _unset)
          ? this.selectedLocation
          : selectedLocation as PrayerLocationSelection?,
      locationStatus: locationStatus ?? this.locationStatus,
      locationStatusMessage: identical(locationStatusMessage, _unset)
          ? this.locationStatusMessage
          : locationStatusMessage as String?,
    );
  }
}
