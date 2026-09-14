import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';

/// حقول جدولة الإشعار بلغة الصفوف النحيلة نفسها: بلا بطاقات ولا ألوان حرفية.

/// اسم نوع الجدولة بالعربية.
String scheduleTypeLabel(ScheduleType type) {
  switch (type) {
    case ScheduleType.daily:
      return 'يومي';
    case ScheduleType.hourly:
      return 'كل ساعة';
    case ScheduleType.everyNMinutes:
      return 'كل عدة دقائق';
    case ScheduleType.weekly:
      return 'أسبوعي';
    case ScheduleType.customDates:
      return 'تواريخ مخصصة';
  }
}

/// شرح سطر واحد لكل نوع جدولة.
String scheduleTypeDescription(ScheduleType type) {
  switch (type) {
    case ScheduleType.daily:
      return 'يتكرر كل يوم في الوقت نفسه';
    case ScheduleType.hourly:
      return 'يتكرر كل ساعة عند دقيقة محددة';
    case ScheduleType.everyNMinutes:
      return 'يتكرر كل فترة زمنية تحددها';
    case ScheduleType.weekly:
      return 'يتكرر في أيام محددة من الأسبوع';
    case ScheduleType.customDates:
      return 'يظهر في تواريخ وأوقات تختارها';
  }
}

/// أيقونة نوع الجدولة.
HugeIconData scheduleTypeIcon(ScheduleType type) {
  switch (type) {
    case ScheduleType.daily:
      return AppIcons.sun;
    case ScheduleType.hourly:
      return AppIcons.clock;
    case ScheduleType.everyNMinutes:
      return AppIcons.refresh;
    case ScheduleType.weekly:
      return AppIcons.calendar;
    case ScheduleType.customDates:
      return AppIcons.bookmarkAdd;
  }
}

/// اختيار نوع الجدولة: صفّ لكل نوع، وعلامة صحّ على المختار.
class ScheduleTypeSelector extends StatelessWidget {
  const ScheduleTypeSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ScheduleType value;
  final ValueChanged<ScheduleType> onChanged;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    const types = ScheduleType.values;

    return SettingsGroup(
      title: 'نوع الجدولة',
      children: [
        for (var i = 0; i < types.length; i++)
          SettingsRow(
            icon: scheduleTypeIcon(types[i]),
            title: scheduleTypeLabel(types[i]),
            subtitle: scheduleTypeDescription(types[i]),
            active: types[i] == value,
            isLast: i == types.length - 1,
            onTap: () => onChanged(types[i]),
            trailing: types[i] == value
                ? AppIcon(AppIcons.check, color: skin.accent, size: 16.sp)
                : SizedBox(width: 16.sp),
          ),
      ],
    );
  }
}

/// صفّ اختيار الوقت — يفتح منتقي الوقت المناسب للمنصة.
class ScheduleTimeRow extends StatelessWidget {
  const ScheduleTimeRow({
    required this.hour,
    required this.minute,
    required this.onChanged,
    this.isLast = false,
    super.key,
  });

  final int? hour;
  final int? minute;
  final void Function(int hour, int minute) onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final h = hour?.toString().padLeft(2, '0') ?? '--';
    final m = minute?.toString().padLeft(2, '0') ?? '--';

    return SettingsRow(
      icon: AppIcons.clock,
      title: 'وقت التنبيه',
      subtitle: 'اضغط لاختيار الساعة والدقيقة',
      isLast: isLast,
      trailing: SettingsValueText('$h:$m'),
      onTap: () async {
        final picked = await AdaptiveTimePicker.show(
          context: context,
          initialTime: TimeOfDay(hour: hour ?? 6, minute: minute ?? 0),
        );
        if (picked != null) {
          onChanged(picked.hour, picked.minute);
        }
      },
    );
  }
}

/// صفّ رقم: حقل صغير في طرف الصفّ بدل نموذج كامل.
class ScheduleNumberRow extends StatelessWidget {
  const ScheduleNumberRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.suffix,
    this.isLast = false,
    super.key,
  });

  final HugeIconData icon;
  final String title;
  final String subtitle;
  final int? value;
  final ValueChanged<int?> onChanged;
  final String? suffix;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final unit = suffix;

    return SettingsRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      isLast: isLast,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52.w,
            child: TextFormField(
              initialValue: value?.toString() ?? '',
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: skin.iconChip,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 7.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9.r),
                  borderSide: BorderSide(color: skin.accent),
                ),
              ),
              onChanged: (text) => onChanged(int.tryParse(text)),
            ),
          ),
          if (unit != null) ...[
            SizedBox(width: 6.w),
            Text(
              unit,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// وصف اختياري للموعد — حقل نصّي بعرض القسم.
class ScheduleLabelField extends StatelessWidget {
  const ScheduleLabelField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      child: TextFormField(
        initialValue: value,
        maxLines: 2,
        style: TextStyle(
          color: skin.ink,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: skin.iconChip,
          hintText: 'أضف وصفاً قصيراً لهذا الموعد',
          hintStyle: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.6),
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 9.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11.r),
            borderSide: BorderSide(color: skin.accent),
          ),
        ),
        onChanged: (text) => onChanged(text.trim().isEmpty ? null : text),
      ),
    );
  }
}
