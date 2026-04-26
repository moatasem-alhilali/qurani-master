import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_permission_service.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_call_logs_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_execution_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_settings_screen.dart';
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

class _SmartOutreachSchedulesView extends StatefulWidget {
  const _SmartOutreachSchedulesView();

  @override
  State<_SmartOutreachSchedulesView> createState() =>
      _SmartOutreachSchedulesViewState();
}

class _SmartOutreachSchedulesViewState
    extends State<_SmartOutreachSchedulesView> with WidgetsBindingObserver {
  final SmartOutreachPermissionService _permissionService =
      SmartOutreachPermissionService();

  SmartOutreachPermissionSnapshot? _permissionSnapshot;
  bool _isCheckingPermissions = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensurePermissions(requestIfNeeded: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SmartOutreachSchedulesBloc,
        SmartOutreachSchedulesState>(
      listener: (context, state) {
        if (state.validationErrors.isEmpty) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(state.validationErrors.join('\n'))),
          );

        context
            .read<SmartOutreachSchedulesBloc>()
            .add(const ClearSmartOutreachScheduleFeedbackEvent());
      },
      builder: (context, state) {
        return AppScaffoldWidget(
          title: 'المكالمات المجدولة',
          showLargeHeader: false,
          initialOffset: null,
          onRefresh: () async {
            context
                .read<SmartOutreachSchedulesBloc>()
                .add(const LoadSmartOutreachSchedulesEvent());
          },
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openUpsertScreen(context),
            child: const Icon(Icons.add),
            // label: const Text('إضافة قائمة'),
          ),
          slivers: _buildSlivers(context, state),
        );
      },
    );
  }

  List<Widget> _buildSlivers(
    BuildContext context,
    SmartOutreachSchedulesState state,
  ) {
    final permissionCard = _buildPermissionsCard();

    return <Widget>[
      if (permissionCard != null)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: permissionCard,
          ),
        ),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            permissionCard == null ? 16 : 12,
            16,
            0,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SmartOutreachCallLogsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('السجل'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SmartOutreachSettingsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('الإعدادات'),
                ),
              ),
            ],
          ),
        ),
      ),
      _buildContentSliver(context, state),
    ];
  }

  Widget _buildContentSliver(
    BuildContext context,
    SmartOutreachSchedulesState state,
  ) {
    if (state.loadState == RequestState.loading && state.schedules.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.schedules.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'لا توجد قوائم مكالمات حتى الآن.\n'
              'أضف قائمة جديدة وحدد الوقت والأرقام التي تريد الاتصال بها.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final bundle = state.schedules[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == state.schedules.length - 1 ? 0 : 12,
              ),
              child: SmartOutreachScheduleItemCard(
                bundle: bundle,
                onTap: () => _openUpsertScreen(context, bundle: bundle),
                onStart: () => _handleStartNow(context, bundle.schedule.id!),
                onDelete: () {
                  context.read<SmartOutreachSchedulesBloc>().add(
                        DeleteSmartOutreachScheduleEvent(bundle.schedule.id!),
                      );
                },
                onToggle: (enabled) => _handleToggle(
                  context,
                  scheduleId: bundle.schedule.id!,
                  enabled: enabled,
                ),
              ),
            );
          },
          childCount: state.schedules.length,
        ),
      ),
    );
  }

  Future<void> _openUpsertScreen(
    BuildContext context, {
    SmartOutreachScheduleBundle? bundle,
  }) async {
    final bloc = context.read<SmartOutreachSchedulesBloc>();
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: SmartOutreachUpsertScheduleScreen(initialBundle: bundle),
        ),
      ),
    );

    bloc.add(const LoadSmartOutreachSchedulesEvent(changeState: false));
  }

  Future<void> _openExecution(BuildContext context, int scheduleId) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => SmartOutreachExecutionScreen(scheduleId: scheduleId),
      ),
    );
    if (context.mounted) {
      context
          .read<SmartOutreachSchedulesBloc>()
          .add(const LoadSmartOutreachSchedulesEvent(changeState: false));
    }
  }

  Future<void> _refreshPermissions() async {
    final status = await _permissionService.getCurrentStatus();
    if (!mounted) {
      return;
    }
    setState(() {
      _permissionSnapshot = status;
    });
  }

  Future<bool> _ensurePermissions({required bool requestIfNeeded}) async {
    if (_isCheckingPermissions) {
      return _permissionSnapshot?.allGranted ?? false;
    }

    _isCheckingPermissions = true;
    try {
      final status = requestIfNeeded
          ? await _permissionService.requestRequiredPermissions()
          : await _permissionService.getCurrentStatus();

      if (!mounted) {
        return status.allGranted;
      }

      setState(() {
        _permissionSnapshot = status;
      });

      if (!status.allGranted) {
        _showPermissionsMessage(status);
      }

      return status.allGranted;
    } finally {
      _isCheckingPermissions = false;
    }
  }

  void _showPermissionsMessage(SmartOutreachPermissionSnapshot status) {
    final missing = status.missingPermissionLabels.join('، ');
    if (missing.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('لازم تفعيل هذه الصلاحيات أولًا: $missing'),
        ),
      );
  }

  Widget? _buildPermissionsCard() {
    final snapshot = _permissionSnapshot;
    if (snapshot == null || snapshot.allGranted) {
      return null;
    }

    final missing = snapshot.missingPermissionLabels.join('، ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'الصلاحيات المطلوبة غير مكتملة',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'لتشغيل المكالمات المجدولة بشكل صحيح، فعّل هذه الصلاحيات: '
              '$missing',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: () {
                    _ensurePermissions(requestIfNeeded: true);
                  },
                  icon: const Icon(Icons.verified_user_outlined),
                  label: const Text('منح الصلاحيات'),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    await _permissionService.openSettings();
                  },
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('فتح الإعدادات'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleStartNow(BuildContext context, int scheduleId) async {
    final ready = await _ensurePermissions(requestIfNeeded: true);
    if (!ready || !context.mounted) {
      return;
    }
    await _openExecution(context, scheduleId);
  }

  Future<void> _handleToggle(
    BuildContext context, {
    required int scheduleId,
    required bool enabled,
  }) async {
    final bloc = context.read<SmartOutreachSchedulesBloc>();

    if (enabled) {
      final ready = await _ensurePermissions(requestIfNeeded: true);
      if (!ready || !context.mounted) {
        return;
      }
    }

    bloc.add(
      ToggleSmartOutreachScheduleEnabledEvent(
        scheduleId: scheduleId,
        enabled: enabled,
      ),
    );
  }
}
