import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/analytics_period_selector.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/dhikr_stats_card.dart';

class AnalyticsDetailedTab extends StatelessWidget {
  const AnalyticsDetailedTab({
    super.key,
    required this.state,
  });

  final SabihState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                // Custom period selection handled separately
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
