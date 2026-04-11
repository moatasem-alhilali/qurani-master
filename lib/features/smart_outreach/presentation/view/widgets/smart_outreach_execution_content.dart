import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_execution_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_current_contact_actions.dart';

class SmartOutreachExecutionContent extends StatelessWidget {
  const SmartOutreachExecutionContent({
    required this.state,
    super.key,
  });

  final SmartOutreachExecutionState state;

  @override
  Widget build(BuildContext context) {
    if (state.loadState == RequestState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final bundle = state.sessionBundle;
    if (bundle == null) {
      return const Center(
        child: Text('لا توجد جلسة نشطة حالياً.'),
      );
    }

    final schedule = bundle.scheduleBundle.schedule;
    final contacts = bundle.scheduleBundle.contacts;
    final currentContact = state.currentContact;

    final completedCount = bundle.completedCount;
    final totalCount = contacts.length;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.title,
                style: context.titleLarge,
              ),
              if ((schedule.note ?? '').trim().isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(schedule.note!, style: context.bodySmall),
              ],
              SizedBox(height: 12.h),
              Text(
                'تم إنجاز $completedCount من $totalCount',
                style: context.bodyMedium,
              ),
              SizedBox(height: 6.h),
              LinearProgressIndicator(value: progress),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              final isCurrent =
                  !state.isCompleted && index == bundle.session.currentIndex;
              final isCompleted = bundle.isContactCompleted(contact);
              final statusText = _statusText(bundle, contact);

              return Card(
                margin: EdgeInsets.only(bottom: 10.h),
                color: isCurrent
                    ? context.primaryColor.withValues(alpha: 0.08)
                    : null,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(contact.displayName),
                  subtitle:
                      Text('${contact.phone}\n${contact.actionType.label}'),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isCompleted
                            ? Icons.check_circle
                            : isCurrent
                                ? Icons.play_circle_fill
                                : Icons.radio_button_unchecked,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        statusText,
                        style: context.bodySmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (currentContact != null)
          SafeArea(
            top: false,
            child: SmartOutreachCurrentContactActions(
              state: state,
              contact: currentContact,
            ),
          ),
      ],
    );
  }

  String _statusText(
    SmartOutreachSessionBundle bundle,
    SmartOutreachContactModel contact,
  ) {
    final contactId = contact.id;
    if (contactId == null) {
      return 'معلّق';
    }

    final types = bundle.resultTypesByContact[contactId] ?? const [];
    if (types.contains(SmartOutreachContactResultType.answered)) {
      return 'تم الرد';
    }
    if (types.contains(SmartOutreachContactResultType.smsSent)) {
      return 'تم إرسال رسالة';
    }
    if (types.contains(SmartOutreachContactResultType.skipped)) {
      return 'تم التخطي';
    }
    if (types.contains(SmartOutreachContactResultType.notAnswered)) {
      return 'لا يوجد رد';
    }

    return 'معلّق';
  }
}
