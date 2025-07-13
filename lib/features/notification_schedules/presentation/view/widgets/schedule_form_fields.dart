import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

// Schedule Type Dropdown
class ScheduleTypeDropdown extends StatelessWidget {
  const ScheduleTypeDropdown({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ScheduleType value;
  final ValueChanged<ScheduleType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<ScheduleType>(
        value: value,
        decoration: InputDecoration(
          labelText: 'نوع الجدولة',
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          labelStyle: titleSmall(context),
        ),
        items: ScheduleType.values
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Row(
                  children: [
                    Icon(
                      _getScheduleTypeIcon(e),
                      size: 20.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      _scheduleTypeStr(e),
                      style: titleSmall(context),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (val) => onChanged(val!),
        borderRadius: BorderRadius.circular(12.r),
        dropdownColor: Colors.white,
      ),
    );
  }

  IconData _getScheduleTypeIcon(ScheduleType type) {
    switch (type) {
      case ScheduleType.daily:
        return Icons.today;
      case ScheduleType.hourly:
        return Icons.access_time;
      case ScheduleType.weekly:
        return Icons.date_range;
      case ScheduleType.everyNMinutes:
        return Icons.schedule;
      case ScheduleType.customDates:
        return Icons.event_note;
      default:
        return Icons.schedule;
    }
  }

  String _scheduleTypeStr(ScheduleType t) {
    switch (t) {
      case ScheduleType.daily:
        return 'يومي';
      case ScheduleType.hourly:
        return 'ساعه واحده';
      case ScheduleType.weekly:
        return 'أسبوعي (اختر أيام)';
      case ScheduleType.everyNMinutes:
        return 'كل X دقيقة';
      case ScheduleType.customDates:
        return 'تواريخ مخصصة';
      default:
        return '';
    }
  }
}

// Time Picker Fields
class TimePickerFields extends StatelessWidget {
  const TimePickerFields({
    required this.hour,
    required this.minute,
    required this.onHourChanged,
    required this.onMinuteChanged,
    super.key,
  });

  final int? hour;
  final int? minute;
  final ValueChanged<int?> onHourChanged;
  final ValueChanged<int?> onMinuteChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الوقت',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildTimeField(
                  label: 'ساعة',
                  value: hour,
                  onChanged: onHourChanged,
                  min: 0,
                  max: 23,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                ':',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildTimeField(
                  label: 'دقيقة',
                  value: minute,
                  onChanged: onMinuteChanged,
                  min: 0,
                  max: 59,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required int? value,
    required ValueChanged<int?> onChanged,
    required int min,
    required int max,
  }) {
    return TextFormField(
      initialValue: value?.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      ),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      validator: (v) {
        if (v == null || v.isEmpty) return 'مطلوب';
        final val = int.tryParse(v);
        if (val == null) return 'رقم غير صحيح';
        if (val < min || val > max) return '$min-$max';
        return null;
      },
      onSaved: (v) => onChanged(int.tryParse(v ?? '')),
    );
  }
}

// Interval Minutes Field
class IntervalMinutesField extends StatelessWidget {
  const IntervalMinutesField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 20.sp,
                color: Colors.orange[700],
              ),
              SizedBox(width: 8.w),
              Text(
                'التكرار بالدقائق',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          MyTextFormFieldWidget(
            labelText: 'كل كم دقيقة؟',
            hintText: 'مثال: 30',
            suffixText: 'دقيقة',
            initialValue: value?.toString(),
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.isEmpty) return 'مطلوب';
              final val = int.tryParse(v);
              if (val == null) return 'رقم غير صحيح';
              if (val < 1) return 'يجب أن يكون أكبر من 0';
              return null;
            },
            onFieldSubmitted: (v) => onChanged(int.tryParse(v ?? '')),
          ),
        ],
      ),
    );
  }
}

// Label Field
class LabelField extends StatelessWidget {
  const LabelField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return MyTextFormFieldWidget(
      initialValue: value,
      labelText: 'وصف اختياري',
      hintText: 'أضف وصفاً لهذا الموعد',
      // prefixIcon: Icon(Icons.label_outline, size: 20.sp),
      maxLines: 2,
      onFieldSubmitted: (v) => onChanged(v.isEmpty == true ? null : v),
    );
  }
}
