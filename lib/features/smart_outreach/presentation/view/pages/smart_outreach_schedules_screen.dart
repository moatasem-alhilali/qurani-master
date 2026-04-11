import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_execution_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_upsert_schedule_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_schedule_item_card.dart';

class SmartOutreachSchedulesScreen extends StatelessWidget {
  const SmartOutreachSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SmartOutreachSchedulesBloc>(
      create: (_) => sl<SmartOutreachSchedulesBloc>()
        ..add(const LoadSmartOutreachSchedulesEvent()),
      child: const _SmartOutreachSchedulesView(),
    );
  }
}

class _SmartOutreachSchedulesView extends StatelessWidget {
  const _SmartOutreachSchedulesView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SmartOutreachSchedulesBloc,
        SmartOutreachSchedulesState>(
      listener: (context, state) {
        if (state.validationErrors.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.validationErrors.join('\n')),
              ),
            );

          context
              .read<SmartOutreachSchedulesBloc>()
              .add(const ClearSmartOutreachScheduleFeedbackEvent());
        }
      },
      builder: (context, state) {
        return AppScaffoldWidget(
          title: 'جدولة أيقظنية',
          showLargeHeader: false,
          initialOffset: null,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openUpsertScreen(context),
            child: const Icon(Icons.add),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    SmartOutreachSchedulesState state,
  ) {
    if (state.loadState == RequestState.loading && state.schedules.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.schedules.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: const Text(
            'لا توجد جداول حتى الآن. أضف أول جدول تواصل ذكي.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(12.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.schedules.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final bundle = state.schedules[index];
        return SmartOutreachScheduleItemCard(
          bundle: bundle,
          onTap: () => _openUpsertScreen(context, bundle: bundle),
          onStart: () => _openExecution(context, bundle.schedule.id!),
          onDelete: () {
            context.read<SmartOutreachSchedulesBloc>().add(
                  DeleteSmartOutreachScheduleEvent(bundle.schedule.id!),
                );
          },
          onToggle: (enabled) {
            context.read<SmartOutreachSchedulesBloc>().add(
                  ToggleSmartOutreachScheduleEnabledEvent(
                    scheduleId: bundle.schedule.id!,
                    enabled: enabled,
                  ),
                );
          },
        );
      },
    );
  }

  Future<void> _openUpsertScreen(
    BuildContext context, {
    SmartOutreachScheduleBundle? bundle,
  }) async {
    final bloc = context.read<SmartOutreachSchedulesBloc>();
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: SmartOutreachUpsertScheduleScreen(initialBundle: bundle),
        ),
      ),
    );

    bloc.add(const LoadSmartOutreachSchedulesEvent(changeState: false));
  }

  Future<void> _openExecution(BuildContext context, int scheduleId) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => SmartOutreachExecutionScreen(scheduleId: scheduleId),
      ),
    );
  }
}
