import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/animated_snackbar_widget.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/normal_app_scaffold_widget.dart';
import 'package:quran_app/features/quran_plan/data/model/plan_progress_analysis_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_library/quran.dart';

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
    if (!_isBottom) return;
    _scaffoldKey.currentContext
        ?.read<QuranPlanBloc>()
        .add(LoadMoreSessionsEvent(widget.planId));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll * 0.9;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranPlanBloc>()
        ..add(LoadSessionsEvent(widget.planId))
        ..add(LoadNextSessionEvent(widget.planId)),
      child: BlocBuilder<QuranPlanBloc, QuranPlanState>(
        builder: (context, state) {
          final title = widget.title ?? state.selectedPlan?.title ?? '';

          return NormalAppScaffoldWidget(
            key: _scaffoldKey,
            scrollController: _scrollController,
            titleWidget: Text(title, style: context.titleMedium),
            onRefresh: () async {
              context
                  .read<QuranPlanBloc>()
                  .add(LoadSessionsEvent(widget.planId, refresh: true));
              context
                  .read<QuranPlanBloc>()
                  .add(LoadNextSessionEvent(widget.planId));
            },
            body: BlocConsumer<QuranPlanBloc, QuranPlanState>(
              listenWhen: (previous, current) =>
                  previous.analysis?.stagnationDays.length !=
                  current.analysis?.stagnationDays.length,
              listener: _listenForStagnation,
              builder: (context, state) {
                if (state.requestState == RequestState.loading &&
                    state.selectedPlan == null) {
                  return _PlanSessionLoading(planId: widget.planId);
                }

                final plan = state.selectedPlan;
                if (plan == null) {
                  return const _EmptyPlanState();
                }

                final progress = plan.progress.clamp(0, 1).toDouble();
                final completed =
                    state.sessions.where((session) => session.completed).length;

                return Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FocusSessionCard(
                        plan: plan,
                        session: state.nextSession,
                        progress: progress,
                        onOpenSession: (session) =>
                            _openSession(context, session),
                        onCompleteSession: (session) =>
                            _confirmCompleteSession(context, plan, session),
                      ),
                      SizedBox(height: 12.h),
                      _PlanPulseStrip(
                        plan: plan,
                        completedSessions: completed,
                        loadedSessions: state.sessions.length,
                        analysis: state.analysis,
                      ),
                      if (state.analysis != null) ...[
                        SizedBox(height: 12.h),
                        _QuietAnalysisCard(analysis: state.analysis!),
                      ],
                      SizedBox(height: 16.h),
                      const _SectionHeader(
                        title: 'مسار الختمة',
                        subtitle: 'جلسات مختصرة، افتح أي جلسة للانتقال لموضعها',
                      ),
                      SizedBox(height: 10.h),
                      if (state.sessions.isEmpty)
                        const _EmptySessionsCard()
                      else
                        _SessionsPath(
                          plan: plan,
                          sessions: state.sessions,
                          onOpenSession: (session) =>
                              _openSession(context, session),
                        ),
                      if (state.isLoadingMore)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                          child: Center(
                            child: SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                color: context.primaryColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _listenForStagnation(BuildContext context, QuranPlanState state) {
    final analysis = state.analysis;
    if (analysis == null || analysis.stagnationDays.length < 3) return;
    context.showCustomSnackbar(
      'انتبه: لديك عدة أيام ركود. جلسة قصيرة اليوم تكفي لإعادة الإيقاع.',
      style: SnackBarType.warning,
    );
  }

  void _openSession(BuildContext context, QuranPlanSession session) {
    final quranCtrl = QuranCtrl.instance;
    final uqIndex = quranCtrl.resolveAyahUq(
      surahNumber: session.fromSurahId,
      ayahNumber: session.fromAyahNumber,
    );
    final ayah = quranCtrl.getAyahByUq(uqIndex);

    var targetPage = 1;
    if (ayah.ayahUQNumber != 0) {
      targetPage = ayah.page;
      quranCtrl
        ..jumpToPage(targetPage - 1)
        ..toggleAyahSelection(ayah.ayahUQNumber);
    } else {
      final surah = _findSurah(session.fromSurahId);
      if (surah != null && surah.ayahs.isNotEmpty) {
        targetPage = surah.ayahs.first.page;
        quranCtrl.jumpToPage(targetPage - 1);
      }
    }

    context.push(ReadQuranScreen(page: targetPage - 1));
  }

  void _confirmCompleteSession(
    BuildContext context,
    QuranPlan plan,
    QuranPlanSession session,
  ) {
    if (session.id == null || plan.id == null) return;
    context.showCustomSnackbar(
      'تأكيد إنهاء جلسة اليوم؟',
      style: SnackBarType.warning,
      actionLabel: 'تأكيد',
      duration: const Duration(seconds: 3),
      paddingBottom: 100,
      onAction: () {
        context
            .read<QuranPlanBloc>()
            .add(CompleteSessionEvent(session.id!, plan.id!));
      },
    );
  }
}

class _FocusSessionCard extends StatelessWidget {
  const _FocusSessionCard({
    required this.plan,
    required this.session,
    required this.progress,
    required this.onOpenSession,
    required this.onCompleteSession,
  });

  final QuranPlan plan;
  final QuranPlanSession? session;
  final double progress;
  final ValueChanged<QuranPlanSession> onOpenSession;
  final ValueChanged<QuranPlanSession> onCompleteSession;

  @override
  Widget build(BuildContext context) {
    final currentSession = session;
    final percent = (progress * 100).round();

    return _SoftPanel(
      padding: EdgeInsets.fromLTRB(16.w, 15.h, 16.w, 16.h),
      child: Stack(
        children: [
          PositionedDirectional(
            top: -44.h,
            end: -30.w,
            child: _SoftOrb(size: 118.w),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _ProgressRing(progress: progress, label: '$percent%'),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'جلسة اليوم',
                          style: TextStyle(
                            color: context.primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          currentSession == null
                              ? 'أتممت هذه الخطة'
                              : 'الجلسة ${currentSession.sessionNumber}',
                          style: TextStyle(
                            color: context.onSurfaceColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          currentSession == null
                              ? 'لا توجد جلسة قادمة حالياً'
                              : _sessionRangeText(currentSession),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: context.onSurfaceVariant
                                .withValues(alpha: 0.82),
                            fontSize: 11.5.sp,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(99.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5.h,
                  backgroundColor:
                      context.outlineVariant.withValues(alpha: 0.18),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(context.primaryColor),
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: currentSession == null
                          ? null
                          : () => onOpenSession(currentSession),
                      icon: const AppIcon(AppIcons.bookOpen, size: 16),
                      label: const Text('ابدأ القراءة'),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton.filledTonal(
                    tooltip: 'إنهاء الجلسة',
                    onPressed:
                        currentSession == null || currentSession.completed
                            ? null
                            : () => onCompleteSession(currentSession),
                    icon: const AppIcon(AppIcons.check, size: 17),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanPulseStrip extends StatelessWidget {
  const _PlanPulseStrip({
    required this.plan,
    required this.completedSessions,
    required this.loadedSessions,
    required this.analysis,
  });

  final QuranPlan plan;
  final int completedSessions;
  final int loadedSessions;
  final PlanProgressAnalysis? analysis;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            icon: AppIcons.check,
            label: 'المنجز',
            value: '$completedSessions/${plan.sessionsCount}',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _MetricTile(
            icon: AppIcons.calendar,
            label: 'مدة الخطة',
            value: '${plan.totalDays} يوم',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _MetricTile(
            icon: AppIcons.layers,
            label: 'المحمّل',
            value: '$loadedSessions جلسة',
          ),
        ),
      ],
    );
  }
}

class _QuietAnalysisCard extends StatelessWidget {
  const _QuietAnalysisCard({required this.analysis});

  final PlanProgressAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final finishDate = analysis.expectedFinishDate;
    final finishText = finishDate == null
        ? 'غير محدد'
        : DateFormat('yyyy/MM/dd').format(finishDate);

    return _SoftPanel(
      padding: EdgeInsets.all(13.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SmallIconBox(icon: AppIcons.clock, size: 15.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'إيقاع الخطة',
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _TinyPill(label: finishText),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            analysis.predictionMessage,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.onSurfaceVariant.withValues(alpha: 0.76),
              fontSize: 11.sp,
              height: 1.35,
            ),
          ),
          SizedBox(height: 11.h),
          Row(
            children: [
              Expanded(
                child: _InlineFact(
                  title: 'أنشط يوم',
                  value: analysis.activityDay,
                ),
              ),
              Expanded(
                child: _InlineFact(
                  title: 'الأهدأ',
                  value: analysis.lazyDay,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionsPath extends StatelessWidget {
  const _SessionsPath({
    required this.plan,
    required this.sessions,
    required this.onOpenSession,
  });

  final QuranPlan plan;
  final List<QuranPlanSession> sessions;
  final ValueChanged<QuranPlanSession> onOpenSession;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(sessions.length, (index) {
        final session = sessions[index];
        return _SessionPathTile(
          session: session,
          isFirst: index == 0,
          isLast: index == sessions.length - 1,
          onTap: () => onOpenSession(session),
        );
      }),
    );
  }
}

class _SessionPathTile extends StatelessWidget {
  const _SessionPathTile({
    required this.session,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  final QuranPlanSession session;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDone = session.completed;
    final accent = isDone ? context.primaryColor : context.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34.w,
          child: Column(
            children: [
              if (!isFirst) _PathLine(active: isDone),
              Container(
                width: 26.w,
                height: 26.w,
                decoration: BoxDecoration(
                  color: isDone
                      ? context.primaryColor.withValues(alpha: 0.14)
                      : context.surfaceColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone
                        ? context.primaryColor
                        : context.outline.withValues(alpha: 0.56),
                  ),
                ),
                child: Center(
                  child: isDone
                      ? AppIcon(
                          AppIcons.checkSmall,
                          color: context.primaryColor,
                          size: 13.sp,
                        )
                      : Text(
                          '${session.sessionNumber}',
                          style: TextStyle(
                            color: accent,
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
              if (!isLast) _PathLine(active: isDone),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(15.r),
              child: Ink(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: isDone
                        ? context.primaryColor.withValues(alpha: 0.22)
                        : context.outline.withValues(alpha: 0.38),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'جلسة ${session.sessionNumber}',
                            style: TextStyle(
                              color: isDone
                                  ? context.primaryColor
                                  : context.onSurfaceColor,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _sessionRangeText(session),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: context.onSurfaceVariant
                                  .withValues(alpha: 0.76),
                              fontSize: 10.5.sp,
                            ),
                          ),
                          if (session.completedAt != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              DateFormat('yyyy/MM/dd - HH:mm')
                                  .format(session.completedAt!),
                              style: TextStyle(
                                color: context.onSurfaceVariant
                                    .withValues(alpha: 0.54),
                                fontSize: 9.5.sp,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AppIcon(
                      AppIcons.chevronLeft,
                      color: context.onSurfaceVariant.withValues(alpha: 0.42),
                      size: 14.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final HugeIconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
      child: Column(
        children: [
          AppIcon(
            icon,
            color: context.primaryColor,
            size: 15.sp,
            strokeWidth: 1.55,
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.onSurfaceVariant.withValues(alpha: 0.72),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.progress,
    required this.label,
  });

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68.w,
      height: 68.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6.w,
              backgroundColor: context.outlineVariant.withValues(alpha: 0.16),
              color: context.primaryColor,
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: context.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftPanel extends StatelessWidget {
  const _SoftPanel({
    required this.child,
    required this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: context.outline.withValues(alpha: 0.54),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.045),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _SmallIconBox extends StatelessWidget {
  const _SmallIconBox({
    required this.icon,
    required this.size,
  });

  final HugeIconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: AppIcon(
        icon,
        color: context.primaryColor,
        size: size,
        strokeWidth: 1.55,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SmallIconBox(icon: AppIcons.traveler, size: 14.sp),
        SizedBox(width: 9.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  color: context.onSurfaceVariant.withValues(alpha: 0.68),
                  fontSize: 10.5.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InlineFact extends StatelessWidget {
  const _InlineFact({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: context.onSurfaceVariant.withValues(alpha: 0.62),
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: context.onSurfaceColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: context.primaryColor,
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PathLine extends StatelessWidget {
  const _PathLine({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.4.w,
      height: 18.h,
      color: active
          ? context.primaryColor.withValues(alpha: 0.42)
          : context.outlineVariant.withValues(alpha: 0.36),
    );
  }
}

class _SoftOrb extends StatelessWidget {
  const _SoftOrb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.primaryColor.withValues(alpha: 0.04),
      ),
    );
  }
}

class _PlanSessionLoading extends StatelessWidget {
  const _PlanSessionLoading({required this.planId});

  final int planId;

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeletonizerWidget(
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 28.h),
        child: Column(
          children: [
            _FocusSessionCard(
              plan: QuranPlan(
                title: 'خطة الختمة',
                startJuz: 1,
                endJuz: 30,
                totalDays: 30,
                sessionsCount: 30,
                versesPerSession: 20,
                ownerId: '0',
                createdAt: DateTime.now(),
              ),
              session: QuranPlanSession(
                planId: planId,
                sessionNumber: 1,
                fromSurahId: 1,
                fromAyahNumber: 1,
                toSurahId: 1,
                toAyahNumber: 7,
              ),
              progress: 0.36,
              onOpenSession: (_) {},
              onCompleteSession: (_) {},
            ),
            SizedBox(height: 12.h),
            _PlanPulseStrip(
              plan: QuranPlan(
                title: 'خطة الختمة',
                startJuz: 1,
                endJuz: 30,
                totalDays: 30,
                sessionsCount: 30,
                versesPerSession: 20,
                ownerId: '0',
                createdAt: DateTime.now(),
              ),
              completedSessions: 7,
              loadedSessions: 20,
              analysis: null,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPlanState extends StatelessWidget {
  const _EmptyPlanState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(18.w),
      child: _SoftPanel(
        padding: EdgeInsets.all(18.w),
        child: Text(
          'تعذر تحميل هذه الخطة حالياً.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.onSurfaceVariant,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _EmptySessionsCard extends StatelessWidget {
  const _EmptySessionsCard();

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.all(16.w),
      child: Text(
        'لا توجد جلسات ظاهرة بعد.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: context.onSurfaceVariant,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _sessionRangeText(QuranPlanSession session) {
  final fromSurah = _findSurah(session.fromSurahId);
  final toSurah = _findSurah(session.toSurahId);

  final fromName = fromSurah?.arabicName ?? 'سورة ${session.fromSurahId}';
  final toName = toSurah?.arabicName ?? 'سورة ${session.toSurahId}';
  return '$fromName ${session.fromAyahNumber} - '
      '$toName ${session.toAyahNumber}';
}

SurahModel? _findSurah(int surahId) {
  for (final surah in QuranCtrl.instance.surahs) {
    if (surah.surahNumber == surahId) return surah;
  }
  return null;
}
