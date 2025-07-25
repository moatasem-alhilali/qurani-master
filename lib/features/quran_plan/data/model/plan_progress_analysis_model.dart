// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class PlanProgressAnalysis {
  // أيام الركود (لم يقرأ فيها جلسة)

  PlanProgressAnalysis({
    required this.averageSessionIntervalDays,
    required this.sessionsPerWeekday,
    required this.activityDay,
    required this.lazyDay,
    required this.predictionMessage,
    required this.completionProbability,
    required this.stagnationDays,
    this.expectedFinishDate,
  });
  final DateTime? expectedFinishDate;
  final double averageSessionIntervalDays;
  final Map<int, int> sessionsPerWeekday; // 1:Mon..7:Sun
  final String activityDay; // الأكثر نشاطًا
  final String lazyDay; // الأقل نشاطًا
  final String predictionMessage;
  final double completionProbability; // % تقريبي
  final List<DateTime> stagnationDays;

  PlanProgressAnalysis copyWith({
    DateTime? expectedFinishDate,
    double? averageSessionIntervalDays,
    Map<int, int>? sessionsPerWeekday,
    String? activityDay,
    String? lazyDay,
    String? predictionMessage,
    double? completionProbability,
    List<DateTime>? stagnationDays,
  }) {
    return PlanProgressAnalysis(
      expectedFinishDate: expectedFinishDate ?? this.expectedFinishDate,
      averageSessionIntervalDays:
          averageSessionIntervalDays ?? this.averageSessionIntervalDays,
      sessionsPerWeekday: sessionsPerWeekday ?? this.sessionsPerWeekday,
      activityDay: activityDay ?? this.activityDay,
      lazyDay: lazyDay ?? this.lazyDay,
      predictionMessage: predictionMessage ?? this.predictionMessage,
      completionProbability:
          completionProbability ?? this.completionProbability,
      stagnationDays: stagnationDays ?? this.stagnationDays,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'expectedFinishDate': expectedFinishDate?.millisecondsSinceEpoch,
      'averageSessionIntervalDays': averageSessionIntervalDays,
      'sessionsPerWeekday': sessionsPerWeekday,
      'activityDay': activityDay,
      'lazyDay': lazyDay,
      'predictionMessage': predictionMessage,
      'completionProbability': completionProbability,
      'stagnationDays':
          stagnationDays.map((x) => x.millisecondsSinceEpoch).toList(),
    };
  }

  @override
  String toString() {
    return 'PlanProgressAnalysis(expectedFinishDate: $expectedFinishDate, averageSessionIntervalDays: $averageSessionIntervalDays, sessionsPerWeekday: $sessionsPerWeekday, activityDay: $activityDay, lazyDay: $lazyDay, predictionMessage: $predictionMessage, completionProbability: $completionProbability, stagnationDays: $stagnationDays)';
  }

  @override
  bool operator ==(covariant PlanProgressAnalysis other) {
    if (identical(this, other)) return true;

    return other.expectedFinishDate == expectedFinishDate &&
        other.averageSessionIntervalDays == averageSessionIntervalDays &&
        mapEquals(other.sessionsPerWeekday, sessionsPerWeekday) &&
        other.activityDay == activityDay &&
        other.lazyDay == lazyDay &&
        other.predictionMessage == predictionMessage &&
        other.completionProbability == completionProbability &&
        listEquals(other.stagnationDays, stagnationDays);
  }

  @override
  int get hashCode {
    return expectedFinishDate.hashCode ^
        averageSessionIntervalDays.hashCode ^
        sessionsPerWeekday.hashCode ^
        activityDay.hashCode ^
        lazyDay.hashCode ^
        predictionMessage.hashCode ^
        completionProbability.hashCode ^
        stagnationDays.hashCode;
  }
}
