import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_ui_kit.dart';
import 'package:quran_app/l10n/l10n.dart';

@RoutePage()
class SmartOutreachCallLogsScreen extends StatefulWidget {
  const SmartOutreachCallLogsScreen({
    @QueryParam('scheduleId') this.scheduleId,
    super.key,
  });

  final int? scheduleId;

  @override
  State<SmartOutreachCallLogsScreen> createState() =>
      _SmartOutreachCallLogsScreenState();
}

class _SmartOutreachCallLogsScreenState
    extends State<SmartOutreachCallLogsScreen> {
  final SmartOutreachScheduleRepository _repository =
      sl<SmartOutreachScheduleRepository>();

  bool _loading = true;
  List<SmartOutreachCallLogEntry> _logs = const <SmartOutreachCallLogEntry>[];
  SmartOutreachCallStats? _stats;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final logs = await _repository.getCallLogs(scheduleId: widget.scheduleId);
    final stats = await _repository.getCallStats();

    if (!mounted) return;
    setState(() {
      _logs = logs;
      _stats = stats;
      _loading = false;
    });
  }

  Future<void> _clear() async {
    unawaited(HapticFeedback.mediumImpact());

    if (widget.scheduleId == null) {
      await _repository.clearAllCallLogs();
    } else {
      await _repository.clearCallLogsForSchedule(widget.scheduleId!);
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final stats = _stats;
    final l10n = context.l10n;

    return AppScaffoldWidget(
      title: l10n.outreachCallLogsTitle,
      showLargeHeader: false,
      initialOffset: null,
      trailing: IconButton(
        onPressed: _loading ? null : _clear,
        icon: AppIcon(
          AppIcons.delete,
          color: _loading ? skin.inkSoft.withValues(alpha: 0.4) : skin.accent,
          size: 17.sp,
        ),
        tooltip: l10n.outreachClearLog,
      ),
      onRefresh: _load,
      body: _loading
          ? const OutreachLoading()
          : OutreachGround(
              children: <Widget>[
                if (stats != null)
                  OutreachStatsRow(
                    cells: <OutreachStatCell>[
                      OutreachStatCell(
                        label: l10n.outreachStatTotal,
                        value: '${stats.total}',
                      ),
                      OutreachStatCell(
                        label: l10n.outreachStatAnswered,
                        value: '${stats.answered}',
                      ),
                      OutreachStatCell(
                        label: l10n.outreachStatNotAnswered,
                        value: '${stats.notAnswered}',
                      ),
                      OutreachStatCell(
                        label: l10n.outreachStatFailed,
                        value: '${stats.failed}',
                      ),
                    ],
                  ),
                HomeSectionHeader(title: l10n.outreachResultsHeader),
                if (_logs.any((log) => log.duration > 0))
                  OutreachNotice(
                    message: l10n.outreachCallDurationNote,
                    icon: AppIcons.clock,
                  ),
                if (_logs.isEmpty)
                  OutreachEmptyState(
                    title: l10n.outreachNoResultsTitle,
                    icon: AppIcons.clock,
                    message: l10n.outreachNoResultsMessage,
                  )
                else
                  for (final entry in _logs.asMap().entries)
                    _LogRow(
                      log: entry.value,
                      isLast: entry.key == _logs.length - 1,
                    ),
                SizedBox(height: 28.h),
              ],
            ),
    );
  }
}

/// نتيجة مكالمة واحدة: اسم المتّصَل به، ثم وقتها وحالتها، ثم مدّتها.
///
/// الحالة تُقرأ من نصّها وأيقونتها معًا، لا من لونها وحده.
class _LogRow extends StatelessWidget {
  const _LogRow({
    required this.log,
    required this.isLast,
  });

  final SmartOutreachCallLogEntry log;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final l10n = context.l10n;
    final timeText = intl.DateFormat('yyyy/MM/dd - HH:mm', context.localeCode)
        .format(log.calledAt);
    final reason = log.reason?.trim() ?? '';
    final color = _statusColor(skin, log.status);
    final meta = reason.isEmpty
        ? '${_statusLabel(l10n, log.status)} · $timeText'
        : '${_statusLabel(l10n, log.status)} · $timeText · $reason';

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 9.h, 16.w, 9.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: AppIcon(_statusIcon(log.status), color: color, size: 15.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  log.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // Only a bare number is forced LTR; a name follows the UI.
                  textDirection: log.displayName == log.number
                      ? TextDirection.ltr
                      : null,
                  textAlign: outreachStartAlign(context),
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  meta,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          if (log.duration > 0) ...[
            SizedBox(width: 8.w),
            _CallDuration(seconds: log.duration),
          ],
        ],
      ),
    );
  }

  static HugeIconData _statusIcon(String status) {
    switch (status) {
      case 'answered':
        return AppIcons.checkSmall;
      case 'not_answered':
        return AppIcons.phone;
      default:
        return AppIcons.warning;
    }
  }

  static Color _statusColor(AppSkin skin, String status) {
    switch (status) {
      case 'answered':
        return skin.accent;
      case 'not_answered':
        return skin.inkSoft;
      default:
        return AppColors.error;
    }
  }

  static String _statusLabel(L10n l10n, String status) {
    switch (status) {
      case 'answered':
        return l10n.outreachCallStatusAnswered;
      case 'not_answered':
        return l10n.outreachCallStatusNotAnswered;
      case 'failed':
        return l10n.outreachCallStatusFailed;
      default:
        return status;
    }
  }
}

/// How long the call lasted. The glyph is what says "30s" is time spent, not
/// a countdown — the reading the screenshot in the bug report got wrong.
///
/// A duration is logged only when the app itself ended an answered call after
/// the schedule's delay; a call the two sides ended is logged as zero.
class _CallDuration extends StatelessWidget {
  const _CallDuration({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final label = context.l10n.outreachCallDurationLabel(seconds);

    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        excludeSemantics: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(AppIcons.clock, color: skin.accent, size: 11.sp),
            SizedBox(width: 3.w),
            OutreachValue(
              text: context.l10n.outreachSecondsShort(seconds),
              accented: true,
            ),
          ],
        ),
      ),
    );
  }
}
