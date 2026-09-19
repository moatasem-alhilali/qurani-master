part of 'prayer_time_screen.dart';

/// مربّع الأيقونة الصغير — بديل البطاقة حول كل صفّ.
class _IconChip extends StatelessWidget {
  const _IconChip({required this.icon, required this.skin});

  final HugeIconData icon;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: AppIcon(icon, color: skin.accent, size: 15.sp),
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final HugeIconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: AppIcon(icon, color: skin.accent, size: 16.sp),
        ),
      ),
    );
  }
}

class _TextLink extends StatelessWidget {
  const _TextLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Text(
          label,
          style: TextStyle(
            color: skin.accent,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// مواقيت يوم واحد كما تُعرض في عمود الجدول.
class _DayTimes {
  const _DayTimes({
    required this.date,
    required this.slots,
    required this.nextFajr,
    required this.middleOfTheNight,
    required this.lastThirdOfTheNight,
  });

  final DateTime date;

  /// الفجر، الشروق، الظهر، العصر، المغرب، العشاء.
  final List<DateTime> slots;

  final DateTime nextFajr;
  final DateTime middleOfTheNight;
  final DateTime lastThirdOfTheNight;

  /// مدّة نافذة الوقت: حتى الذي يليه، والعشاء حتى فجر الغد.
  Duration windowOf(int index) {
    final end = index + 1 < slots.length ? slots[index + 1] : nextFajr;
    return end.difference(slots[index]);
  }
}

/// مفاتيح الصلوات الستّ بترتيب [_DayTimes.slots].
const List<String> _prayerKeys = [
  'fajr',
  'sunrise',
  'dhuhr',
  'asr',
  'maghrib',
  'isha',
];

String _prayerName(L10n l10n, int index) => l10n.prayerName(_prayerKeys[index]);

double get _tableHeaderHeight => 38.h;

double get _tableRowHeight => 34.h;

/// اسم اليوم مختصرًا: الاثنين ← «إثن».
String _shortWeekday(L10n l10n, DateTime date) {
  switch (date.weekday) {
    case DateTime.saturday:
      return l10n.prayerTimeWeekdaySat;
    case DateTime.sunday:
      return l10n.prayerTimeWeekdaySun;
    case DateTime.monday:
      return l10n.prayerTimeWeekdayMon;
    case DateTime.tuesday:
      return l10n.prayerTimeWeekdayTue;
    case DateTime.wednesday:
      return l10n.prayerTimeWeekdayWed;
    case DateTime.thursday:
      return l10n.prayerTimeWeekdayThu;
    default:
      return l10n.prayerTimeWeekdayFri;
  }
}

String _formatClock(DateTime date) {
  final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
  return '${_twoDigits(hour12)}:${_twoDigits(date.minute)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _formatDuration(L10n l10n, Duration duration) {
  if (duration.inMinutes < 1) return l10n.prayerTimeLessThanMinute;
  if (duration.inMinutes < 60) {
    return l10n.prayerTimeMinutesShort('${duration.inMinutes}');
  }

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (minutes == 0) return l10n.prayerTimeHoursShort(hours);
  return l10n.prayerTimeHoursMinutesShort(hours, minutes);
}

/// «‎+3 د‎» أو «‎-2 د‎» مقارنةً بنفس الصلاة اليوم.
String _shiftLabel(L10n l10n, Duration shift, {required bool isToday}) {
  if (isToday) return l10n.prayerTimeShiftSameDay;

  final minutes = shift.inMinutes;
  if (minutes == 0) return l10n.prayerTimeShiftNone;

  return minutes > 0
      ? l10n.prayerTimeShiftLater(minutes.abs())
      : l10n.prayerTimeShiftEarlier(minutes.abs());
}
