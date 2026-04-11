import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_execution_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_execution_content.dart';

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
      _handlePostCallAutoFlow(executionState);
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
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('تنفيذ جدول التواصل'),
          ),
          body: SmartOutreachExecutionContent(state: state),
        );
      },
    );
  }

  void _handlePostCallAutoFlow(SmartOutreachExecutionState state) {
    if (!state.awaitingCallOutcome) {
      return;
    }

    final currentContact = state.currentContact;
    if (currentContact == null) {
      return;
    }

    final bloc = context.read<SmartOutreachExecutionBloc>();
    if (currentContact.actionType == SmartOutreachActionType.callThenSms) {
      bloc.add(const SendCurrentContactSmsEvent());
      return;
    }

    bloc.add(const MarkCurrentContactAnsweredEvent());
  }
}
