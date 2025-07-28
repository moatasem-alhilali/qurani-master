import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/quran_plan/data/model/plan_progress_analysis_model.dart';

class SmartAnalysisPlanWidget extends StatelessWidget {
  const SmartAnalysisPlanWidget({required this.analysis, super.key});
  final PlanProgressAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('yyyy-MM-dd');
    return CardWidget(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      // color: Colors.blue[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تحليل متقدم للخطة',
            style: context.titleMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              color: context.gray2,
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              color: context.gray2,
            ),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              color: context.gray2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'نص التوقع والتحفيز:',
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            analysis.predictionMessage,
            style: context.labelMedium,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              color: context.gray2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أيام الركود:',
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            children: analysis.stagnationDays
                .map(
                  (d) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Chip(
                      label: Text(
                        f.format(d),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
