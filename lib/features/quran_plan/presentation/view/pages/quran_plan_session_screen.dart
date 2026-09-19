import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/animated_snackbar_widget.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/normal_app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/current_session_widget.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/plan_progress_line.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/session_widget.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/smart_analysis_plan_widget.dart';
import 'package:quran_app/l10n/l10n.dart';

/// شاشة خطة واحدة: ملخّصها، جلسة اليوم، إيقاعها، ثم مسار جلساتها.
///
/// كانت الشاشة أربع بطاقات فوق بعضها (حلقة تقدّم، ثلاثة مربّعات أرقام، بطاقة
/// تحليل، ثم خطّ زمني ببطاقة لكل جلسة). صارت أقسامًا على أرضية واحدة تفصلها
/// شعرة، والارتفاع محجوز لجلسة اليوم وحدها.
class QuranPlanSessionScreen extends StatefulWidget {
  const QuranPlanSessionScreen({
    required this.planId,
    this.title,
    super.key,
  });

  final int planId;
  final String? title;

  @override
  State<QuranPlanSessionScreen> createState() => _QuranPlanSessionScreenState();
}

class _QuranPlanSessionScreenState extends State<QuranPlanSessionScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isBottom) {
      return;
    }
    _scaffoldKey.currentContext
        ?.read<QuranPlanBloc>()
        .add(LoadMoreSessionsEvent(widget.planId));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) {
      return false;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll * 0.9;
  }

  void _listenForStagnation(BuildContext context, QuranPlanState state) {
    final analysis = state.analysis;
    if (analysis == null || analysis.stagnationDays.length < 3) {
      return;
    }
    context.showCustomSnackbar(
      context.l10n.quranPlanStagnationWarning,
      style: SnackBarType.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (_) => sl<QuranPlanBloc>()
        ..add(LoadSessionsEvent(widget.planId))
        ..add(LoadNextSessionEvent(widget.planId)),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: BlocBuilder<QuranPlanBloc, QuranPlanState>(
          builder: (context, state) {
            final title = widget.title ?? state.selectedPlan?.title ?? '';

            return NormalAppScaffoldWidget(
              key: _scaffoldKey,
              scrollController: _scrollController,
              titleWidget: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onRefresh: () async {
                context
                    .read<QuranPlanBloc>()
                    .add(LoadSessionsEvent(widget.planId, refresh: true));
                context
                    .read<QuranPlanBloc>()
                    .add(LoadNextSessionEvent(widget.planId));
              },
              slivers: [
                SliverToBoxAdapter(
                  child: BlocConsumer<QuranPlanBloc, QuranPlanState>(
                    listenWhen: (previous, current) =>
                        previous.analysis?.stagnationDays.length !=
                        current.analysis?.stagnationDays.length,
                    listener: _listenForStagnation,
                    builder: (context, state) {
                      if (state.requestState == RequestState.loading &&
                          state.selectedPlan == null) {
                        return const _PlanSessionSkeleton();
                      }

                      final plan = state.selectedPlan;
                      if (plan == null) {
                        return _Note(
                          icon: AppIcons.warning,
                          text: context.l10n.quranPlanLoadFailed,
                        );
                      }

                      final completed = state.sessions
                          .where((session) => session.completed)
                          .length;
                      final nextSession = state.nextSession;
                      final analysis = state.analysis;

                      return ColoredBox(
                        color: skin.ground,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _PlanSummary(
                              plan: plan,
                              completedSessions: completed,
                              loadedSessions: state.sessions.length,
                            ),
                            skin.divider(),
                            HomeSectionHeader(
                              title: context.l10n.quranPlanTodaySession,
                            ),
                            if (nextSession == null)
                              _Note(
                                icon: AppIcons.check,
                                text: context.l10n.quranPlanAllSessionsDone,
                              )
                            else
                              CurrentSessionWidget(
                                plan: plan,
                                session: nextSession,
                              ),
                            if (analysis != null) ...[
                              skin.divider(),
                              HomeSectionHeader(
                                title: context.l10n.quranPlanRhythm,
                              ),
                              SmartAnalysisPlanWidget(analysis: analysis),
                            ],
                            skin.divider(),
                            HomeSectionHeader(
                              title: context.l10n.quranPlanPath,
                            ),
                            if (state.sessions.isEmpty)
                              _Note(
                                icon: AppIcons.list,
                                text: context.l10n.quranPlanNoSessions,
                              )
                            else
                              for (var i = 0; i < state.sessions.length; i++)
                                SessionWidget(
                                  plan: plan,
                                  session: state.sessions[i],
                                  isLast: i == state.sessions.length - 1,
                                ),
                            if (state.isLoadingMore)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: Center(
                                  child: SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: skin.accent,
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ملخّص الخطة: سطر واحد، خطّ تقدّم رفيع، ونسبة عربية.
class _PlanSummary extends StatelessWidget {
  const _PlanSummary({
    required this.plan,
    required this.completedSessions,
    required this.loadedSessions,
  });

  final QuranPlan plan;
  final int completedSessions;
  final int loadedSessions;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final total = plan.sessionsCount;
    final done = total == 0
        ? completedSessions
        : (plan.progress.clamp(0.0, 1.0) * total).round();

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: skin.iconChip,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: AppIcon(
                    AppIcons.quran,
                    color: skin.accent,
                    size: 15.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      plan.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      [
                        context.l10n
                            .quranPlanJuzRange(plan.startJuz, plan.endJuz),
                        context.l10n.quranPlanDaysCount(plan.totalDays),
                        context.l10n.quranPlanLoadedSessions(loadedSessions),
                      ].join(' · '),
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
              // «٣ من ٣٠» بالكلمات — الكسر ينقلب في الاتجاه العربي.
              Text(
                context.l10n.quranPlanProgress(done, total),
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          PlanProgressLine(value: plan.progress),
        ],
      ),
    );
  }
}

/// ملاحظة من سطر واحد: بديل البطاقات الفارغة.
class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final HugeIconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Row(
        children: [
          AppIcon(icon, color: skin.accent, size: 15.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// هيكل انتظار: الأقسام نفسها بخطوط باهتة.
class _PlanSessionSkeleton extends StatelessWidget {
  const _PlanSessionSkeleton();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return ColoredBox(
      color: skin.ground,
      child: Column(
        children: List.generate(
          6,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: index == 5
                ? null
                : BoxDecoration(
                    border: Border(bottom: BorderSide(color: skin.hairline)),
                  ),
            child: Row(
              children: [
                Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(
                    color: skin.hairline,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    height: 9.h,
                    decoration: BoxDecoration(
                      color: skin.hairline,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
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
