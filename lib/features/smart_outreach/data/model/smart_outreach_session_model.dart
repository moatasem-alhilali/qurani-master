import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';

class SmartOutreachSessionModel {
  const SmartOutreachSessionModel({
    this.id,
    required this.scheduleId,
    required this.currentIndex,
    required this.status,
    required this.startedAt,
    this.completedAt,
    required this.triggerSource,
    required this.sessionDate,
  });

  factory SmartOutreachSessionModel.fromMap(Map<String, dynamic> map) {
    return SmartOutreachSessionModel(
      id: map['id'] as int?,
      scheduleId: (map['schedule_id'] as num?)?.toInt() ?? 0,
      currentIndex: (map['current_index'] as num?)?.toInt() ?? 0,
      status: SmartOutreachSessionStatusX.fromDbValue(
        (map['status'] as String? ?? 'active').trim(),
      ),
      startedAt: DateTime.tryParse((map['started_at'] as String?) ?? '') ??
          DateTime.now(),
      completedAt: DateTime.tryParse((map['completed_at'] as String?) ?? ''),
      triggerSource: SmartOutreachSessionTriggerSourceX.fromDbValue(
        (map['trigger_source'] as String? ?? 'manual').trim(),
      ),
      sessionDate: (map['session_date'] as String? ?? '').trim(),
    );
  }

  final int? id;
  final int scheduleId;
  final int currentIndex;
  final SmartOutreachSessionStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final SmartOutreachSessionTriggerSource triggerSource;
  final String sessionDate;

  SmartOutreachSessionModel copyWith({
    int? id,
    int? scheduleId,
    int? currentIndex,
    SmartOutreachSessionStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    SmartOutreachSessionTriggerSource? triggerSource,
    String? sessionDate,
  }) {
    return SmartOutreachSessionModel(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      currentIndex: currentIndex ?? this.currentIndex,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      triggerSource: triggerSource ?? this.triggerSource,
      sessionDate: sessionDate ?? this.sessionDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'schedule_id': scheduleId,
      'current_index': currentIndex,
      'status': status.dbValue,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'trigger_source': triggerSource.dbValue,
      'session_date': sessionDate,
    };
  }
}
