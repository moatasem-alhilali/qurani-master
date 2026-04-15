import 'package:equatable/equatable.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_item_model.dart';

class DailyWirdProgram extends Equatable {
  const DailyWirdProgram({
    required this.date,
    required this.items,
    required this.completionPercentage,
    required this.presetId,
    required this.createdAt,
  });

  final DateTime date;
  final List<DailyWirdItem> items;
  final double completionPercentage;
  final String presetId;
  final DateTime createdAt;

  bool get isCompleted => completionPercentage >= 100;

  DailyWirdProgram copyWith({
    DateTime? date,
    List<DailyWirdItem>? items,
    double? completionPercentage,
    String? presetId,
    DateTime? createdAt,
  }) {
    return DailyWirdProgram(
      date: date ?? this.date,
      items: items ?? this.items,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      presetId: presetId ?? this.presetId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        date,
        items,
        completionPercentage,
        presetId,
        createdAt,
      ];
}
