import 'package:equatable/equatable.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_preset_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_settings_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_stats_model.dart';

class DailyWirdOverview extends Equatable {
  const DailyWirdOverview({
    required this.presets,
    required this.settings,
    required this.stats,
    this.program,
  });

  final List<DailyWirdPreset> presets;
  final DailyWirdSettings settings;
  final DailyWirdStats stats;
  final DailyWirdProgram? program;

  @override
  List<Object?> get props => [presets, settings, stats, program];
}
