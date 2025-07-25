import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/components/app_scaffold_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/quran_plan/data/model/plan_progress_analysis_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class QuranPlanSessionScreen extends StatelessWidget {
  const QuranPlanSessionScreen({
    required this.plan,
    super.key,
  });
  final QuranPlan plan;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<QuranPlanBloc>()..add(LoadSessionsEvent(plan.id!, plan)),
      child: BlocBuilder<QuranPlanBloc, QuranPlanState>(
        builder: (context, state) {
          return AppScaffoldWidget(
            title: plan.title,
            onRefresh: () async {
              context
                  .read<QuranPlanBloc>()
                  .add(LoadSessionsEvent(plan.id!, plan));
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
                  if (state.requestState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.requestState == RequestState.error) {
                    return Center(child: Text('Error: ${state.errorMessage}'));
                  }

                  final progress = plan.progress;
                  final progressPercent = (progress * 100).toStringAsFixed(0);
                  final analysis = state.analysis;

                  return Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==== شريط التقدم والنسبة ====
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
                                style: Theme.of(context).textTheme.titleMedium,
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
                      // ==== التحليل الذكي ====
                      if (analysis == null)
                        const Center(child: CircularProgressIndicator())
                      else
                        _buildSmartAnalysis(analysis, context),
                      const SizedBox(height: 20),
                      // ==== الجلسات ====
                      Text(
                        'جلسات الخطة:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...state.sessions.map(
                        (session) => _buildSessionCard(session, context),
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

  Widget _buildSessionCard(QuranPlanSession session, BuildContext context) {
    final isCompleted = session.completed;
    final dateStr = session.completedAt != null
        ? DateFormat('yyyy-MM-dd – kk:mm').format(session.completedAt!)
        : '—';

    return CardWidget(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      // color: isCompleted ? Colors.green[50] : Colors.grey[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted ? Colors.green : Colors.grey,
          child: Icon(
            isCompleted ? Icons.check : Icons.menu_book,
            color: Colors.white,
          ),
        ),
        title: Text(
          'جلسة ${session.sessionNumber}',
          style: context.bodyMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ReadQuranBloc, ReadQuranState>(
              builder: (context, stateQuran) {
                final fromAyah = stateQuran.surahs.firstWhere(
                  (surah) => surah.id == session.fromSurahId,
                );
                final toAyah = stateQuran.surahs.firstWhere(
                  (surah) => surah.id == session.toSurahId,
                );
                return Text(
                  'من ${fromAyah.nameAr} الاية ${session.fromAyahNumber} \n إلى ${toAyah.nameAr} الاية ${session.toAyahNumber}',
                  style: context.bodyMedium,
                );
              },
            ),
            if (isCompleted)
              Text(
                'تم الإنجاز: $dateStr',
                style: context.bodyMedium,
              ),
          ],
        ),
        trailing: isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : IconButton(
                icon: const Icon(Icons.done, color: Colors.blue),
                onPressed: () {
                  context
                      .read<QuranPlanBloc>()
                      .add(CompleteSessionEvent(session.id!));
                },
              ),
      ),
    );
  }

  Widget _buildSmartAnalysis(
    PlanProgressAnalysis analysis,
    BuildContext context,
  ) {
    final f = DateFormat('yyyy-MM-dd');
    return CardWidget(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      // color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تحليل متقدم للخطة',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'توقع يوم الختم:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        analysis.expectedFinishDate != null
                            ? f.format(analysis.expectedFinishDate!)
                            : '—',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'متوسط الفاصل بين الجلسات:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${analysis.averageSessionIntervalDays.toStringAsFixed(2)} يوم',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text('اليوم الأكثر نشاطًا: ${analysis.activityDay}'),
                ),
                Expanded(child: Text('الأقل نشاطًا: ${analysis.lazyDay}')),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'نص التوقع والتحفيز:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              analysis.predictionMessage,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: analysis.completionProbability,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            const Text(
              'أيام الركود:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: analysis.stagnationDays
                  .map(
                    (d) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Chip(label: Text(f.format(d))),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
