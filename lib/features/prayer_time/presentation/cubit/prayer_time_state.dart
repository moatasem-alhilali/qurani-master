// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'prayer_time_cubit.dart';

class PrayerTimeState {
  final RequestState prayerState;
  final List<PrayerInfoModel> prayerList;
  final PrayerInfoModel? currentPrayer;
  final PrayerInfoModel? nextPrayer;
  //
  final TimePrayerModel? currentPrayerModel;
  final TimePrayerModel? nextPrayerModel;

  PrayerTimeState({
    this.prayerState = RequestState.initial,
    this.prayerList = const [],
    this.currentPrayer,
    this.nextPrayer,
    this.currentPrayerModel,
    this.nextPrayerModel,
  });

  PrayerTimeState copyWith({
    RequestState? prayerState,
    List<PrayerInfoModel>? prayerList,
    PrayerInfoModel? currentPrayer,
    PrayerInfoModel? nextPrayer,
    TimePrayerModel? currentPrayerModel,
    TimePrayerModel? nextPrayerModel,
  }) {
    return PrayerTimeState(
      prayerState: prayerState ?? this.prayerState,
      prayerList: prayerList ?? this.prayerList,
      currentPrayer: currentPrayer ?? this.currentPrayer,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      currentPrayerModel: currentPrayerModel ?? this.currentPrayerModel,
      nextPrayerModel: nextPrayerModel ?? this.nextPrayerModel,
    );
  }
}
