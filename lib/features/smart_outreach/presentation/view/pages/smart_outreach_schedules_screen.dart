import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_schedule_model.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_permission_service.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_call_logs_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_execution_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_settings_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_upsert_schedule_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_schedule_item_card.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_ui_kit.dart';

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
    final skin = AppSkin.of(context);

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
          title: 'صحبة الفجر',
          showLargeHeader: false,
          initialOffset: null,
          onRefresh: () async {
            context
                .read<SmartOutreachSchedulesBloc>()
                .add(const LoadSmartOutreachSchedulesEvent());
          },
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              _openUpsertScreen(context);
            },
            backgroundColor: skin.accent,
            foregroundColor: outreachOnAccent(skin),
            tooltip: 'إضافة قائمة',
            child: AppIcon(
              AppIcons.add,
              color: outreachOnAccent(skin),
              size: 19.sp,
            ),
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
    final skin = AppSkin.of(context);
    final notice = _buildPermissionsNotice();
    final enabledCount =
        state.schedules.where((bundle) => bundle.schedule.isEnabled).length;
    final contactsCount = state.schedules.fold<int>(
      0,
      (total, bundle) => total + bundle.contacts.length,
    );

    return OutreachGround(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
          child: Text(
            'قوائم اتصال هادئة تبدأ يوم من تحبّ بالخير',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
        OutreachStatsRow(
          cells: <OutreachStatCell>[
            OutreachStatCell(
              label: 'القوائم',
              value: '${state.schedules.length}',
            ),
            OutreachStatCell(label: 'المفعّلة', value: '$enabledCount'),
            OutreachStatCell(label: 'الأرقام', value: '$contactsCount'),
          ],
        ),
        if (notice != null) notice,
        const HomeSectionHeader(title: 'قوائم الاتصال'),
        _buildContent(context, state),
        skin.divider(),
        const HomeSectionHeader(title: 'أدوات'),
        OutreachRow(
          title: 'سجل المكالمات',
          subtitle: 'نتيجة كل اتصال: من ردّ ومن لم يردّ',
          icon: AppIcons.clock,
          showChevron: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SmartOutreachCallLogsScreen(),
              ),
            );
          },
        ),
        OutreachRow(
          title: 'إعدادات الاتصال',
          subtitle: 'المدد الافتراضية وسلوك القوائم الجديدة',
          icon: AppIcons.settings,
          showChevron: true,
          isLast: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SmartOutreachSettingsScreen(),
              ),
            );
          },
        ),
        SizedBox(height: 64.h),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    SmartOutreachSchedulesState state,
  ) {
    if (state.loadState == RequestState.loading && state.schedules.isEmpty) {
      return const OutreachLoading();
    }

    if (state.schedules.isEmpty) {
      return OutreachEmptyState(
        title: 'لا توجد قوائم بعد',
        icon: AppIcons.contacts,
        message: 'أضف قائمة وحدّد وقتها والأرقام التي تودّ الاتصال بها.',
        actionLabel: 'إضافة قائمة',
        onAction: () => _openUpsertScreen(context),
      );
    }

    final nextIndex = _nextScheduleIndex(state.schedules);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final entry in state.schedules.asMap().entries)
          SmartOutreachScheduleItemCard(
            bundle: entry.value,
            isNext: entry.key == nextIndex,
            isLast: entry.key == state.schedules.length - 1,
            countdownLabel: entry.key == nextIndex
                ? _remainingLabel(_minutesUntilNextRun(entry.value.schedule))
                : null,
            onTap: () => _openUpsertScreen(context, bundle: entry.value),
            onStart: () => _handleStartNow(context, entry.value.schedule.id!),
            onDelete: () {
              context.read<SmartOutreachSchedulesBloc>().add(
                    DeleteSmartOutreachScheduleEvent(entry.value.schedule.id!),
                  );
            },
            onToggle: (enabled) => _handleToggle(
              context,
              scheduleId: entry.value.schedule.id!,
              enabled: enabled,
            ),
          ),
      ],
    );
  }

  /// الجدولة الأقرب موعدًا بين المفعّلة — هي وحدها التي ترتفع في الشاشة.
  int _nextScheduleIndex(List<SmartOutreachScheduleBundle> schedules) {
    var best = -1;
    var bestMinutes = -1;

    for (var index = 0; index < schedules.length; index++) {
      final minutes = _minutesUntilNextRun(schedules[index].schedule);
      if (minutes == null) {
        continue;
      }
      if (best == -1 || minutes < bestMinutes) {
        best = index;
        bestMinutes = minutes;
      }
    }

    return best;
  }

  /// كم دقيقة تفصلنا عن أقرب تشغيل لهذه الجدولة، أو `null` لو كانت متوقّفة
  /// أو بلا أيام مختارة.
  int? _minutesUntilNextRun(SmartOutreachScheduleModel schedule) {
    if (!schedule.isEnabled) {
      return null;
    }
    final days = schedule.isDaily ? null : schedule.scheduleDays;
    if (days != null && days.isEmpty) {
      return null;
    }

    final now = DateTime.now();
    for (var offset = 0; offset < 8; offset++) {
      final day = DateTime(now.year, now.month, now.day).add(
        Duration(days: offset),
      );
      final runAt = DateTime(
        day.year,
        day.month,
        day.day,
        schedule.hour,
        schedule.minute,
      );
      if (!runAt.isAfter(now)) {
        continue;
      }
      // ترقيم `DateTime.weekday` هو نفسه ترقيم أيام الجدولة: ١ الإثنين.
      if (days != null && !days.contains(runAt.weekday)) {
        continue;
      }
      return runAt.difference(now).inMinutes;
    }

    return null;
  }

  String? _remainingLabel(int? minutes) {
    if (minutes == null) {
      return null;
    }
    if (minutes < 1) {
      return 'تبدأ الآن';
    }
    if (minutes < 60) {
      return 'بعد $minutes دقيقة';
    }

    final hours = minutes ~/ 60;
    if (hours < 24) {
      final rest = minutes % 60;
      if (rest == 0) {
        return 'بعد $hours ساعة';
      }
      return 'بعد $hours ساعة و$rest دقيقة';
    }

    final days = hours ~/ 24;
    return days == 1 ? 'بعد يوم' : 'بعد $days أيام';
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

  Widget? _buildPermissionsNotice() {
    final snapshot = _permissionSnapshot;
    if (snapshot == null || snapshot.allGranted) {
      return null;
    }

    final missing = snapshot.missingPermissionLabels.join('، ');

    return OutreachNotice(
      message: 'الصلاحيات المطلوبة غير مكتملة. لتعمل القوائم في وقتها '
          'فعّل: $missing',
      icon: AppIcons.shield,
      tone: OutreachNoticeTone.alert,
      actions: <Widget>[
        OutreachTextAction(
          label: 'منح الصلاحيات',
          icon: AppIcons.shield,
          onTap: () => _ensurePermissions(requestIfNeeded: true),
        ),
        OutreachTextAction(
          label: 'فتح الإعدادات',
          icon: AppIcons.settings,
          onTap: _permissionService.openSettings,
        ),
      ],
    );
  }

  Future<void> _handleStartNow(BuildContext context, int scheduleId) async {
    unawaited(HapticFeedback.mediumImpact());
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
