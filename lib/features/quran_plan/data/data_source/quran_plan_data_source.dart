import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/core/notification/notification_service.dart'; // تأكد من استيراد الخدمة
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/read_quran/data/data_source/ayah_data_source.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:sqflite/sqflite.dart';

class QuranPlanDataSource {
  QuranPlanDataSource({
    required this.ayahDataSource,
    required this.notificationService,
  });
  final AyahDataSource ayahDataSource;
  final NotificationService notificationService;

  final _db = DatabaseService();
  static const String quranPlanTable = '''
CREATE TABLE IF NOT EXISTS ${DatabaseTables.quranPlan} (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  start_juz INTEGER NOT NULL,
  end_juz INTEGER NOT NULL,
  total_days INTEGER NOT NULL,
  sessions_count INTEGER NOT NULL,
  verses_per_session INTEGER NOT NULL,
  reminder_time TEXT,         -- format HH:mm or NULL
  progress REAL DEFAULT 0,
  owner_id TEXT NOT NULL,
  group_invite_code TEXT,     -- group invite code (NULL if individual)
  is_group INTEGER DEFAULT 0, -- 1=خطة جماعية، 0=فردية
  created_at TEXT NOT NULL,
  updated_at TEXT
);

  ''';
  static const String quranPlanSessionTable = '''
CREATE TABLE IF NOT EXISTS quran_plan_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plan_id INTEGER NOT NULL,
  session_number INTEGER NOT NULL,
  from_surah_id INTEGER NOT NULL,
  from_ayah_number INTEGER NOT NULL,
  to_surah_id INTEGER NOT NULL,
  to_ayah_number INTEGER NOT NULL,
  assigned_to_user_id TEXT,
  completed INTEGER DEFAULT 0,
  completed_at TEXT,
  UNIQUE(plan_id, session_number)
);
''';

  /// get all plans
  Future<List<QuranPlan>> getAllPlans() async {
    final maps =
        await _db.query(DatabaseTables.quranPlan, orderBy: 'created_at DESC');
    return maps.map(QuranPlan.fromMap).toList();
  }

  /// get plan by id
  Future<QuranPlan?> getPlanById(int id) async {
    final maps = await _db
        .query(DatabaseTables.quranPlan, where: 'id=?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return QuranPlan.fromMap(maps.first);
  }

  /// delete plan + notification
  Future<void> deletePlan(int id) async {
    // first: cancel the plan notification
    await notificationService.plugin.cancel(id);
    // then delete the plan and sessions
    await _db.delete(DatabaseTables.quranPlan, id);
    await _db.delete(DatabaseTables.quranPlanSession, id);
  }

  /// create plan + schedule notification
  Future<int> createPlan(
    QuranPlan plan,
    int fromJuz,
    int toJuz,
    int totalDays,
  ) async {
    // get ayahs by juz range
    final ayahs = await getAyahsByJuzRange(fromJuz, toJuz);
    ayahs.sort((a, b) => a.numberGlobal.compareTo(b.numberGlobal));

    final totalVerses = ayahs.length;
    final versesPerSession = (totalVerses / totalDays).floor();
    final remainder = totalVerses % totalDays; // if not equal

    final planId = await _db.insert(
      DatabaseTables.quranPlan,
      plan
          .copyWith(
            startJuz: fromJuz,
            endJuz: toJuz,
            totalDays: totalDays,
            sessionsCount: totalDays,
            reminderTime: plan.reminderTime,
            versesPerSession: versesPerSession,
            createdAt: DateTime.now(),
            progress: 0,
          )
          .toMap(),
    );

    var currentIndex = 0;
    for (var sessionNum = 1; sessionNum <= totalDays; sessionNum++) {
      // distribute the remainder to the first sessions
      final currentSessionCount =
          versesPerSession + (sessionNum <= remainder ? 1 : 0);
      final fromAyah = ayahs[currentIndex];
      final toAyah = ayahs[currentIndex + currentSessionCount - 1];

      await _db.insert(DatabaseTables.quranPlanSession, {
        'plan_id': planId,
        'session_number': sessionNum,
        'from_surah_id': fromAyah.surahId,
        'from_ayah_number': fromAyah.ayahNumber,
        'to_surah_id': toAyah.surahId,
        'to_ayah_number': toAyah.ayahNumber,
        'completed': 0,
      });

      currentIndex += currentSessionCount;
    }

    await _schedulePlanReminder(plan.copyWith(id: planId));
    return planId;
  }

  /// update the reminder time or any property in the plan
  Future<void> updatePlan(QuranPlan plan) async {
    await _db.update(
      DatabaseTables.quranPlan,
      plan.toMap(),
      where: 'id=?',
      whereArgs: [plan.id],
    );
    // reschedule the notification when updating the time
    await notificationService.plugin.cancel(plan.id!);
    await _schedulePlanReminder(plan);
  }

  /// schedule a daily plan reminder (separate feature for the unit)
  Future<void> _schedulePlanReminder(QuranPlan plan) async {
    if (plan.reminderTime == null || plan.id == null) return;
    final parts = plan.reminderTime!.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    await notificationService.scheduleNotification(
      id: plan.id!,
      hour: hour,
      minute: minute,
      title: 'خطة ختم القرآن: ${plan.title}',
      body: 'لا تنس جلسة اليوم في خطتك "${plan.title}"!',
      payload: 'planId:${plan.id}',
    );
  }

  /// get sessions
  Future<List<QuranPlanSession>> getSessions(int planId) async {
    final maps = await _db.query(
      DatabaseTables.quranPlanSession,
      where: 'plan_id=?',
      whereArgs: [planId],
      orderBy: 'session_number ASC',
    );
    return maps.map(QuranPlanSession.fromMap).toList();
  }

  /// complete session
  Future<void> completeSession(int sessionId) async {
    await _db.update(
      DatabaseTables.quranPlanSession,
      {
        'completed': 1,
        'completed_at': DateTime.now().toIso8601String(),
      },
      where: 'id=?',
      whereArgs: [sessionId],
    );
    // update plan progress
    final session = await _db.query(
      DatabaseTables.quranPlanSession,
      where: 'id=?',
      whereArgs: [sessionId],
    );
    if (session.isNotEmpty) {
      final planId = session.first['plan_id']! as int;
      await updatePlanProgress(planId);
      // optional: if all sessions of the day are completed, you can cancel the day notification if you want
      await _cancelTodayNotificationIfNoSessions(planId);
    }
  }

  /// update plan progress
  Future<void> updatePlanProgress(int planId) async {
    final total = Sqflite.firstIntValue(
      await _db.rawQuery(
        'SELECT COUNT(*) FROM ${DatabaseTables.quranPlanSession} WHERE plan_id=?',
        [planId],
      ),
    );
    final done = Sqflite.firstIntValue(
      await _db.rawQuery(
        'SELECT COUNT(*) FROM ${DatabaseTables.quranPlanSession} WHERE plan_id=? AND completed=1',
        [planId],
      ),
    );
    final progress = (total == 0) ? 0 : (done! / total!);
    await _db.update(
      DatabaseTables.quranPlan,
      {'progress': progress},
      where: 'id=?',
      whereArgs: [planId],
    );
  }

  /// get next session
  Future<QuranPlanSession?> getNextSession(int planId) async {
    final maps = await _db.query(
      DatabaseTables.quranPlanSession,
      where: 'plan_id=? AND completed=0',
      whereArgs: [planId],
      orderBy: 'session_number ASC',
      limit: 1,
    );
    return maps.isNotEmpty ? QuranPlanSession.fromMap(maps.first) : null;
  }

  /// get ayahs by juz range
  Future<List<NewAyahModel>> getAyahsByJuzRange(int fromJuz, int toJuz) async {
    final result = await ayahDataSource.getAyahsByJuzRange(fromJuz, toJuz);
    return result;
  }

  // optional - cancel the day notification if all sessions of the day are completed (Advanced)
  Future<void> _cancelTodayNotificationIfNoSessions(int planId) async {
    final today = DateTime.now();
    final sessions = await getSessions(planId);
    final sessionsToday = sessions.where((s) {
      // according to your logic: you can link the session to a specific date, or a specific session/schedule
      return !s
          .completed; // change the condition if you have a specific date logic for the session
    }).toList();
    if (sessionsToday.isEmpty) {
      await notificationService.plugin.cancel(planId);
    }
  }
}
