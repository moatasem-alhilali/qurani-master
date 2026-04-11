import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_execution_bloc.dart';

class SmartOutreachCurrentContactActions extends StatelessWidget {
  const SmartOutreachCurrentContactActions({
    required this.state,
    required this.contact,
    super.key,
  });

  final SmartOutreachExecutionState state;
  final SmartOutreachContactModel contact;

  @override
  Widget build(BuildContext context) {
    final bundle = state.sessionBundle!;
    final isCompleted = bundle.isContactCompleted(contact);

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          top: BorderSide(color: context.dividerColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الحالي: ${contact.displayName}',
            style: context.titleMedium,
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              if (!isCompleted && contact.actionType.includesCall)
                FilledButton.icon(
                  onPressed: () {
                    context
                        .read<SmartOutreachExecutionBloc>()
                        .add(const LaunchCurrentContactCallEvent());
                  },
                  icon: const Icon(Icons.call),
                  label: const Text('اتصل الآن'),
                ),
              if (!isCompleted &&
                  contact.actionType.includesSms &&
                  (contact.actionType == SmartOutreachActionType.smsOnly ||
                      state.awaitingSmsFallback))
                FilledButton.icon(
                  onPressed: () {
                    context
                        .read<SmartOutreachExecutionBloc>()
                        .add(const SendCurrentContactSmsEvent());
                  },
                  icon: const Icon(Icons.sms),
                  label: Text(
                    state.awaitingSmsFallback
                        ? 'إعادة إرسال الرسالة'
                        : 'إرسال رسالة',
                  ),
                ),
              OutlinedButton(
                onPressed: () {
                  context
                      .read<SmartOutreachExecutionBloc>()
                      .add(const SkipCurrentContactEvent());
                },
                child: const Text('تخطي'),
              ),
              OutlinedButton(
                onPressed: () {
                  context
                      .read<SmartOutreachExecutionBloc>()
                      .add(const MoveToNextContactEvent());
                },
                child: const Text('التالي'),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<SmartOutreachExecutionBloc>()
                      .add(const FinishSmartOutreachSessionEvent());
                },
                child: const Text('إنهاء'),
              ),
            ],
          ),
          if (state.awaitingSmsFallback) ...[
            SizedBox(height: 8.h),
            Text(
              'تم بدء تسلسل اتصال+رسالة. '
              'سيتم إرسال الرسالة تلقائيًا بعد إنهاء الاتصال.',
              style: context.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
