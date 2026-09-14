import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';

/// نظرة عامة على الذكر: صفوف نحيلة تفصلها خطوط شعرة، بلا بطاقات.
class AnalyticsOverviewTab extends StatelessWidget {
  const AnalyticsOverviewTab({
    required this.state,
    super.key,
  });

  final SabihState state;

  int _totalOf(Map<int, int>? counts) {
    if (counts == null) return 0;
    return counts.values.fold<int>(0, (sum, value) => sum + value);
  }

  int _countOf(Map<int, int>? counts, int? mostUsedId) {
    if (counts == null || mostUsedId == null) return 0;
    return counts[mostUsedId] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final periods = <_PeriodRow>[
      _PeriodRow(
        label: 'اليوم',
        subih: state.mostUsedTodaySubih,
        count: _countOf(state.todayCounts, state.todayMostUsed),
        total: _totalOf(state.todayCounts),
      ),
      _PeriodRow(
        label: 'هذا الأسبوع',
        subih: state.mostUsedWeekSubih,
        count: _countOf(state.weekCounts, state.weekMostUsed),
        total: _totalOf(state.weekCounts),
      ),
      _PeriodRow(
        label: 'هذا الشهر',
        subih: state.mostUsedMonthSubih,
        count: _countOf(state.monthCounts, state.monthMostUsed),
        total: _totalOf(state.monthCounts),
      ),
      _PeriodRow(
        label: 'كل الوقت',
        subih: state.mostUsedAllTimeSubih,
        count: _countOf(state.allTimeCounts, state.allTimeMostUsed),
        total: _totalOf(state.allTimeCounts),
      ),
    ];

    return ListView(
      padding: EdgeInsets.only(bottom: 24.h),
      children: [
        const HomeSectionHeader(title: 'الأذكار الأكثر استخدامًا'),
        for (var i = 0; i < periods.length; i++) ...[
          _MostUsedTile(row: periods[i]),
          if (i != periods.length - 1) skin.divider(),
        ],
        skin.divider(),
        const HomeSectionHeader(title: 'إجمالي عدد الأذكار'),
        for (var i = 0; i < periods.length; i++) ...[
          _TotalTile(label: periods[i].label, total: periods[i].total),
          if (i != periods.length - 1) skin.divider(),
        ],
      ],
    );
  }
}

class _PeriodRow {
  const _PeriodRow({
    required this.label,
    required this.subih,
    required this.count,
    required this.total,
  });

  final String label;
  final SubihModel? subih;
  final int count;
  final int total;
}

class _MostUsedTile extends StatelessWidget {
  const _MostUsedTile({required this.row});

  final _PeriodRow row;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final subih = row.subih;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 62.w,
            child: Text(
              row.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: subih == null
                ? Text(
                    'لا توجد بيانات بعد',
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.6),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        subih.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      if (subih.content.trim().isNotEmpty)
                        Text(
                          subih.content,
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
          if (subih != null) ...[
            SizedBox(width: 8.w),
            Text(
              '${row.count}',
              style: TextStyle(
                color: skin.accent,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({required this.label, required this.total});

  final String label;
  final int total;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
          Text(
            '$total',
            style: TextStyle(
              color: skin.accent,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
