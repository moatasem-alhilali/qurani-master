part of 'smart_outreach_schedules_screen.dart';

/// حسابات الجدول وأذوناته وإجراءاته.
///
/// امتداد على الحالة: يقرأ حقولها الخاصّة مباشرةً، ويترك ملفّ الشاشة
/// لدورة الحياة والبناء وحدهما.
extension _SchedulesLogic on _SmartOutreachSchedulesViewState {
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

  String? _remainingLabel(L10n l10n, int? minutes) {
    if (minutes == null) {
      return null;
    }
    if (minutes < 1) {
      return l10n.outreachStartsNow;
    }
    if (minutes < 60) {
      return l10n.outreachStartsInMinutes(minutes);
    }

    final hours = minutes ~/ 60;
    if (hours < 24) {
      final rest = minutes % 60;
      if (rest == 0) {
        return l10n.outreachStartsInHours(hours);
      }
      return l10n.outreachStartsInHoursMinutes(hours, rest);
    }

    final days = hours ~/ 24;
    return l10n.outreachStartsInDays(days);
  }

  Future<void> _openUpsertScreen(
    BuildContext context, {
    SmartOutreachScheduleBundle? bundle,
  }) async {
    final bloc = context.read<SmartOutreachSchedulesBloc>();
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        settings: const RouteSettings(
          name: 'SmartOutreachUpsertScheduleScreen',
        ),
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
        settings: const RouteSettings(
          name: 'SmartOutreachExecutionScreen',
        ),
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
    rebuild(() {
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

      rebuild(() {
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
    final missing =
        status.missingPermissionLabels.join(context.l10n.outreachListSeparator);
    if (missing.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.outreachPermissionsRequiredSnack(missing)),
        ),
      );
  }

  Widget? _buildPermissionsNotice() {
    final snapshot = _permissionSnapshot;
    if (snapshot == null || snapshot.allGranted) {
      return null;
    }

    final l10n = context.l10n;
    final missing =
        snapshot.missingPermissionLabels.join(l10n.outreachListSeparator);

    return OutreachNotice(
      message: l10n.outreachPermissionsNotice(missing),
      icon: AppIcons.shield,
      tone: OutreachNoticeTone.alert,
      actions: <Widget>[
        OutreachTextAction(
          label: l10n.outreachGrantPermissions,
          icon: AppIcons.shield,
          onTap: () => _ensurePermissions(requestIfNeeded: true),
        ),
        OutreachTextAction(
          label: l10n.outreachOpenSettings,
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
