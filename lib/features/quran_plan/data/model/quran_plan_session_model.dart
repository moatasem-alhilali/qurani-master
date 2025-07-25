// ignore_for_file: public_member_api_docs, sort_constructors_first
class QuranPlanSession {
  QuranPlanSession({
    required this.planId,
    required this.sessionNumber,
    required this.fromSurahId,
    required this.fromAyahNumber,
    required this.toSurahId,
    required this.toAyahNumber,
    this.id,
    this.assignedToUserId,
    this.completed = false,
    this.completedAt,
  });

  factory QuranPlanSession.fromMap(Map<String, dynamic> map) =>
      QuranPlanSession(
        id: map['id'] as int?,
        planId: map['plan_id'] as int,
        sessionNumber: map['session_number'] as int,
        fromSurahId: map['from_surah_id'] as int,
        fromAyahNumber: map['from_ayah_number'] as int,
        toSurahId: map['to_surah_id'] as int,
        toAyahNumber: map['to_ayah_number'] as int,
        assignedToUserId: map['assigned_to_user_id'] as String?,
        completed: (map['completed'] ?? 0) == 1,
        completedAt: map['completed_at'] != null
            ? DateTime.parse(map['completed_at'] as String)
            : null,
      );
  final int? id;
  final int planId;
  final int sessionNumber;
  final int fromSurahId;
  final int fromAyahNumber;
  final int toSurahId;
  final int toAyahNumber;
  final String? assignedToUserId;
  final bool completed;
  final DateTime? completedAt;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'plan_id': planId,
        'session_number': sessionNumber,
        'from_surah_id': fromSurahId,
        'from_ayah_number': fromAyahNumber,
        'to_surah_id': toSurahId,
        'to_ayah_number': toAyahNumber,
        'assigned_to_user_id': assignedToUserId,
        'completed': completed ? 1 : 0,
        'completed_at': completedAt?.toIso8601String(),
      };

  QuranPlanSession copyWith({
    int? id,
    int? planId,
    int? sessionNumber,
    int? fromSurahId,
    int? fromAyahNumber,
    int? toSurahId,
    int? toAyahNumber,
    String? assignedToUserId,
    bool? completed,
    DateTime? completedAt,
  }) {
    return QuranPlanSession(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      sessionNumber: sessionNumber ?? this.sessionNumber,
      fromSurahId: fromSurahId ?? this.fromSurahId,
      fromAyahNumber: fromAyahNumber ?? this.fromAyahNumber,
      toSurahId: toSurahId ?? this.toSurahId,
      toAyahNumber: toAyahNumber ?? this.toAyahNumber,
      assignedToUserId: assignedToUserId ?? this.assignedToUserId,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
