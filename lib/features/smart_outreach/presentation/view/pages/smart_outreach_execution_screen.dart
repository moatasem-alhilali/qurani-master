import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_execution_bloc.dart';

class SmartOutreachExecutionScreen extends StatelessWidget {
  const SmartOutreachExecutionScreen({
    required this.scheduleId,
    this.launchedFromNotification = false,
    super.key,
  });

  final int scheduleId;
  final bool launchedFromNotification;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SmartOutreachExecutionBloc>(
      create: (_) => sl<SmartOutreachExecutionBloc>()
        ..add(
          StartSmartOutreachSessionEvent(
            scheduleId: scheduleId,
            launchedFromNotification: launchedFromNotification,
          ),
        ),
      child: const _SmartOutreachExecutionView(),
    );
  }
}

class _SmartOutreachExecutionView extends StatefulWidget {
  const _SmartOutreachExecutionView();

  @override
  State<_SmartOutreachExecutionView> createState() =>
      _SmartOutreachExecutionViewState();
}

class _SmartOutreachExecutionViewState
    extends State<_SmartOutreachExecutionView> with WidgetsBindingObserver {
  bool _isCallOutcomeDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }

    final executionState = context.read<SmartOutreachExecutionBloc>().state;
    if (executionState.awaitingCallOutcome) {
      _promptCallOutcome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SmartOutreachExecutionBloc,
        SmartOutreachExecutionState>(
      listener: (context, state) {
        final message = state.message;
        if (message != null && message.trim().isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
          context
              .read<SmartOutreachExecutionBloc>()
              .add(const ClearSmartOutreachExecutionFeedbackEvent());
        }

        if (state.awaitingCallOutcome && !_isCallOutcomeDialogOpen) {
          _promptCallOutcome();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('تنفيذ جدول التواصل'),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    SmartOutreachExecutionState state,
  ) {
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
                color:
                    isCurrent ? context.primaryColor.withOpacity(0.08) : null,
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
            child: _CurrentContactActions(
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

  Future<void> _promptCallOutcome() async {
    final bloc = context.read<SmartOutreachExecutionBloc>();
    final state = bloc.state;
    if (!state.awaitingCallOutcome || _isCallOutcomeDialogOpen) {
      return;
    }

    _isCallOutcomeDialogOpen = true;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('هل تم الرد على الاتصال؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                bloc.add(const MarkCurrentContactAnsweredEvent());
              },
              child: const Text('نعم'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                bloc.add(const MarkCurrentContactNotAnsweredEvent());
              },
              child: const Text('لا'),
            ),
          ],
        );
      },
    );

    _isCallOutcomeDialogOpen = false;
  }
}

class _CurrentContactActions extends StatelessWidget {
  const _CurrentContactActions({
    required this.state,
    required this.contact,
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
                  label: const Text('إرسال رسالة'),
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
              'تم تسجيل عدم الرد. أرسل رسالة لإكمال هذا التواصل.',
              style: context.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
