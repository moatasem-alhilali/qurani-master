part of 'prayer_time_cubit.dart';

@immutable
abstract class PrayerTimeState {}

class PrayerTimeInitial extends PrayerTimeState {}

class PrayerTimeSuccessState extends PrayerTimeState {}
class PrayerTimeLoadingState extends PrayerTimeState {}
