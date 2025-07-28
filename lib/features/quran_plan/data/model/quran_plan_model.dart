// ignore_for_file: public_member_api_docs, sort_constructors_first
class QuranPlan {
  QuranPlan({
    required this.title,
    required this.startJuz,
    required this.endJuz,
    required this.totalDays,
    required this.sessionsCount,
    required this.versesPerSession,
    required this.ownerId,
    required this.createdAt,
    this.id,
    this.reminderTime,
    this.progress = 0,
    this.groupInviteCode,
    this.isGroup = false,
    this.updatedAt,
  });

  factory QuranPlan.fromMap(Map<String, dynamic> map) => QuranPlan(
        id: map['id'] as int?,
        title: map['title'] as String,
        startJuz: map['start_juz'] as int,
        endJuz: map['end_juz'] as int,
        totalDays: map['total_days'] as int,
        sessionsCount: map['sessions_count'] as int,
        versesPerSession: map['verses_per_session'] as int,
        reminderTime: map['reminder_time'] as String?,
        progress: (map['progress'] as num?)?.toDouble() ?? 0,
        ownerId: map['owner_id'] as String,
        groupInviteCode: map['group_invite_code'] as String?,
        isGroup: (map['is_group'] ?? 0) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: map['updated_at'] != null
            ? DateTime.parse(map['updated_at'] as String)
            : null,
      );
  final int? id;
  final String title;
  final int startJuz;
  final int endJuz;
  final int totalDays;
  final int sessionsCount;
  final int versesPerSession;
  final String? reminderTime; // "HH:mm"
  final double progress;
  final String ownerId;
  final String? groupInviteCode;
  final bool isGroup;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'start_juz': startJuz,
        'end_juz': endJuz,
        'total_days': totalDays,
        'sessions_count': sessionsCount,
        'verses_per_session': versesPerSession,
        'reminder_time': reminderTime,
        'progress': progress,
        'owner_id': ownerId,
        'group_invite_code': groupInviteCode,
        'is_group': isGroup ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  QuranPlan copyWith({
    int? id,
    String? title,
    int? startJuz,
    int? endJuz,
    int? totalDays,
    int? sessionsCount,
    int? versesPerSession,
    String? reminderTime,
    double? progress,
    String? ownerId,
    String? groupInviteCode,
    bool? isGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuranPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      startJuz: startJuz ?? this.startJuz,
      endJuz: endJuz ?? this.endJuz,
      totalDays: totalDays ?? this.totalDays,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      versesPerSession: versesPerSession ?? this.versesPerSession,
      reminderTime: reminderTime ?? this.reminderTime,
      progress: progress ?? this.progress,
      ownerId: ownerId ?? this.ownerId,
      groupInviteCode: groupInviteCode ?? this.groupInviteCode,
      isGroup: isGroup ?? this.isGroup,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
