import 'package:equatable/equatable.dart';

class DailyWirdStats extends Equatable {
  const DailyWirdStats({
    required this.streakDays,
    required this.weeklyAdherence,
    required this.todayCompletionPercentage,
    required this.completedToday,
  });

  final int streakDays;
  final double weeklyAdherence;
  final double todayCompletionPercentage;
  final bool completedToday;

  @override
  List<Object?> get props => [
        streakDays,
        weeklyAdherence,
        todayCompletionPercentage,
        completedToday,
      ];
}
