import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/core/notification/notification_service.dart';
import 'package:quran_app/features/quran_plan/data/user_id_manager.dart';
import 'package:quran_app/features/quran_plan/data/model/plan_group_member.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/read_quran/data/data_source/ayah_data_source.dart';

class GroupPlanDataSource {
  GroupPlanDataSource({
    required this.db,
    required this.firestore,
    required this.ayahDataSource,
    required this.notificationService,
  });

  final DatabaseService db;
  final FirebaseFirestore firestore;
  final AyahDataSource ayahDataSource;
  final NotificationService notificationService;

  static const String _serverKey =
      'YOUR_FCM_SERVER_KEY'; // Cloud Function recommended

  // جداول قاعدة البيانات (تضاف عند التهيئة)
  static const String planGroupMemberTable = '''
CREATE TABLE IF NOT EXISTS plan_group_members (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plan_id INTEGER NOT NULL,
  user_id TEXT NOT NULL,
  user_name TEXT NOT NULL,
  fcm_token TEXT,
  device_id TEXT,
  is_owner INTEGER DEFAULT 0,
  joined_at TEXT NOT NULL,
  UNIQUE(plan_id, user_id)
);
''';
  static const String planGroupActivityLogsTable = '''
CREATE TABLE IF NOT EXISTS plan_group_activity_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plan_id INTEGER NOT NULL,
  user_id TEXT NOT NULL,
  action TEXT NOT NULL,
  session_id INTEGER,
  extra_data TEXT,
  timestamp TEXT NOT NULL
);
''';
  static const String planGroupOfflineActionsTable = '''
CREATE TABLE IF NOT EXISTS offline_actions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  action_type TEXT NOT NULL,
  plan_id INTEGER NOT NULL,
  session_id INTEGER,
  user_id TEXT NOT NULL,
  extra_data TEXT,
  timestamp TEXT NOT NULL,
  synced INTEGER DEFAULT 0
);
''';

  // توحيد الوقت
  String _nowUtcIso() => DateTime.now().toUtc().toIso8601String();

  // جلب UUID الموحد للمستخدم (يبقى ثابت حتى بعد حذف التطبيق)
  Future<String> _getUserId() async => UserIdManager.instance.getUserId();

  // جلب اسم المستخدم (خصصها حسب منطقك)
  Future<String> _getUserName() async => 'المستخدم';

  // ========================= إنشاء خطة جماعية (محلي/سحابي) =========================
  Future<int> createGroupPlan({
    required QuranPlan plan,
    required List<PlanGroupMember> members,
    required int fromJuz,
    required int toJuz,
    required int totalDays,
    bool syncToCloud = false,
    String? inviteCode,
  }) async {
    final planId = await db.insert(
      DatabaseTables.quranPlan,
      plan
          .copyWith(
            startJuz: fromJuz,
            endJuz: toJuz,
            totalDays: totalDays,
            sessionsCount: totalDays,
            createdAt: DateTime.parse(_nowUtcIso()),
            progress: 0,
          )
          .toMap(),
    );

    for (final member in members) {
      await addMemberIfNotExists(planId, member);
    }

    // توزيع الجلسات (Round Robin)
    final ayahs = await ayahDataSource.getAyahsByJuzRange(fromJuz, toJuz);
    final versesPerSession = (ayahs.length / totalDays).ceil();
    var index = 0;
    var memberIndex = 0;
    for (var sessionNum = 1; sessionNum <= totalDays; sessionNum++) {
      final fromAyah = ayahs[index];
      final toIndex = (index + versesPerSession >= ayahs.length)
          ? ayahs.length - 1
          : index + versesPerSession - 1;
      final toAyah = ayahs[toIndex];
      final assignedUser = members[memberIndex % members.length];

      // لا تضيف الجلسة إذا كانت موجودة (UNIQUE)
      final exists = await db.query(
        DatabaseTables.quranPlanSession,
        where: 'plan_id=? AND session_number=?',
        whereArgs: [planId, sessionNum],
      );
      if (exists.isEmpty) {
        await db.insert(DatabaseTables.quranPlanSession, {
          'plan_id': planId,
          'session_number': sessionNum,
          'from_surah_id': fromAyah.surahId,
          'from_ayah_number': fromAyah.ayahNumber,
          'to_surah_id': toAyah.surahId,
          'to_ayah_number': toAyah.ayahNumber,
          'assigned_to_user_id': assignedUser.userId,
          'completed': 0,
        });
      }

      index = toIndex + 1;
      memberIndex++;
      if (index >= ayahs.length) break;
    }

    // إنشاء في Firebase إن طلب المستخدم
    if (syncToCloud) {
      final doc =
          firestore.collection('group_plans').doc(inviteCode ?? '$planId');
      await doc.set({
        'title': plan.title,
        'ownerId': members.firstWhere((m) => m.isOwner).userId,
        'createdAt': _nowUtcIso(),
        'inviteCode': inviteCode ?? '$planId',
        'localPlanId': planId,
      });
      for (final member in members) {
        await doc.collection('members').doc(member.userId).set({
          'userName': member.userName,
          'isOwner': member.isOwner,
          'joinedAt': member.joinedAt.toIso8601String(),
          'fcmToken': member.fcmToken,
          'deviceId': member.deviceId,
        });
      }
      final sessions = await db.query(
        DatabaseTables.quranPlanSession,
        where: 'plan_id=?',
        whereArgs: [planId],
      );
      for (final s in sessions) {
        await doc.collection('sessions').add({
          ...s,
          'completed': false,
          'completedAt': null,
        });
      }
    }
    return planId;
  }

  // دالة منع تكرار العضو
  Future<void> addMemberIfNotExists(int planId, PlanGroupMember member) async {
    final exists = await db.query(
      'plan_group_members',
      where: 'plan_id=? AND user_id=?',
      whereArgs: [planId, member.userId],
    );
    if (exists.isEmpty) {
      await db.insert(
        'plan_group_members',
        member.toMap()..['plan_id'] = planId,
      );
    }
  }

  // ============== كود الدعوة الموحد ==============
  Future<String> generateInviteCode(int planId) async {
    final userId = await _getUserId();
    return 'QP-${planId.toString().padLeft(6, '0')}-${userId.substring(0, 8)}';
  }

  // ============== الانضمام للخطة برمز دعوة ==============
  Future<void> joinGroupPlanByCode(
    String inviteCode, {
    String? fcmToken,
    String? deviceId,
  }) async {
    final snapshot = await firestore
        .collection('group_plans')
        .where('inviteCode', isEqualTo: inviteCode)
        .get();
    if (snapshot.docs.isEmpty) throw Exception('Invalid invite code');
    final planDoc = snapshot.docs.first;

    final userId = await _getUserId();
    final userName = await _getUserName();

    // إضافة العضو سحابيًا
    await planDoc.reference.collection('members').doc(userId).set({
      'userName': userName,
      'isOwner': false,
      'joinedAt': _nowUtcIso(),
      'fcmToken': fcmToken,
      'deviceId': deviceId,
    });

    // نسخ الخطة والجلسات محليًا
    final planData = planDoc.data();
    final localPlanId = planData['localPlanId'] as int? ?? planDoc.id.hashCode;
    await db.insert(DatabaseTables.quranPlan, {
      'id': localPlanId,
      'title': planData['title'],
      'owner_id': planData['ownerId'],
      'created_at': planData['createdAt'],
    });
    final membersSnap = await planDoc.reference.collection('members').get();
    for (final m in membersSnap.docs) {
      await addMemberIfNotExists(
        localPlanId,
        PlanGroupMember.fromMap({
          ...m.data(),
          'plan_id': localPlanId,
          'user_id': m.id,
        }),
      );
    }
    final sessionsSnap = await planDoc.reference.collection('sessions').get();
    for (final s in sessionsSnap.docs) {
      final data = {...s.data(), 'plan_id': localPlanId};
      // تحقق من عدم التكرار
      final exists = await db.query(
        DatabaseTables.quranPlanSession,
        where: 'plan_id=? AND session_number=?',
        whereArgs: [localPlanId, data['session_number']],
      );
      if (exists.isEmpty) {
        await db.insert(DatabaseTables.quranPlanSession, data);
      }
    }
  }

  // ============== إنهاء جلسة جماعية ==============
  Future<void> completeSession({
    required int planId,
    required int sessionId,
    bool syncToCloud = false,
  }) async {
    final userId = await _getUserId();

    await db.update(
      DatabaseTables.quranPlanSession,
      {
        'completed': 1,
        'completed_at': _nowUtcIso(),
      },
      where: 'id=?',
      whereArgs: [sessionId],
    );

    if (syncToCloud) {
      final planDoc = firestore.collection('group_plans').doc('$planId');
      final sessionDocs = await planDoc
          .collection('sessions')
          .where('session_number', isEqualTo: sessionId)
          .get();
      if (sessionDocs.docs.isNotEmpty) {
        await sessionDocs.docs.first.reference.update({
          'completed': true,
          'completedAt': _nowUtcIso(),
        });
      }
      await planDoc.collection('activity_logs').add({
        'userId': userId,
        'action': 'completed_session',
        'sessionId': sessionId,
        'timestamp': _nowUtcIso(),
      });
      await _notifyAllMembers(planId, sessionId, excludeUserId: userId);
    } else {
      await recordOfflineAction(
        actionType: 'complete_session',
        planId: planId,
        sessionId: sessionId,
        userId: userId,
      );
    }
  }

  // ============== مغادرة العضو للخطة ==============
  Future<void> leaveGroupPlan(int planId) async {
    final userId = await _getUserId();
    await db.deleteWhere(
      'plan_group_members',
      where: 'plan_id=? AND user_id=?',
      whereArgs: [planId, userId],
    );
    final planDoc = firestore.collection('group_plans').doc('$planId');
    await planDoc.collection('members').doc(userId).delete();
    await planDoc.collection('activity_logs').add({
      'userId': userId,
      'action': 'leave_group',
      'timestamp': _nowUtcIso(),
    });
  }

  // ============== سجل النشاطات ==============
  Future<void> logActivity({
    required int planId,
    required String action,
    required String userId,
    int? sessionId,
    Map<String, dynamic>? extraData,
  }) async {
    await db.insert('plan_group_activity_logs', {
      'plan_id': planId,
      'user_id': userId,
      'action': action,
      'session_id': sessionId,
      'extra_data': extraData != null ? json.encode(extraData) : null,
      'timestamp': _nowUtcIso(),
    });
  }

  // ============== مزامنة أوفلاين ==============
  Future<void> recordOfflineAction({
    required String actionType,
    required int planId,
    required String userId,
    int? sessionId,
    Map<String, dynamic>? extraData,
  }) async {
    await db.insert('offline_actions', {
      'action_type': actionType,
      'plan_id': planId,
      'session_id': sessionId,
      'user_id': userId,
      'extra_data': extraData != null ? json.encode(extraData) : null,
      'timestamp': _nowUtcIso(),
      'synced': 0,
    });
  }

  Future<void> syncOfflineChanges() async {
    final offlineActions = await db.query(
      'offline_actions',
      where: 'synced = 0',
    );

    for (final action in offlineActions) {
      final actionType = action['action_type']! as String;
      final planId = action['plan_id']! as int;
      final sessionId = action['session_id'] as int?;
      final userId = action['user_id']! as String;
      final extraData = action['extra_data'] != null
          ? json.decode(action['extra_data']! as String)
          : null;

      try {
        if (actionType == 'complete_session') {
          final planDoc = firestore.collection('group_plans').doc('$planId');
          final sessionDocs = await planDoc
              .collection('sessions')
              .where('session_number', isEqualTo: sessionId)
              .get();
          if (sessionDocs.docs.isNotEmpty) {
            await sessionDocs.docs.first.reference.update({
              'completed': true,
              'completedAt': _nowUtcIso(),
            });
          }
          await planDoc.collection('activity_logs').add({
            'userId': userId,
            'action': 'completed_session',
            'sessionId': sessionId,
            'timestamp': _nowUtcIso(),
          });
          await _notifyAllMembers(planId, sessionId!, excludeUserId: userId);
        }
        // أنواع أخرى...

        // علم الحدث كمُزامن
        await db.update(
          'offline_actions',
          {'synced': 1},
          where: 'id = ?',
          whereArgs: [action['id']],
        );
      } catch (e) {
        continue;
      }
    }
  }

  // ============== الإشعار الجماعي عبر FCM (اختبار فقط) ==============
  Future<void> _notifyAllMembers(
    int planId,
    int sessionId, {
    required String excludeUserId,
  }) async {
    final planDoc = firestore.collection('group_plans').doc('$planId');
    final membersSnap = await planDoc.collection('members').get();
    for (final m in membersSnap.docs) {
      if (m.id == excludeUserId) continue;
      final fcmToken = m.data()['fcmToken'];
      final memberName = m.data()['userName'];
      if (fcmToken != null && _serverKey != 'YOUR_FCM_SERVER_KEY') {
        await _sendFcmNotification(
          fcmToken: fcmToken as String,
          title: 'ختم جماعي: عضو أكمل جلسة',
          body: 'قام $memberName بإكمال جلسته. شارك التقدم الآن!',
          data: {
            'planId': planId.toString(),
            'sessionId': sessionId.toString(),
            'type': 'session_completed',
          },
        );
      }
    }
  }

  // إشعار FCM مباشر (يفضل Cloud Function في الإنتاج)
  Future<void> _sendFcmNotification({
    required String fcmToken,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    final payload = {
      'to': fcmToken,
      'notification': {
        'title': title,
        'body': body,
        'sound': 'default',
      },
      'data': data,
    };
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverKey',
    };
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: json.encode(payload),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'FCM send error: ${response.statusCode}, ${response.body}',
      );
    }
  }

  // ============== مراقبة التقدم الجماعي (Leaderboard) ==============
  Stream<List<Map<String, dynamic>>> groupProgressStream(String planId) {
    return firestore
        .collection('group_plans')
        .doc(planId)
        .collection('sessions')
        .snapshots()
        .map((snapshot) {
      final counts = <String, int>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data['completed'] == true) {
          final uid = data['assigned_to_user_id'];
          counts[uid as String] = (counts[uid] ?? 0) + 1;
        }
      }
      return counts.entries
          .map((e) => {'userId': e.key, 'completedCount': e.value})
          .toList();
    });
  }
}
