import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_call_logs_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_ui_kit.dart';

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
    final skin = AppSkin.of(context);

    return AppScaffoldWidget(
      title: 'بدء المكالمات',
      showLargeHeader: false,
      initialOffset: null,
      body: OutreachGround(
        children: <Widget>[
          _ExecutionStatus(
            starting: _starting,
            failed: _failed,
            message: _message ?? '',
          ),
          if (_failed)
            OutreachPrimaryButton(
              label: 'إعادة المحاولة',
              icon: AppIcons.refresh,
              onTap: _start,
            ),
          SizedBox(height: 10.h),
          skin.divider(),
          OutreachRow(
            title: 'سجل المكالمات',
            icon: AppIcons.clock,
            subtitle: 'راجع من ردّ ومن لم يردّ بعد انتهاء القائمة',
            showChevron: !_starting,
            dimmed: _starting,
            isLast: true,
            onTap: _starting
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
          SizedBox(height: 28.h),
        ],
      ),
    );
  }
}

/// حالة التشغيل — العنصر الوحيد المرتفع في الشاشة.
class _ExecutionStatus extends StatelessWidget {
  const _ExecutionStatus({
    required this.starting,
    required this.failed,
    required this.message,
  });

  final bool starting;
  final bool failed;
  final String message;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final tone = failed ? AppColors.error : skin.accent;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 2.h),
      padding: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 11.h),
      decoration: BoxDecoration(
        color: skin.raised,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: skin.raisedBorder, width: 1.2),
        boxShadow: skin.raisedShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: starting
                ? SizedBox.square(
                    dimension: 15.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: tone,
                    ),
                  )
                : AppIcon(
                    failed ? AppIcons.warning : AppIcons.phone,
                    color: tone,
                    size: 16.sp,
                  ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  starting ? 'جارِ تجهيز المكالمات...' : message,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  starting
                      ? 'لا تغلق الصفحة حتى تبدأ العملية.'
                      : 'يمكنك إغلاق الصفحة الآن ومراجعة النتيجة من السجل.',
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
        ],
      ),
    );
  }
}
