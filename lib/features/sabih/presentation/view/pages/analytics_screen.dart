import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/analytics/analytics_detailed_tab.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/analytics/analytics_overview_tab.dart';

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
    context.read<SabihBloc>().add(GetAnalyticsDataEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'الإحصائيات',
      onRefresh: () async {},
      body: SizedBox(
        height: context.fullHeight,
        child: BlocBuilder<SabihBloc, SabihState>(
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
                AnalyticsOverviewTab(state: state),
                AnalyticsDetailedTab(state: state),
              ],
            );
          },
        ),
      ),
    );
  }
}
