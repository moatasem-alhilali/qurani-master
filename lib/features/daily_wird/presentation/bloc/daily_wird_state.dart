part of 'daily_wird_bloc.dart';

class DailyWirdState extends Equatable {
  const DailyWirdState({
    this.requestState = RequestState.initial,
    this.actionState = RequestState.initial,
    this.presets = const [],
    this.settings,
    this.program,
    this.stats,
    this.errorMessage,
  });

  final RequestState requestState;
  final RequestState actionState;
  final List<DailyWirdPreset> presets;
  final DailyWirdSettings? settings;
  final DailyWirdProgram? program;
  final DailyWirdStats? stats;
  final String? errorMessage;

  bool get requiresPresetSelection => (settings?.selectedPresetId == null ||
      settings!.selectedPresetId!.isEmpty);

  DailyWirdState copyWith({
    RequestState? requestState,
    RequestState? actionState,
    List<DailyWirdPreset>? presets,
    DailyWirdSettings? settings,
    DailyWirdProgram? program,
    DailyWirdStats? stats,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DailyWirdState(
      requestState: requestState ?? this.requestState,
      actionState: actionState ?? this.actionState,
      presets: presets ?? this.presets,
      settings: settings ?? this.settings,
      program: program ?? this.program,
      stats: stats ?? this.stats,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        requestState,
        actionState,
        presets,
        settings,
        program,
        stats,
        errorMessage,
      ];
}
