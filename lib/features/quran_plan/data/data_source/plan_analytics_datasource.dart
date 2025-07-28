import 'package:intl/intl.dart';
import 'package:quran_app/features/quran_plan/data/model/plan_progress_analysis_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';

class PlanAnalyticsService {
  /// يحلل خطة ختم معينة ويعيد إحصائيات وتوقعات متقدمة
  Future<PlanProgressAnalysis> analyzePlan(
    QuranPlan plan,
    List<QuranPlanSession> sessions,
  ) async {
    // 1. استخراج الجلسات المكتملة بترتيب التنفيذ
    final completed = sessions
        .where((s) => s.completed && s.completedAt != null)
        .toList()
      ..sort((a, b) => a.completedAt!.compareTo(b.completedAt!));
    if (completed.isEmpty) {
      // لم يبدأ الخطة
      return PlanProgressAnalysis(
        averageSessionIntervalDays: 0,
        sessionsPerWeekday: {},
        activityDay: '-',
        lazyDay: '-',
        predictionMessage: 'ابدأ أول جلسة لتحليل تقدمك.',
        completionProbability: 0,
        stagnationDays: [],
      );
    }

    // 2. متوسط المدة بين كل جلستين (بالأيام)
    final intervals = <double>[];
    for (var i = 1; i < completed.length; i++) {
      final diff = completed[i]
              .completedAt!
              .difference(completed[i - 1].completedAt!)
              .inHours /
          24.0;
      intervals.add(diff);
    }
    final avgInterval = intervals.isEmpty
        ? 1.0 // إذا أكمل جلسة واحدة فقط، نفترض يوم واحد كمتوسط
        : intervals.reduce((a, b) => a + b) / intervals.length;

    // 3. توقع يوم الختم الحقيقي
    final sessionsRemaining = plan.sessionsCount - completed.length;
    final lastCompletion = completed.last.completedAt;
    final expectedFinishDate = lastCompletion
        ?.add(Duration(days: (avgInterval * sessionsRemaining).ceil()));

    // 4. تحليل أيام النشاط والكسل (كل يوم جمعة/سبت..)
    final sessionsPerWeekday = <int, int>{};
    for (final s in completed) {
      final weekday = s.completedAt!.weekday; // 1=Mon ... 7=Sun
      sessionsPerWeekday[weekday] = (sessionsPerWeekday[weekday] ?? 0) + 1;
    }
    final maxEntry =
        sessionsPerWeekday.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final minEntry =
        sessionsPerWeekday.entries.reduce((a, b) => a.value <= b.value ? a : b);

    // 5. نصيحة ذكية واحتمال الإنجاز
    final today = DateTime.now();
    final planDaysLeft =
        plan.totalDays - today.difference(completed.first.completedAt!).inDays;
    final probability = (avgInterval <= 1.2)
        ? 0.9
        : (avgInterval <= 1.7)
            ? 0.7
            : 0.4;

    final f = DateFormat('EEEE', 'ar');
    final activityDay = f.format(DateTime(2025, 7, 21 + maxEntry.key));
    final lazyDay = f.format(DateTime(2025, 7, 21 + minEntry.key));

    final predictionMsg = (sessionsRemaining == 0)
        ? 'مبارك! لقد أنهيت الخطة.'
        : (expectedFinishDate != null &&
                expectedFinishDate.isBefore(
                  plan.createdAt.add(Duration(days: plan.totalDays)),
                ))
            ? 'أنت على المسار الصحيح، ومتوقع أن تختم قبل الوقت المحدد!'
            : 'قد تتأخر قليلاً عن الموعد. حاول تسريع وتيرة القراءة.';

    // 6. أيام الركود (أي يوم لم تتم فيه جلسة لأكثر من يوم متتالي)
    final stagnationDays = <DateTime>[];
    for (var i = 1; i < completed.length; i++) {
      final diffDays = completed[i]
          .completedAt!
          .difference(completed[i - 1].completedAt!)
          .inDays;
      if (diffDays > 1) {
        // أضف كل يوم توقف فيه
        for (var d = 1; d < diffDays; d++) {
          stagnationDays
              .add(completed[i - 1].completedAt!.add(Duration(days: d)));
        }
      }
    }

    return PlanProgressAnalysis(
      expectedFinishDate: expectedFinishDate,
      averageSessionIntervalDays: avgInterval,
      sessionsPerWeekday: sessionsPerWeekday,
      activityDay: activityDay,
      lazyDay: lazyDay,
      predictionMessage: predictionMsg,
      completionProbability: probability,
      stagnationDays: stagnationDays,
    );
  }
}

// Widget buildSmartAnalysis(PlanProgressAnalysis analysis) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text('توقع يوم الختم:', style: TextStyle(fontWeight: FontWeight.bold)),
//       Text(analysis.expectedFinishDate != null
//           ? DateFormat('yyyy-MM-dd').format(analysis.expectedFinishDate!)
//           : '—'),
//       SizedBox(height: 12),
//       Text('متوسط الفاصل بين الجلسات: ${analysis.averageSessionIntervalDays.toStringAsFixed(2)} يوم'),
//       SizedBox(height: 12),
//       Text('اليوم الأكثر نشاطًا: ${analysis.activityDay}'),
//       Text('اليوم الأقل نشاطًا: ${analysis.lazyDay}'),
//       SizedBox(height: 12),
//       Text('نص التوقع والتحفيز:', style: TextStyle(fontWeight: FontWeight.bold)),
//       Text(analysis.predictionMessage),
//       SizedBox(height: 12),
//       LinearProgressIndicator(value: analysis.completionProbability),
//       SizedBox(height: 8),
//       Text('أيام الركود:', style: TextStyle(fontWeight: FontWeight.bold)),
//       Wrap(
//         children: analysis.stagnationDays.map((d) => Text(
//           DateFormat('yyyy-MM-dd').format(d) + "، ",
//         )).toList(),
//       ),
//     ],
//   );
// }
// void checkForStagnation(PlanProgressAnalysis analysis) {
//   if (analysis.stagnationDays.length >= 3) {
//     // Show notification: "خسارة! كنت ملتزمًا جدًا، جرب تقرأ اليوم نصف جلسة فقط!"
//   }
// }
