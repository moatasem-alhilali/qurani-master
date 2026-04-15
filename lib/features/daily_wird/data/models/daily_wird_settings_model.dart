import 'package:equatable/equatable.dart';

class DailyWirdSettings extends Equatable {
  const DailyWirdSettings({
    required this.selectedPresetId,
    required this.onboardingCompleted,
    required this.morningReminderEnabled,
    required this.morningReminderTime,
    required this.eveningReminderEnabled,
    required this.eveningReminderTime,
    required this.nightReminderEnabled,
    required this.nightReminderTime,
    required this.endOfDaySummaryEnabled,
    required this.endOfDaySummaryTime,
    required this.updatedAt,
  });

  factory DailyWirdSettings.fromMap(Map<String, dynamic> map) {
    return DailyWirdSettings(
      selectedPresetId: map['selected_preset_id'] as String?,
      onboardingCompleted: map['onboarding_completed'] == 1,
      morningReminderEnabled: map['morning_reminder_enabled'] != 0,
      morningReminderTime: map['morning_reminder_time'] as String? ?? '07:00',
      eveningReminderEnabled: map['evening_reminder_enabled'] != 0,
      eveningReminderTime: map['evening_reminder_time'] as String? ?? '17:30',
      nightReminderEnabled: map['night_reminder_enabled'] != 0,
      nightReminderTime: map['night_reminder_time'] as String? ?? '21:00',
      endOfDaySummaryEnabled: map['end_of_day_summary_enabled'] != 0,
      endOfDaySummaryTime: map['end_of_day_summary_time'] as String? ?? '22:30',
      updatedAt: DateTime.tryParse(map['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final String? selectedPresetId;
  final bool onboardingCompleted;
  final bool morningReminderEnabled;
  final String morningReminderTime;
  final bool eveningReminderEnabled;
  final String eveningReminderTime;
  final bool nightReminderEnabled;
  final String nightReminderTime;
  final bool endOfDaySummaryEnabled;
  final String endOfDaySummaryTime;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() => {
        'id': 1,
        'selected_preset_id': selectedPresetId,
        'onboarding_completed': onboardingCompleted ? 1 : 0,
        'morning_reminder_enabled': morningReminderEnabled ? 1 : 0,
        'morning_reminder_time': morningReminderTime,
        'evening_reminder_enabled': eveningReminderEnabled ? 1 : 0,
        'evening_reminder_time': eveningReminderTime,
        'night_reminder_enabled': nightReminderEnabled ? 1 : 0,
        'night_reminder_time': nightReminderTime,
        'end_of_day_summary_enabled': endOfDaySummaryEnabled ? 1 : 0,
        'end_of_day_summary_time': endOfDaySummaryTime,
        'updated_at': updatedAt.toIso8601String(),
      };

  DailyWirdSettings copyWith({
    String? selectedPresetId,
    bool? onboardingCompleted,
    bool? morningReminderEnabled,
    String? morningReminderTime,
    bool? eveningReminderEnabled,
    String? eveningReminderTime,
    bool? nightReminderEnabled,
    String? nightReminderTime,
    bool? endOfDaySummaryEnabled,
    String? endOfDaySummaryTime,
    DateTime? updatedAt,
    bool clearSelectedPreset = false,
  }) {
    return DailyWirdSettings(
      selectedPresetId: clearSelectedPreset
          ? null
          : selectedPresetId ?? this.selectedPresetId,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      morningReminderEnabled:
          morningReminderEnabled ?? this.morningReminderEnabled,
      morningReminderTime: morningReminderTime ?? this.morningReminderTime,
      eveningReminderEnabled:
          eveningReminderEnabled ?? this.eveningReminderEnabled,
      eveningReminderTime: eveningReminderTime ?? this.eveningReminderTime,
      nightReminderEnabled: nightReminderEnabled ?? this.nightReminderEnabled,
      nightReminderTime: nightReminderTime ?? this.nightReminderTime,
      endOfDaySummaryEnabled:
          endOfDaySummaryEnabled ?? this.endOfDaySummaryEnabled,
      endOfDaySummaryTime: endOfDaySummaryTime ?? this.endOfDaySummaryTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        selectedPresetId,
        onboardingCompleted,
        morningReminderEnabled,
        morningReminderTime,
        eveningReminderEnabled,
        eveningReminderTime,
        nightReminderEnabled,
        nightReminderTime,
        endOfDaySummaryEnabled,
        endOfDaySummaryTime,
        updatedAt,
      ];
}
