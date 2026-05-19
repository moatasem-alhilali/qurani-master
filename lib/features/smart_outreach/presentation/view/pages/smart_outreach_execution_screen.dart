import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_call_logs_screen.dart';

class SmartOutreachExecutionScreen extends StatefulWidget {
  const SmartOutreachExecutionScreen({
    required this.scheduleId,
    this.launchedFromNotification = false,
    super.key,
  });

  final int scheduleId;
  final bool launchedFromNotification;

  @override
  State<SmartOutreachExecutionScreen> createState() =>
      _SmartOutreachExecutionScreenState();
}

class _SmartOutreachExecutionScreenState
    extends State<SmartOutreachExecutionScreen> {
  final SmartOutreachScheduleRepository _repository =
      sl<SmartOutreachScheduleRepository>();

  bool _starting = true;
  String? _message;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      await _repository.startScheduleNow(widget.scheduleId);
      if (!mounted) return;
      setState(() {
        _starting = false;
        _failed = false;
        _message = widget.launchedFromNotification
            ? 'بدأت المكالمات من التنبيه.'
            : 'بدأت المكالمات الآن.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _starting = false;
        _failed = true;
        _message = 'تعذر بدء المكالمات الآن. حاول مرة أخرى.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'بدء المكالمات',
      showLargeHeader: false,
      initialOffset: null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24.h),
            _ExecutionPanel(
              starting: _starting,
              failed: _failed,
              message: _message ?? '',
              onRetry: _start,
              onLogs: _starting
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => SmartOutreachCallLogsScreen(
                            scheduleId: widget.scheduleId,
                          ),
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _ExecutionPanel extends StatelessWidget {
  const _ExecutionPanel({
    required this.starting,
    required this.failed,
    required this.message,
    required this.onRetry,
    required this.onLogs,
  });

  final bool starting;
  final bool failed;
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onLogs;

  @override
  Widget build(BuildContext context) {
    final color = failed ? context.errorColor : context.primaryColor;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 62.w,
            height: 62.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: starting
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      color: color,
                      strokeWidth: 2.5.w,
                    ),
                  )
                : AppIcon(
                    failed ? AppIcons.warning : AppIcons.phone,
                    color: color,
                    size: 25.sp,
                    strokeWidth: 1.55,
                  ),
          ),
          SizedBox(height: 16.h),
          Text(
            starting ? 'جارِ تجهيز المكالمات...' : message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            starting
                ? 'لا تغلق الصفحة حتى يتم بدء العملية.'
                : 'يمكنك إغلاق هذه الصفحة الآن ومراجعة النتيجة من '
                    'سجل المكالمات.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.onSurfaceVariant,
              fontSize: 11.sp,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              if (failed) ...[
                Expanded(
                  child: _ActionButton(
                    label: 'إعادة المحاولة',
                    icon: AppIcons.refresh,
                    filled: true,
                    onTap: onRetry,
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Expanded(
                child: _ActionButton(
                  label: 'عرض السجل',
                  icon: AppIcons.clock,
                  filled: !failed,
                  onTap: onLogs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final HugeIconData icon;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      borderRadius: BorderRadius.circular(13.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: BoxDecoration(
          color: !enabled
              ? context.onSurfaceColor.withValues(alpha: 0.08)
              : filled
                  ? context.primaryColor
                  : context.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon,
              size: 13.sp,
              color: filled && enabled
                  ? context.onPrimaryColor
                  : context.primaryColor,
              strokeWidth: 1.55,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: filled && enabled
                    ? context.onPrimaryColor
                    : context.primaryColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
