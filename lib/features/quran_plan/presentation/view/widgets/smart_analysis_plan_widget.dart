import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/features/quran_plan/data/model/plan_progress_analysis_model.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/plan_progress_line.dart';
import 'package:quran_app/l10n/l10n.dart';

/// تحليل الخطة: أرقام قليلة في صفوف نحيلة، لا بطاقة زرقاء بتدرّج.
class SmartAnalysisPlanWidget extends StatelessWidget {
  const SmartAnalysisPlanWidget({required this.analysis, super.key});

  final PlanProgressAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final l10n = context.l10n;
    final formatter = DateFormat('yyyy/MM/dd', context.localeCode);
    final finishDate = analysis.expectedFinishDate;
    final probability =
        (analysis.completionProbability.clamp(0.0, 1.0) * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StatRow(
          label: l10n.quranPlanExpectedFinish,
          value: finishDate != null ? formatter.format(finishDate) : '—',
        ),
        _StatRow(
          label: l10n.quranPlanAverageInterval,
          value: l10n.quranPlanAverageIntervalValue(
            analysis.averageSessionIntervalDays.toStringAsFixed(1),
          ),
        ),
        _StatRow(
          label: l10n.quranPlanMostActiveDay,
          value: analysis.activityDay,
        ),
        _StatRow(
          label: l10n.quranPlanLeastActiveDay,
          value: analysis.lazyDay,
        ),
        _StatRow(
          label: l10n.quranPlanCompletionProbability,
          value: l10n.quranPlanPercentValue(probability),
          isLast: true,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
          child: PlanProgressLine(value: analysis.completionProbability),
        ),
        if (analysis.predictionMessage.trim().isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: Text(
              analysis.predictionMessage,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.88),
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
          ),
        if (analysis.stagnationDays.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 7.h),
            child: Row(
              children: [
                Text(
                  l10n.quranPlanStagnationDays,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.8),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Divider(height: 1, thickness: 1, color: skin.hairline),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: analysis.stagnationDays
                  .map(
                    (day) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: skin.iconChip,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        formatter.format(day),
                        style: TextStyle(
                          color: skin.accent,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}

/// صفّ إحصاء: عنوانه على اليمين وقيمته على اليسار، تفصلهما مسافة لا بطاقة.
class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 9.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            value,
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
