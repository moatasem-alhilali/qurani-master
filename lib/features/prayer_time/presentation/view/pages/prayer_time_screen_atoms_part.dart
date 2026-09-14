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

const List<String> _prayerNames = [
  'الفجر',
  'الشروق',
  'الظهر',
  'العصر',
  'المغرب',
  'العشاء',
];

double get _tableHeaderHeight => 38.h;

double get _tableRowHeight => 34.h;

/// اسم اليوم مختصرًا: الاثنين ← «إثن».
String _shortWeekday(DateTime date) {
  switch (date.weekday) {
    case DateTime.saturday:
      return 'سبت';
    case DateTime.sunday:
      return 'أحد';
    case DateTime.monday:
      return 'إثن';
    case DateTime.tuesday:
      return 'ثلا';
    case DateTime.wednesday:
      return 'أرب';
    case DateTime.thursday:
      return 'خمي';
    default:
      return 'جمع';
  }
}

String _formatClock(DateTime date) {
  final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
  return '${_twoDigits(hour12)}:${_twoDigits(date.minute)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _formatDuration(Duration duration) {
  if (duration.inMinutes < 1) return 'أقل من دقيقة';
  if (duration.inMinutes < 60) return '${duration.inMinutes} د';

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (minutes == 0) return '$hours س';
  return '$hours س $minutes د';
}

/// «‎+3 د‎» أو «‎-2 د‎» مقارنةً بنفس الصلاة اليوم.
String _shiftLabel(Duration shift, {required bool isToday}) {
  if (isToday) return 'اليوم نفسه';

  final minutes = shift.inMinutes;
  if (minutes == 0) return 'بلا فارق';

  final sign = minutes > 0 ? 'متأخّر' : 'مبكّر';
  return '$sign ${minutes.abs()} د';
}
