import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/analytics/analytics_detailed_tab.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/analytics/analytics_overview_tab.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/sabih_state_views.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) return;
        HapticFeedback.selectionClick();
        setState(() {});
      });
    context.read<SabihBloc>().add(GetAnalyticsDataEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        title: 'الإحصائيات',
        onRefresh: () async {
          context.read<SabihBloc>().add(GetAnalyticsDataEvent());
        },
        body: ColoredBox(
          color: skin.ground,
          child: SizedBox(
            height: context.fullHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TabSwitcher(
                  controller: _tabController,
                  labels: const ['نظرة عامة', 'تفصيل الأذكار'],
                ),
                Expanded(
                  child: BlocBuilder<SabihBloc, SabihState>(
                    buildWhen: (previous, current) =>
                        previous.analyticsLoadState !=
                            current.analyticsLoadState ||
                        previous.todayCounts != current.todayCounts ||
                        previous.weekCounts != current.weekCounts ||
                        previous.monthCounts != current.monthCounts ||
                        previous.allTimeCounts != current.allTimeCounts,
                    builder: (context, state) {
                      if (state.analyticsLoadState == RequestState.loading) {
                        return const SabihLoading();
                      }

                      if (state.analyticsLoadState == RequestState.error) {
                        return SabihNotice(
                          message: state.errorMessage ?? 'حدث خطأ',
                          actionLabel: 'إعادة المحاولة',
                          onAction: () {
                            context
                                .read<SabihBloc>()
                                .add(GetAnalyticsDataEvent());
                          },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// مبدّل تبويب نحيل: النشط يحمل خطًّا ذهبيًا تحته، لا بطاقة ولا حشو.
///
/// كان التبويب الثاني بلا مقبض يُرى، فلا يصله إلا من عرف أنّ الصفحة تُسحب.
class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({
    required this.controller,
    required this.labels,
  });

  final TabController controller;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => controller.animateTo(i),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    final selected = controller.index == i;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 7.h),
                          child: Text(
                            labels[i],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected
                                  ? skin.ink
                                  : skin.inkSoft.withValues(alpha: 0.6),
                              fontSize: 11.sp,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOutCubic,
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: selected ? AppColors.gold : skin.hairline,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
