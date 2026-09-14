import 'dart:async';

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

    return AppScaffoldWidget(
      title: 'سجل المكالمات',
      showLargeHeader: false,
      initialOffset: null,
      trailing: IconButton(
        onPressed: _loading ? null : _clear,
        icon: AppIcon(
          AppIcons.delete,
          color: _loading ? skin.inkSoft.withValues(alpha: 0.4) : skin.accent,
          size: 17.sp,
        ),
        tooltip: 'مسح السجل',
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
                        label: 'الإجمالي',
                        value: '${stats.total}',
                      ),
                      OutreachStatCell(
                        label: 'ردّوا',
                        value: '${stats.answered}',
                      ),
                      OutreachStatCell(
                        label: 'لم يردّوا',
                        value: '${stats.notAnswered}',
                      ),
                      OutreachStatCell(
                        label: 'فشل',
                        value: '${stats.failed}',
                      ),
                    ],
                  ),
                const HomeSectionHeader(title: 'النتائج'),
                if (_logs.isEmpty)
                  const OutreachEmptyState(
                    title: 'لا توجد نتائج بعد',
                    icon: AppIcons.clock,
                    message: 'ستظهر هنا نتيجة كل مكالمة بعد أول تشغيل.',
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

/// نتيجة مكالمة واحدة: الرقم، ثم وقتها وحالتها، ثم مدّتها.
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
    final timeText =
        intl.DateFormat('yyyy/MM/dd - HH:mm', 'ar').format(log.calledAt);
    final reason = log.reason?.trim() ?? '';
    final color = _statusColor(skin, log.status);
    final meta = reason.isEmpty
        ? '${_statusLabel(log.status)} · $timeText'
        : '${_statusLabel(log.status)} · $timeText · $reason';

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
                  log.number,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
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
            OutreachValue(text: '${log.duration}ث', accented: true),
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
