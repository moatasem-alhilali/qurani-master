import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/device_info_service.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/app_scaffold/back_icon_widget.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';

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
  Widget build(BuildContext context) {
    return BlocConsumer<QuranPlanBloc, QuranPlanState>(
      buildWhen: (previous, current) =>
          previous.createRequestState != current.createRequestState,
      listener: (context, state) {
        if (state.createRequestState == RequestState.success) {
          context.pop();
        }
      },
      builder: (context, state) {
        return AppScaffoldWidget(
          title: 'إضافة خطة ختم جديدة',
          leading: const Hero(
            tag: 'add_plan',
            child: BackIconWidget(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          context.surfaceColor,
                          context.surfaceVariant.withValues(alpha: 0.42),
                        ],
                      ),
                      border: Border.all(
                        color: context.outline.withValues(alpha: 0.85),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.shadow.withValues(alpha: 0.05),
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'عنوان الخطة',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'أدخل عنواناً' : null,
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'من الجزء',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                initialValue: _startJuz,
                                items: List.generate(30, (i) => i + 1)
                                    .map(
                                      (j) => DropdownMenuItem(
                                        value: j,
                                        child: Text('$j'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(() => _startJuz = v),
                                validator: (v) =>
                                    v == null || v == 0 ? 'اختر البداية' : null,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'إلى الجزء',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                initialValue: _endJuz,
                                items: List.generate(30, (i) => i + 1)
                                    .map(
                                      (j) => DropdownMenuItem(
                                        value: j,
                                        child: Text('$j'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(() => _endJuz = v),
                                validator: (v) {
                                  if (v == null) return 'اختر النهاية';
                                  if (_startJuz != null && v < _startJuz!) {
                                    return 'يجب أن يكون الجزء النهائي أكبر أو يساوي البداية';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'عدد الأيام',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => _totalDays = int.tryParse(v),
                          validator: (v) {
                            final num = int.tryParse(v ?? '');
                            if (num == null || num <= 0)
                              return 'أدخل عدد الأيام بشكل صحيح';
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        ListTile(
                          tileColor:
                              context.primaryColor.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          title: Text(
                            _reminderTime == null
                                ? 'حدد وقت التذكير اليومي'
                                : 'وقت التذكير: ${_reminderTime!.format(context)}',
                            style: context.bodyMedium?.copyWith(
                              fontWeight: _reminderTime == null
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: context.primaryColor,
                            ),
                          ),
                          leading: Icon(
                            Icons.alarm,
                            color: context.primaryColor,
                          ),
                          onTap: () async {
                            final t = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (t != null) setState(() => _reminderTime = t);
                          },
                          trailing: _reminderTime != null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: context.errorColor,
                                  ),
                                  onPressed: () =>
                                      setState(() => _reminderTime = null),
                                )
                              : Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: context.primaryColor,
                                  size: 16.sp,
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ProgressButtonState(
                    state: state.createRequestState,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      // اجلب ownerId (معرف الجهاز أو المستخدم حسب مشروعك)
                      final deviceId = await DeviceInfoService().getDeviceId();

                      final plan = QuranPlan(
                        title: _titleController.text.trim(),
                        startJuz: _startJuz!,
                        endJuz: _endJuz!,
                        totalDays: _totalDays!,
                        reminderTime: _reminderTime != null
                            ? "${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}"
                            : null,
                        sessionsCount: 0, // سيحسبها الداتا سورس
                        versesPerSession: 0, // سيحسبها الداتا سورس
                        ownerId: deviceId,
                        createdAt: DateTime.now(),
                      );
                      if (context.mounted) {
                        context.read<QuranPlanBloc>().add(
                              CreatePlanEvent(
                                plan,
                                _startJuz!,
                                _endJuz!,
                                _totalDays!,
                              ),
                            );
                      }
                    },
                    text: 'حفظ الخطة',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
