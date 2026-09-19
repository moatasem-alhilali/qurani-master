import 'dart:async';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_ui_kit.dart';
import 'package:quran_app/l10n/l10n.dart';

/// جدولة واحدة في القائمة.
///
/// كانت بطاقة بحدّ وظلّ وستّ شارات داخلها، فصارت القائمة صفًّا من الصناديق
/// المتشابهة. هنا كل جدولة صفّ نحيل على الأرضية يفصله خطّ شعرة، ولا يرتفع
/// إلا صفّ واحد: الجدولة الأقرب موعدًا.
class SmartOutreachScheduleItemCard extends StatelessWidget {
  const SmartOutreachScheduleItemCard({
    required this.bundle,
    required this.onTap,
    required this.onStart,
    required this.onDelete,
    required this.onToggle,
    this.isNext = false,
    this.isLast = false,
    this.countdownLabel,
    super.key,
  });

  final SmartOutreachScheduleBundle bundle;
  final VoidCallback onTap;
  final VoidCallback onStart;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  /// الجدولة الأقرب موعدًا — هي وحدها التي يحقّ لها الارتفاع.
  final bool isNext;
  final bool isLast;

  /// «بعد ٣ ساعات» — يظهر مع الصفّ المرتفع فقط.
  final String? countdownLabel;

  @override
  Widget build(BuildContext context) {
    final schedule = bundle.schedule;
    final l10n = context.l10n;
    final timeLabel = TimeOfDay(
      hour: schedule.hour,
      minute: schedule.minute,
    ).format(context);

    final daysLabel = schedule.isDaily
        ? l10n.outreachEveryDay
        : schedule.scheduleDays.isEmpty
            ? l10n.outreachNoDays
            : schedule.scheduleDays
                .map((day) => outreachWeekdayLabel(l10n, day))
                .join(l10n.outreachListSeparator);

    final meta = <String>[
      daysLabel,
      l10n.outreachContactsCount(bundle.contacts.length),
      l10n.outreachMetaRing(schedule.ringTimeout),
      l10n.outreachMetaAfterAnswer(schedule.hangupDelay),
      l10n.outreachMetaBetween(schedule.delayBetweenCalls),
    ].join(' · ');

    final body = _ScheduleBody(
      title: schedule.title,
      timeLabel: timeLabel,
      meta: meta,
      enabled: schedule.isEnabled,
      raised: isNext,
      isLast: isLast,
      countdownLabel: countdownLabel,
      onStart: onStart,
      onEdit: onTap,
      onDelete: () {
        unawaited(HapticFeedback.mediumImpact());
        onDelete();
      },
      onToggle: (value) {
        unawaited(HapticFeedback.selectionClick());
        onToggle(value);
      },
    );

    if (!isNext) {
      return InkWell(onTap: onTap, child: body);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: body,
    );
  }
}

/// جسم الجدولة: نحيل على الأرضية، أو مرتفع حين تكون هي الأقرب.
class _ScheduleBody extends StatelessWidget {
  const _ScheduleBody({
    required this.title,
    required this.timeLabel,
    required this.meta,
    required this.enabled,
    required this.raised,
    required this.isLast,
    required this.countdownLabel,
    required this.onStart,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  final String title;
  final String timeLabel;
  final String meta;
  final bool enabled;
  final bool raised;
  final bool isLast;
  final String? countdownLabel;
  final VoidCallback onStart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final countdown = countdownLabel?.trim() ?? '';

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutreachIconChip(
          icon: enabled ? AppIcons.phone : AppIcons.power,
          muted: !enabled,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        // الوزن نفسه يقول الحالة: النشط ثقيل والمتوقّف خفيف
                        // باهت، فلا يعتمد التمييز على اللون وحده.
                        color: enabled
                            ? skin.ink
                            : skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: raised ? 14.sp : 12.5.sp,
                        fontWeight: enabled
                            ? (raised ? FontWeight.w800 : FontWeight.w700)
                            : FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (raised) ...[
                    SizedBox(width: 7.w),
                    OutreachPill(label: context.l10n.outreachNearest),
                  ],
                  SizedBox(width: 7.w),
                  OutreachValue(text: timeLabel, emphasised: raised),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutreachStatusBadge(active: enabled),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      countdown.isEmpty ? meta : '$countdown · $meta',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  OutreachTextAction(
                    label: context.l10n.outreachStartNow,
                    icon: AppIcons.play,
                    onTap: onStart,
                  ),
                  SizedBox(width: 12.w),
                  OutreachTextAction(
                    label: context.l10n.commonEdit,
                    icon: AppIcons.edit,
                    onTap: onEdit,
                  ),
                  const Spacer(),
                  OutreachTextAction(
                    label: context.l10n.commonDelete,
                    icon: AppIcons.delete,
                    danger: true,
                    onTap: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 6.w),
        Transform.scale(
          scale: 0.72,
          child: AdaptiveSwitch(
            value: enabled,
            activeColor: AppColors.gold,
            onChanged: onToggle,
          ),
        ),
      ],
    );

    if (!raised) {
      return Container(
        padding: EdgeInsets.fromLTRB(16.w, 9.h, 16.w, 9.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: content,
      );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 8.h),
      padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 9.h),
      decoration: BoxDecoration(
        color: skin.raised,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: skin.raisedBorder, width: 1.2),
        boxShadow: skin.raisedShadow,
      ),
      child: content,
    );
  }
}
