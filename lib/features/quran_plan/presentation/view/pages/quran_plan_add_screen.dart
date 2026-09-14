import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/device_info_service.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/app_scaffold/back_icon_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';

/// إنشاء خطة ختمة.
///
/// كان النموذج داخل بطاقة بتدرّج وحقول محاطة بإطارات — إطار داخل إطار.
/// صار كلّ حقل صفًّا: عنوانه يمينًا وقيمته يسارًا، تفصلها شعرة.
class QuranPlanAddScreen extends StatefulWidget {
  const QuranPlanAddScreen({super.key});

  @override
  State<QuranPlanAddScreen> createState() => _QuranPlanAddScreenState();
}

class _QuranPlanAddScreenState extends State<QuranPlanAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  int? _startJuz;
  int? _endJuz;
  int? _totalDays;
  TimeOfDay? _reminderTime;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickReminderTime() async {
    final picked = await AdaptiveTimePicker.show(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() => _reminderTime = picked);
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // معرّف المالك: معرّف الجهاز.
    final deviceId = await DeviceInfoService().getDeviceId();
    final time = _reminderTime;

    final plan = QuranPlan(
      title: _titleController.text.trim(),
      startJuz: _startJuz!,
      endJuz: _endJuz!,
      totalDays: _totalDays!,
      reminderTime: time != null
          ? '${time.hour.toString().padLeft(2, '0')}:'
              '${time.minute.toString().padLeft(2, '0')}'
          : null,
      sessionsCount: 0, // يحسبها مصدر البيانات
      versesPerSession: 0, // يحسبها مصدر البيانات
      ownerId: deviceId,
      createdAt: DateTime.now(),
    );

    if (!mounted) {
      return;
    }
    context.read<QuranPlanBloc>().add(
          CreatePlanEvent(plan, _startJuz!, _endJuz!, _totalDays!),
        );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocConsumer<QuranPlanBloc, QuranPlanState>(
      buildWhen: (previous, current) =>
          previous.createRequestState != current.createRequestState,
      listener: (context, state) {
        if (state.createRequestState == RequestState.success) {
          context.pop();
        }
      },
      builder: (context, state) {
        return Theme(
          data:
              Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
          child: AppScaffoldWidget(
            title: 'إضافة خطة ختم جديدة',
            leading: const Hero(
              tag: 'add_plan',
              child: BackIconWidget(),
            ),
            body: ColoredBox(
              color: skin.ground,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const HomeSectionHeader(title: 'تفاصيل الخطة'),
                    _FieldRow(
                      label: 'عنوان الخطة',
                      child: TextFormField(
                        controller: _titleController,
                        textAlign: TextAlign.end,
                        cursorColor: skin.accent,
                        style: _valueStyle(skin),
                        decoration: _fieldDecoration(skin, 'اسم الخطة'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'أدخل عنوانًا'
                            : null,
                      ),
                    ),
                    _FieldRow(
                      label: 'من الجزء',
                      child: _JuzDropdown(
                        value: _startJuz,
                        onChanged: (value) =>
                            setState(() => _startJuz = value),
                        validator: (value) =>
                            value == null ? 'اختر البداية' : null,
                      ),
                    ),
                    _FieldRow(
                      label: 'إلى الجزء',
                      child: _JuzDropdown(
                        value: _endJuz,
                        onChanged: (value) => setState(() => _endJuz = value),
                        validator: (value) {
                          if (value == null) {
                            return 'اختر النهاية';
                          }
                          final start = _startJuz;
                          if (start != null && value < start) {
                            return 'النهاية قبل البداية';
                          }
                          return null;
                        },
                      ),
                    ),
                    _FieldRow(
                      label: 'عدد الأيام',
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        cursorColor: skin.accent,
                        style: _valueStyle(skin),
                        keyboardType: TextInputType.number,
                        decoration: _fieldDecoration(skin, 'مثال: 30'),
                        onChanged: (value) => _totalDays = int.tryParse(value),
                        validator: (value) {
                          final days = int.tryParse(value ?? '');
                          if (days == null || days <= 0) {
                            return 'أدخل عدد الأيام بشكل صحيح';
                          }
                          return null;
                        },
                      ),
                    ),
                    _ReminderRow(
                      time: _reminderTime,
                      onPick: _pickReminderTime,
                      onClear: () => setState(() => _reminderTime = null),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: AppSkin.gutter,
                      child: ProgressButtonState(
                        state: state.createRequestState,
                        onPressed: _save,
                        text: 'حفظ الخطة',
                        borderRadius: 12.r,
                        defaultColor: AppColors.gold,
                        colorText: skin.isDark
                            ? AppColors.brandNight
                            : AppColors.brandIvory,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

TextStyle _valueStyle(AppSkin skin) => TextStyle(
      color: skin.ink,
      fontSize: 12.5.sp,
      fontWeight: FontWeight.w600,
    );

InputDecoration _fieldDecoration(AppSkin skin, String hint) => InputDecoration(
      isDense: true,
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.zero,
      hintText: hint,
      hintStyle: TextStyle(
        color: skin.inkSoft.withValues(alpha: 0.5),
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
      ),
      errorStyle: TextStyle(
        color: AppColors.error,
        fontSize: 9.sp,
        fontWeight: FontWeight.w600,
      ),
    );

/// صفّ حقل: عنوانه ثابت العرض، وقيمته تملأ الباقي.
class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92.w,
            child: Text(
              label,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// اختيار جزء من ثلاثين — قائمة منسدلة بلا إطار.
class _JuzDropdown extends StatelessWidget {
  const _JuzDropdown({
    required this.value,
    required this.onChanged,
    required this.validator,
  });

  final int? value;
  final ValueChanged<int?> onChanged;
  final String? Function(int?) validator;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return DropdownButtonFormField<int>(
      initialValue: value,
      alignment: AlignmentDirectional.centerEnd,
      dropdownColor: skin.raised,
      borderRadius: BorderRadius.circular(12.r),
      icon: AppIcon(
        AppIcons.down,
        color: skin.accent,
        size: 14.sp,
      ),
      style: _valueStyle(skin),
      decoration: _fieldDecoration(skin, 'اختر'),
      items: List.generate(30, (i) => i + 1)
          .map(
            (juz) => DropdownMenuItem<int>(
              value: juz,
              alignment: AlignmentDirectional.centerEnd,
              child: Text('الجزء $juz', style: _valueStyle(skin)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

/// صفّ التذكير اليومي: وقتٌ واحد يُختار أو يُمسح.
class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.time,
    required this.onPick,
    required this.onClear,
  });

  final TimeOfDay? time;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onPick,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: skin.hairline)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 92.w,
              child: Text(
                'تذكير يومي',
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.78),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Text(
                time == null ? 'غير محدّد' : time!.format(context),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: time == null
                      ? skin.inkSoft.withValues(alpha: 0.5)
                      : skin.ink,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            if (time != null)
              InkWell(
                onTap: onClear,
                borderRadius: BorderRadius.circular(999.r),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: AppIcon(
                    AppIcons.close,
                    color: skin.inkSoft.withValues(alpha: 0.7),
                    size: 13.sp,
                  ),
                ),
              )
            else
              AppIcon(AppIcons.clock, color: skin.accent, size: 14.sp),
          ],
        ),
      ),
    );
  }
}
