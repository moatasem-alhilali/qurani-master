import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/session_navigation.dart';
import 'package:quran_app/l10n/l10n.dart';

/// صفّ جلسة في قائمة الخطة: نحيل، تفصله شعرة، بلا بطاقة ولا ظلّ.
class SessionWidget extends StatelessWidget {
  const SessionWidget({
    required this.plan,
    required this.session,
    this.isLast = false,
    super.key,
  });

  final QuranPlan plan;
  final QuranPlanSession session;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final isCompleted = session.completed;
    final completedAt = session.completedAt;
    final dateLabel = completedAt != null
        ? DateFormat('yyyy/MM/dd · HH:mm', context.localeCode)
            .format(completedAt)
        : null;

    return InkWell(
      onTap: () => openSessionInQuran(context, session),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: Row(
          children: [
            // رقم الجلسة يقوم مقام الأيقونة: أقصر وأصدق في الدلالة.
            SizedBox(
              width: 26.w,
              child: isCompleted
                  ? AppIcon(
                      AppIcons.checkSmall,
                      color: skin.accent,
                      size: 15.sp,
                    )
                  : Text(
                      '${session.sessionNumber}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.62),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sessionRangeLabel(context.l10n, session),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCompleted
                          ? skin.ink.withValues(alpha: 0.72)
                          : skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  if (dateLabel != null)
                    Text(
                      context.l10n.quranPlanCompletedAt(dateLabel),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            AppIcon(
              Directionality.of(context) == TextDirection.rtl
                  ? AppIcons.chevronLeft
                  : AppIcons.chevronRight,
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}
