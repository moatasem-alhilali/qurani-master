import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/analytics_period_selector.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/dhikr_stats_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // تحميل بيانات التحليلات
    context.read<SabihBloc>().add(GetAnalyticsDataEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseHomeWidget(
      isScroll: false,
      title: 'الإحصائيات',
      body: BlocBuilder<SabihBloc, SabihState>(
        buildWhen: (previous, current) =>
            previous.analyticsLoadState != current.analyticsLoadState ||
            previous.todayCounts != current.todayCounts ||
            previous.weekCounts != current.weekCounts ||
            previous.monthCounts != current.monthCounts ||
            previous.allTimeCounts != current.allTimeCounts,
        builder: (context, state) {
          if (state.analyticsLoadState == LoadState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.analyticsLoadState == LoadState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'حدث خطأ'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SabihBloc>().add(GetAnalyticsDataEvent());
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(state),
              _buildDetailedStatsTab(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(SabihState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMostUsedSection(state),
          const SizedBox(height: 24),
          _buildTotalCountsSection(state),
        ],
      ),
    );
  }

  Widget _buildMostUsedSection(SabihState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الأذكار الأكثر استخداماً',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // الأكثر استخداماً اليوم
        _buildMostUsedCard(
          title: 'اليوم',
          subih: state.mostUsedTodaySubih,
          count: state.todayMostUsed != null && state.todayCounts != null
              ? state.todayCounts![state.todayMostUsed!] ?? 0
              : 0,
        ),

        // الأكثر استخداماً هذا الأسبوع
        _buildMostUsedCard(
          title: 'هذا الأسبوع',
          subih: state.mostUsedWeekSubih,
          count: state.weekMostUsed != null && state.weekCounts != null
              ? state.weekCounts![state.weekMostUsed!] ?? 0
              : 0,
        ),

        // الأكثر استخداماً هذا الشهر
        _buildMostUsedCard(
          title: 'هذا الشهر',
          subih: state.mostUsedMonthSubih,
          count: state.monthMostUsed != null && state.monthCounts != null
              ? state.monthCounts![state.monthMostUsed!] ?? 0
              : 0,
        ),

        // الأكثر استخداماً على الإطلاق
        _buildMostUsedCard(
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
    required String title,
    required SubihModel? subih,
    required int count,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subih.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.primaryScheme,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

  Widget _buildTotalCountsSection(SabihState state) {
    // حساب المجاميع لكل فترة
    final todayTotal = _calculateTotalCount(state.todayCounts);
    final weekTotal = _calculateTotalCount(state.weekCounts);
    final monthTotal = _calculateTotalCount(state.monthCounts);
    final allTimeTotal = _calculateTotalCount(state.allTimeCounts);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إجمالي عدد الأذكار',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildTotalCountCard('اليوم', todayTotal),
            _buildTotalCountCard('هذا الأسبوع', weekTotal),
          ],
        ),
        Row(
          children: [
            _buildTotalCountCard('هذا الشهر', monthTotal),
            _buildTotalCountCard('كل الوقت', allTimeTotal),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalCountCard(String title, int count) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.primaryScheme,
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

  Widget _buildDetailedStatsTab(SabihState state) {
    return Column(
      children: [
        // محدد الفترة
        AnalyticsPeriodSelector(
          // selectedPeriod: state.periodType,
          onPeriodChanged: (periodType) {
            final now = DateTime.now();
            DateTime from;

            switch (periodType) {
              case PeriodType.today:
                from = DateTime(now.year, now.month, now.day);
              case PeriodType.week:
                from = DateTime(now.year, now.month, now.day - now.weekday + 1);
              case PeriodType.month:
                from = DateTime(now.year, now.month);
              case PeriodType.year:
                from = DateTime(now.year);
              case PeriodType.allTime:
                from = DateTime(2000);
              case PeriodType.custom:
                // Custom period selection would be handled separately
                return;
            }

            context.read<SabihBloc>().add(
                  GetCountsForPeriodEvent(
                    from: from,
                    to: now,
                    periodType: periodType,
                  ),
                );
          },
        ),
        Divider(
          color: FxColors.gray1,
        ),

        // Dhikr stats list
        Expanded(
          child: state.subihList.isEmpty
              ? const Center(child: Text('لا يوجد ذكر مخصص'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.subihList.length,
                  itemBuilder: (context, index) {
                    final subih = state.subihList[index];
                    final count = state.getCountForSubih(subih.id ?? -1);

                    return DhikrStatsCard(
                      subih: subih,
                      count: count,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
