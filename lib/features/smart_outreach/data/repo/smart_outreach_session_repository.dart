import 'package:intl/intl.dart';
import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/smart_outreach/data/database/smart_outreach_database_service.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_result_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_session_model.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:sqflite/sqflite.dart';

class SmartOutreachSessionRepository {
  SmartOutreachSessionRepository({
    required SmartOutreachDatabaseService databaseService,
    required SmartOutreachScheduleRepository scheduleRepository,
  })  : _databaseService = databaseService,
        _scheduleRepository = scheduleRepository;

  final SmartOutreachDatabaseService _databaseService;
  final SmartOutreachScheduleRepository _scheduleRepository;
  final DatabaseService _db = DatabaseService();

  Future<SmartOutreachSessionBundle?> startOrResumeSession({
    required int scheduleId,
    required SmartOutreachSessionTriggerSource triggerSource,
  }) async {
    await _databaseService.ensureTables();
    final now = DateTime.now();
    final sessionDate = _sessionDateKey(now);

    final scheduleBundle =
        await _scheduleRepository.getScheduleById(scheduleId);
    if (scheduleBundle == null || scheduleBundle.contacts.isEmpty) {
      return null;
    }

    final db = await _db.database;

    final activeRows = await db.query(
      SmartOutreachDatabaseService.sessionsTable,
      where: 'schedule_id = ? AND status = ?',
      whereArgs: [scheduleId, SmartOutreachSessionStatus.active.dbValue],
      orderBy: 'started_at DESC',
      limit: 1,
    );

    if (activeRows.isNotEmpty) {
      final activeSession = SmartOutreachSessionModel.fromMap(activeRows.first);
      if (activeSession.sessionDate == sessionDate) {
        return _loadSessionBundle(activeSession.id!);
      }

      await db.update(
        SmartOutreachDatabaseService.sessionsTable,
        {
          'status': SmartOutreachSessionStatus.abandoned.dbValue,
          'completed_at': now.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [activeSession.id],
      );
    }

    final latestTodayRows = await db.query(
      SmartOutreachDatabaseService.sessionsTable,
      where: 'schedule_id = ? AND session_date = ?',
      whereArgs: [scheduleId, sessionDate],
      orderBy: 'started_at DESC',
      limit: 1,
    );

    if (latestTodayRows.isNotEmpty) {
      final todaySession =
          SmartOutreachSessionModel.fromMap(latestTodayRows.first);
      if (todaySession.status == SmartOutreachSessionStatus.completed) {
        return _loadSessionBundle(todaySession.id!);
      }
    }

    final newSession = SmartOutreachSessionModel(
      scheduleId: scheduleId,
      currentIndex: 0,
      status: SmartOutreachSessionStatus.active,
      startedAt: now,
      completedAt: null,
      triggerSource: triggerSource,
      sessionDate: sessionDate,
    );

    final sessionId = await db.insert(
      SmartOutreachDatabaseService.sessionsTable,
      newSession.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return _loadSessionBundle(sessionId);
  }

  Future<SmartOutreachSessionBundle?> getSessionById(int sessionId) async {
    await _databaseService.ensureTables();
    return _loadSessionBundle(sessionId);
  }

  Future<SmartOutreachSessionBundle?> getLatestSessionForSchedule(
    int scheduleId,
  ) async {
    await _databaseService.ensureTables();

    final db = await _db.database;
    final rows = await db.query(
      SmartOutreachDatabaseService.sessionsTable,
      where: 'schedule_id = ?',
      whereArgs: [scheduleId],
      orderBy: 'started_at DESC',
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    final session = SmartOutreachSessionModel.fromMap(rows.first);
    final sessionId = session.id;
    if (sessionId == null) {
      return null;
    }

    return _loadSessionBundle(sessionId);
  }

  Future<SmartOutreachSessionBundle?> addContactResultAndRefresh({
    required int sessionId,
    required int contactId,
    required SmartOutreachContactResultType resultType,
  }) async {
    await _databaseService.ensureTables();

    final db = await _db.database;
    final now = DateTime.now();

    await db.delete(
      SmartOutreachDatabaseService.contactResultsTable,
      where: 'session_id = ? AND contact_id = ? AND result_type = ?',
      whereArgs: [sessionId, contactId, resultType.dbValue],
    );

    await db.insert(
      SmartOutreachDatabaseService.contactResultsTable,
      SmartOutreachContactResultModel(
        sessionId: sessionId,
        contactId: contactId,
        resultType: resultType,
        timestamp: now,
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return advanceSession(sessionId);
  }

  Future<SmartOutreachSessionBundle?> advanceSession(int sessionId) async {
    final bundle = await _loadSessionBundle(sessionId);
    if (bundle == null) {
      return null;
    }

    if (bundle.session.status != SmartOutreachSessionStatus.active) {
      return bundle;
    }

    if (bundle.isFullyCompleted) {
      await _markSessionCompleted(sessionId);
      return _loadSessionBundle(sessionId);
    }

    final nextIndex = bundle.firstIncompleteIndex();

    await _db.update(
      SmartOutreachDatabaseService.sessionsTable,
      {'current_index': nextIndex},
      where: 'id = ?',
      whereArgs: [sessionId],
    );

    return _loadSessionBundle(sessionId);
  }

  Future<SmartOutreachSessionBundle?> moveToIndex({
    required int sessionId,
    required int index,
  }) async {
    final bundle = await _loadSessionBundle(sessionId);
    if (bundle == null) {
      return null;
    }

    if (bundle.scheduleBundle.contacts.isEmpty) {
      return bundle;
    }

    final safeIndex = index.clamp(0, bundle.scheduleBundle.contacts.length - 1);
    await _db.update(
      SmartOutreachDatabaseService.sessionsTable,
      {'current_index': safeIndex},
      where: 'id = ?',
      whereArgs: [sessionId],
    );

    return _loadSessionBundle(sessionId);
  }

  Future<SmartOutreachSessionBundle?> finishSession(
    int sessionId, {
    bool markRemainingAsSkipped = false,
  }) async {
    final bundle = await _loadSessionBundle(sessionId);
    if (bundle == null) {
      return null;
    }

    if (markRemainingAsSkipped) {
      for (final contact in bundle.scheduleBundle.contacts) {
        if (contact.id == null) {
          continue;
        }

        if (!bundle.isContactCompleted(contact)) {
          await addContactResultAndRefresh(
            sessionId: sessionId,
            contactId: contact.id!,
            resultType: SmartOutreachContactResultType.skipped,
          );
        }
      }
    }

    await _markSessionCompleted(sessionId);
    return _loadSessionBundle(sessionId);
  }

  Future<void> _markSessionCompleted(int sessionId) {
    final now = DateTime.now().toIso8601String();
    return _db.update(
      SmartOutreachDatabaseService.sessionsTable,
      {
        'status': SmartOutreachSessionStatus.completed.dbValue,
        'completed_at': now,
      },
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<SmartOutreachSessionBundle?> _loadSessionBundle(int sessionId) async {
    final db = await _db.database;

    final sessionRows = await db.query(
      SmartOutreachDatabaseService.sessionsTable,
      where: 'id = ?',
      whereArgs: [sessionId],
      limit: 1,
    );

    if (sessionRows.isEmpty) {
      return null;
    }

    var session = SmartOutreachSessionModel.fromMap(sessionRows.first);
    final scheduleBundle =
        await _scheduleRepository.getScheduleById(session.scheduleId);
    if (scheduleBundle == null) {
      return null;
    }

    final resultsRows = await db.query(
      SmartOutreachDatabaseService.contactResultsTable,
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'timestamp ASC',
    );

    final results = resultsRows
        .map(SmartOutreachContactResultModel.fromMap)
        .toList(growable: false);

    final bundle = SmartOutreachSessionBundle(
      scheduleBundle: scheduleBundle,
      session: session,
      results: results,
    );

    if (session.status == SmartOutreachSessionStatus.active &&
        scheduleBundle.contacts.isNotEmpty) {
      final idealIndex = bundle.firstIncompleteIndex();
      if (idealIndex != session.currentIndex) {
        await _db.update(
          SmartOutreachDatabaseService.sessionsTable,
          {'current_index': idealIndex},
          where: 'id = ?',
          whereArgs: [sessionId],
        );

        session = session.copyWith(currentIndex: idealIndex);
      }

      if (bundle.isFullyCompleted) {
        await _markSessionCompleted(sessionId);
        session = session.copyWith(
          status: SmartOutreachSessionStatus.completed,
          completedAt: DateTime.now(),
        );
      }
    }

    return SmartOutreachSessionBundle(
      scheduleBundle: scheduleBundle,
      session: session,
      results: results,
    );
  }

  String _sessionDateKey(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
}
