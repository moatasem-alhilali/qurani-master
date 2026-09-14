part of 'prayer_time_bloc.dart';

abstract class PrayerTimeEvent {
  const PrayerTimeEvent();
}

class PrayerTimeInitRequested extends PrayerTimeEvent {
  const PrayerTimeInitRequested();
}

class PrayerTimeUpdateLocationRequested extends PrayerTimeEvent {
  const PrayerTimeUpdateLocationRequested();
}

class PrayerTimeManualLocationSelected extends PrayerTimeEvent {
  const PrayerTimeManualLocationSelected(this.selection);

  final PrayerLocationSelection selection;
}

class PrayerTimeUseCurrentDeviceLocationRequested extends PrayerTimeEvent {
  const PrayerTimeUseCurrentDeviceLocationRequested();
}

class PrayerTimeRefreshOnAppResumeRequested extends PrayerTimeEvent {
  const PrayerTimeRefreshOnAppResumeRequested();
}

class PrayerTimeRefreshFromDeviceLocationInBackgroundRequested
    extends PrayerTimeEvent {
  const PrayerTimeRefreshFromDeviceLocationInBackgroundRequested();
}

/// يُرسل بعد حفظ إعدادات الحساب لإعادة احتساب المواقيت بالإعداد الجديد.
class PrayerTimeCalculationSettingsChanged extends PrayerTimeEvent {
  const PrayerTimeCalculationSettingsChanged();
}

class _PrayerTimeProgressTicked extends PrayerTimeEvent {
  const _PrayerTimeProgressTicked();
}
