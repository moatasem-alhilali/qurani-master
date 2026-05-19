import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';

class SmartOutreachCallLogsScreen extends StatefulWidget {
  const SmartOutreachCallLogsScreen({
    this.scheduleId,
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
    if (widget.scheduleId == null) {
      await _repository.clearAllCallLogs();
    } else {
      await _repository.clearCallLogsForSchedule(widget.scheduleId!);
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'سجل المكالمات',
      showLargeHeader: false,
      initialOffset: null,
      trailing: IconButton(
        onPressed: _loading ? null : _clear,
        icon: const AppIcon(AppIcons.delete),
        tooltip: 'مسح السجل',
      ),
      onRefresh: _load,
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: context.primaryColor),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (_stats != null) ...[
                    _StatsGrid(stats: _stats!),
                    SizedBox(height: 12.h),
                  ],
                  if (_logs.isEmpty)
                    const _EmptyLogsState()
                  else
                    ..._logs.map(_LogTile.new),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final SmartOutreachCallStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'الإجمالي',
                value: '${stats.total}',
                icon: AppIcons.list,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _StatCard(
                label: 'تم الرد',
                value: '${stats.answered}',
                icon: AppIcons.checkSmall,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'لم يتم الرد',
                value: '${stats.notAnswered}',
                icon: AppIcons.phone,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _StatCard(
                label: 'فشل',
                value: '${stats.failed}',
                icon: AppIcons.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final HugeIconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border:
            Border.all(color: context.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          AppIcon(
            icon,
            size: 14.sp,
            color: context.primaryColor,
            strokeWidth: 1.55,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: context.onSurfaceVariant,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile(this.log);

  final SmartOutreachCallLogEntry log;

  @override
  Widget build(BuildContext context) {
    final timeText =
        intl.DateFormat('yyyy/MM/dd - HH:mm', 'ar').format(log.calledAt);
    final reason = log.reason?.trim();
    final color = _statusColor(context, log.status);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: AppIcon(
                _statusIcon(log.status),
                color: color,
                size: 15.sp,
                strokeWidth: 1.55,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.number,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: context.onSurfaceColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    reason == null || reason.isEmpty
                        ? '$timeText • ${_statusLabel(log.status)}'
                        : '$timeText • ${_statusLabel(log.status)} • $reason',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.onSurfaceVariant,
                      fontSize: 10.sp,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (log.duration > 0) ...[
              SizedBox(width: 8.w),
              Text(
                '${log.duration}ث',
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ],
        ),
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

  static Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'answered':
        return context.primaryColor;
      case 'not_answered':
        return Colors.orange;
      default:
        return context.errorColor;
    }
  }

  static String _statusLabel(String status) {
    switch (status) {
      case 'answered':
        return 'تم الرد';
      case 'not_answered':
        return 'لم يتم الرد';
      case 'failed':
        return 'فشل الاتصال';
      default:
        return status;
    }
  }
}

class _EmptyLogsState extends StatelessWidget {
  const _EmptyLogsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(18.r),
        border:
            Border.all(color: context.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Column(
        children: [
          AppIcon(
            AppIcons.clock,
            size: 23.sp,
            color: context.primaryColor,
            strokeWidth: 1.55,
          ),
          SizedBox(height: 9.h),
          Text(
            'لا توجد نتائج بعد.',
            style: TextStyle(
              color: context.onSurfaceVariant,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
