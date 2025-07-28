import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_extension.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/quran_plan/data/model/plan_progress_analysis_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/current_session_widget.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/session_widget.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/smart_analysis_plan_widget.dart';

class QuranPlanSessionScreen extends StatelessWidget {
  const QuranPlanSessionScreen({
    required this.planId,
    this.title,
    super.key,
  });
  final int planId;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranPlanBloc>()
        ..add(LoadSessionsEvent(planId))
        ..add(LoadNextSessionEvent(planId)),
      child: BlocBuilder<QuranPlanBloc, QuranPlanState>(
        builder: (context, state) {
          return AppScaffoldWidget(
            titleWidget: Text(
              title ?? state.selectedPlan?.title ?? '',
              style: context.titleMedium,
            ),
            onRefresh: () async {
              context.read<QuranPlanBloc>().add(LoadSessionsEvent(planId));
            },
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: BlocConsumer<QuranPlanBloc, QuranPlanState>(
                listenWhen: (prev, curr) =>
                    prev.analysis?.stagnationDays.length !=
                    curr.analysis?.stagnationDays.length,
                listener: (context, state) {
                  final analysis = state.analysis;
                  if (analysis != null && analysis.stagnationDays.length >= 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'انتبه: لديك عدة أيام ركود! حاول الانتظام أكثر أو أكمل اليوم نصف جلسة!',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final progress = state.selectedPlan?.progress ?? 0;
                  final progressPercent = (progress * 100).toStringAsFixed(0);
                  final analysis = state.analysis;

                  return Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardWidget(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        // color: Colors.blue[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'التقدم الكلي',
                                style: context.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                                backgroundColor: Colors.grey[300],
                              ),
                              const SizedBox(height: 4),
                              Text('$progressPercent% من الخطة'),
                            ],
                          ),
                        ),
                      ),
                      state.nextSessionState.when<QuranPlanSession>(
                        onSuccess: () => state.nextSession != null
                            ? CurrentSessionWidget(
                                plan: state.selectedPlan!,
                                session: state.nextSession!,
                              )
                            : const SizedBox.shrink(),
                        context: context,
                        onLoading: ShimmerWidget(
                          child: CurrentSessionWidget(
                            plan: QuranPlan(
                              title: 'title',
                              startJuz: 1,
                              endJuz: 1,
                              totalDays: 1,
                              sessionsCount: 1,
                              versesPerSession: 1,
                              ownerId: '1',
                              createdAt: DateTime.now(),
                            ),
                            session: QuranPlanSession(
                              planId: planId,
                              sessionNumber: 1,
                              fromSurahId: 1,
                              fromAyahNumber: 1,
                              toSurahId: 1,
                              toAyahNumber: 1,
                            ),
                          ),
                        ),
                      ),
                      state.requestState.when<QuranPlanSession>(
                        onSuccess: () => SmartAnalysisPlanWidget(
                          analysis: analysis!,
                        ),
                        onLoading: ShimmerWidget(
                          child: SmartAnalysisPlanWidget(
                            analysis: PlanProgressAnalysis(
                              averageSessionIntervalDays: 55,
                              sessionsPerWeekday: {
                                1: 1,
                                2: 2,
                                3: 3,
                                4: 4,
                                5: 5,
                                6: 6,
                                7: 7,
                              },
                              activityDay: 'test',
                              lazyDay: 'test',
                              predictionMessage: 'test',
                              completionProbability: 0.5,
                              stagnationDays: [DateTime.now()],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'جلسات الخطة:',
                        style: context.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      state.requestState.when<QuranPlanSession>(
                        onSuccess: () => ListView.builder(
                          itemCount: state.sessions.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final session = state.sessions[index];
                            return SessionWidget(
                              plan: state.selectedPlan!,
                              session: session,
                            );
                          },
                        ),
                        list: state.sessions,
                        onLoading: ShimmerWidget(
                          child: ListView.builder(
                            itemCount: state.sessions.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final session = state.sessions[index];
                              return SessionWidget(
                                plan: state.selectedPlan!,
                                session: session,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
