import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/l10n/l10n.dart';

/// ملخّص المواعيد: ثلاثة أرقام في صفّ واحد، بلا بطاقة ولا تدرّج لوني.
class SchedulesSummaryWidget extends StatelessWidget {
  const SchedulesSummaryWidget({
    required this.totalCount,
    required this.enabledCount,
    required this.disabledCount,
    super.key,
  });

  final int totalCount;
  final int enabledCount;
  final int disabledCount;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: skin.hairline)),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            _Stat(
              label: context.l10n.notifScheduleStatTotal,
              value: totalCount,
            ),
            _Divider(color: skin.hairline),
            _Stat(
              label: context.l10n.notifScheduleStatEnabled,
              value: enabledCount,
            ),
            _Divider(color: skin.hairline),
            _Stat(
              label: context.l10n.notifScheduleStatStopped,
              value: disabledCount,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: skin.accent,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
              height: 1.1,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 22.h, color: color);
  }
}
