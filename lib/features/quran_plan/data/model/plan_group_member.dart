// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlanGroupMember {
  PlanGroupMember({
    required this.planId,
    required this.userId,
    required this.userName,
    required this.joinedAt,
    this.id,
    this.fcmToken,
    this.isOwner = false,
    this.deviceId,
  });

  factory PlanGroupMember.fromMap(Map<String, dynamic> map) => PlanGroupMember(
        id: map['id'] as int?,
        planId: map['plan_id'] as int,
        userId: map['user_id'] as String,
        userName: map['user_name'] as String,
        fcmToken: map['fcm_token'] as String?,
        isOwner: (map['is_owner'] ?? 0) == 1,
        joinedAt: DateTime.parse(map['joined_at'] as String),
        deviceId: map['device_id'] as String?,
      );
  final int? id;
  final int planId;
  final String userId;
  final String userName;
  final String? fcmToken;
  final bool isOwner;
  final DateTime joinedAt;
  final String? deviceId;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'plan_id': planId,
        'user_id': userId,
        'user_name': userName,
        'fcm_token': fcmToken,
        'is_owner': isOwner ? 1 : 0,
        'joined_at': joinedAt.toIso8601String(),
        'device_id': deviceId,
      };

  PlanGroupMember copyWith({
    int? id,
    int? planId,
    String? userId,
    String? userName,
    String? fcmToken,
    bool? isOwner,
    DateTime? joinedAt,
    String? deviceId,
  }) {
    return PlanGroupMember(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      fcmToken: fcmToken ?? this.fcmToken,
      isOwner: isOwner ?? this.isOwner,
      joinedAt: joinedAt ?? this.joinedAt,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}

class PlanGroupActivityLog {
  PlanGroupActivityLog({
    required this.planId,
    required this.userId,
    required this.action,
    required this.timestamp,
    this.id,
    this.sessionId,
    this.extraData,
  });

  factory PlanGroupActivityLog.fromMap(Map<String, dynamic> map) =>
      PlanGroupActivityLog(
        id: map['id'] as int?,
        planId: map['plan_id'] as int,
        userId: map['user_id'] as String,
        action: map['action'] as String,
        sessionId: map['session_id'] as int?,
        extraData: map['extra_data'] != null
            ? json.decode(map['extra_data'] as String) as Map<String, dynamic>
            : null,
        timestamp: DateTime.parse(map['timestamp'] as String),
      );
  final int? id;
  final int planId;
  final String userId;
  final String action; // مثال: completed_session, join, leave, ...
  final int? sessionId;
  final Map<String, dynamic>? extraData;
  final DateTime timestamp;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'plan_id': planId,
        'user_id': userId,
        'action': action,
        'session_id': sessionId,
        'extra_data': extraData != null ? json.encode(extraData) : null,
        'timestamp': timestamp.toIso8601String(),
      };

  PlanGroupActivityLog copyWith({
    int? id,
    int? planId,
    String? userId,
    String? action,
    int? sessionId,
    Map<String, dynamic>? extraData,
    DateTime? timestamp,
  }) {
    return PlanGroupActivityLog(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      sessionId: sessionId ?? this.sessionId,
      extraData: extraData ?? this.extraData,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class OfflineAction {
  OfflineAction({
    required this.actionType,
    required this.planId,
    required this.userId,
    required this.timestamp,
    this.id,
    this.sessionId,
    this.extraData,
    this.synced = false,
  });

  factory OfflineAction.fromMap(Map<String, dynamic> map) => OfflineAction(
        id: map['id'] as int?,
        actionType: map['action_type'] as String,
        planId: map['plan_id'] as int,
        sessionId: map['session_id'] as int?,
        userId: map['user_id'] as String,
        extraData: map['extra_data'] != null
            ? json.decode(map['extra_data'] as String) as Map<String, dynamic>
            : null,
        timestamp: DateTime.parse(map['timestamp'] as String),
        synced: (map['synced'] ?? 0) == 1,
      );
  final int? id;
  final String actionType;
  final int planId;
  final int? sessionId;
  final String userId;
  final Map<String, dynamic>? extraData;
  final DateTime timestamp;
  final bool synced;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'action_type': actionType,
        'plan_id': planId,
        'session_id': sessionId,
        'user_id': userId,
        'extra_data': extraData != null ? json.encode(extraData) : null,
        'timestamp': timestamp.toIso8601String(),
        'synced': synced ? 1 : 0,
      };

  OfflineAction copyWith({
    int? id,
    String? actionType,
    int? planId,
    int? sessionId,
    String? userId,
    Map<String, dynamic>? extraData,
    DateTime? timestamp,
    bool? synced,
  }) {
    return OfflineAction(
      id: id ?? this.id,
      actionType: actionType ?? this.actionType,
      planId: planId ?? this.planId,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      extraData: extraData ?? this.extraData,
      timestamp: timestamp ?? this.timestamp,
      synced: synced ?? this.synced,
    );
  }
}
