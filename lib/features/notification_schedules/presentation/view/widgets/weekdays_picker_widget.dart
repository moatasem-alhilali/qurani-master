import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/schedule_form_fields.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/l10n/l10n.dart';

/// اختيار أيام الأسبوع: أزرار صغيرة بلا بطاقة، التعبئة الذهبية للمحدّد فقط.
class WeekdaysPickerWidget extends StatefulWidget {
  const WeekdaysPickerWidget({
    required this.initialSelection,
    required this.onChanged,
    super.key,
  });

  final List<int> initialSelection;
  final ValueChanged<List<int>> onChanged;

  @override
  State<WeekdaysPickerWidget> createState() => _WeekdaysPickerWidgetState();
}

class _WeekdaysPickerWidgetState extends State<WeekdaysPickerWidget> {
  /// الأحد أولًا كما يبدأ الأسبوع عربيًا (7 = الأحد ... 6 = السبت).
  static const List<int> _weekDays = [7, 1, 2, 3, 4, 5, 6];

  /// عطلة نهاية الأسبوع في بلدان جمهور كل لغة (`DateTime.weekday`: 1 = الإثنين).
  /// الخليج وبنغلاديش: الجمعة والسبت. إيران: الخميس والجمعة. باكستان
  /// وإندونيسيا وتركيا: السبت والأحد.
  static List<int> _weekendFor(String localeCode) {
    switch (localeCode) {
      case 'ar':
      case 'bn':
        return const [5, 6];
      case 'fa':
        return const [4, 5];
      default:
        return const [6, 7];
    }
  }

  static List<int> _workDaysFor(String localeCode) {
    final weekend = _weekendFor(localeCode);
    return [
      for (final day in _weekDays)
        if (!weekend.contains(day)) day,
    ];
  }

  late List<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<int>.of(widget.initialSelection);
  }

  void _apply(List<int> next) {
    HapticFeedback.selectionClick();
    setState(() => _selected = next);
    widget.onChanged(_selected);
  }

  void _toggleDay(int day) {
    final next = List<int>.of(_selected);
    if (next.contains(day)) {
      next.remove(day);
    } else {
      next.add(day);
    }
    _apply(next);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              for (var i = 0; i < _weekDays.length; i++)
                _DayChip(
                  label: shortWeekdayName(context.l10n, _weekDays[i]),
                  selected: _selected.contains(_weekDays[i]),
                  onTap: () => _toggleDay(_weekDays[i]),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Wrap(
            spacing: 2.w,
            children: [
              SettingsGhostButton(
                label: context.l10n.notifScheduleAllDays,
                onPressed: () => _apply(List<int>.of(_weekDays)),
              ),
              SettingsGhostButton(
                label: context.l10n.notifScheduleWorkDays,
                onPressed: () => _apply(_workDaysFor(context.localeCode)),
              ),
              SettingsGhostButton(
                label: context.l10n.notifScheduleWeekend,
                onPressed: () => _apply(_weekendFor(context.localeCode)),
              ),
              SettingsGhostButton(
                label: context.l10n.notifScheduleClear,
                onPressed: () => _apply([]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// زرّ يوم واحد: تعبئة ذهبية حين يُختار، وخلفية خافتة حين لا.
class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Ink(
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : skin.iconChip,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? settingsOnGold : skin.ink.withValues(alpha: 0.85),
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}
