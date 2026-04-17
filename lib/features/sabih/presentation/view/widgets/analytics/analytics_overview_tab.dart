import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';

class AnalyticsOverviewTab extends StatelessWidget {
  const AnalyticsOverviewTab({
    super.key,
    required this.state,
  });

  final SabihState state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMostUsedSection(context),
          const SizedBox(height: 24),
          _buildTotalCountsSection(context),
        ],
      ),
    );
  }

  Widget _buildMostUsedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأذكار الأكثر استخداماً',
          style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        const SizedBox(height: 16),

        _buildMostUsedCard(
          context: context,
          title: 'اليوم',
          subih: state.mostUsedTodaySubih,
          count: state.todayMostUsed != null && state.todayCounts != null
              ? state.todayCounts![state.todayMostUsed!] ?? 0
              : 0,
        ),
        _buildMostUsedCard(
          context: context,
          title: 'هذا الأسبوع',
          subih: state.mostUsedWeekSubih,
          count: state.weekMostUsed != null && state.weekCounts != null
              ? state.weekCounts![state.weekMostUsed!] ?? 0
              : 0,
        ),
        _buildMostUsedCard(
          context: context,
          title: 'هذا الشهر',
          subih: state.mostUsedMonthSubih,
          count: state.monthMostUsed != null && state.monthCounts != null
              ? state.monthCounts![state.monthMostUsed!] ?? 0
              : 0,
        ),
        _buildMostUsedCard(
          context: context,
          title: 'كل الوقت',
          subih: state.mostUsedAllTimeSubih,
          count: state.allTimeMostUsed != null && state.allTimeCounts != null
              ? state.allTimeCounts![state.allTimeMostUsed!] ?? 0
              : 0,
        ),
      ],
    );
  }

  Widget _buildMostUsedCard({
    required BuildContext context,
    required String title,
    required SubihModel? subih,
    required int count,
  }) {
    return CardWidget(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: context.primaryColor,
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 8),
            if (subih != null)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subih.title,
                          style: context.bodyMedium?.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: context.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subih.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.bodyMedium?.copyWith(
                            color: context.gray1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count.toString(),
                      style: context.bodyMedium?.copyWith(
                        color: context.secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              )
            else
              const Text('لا توجد بيانات متاحة'),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCountsSection(BuildContext context) {
    final todayTotal = _calculateTotalCount(state.todayCounts);
    final weekTotal = _calculateTotalCount(state.weekCounts);
    final monthTotal = _calculateTotalCount(state.monthCounts);
    final allTimeTotal = _calculateTotalCount(state.allTimeCounts);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إجمالي عدد الأذكار',
          style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildTotalCountCard(context, 'اليوم', todayTotal),
            _buildTotalCountCard(context, 'هذا الأسبوع', weekTotal),
          ],
        ),
        Row(
          children: [
            _buildTotalCountCard(context, 'هذا الشهر', monthTotal),
            _buildTotalCountCard(context, 'كل الوقت', allTimeTotal),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalCountCard(BuildContext context, String title, int count) {
    return Expanded(
      child: CardWidget(
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                title,
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.primaryColor,
                  fontSize: 16.sp,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count.toString(),
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.gray1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateTotalCount(Map<int, int>? counts) {
    if (counts == null) return 0;

    var total = 0;
    counts.forEach((_, count) {
      total += count;
    });

    return total;
  }
}
