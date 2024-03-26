part of 'prayer_time_cubit.dart';

@immutable
class PrayerTimeState {
  RequestState prayerState;
  PrayerTimeState({this.prayerState = RequestState.defaults});
}
