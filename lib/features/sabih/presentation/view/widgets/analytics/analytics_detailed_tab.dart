import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/analytics_period_selector.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/dhikr_stats_card.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/sabih_state_views.dart';
import 'package:quran_app/l10n/l10n.dart';

class AnalyticsDetailedTab extends StatelessWidget {
  const AnalyticsDetailedTab({
    required this.state,
    super.key,
  });

  final SabihState state;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnalyticsPeriodSelector(
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
                // اختيار مدّة مخصصة يُعالَج على حدة.
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
        skin.divider(),
        Expanded(
          child: state.subihList.isEmpty
              ? SabihNotice(message: context.l10n.sabihNoCustomDhikr)
              : ListView.separated(
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: state.subihList.length,
                  separatorBuilder: (_, __) => skin.divider(),
                  itemBuilder: (context, index) {
                    final subih = state.subihList[index];
                    return DhikrStatsCard(
                      subih: subih,
                      count: state.getCountForSubih(subih.id ?? -1),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
