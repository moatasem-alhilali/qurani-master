import 'package:quran_app/features/smart_outreach/data/database/smart_outreach_database_service.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_schedule_model.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_native_scheduler_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_validation_service.dart';
import 'package:sqflite/sqflite.dart';

class SmartOutreachSaveScheduleResult {
  const SmartOutreachSaveScheduleResult({
    required this.validation,
    this.scheduleId,
  });

  final SmartOutreachValidationResult validation;
  final int? scheduleId;

  bool get isSuccess => validation.isValid && scheduleId != null;
}

class SmartOutreachCallLogEntry {
  const SmartOutreachCallLogEntry({
    required this.id,
    required this.groupId,
    required this.number,
    required this.status,
    required this.reason,
    required this.duration,
    required this.calledAt,
  });

  factory SmartOutreachCallLogEntry.fromMap(Map<String, dynamic> map) {
    return SmartOutreachCallLogEntry(
      id: (map['id'] as num?)?.toInt() ?? 0,
      groupId: (map['group_id'] as num?)?.toInt() ?? 0,
      number: (map['number'] as String? ?? '').trim(),
      status: (map['status'] as String? ?? '').trim(),
      reason: (map['reason'] as String?)?.trim(),
      duration: (map['duration'] as num?)?.toInt() ?? 0,
      calledAt: DateTime.tryParse((map['called_at'] as String?) ?? '') ??
          DateTime.now(),
    );
  }

  final int id;
  final int groupId;
  final String number;
  final String status;
  final String? reason;
  final int duration;
  final DateTime calledAt;
}

class SmartOutreachCallStats {
  const SmartOutreachCallStats({
    required this.total,
    required this.answered,
    required this.notAnswered,
    required this.failed,
  });

  final int total;
  final int answered;
  final int notAnswered;
  final int failed;
}

class SmartOutreachScheduleRepository {
  SmartOutreachScheduleRepository({
    required SmartOutreachDatabaseService databaseService,
    required SmartOutreachValidationService validationService,
    required SmartOutreachNativeSchedulerService nativeSchedulerService,
  })  : _databaseService = databaseService,
        _validationService = validationService,
        _nativeSchedulerService = nativeSchedulerService;

  final SmartOutreachDatabaseService _databaseService;
  final SmartOutreachValidationService _validationService;
  final SmartOutreachNativeSchedulerService _nativeSchedulerService;

  Future<List<SmartOutreachScheduleBundle>> getAllSchedules() async {
    await _databaseService.ensureTables();
    final db = await _databaseService.database;

    final scheduleRows = await db.query(
      SmartOutreachDatabaseService.schedulesTable,
      orderBy: 'created_at ASC',
    );

    return _hydrateBundles(db, scheduleRows);
  }

  Future<SmartOutreachScheduleBundle?> getScheduleById(int scheduleId) async {
    await _databaseService.ensureTables();
    final db = await _databaseService.database;

    final rows = await db.query(
      SmartOutreachDatabaseService.schedulesTable,
      where: 'id = ?',
      whereArgs: <Object>[scheduleId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return _hydrateBundle(db, rows.first);
  }

  Future<SmartOutreachSaveScheduleResult> saveSchedule({
    required String title,
    required int hour,
    required int minute,
    required bool isEnabled,
    required bool isDaily,
    required List<int> scheduleDays,
    required int ringTimeout,
    required int hangupDelay,
    required int delayBetweenCalls,
    required bool stopOnFirstAnswered,
    required bool retryEnabled,
    required bool repeatCycle,
    required List<SmartOutreachContactDraft> contacts,
    int? scheduleId,
    String? note,
    String? smsTemplate,
  }) async {
    await _databaseService.ensureTables();

    final validation = _validationService.validateScheduleDraft(
      title: title,
      contacts: contacts,
      isEnabled: isEnabled,
      isDaily: isDaily,
      scheduleDays: scheduleDays,
    );
    if (!validation.isValid) {
      return SmartOutreachSaveScheduleResult(validation: validation);
    }

    final db = await _databaseService.database;
    final now = DateTime.now();
    var createdAt = now;

    if (scheduleId != null) {
      final existing = await getScheduleById(scheduleId);
      createdAt = existing?.schedule.createdAt ?? now;
    }

    final normalizedScheduleDays =
        isDaily ? <int>[] : (List<int>.from(scheduleDays)..sort());

    final model = SmartOutreachScheduleModel(
      id: scheduleId,
      title: title.trim(),
      note: note?.trim().isEmpty ?? false ? null : note?.trim(),
      isEnabled: isEnabled,
      scheduleTime: '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}',
      scheduleDays: normalizedScheduleDays,
      isDaily: isDaily,
      ringTimeout: ringTimeout,
      hangupDelay: hangupDelay,
      retryEnabled: retryEnabled,
      delayBetweenCalls: delayBetweenCalls,
      stopOnFirstAnswered: stopOnFirstAnswered,
      repeatCycle: repeatCycle,
      smsTemplate:
          smsTemplate?.trim().isEmpty ?? false ? null : smsTemplate?.trim(),
      createdAt: createdAt,
      updatedAt: now,
    );

    final savedId = await db.transaction<int>((txn) async {
      late final int finalId;
      if (scheduleId == null) {
        finalId = await txn.insert(
          SmartOutreachDatabaseService.schedulesTable,
          model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        finalId = scheduleId;
        await txn.update(
          SmartOutreachDatabaseService.schedulesTable,
          model.toMap(),
          where: 'id = ?',
          whereArgs: <Object>[scheduleId],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await txn.delete(
          SmartOutreachDatabaseService.contactsTable,
          where: 'group_id = ?',
          whereArgs: <Object>[scheduleId],
        );
      }

      for (var i = 0; i < contacts.length; i++) {
        final contact = contacts[i].toModel(scheduleId: finalId, order: i);
        await txn.insert(
          SmartOutreachDatabaseService.contactsTable,
          contact.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return finalId;
    });

    final saved = await getScheduleById(savedId);
    if (saved != null && saved.schedule.isEnabled) {
      await _nativeSchedulerService.scheduleGroup(
        saved.schedule,
        phoneNumbers: _phoneNumbersFor(saved.contacts),
      );
    } else {
      await _nativeSchedulerService.cancelGroup(savedId);
    }

    return SmartOutreachSaveScheduleResult(
      validation: SmartOutreachValidationResult.valid(),
      scheduleId: savedId,
    );
  }

  Future<SmartOutreachValidationResult> toggleScheduleEnabled(
    int scheduleId,
    bool enabled,
  ) async {
    final bundle = await getScheduleById(scheduleId);
    if (bundle == null) {
      return SmartOutreachValidationResult.invalid(
        <String>['هذه القائمة غير موجودة.'],
      );
    }

    final validation = _validationService.validateContactModels(
      bundle.schedule.title,
      bundle.contacts,
      enabled,
    );
    if (!validation.isValid) {
      return validation;
    }

    final db = await _databaseService.database;
    await db.update(
      SmartOutreachDatabaseService.schedulesTable,
      <String, Object>{'is_enabled': enabled ? 1 : 0},
      where: 'id = ?',
      whereArgs: <Object>[scheduleId],
    );

    final updated = await getScheduleById(scheduleId);
    if (updated == null) {
      return SmartOutreachValidationResult.invalid(
        <String>['هذه القائمة غير موجودة.'],
      );
    }

    if (enabled) {
      await _nativeSchedulerService.scheduleGroup(
        updated.schedule,
        phoneNumbers: _phoneNumbersFor(updated.contacts),
      );
    } else {
      await _nativeSchedulerService.cancelGroup(scheduleId);
    }

    return SmartOutreachValidationResult.valid();
  }

  Future<void> deleteSchedule(int scheduleId) async {
    final db = await _databaseService.database;
    await _nativeSchedulerService.cancelGroup(scheduleId);

    await db.transaction((txn) async {
      await txn.delete(
        SmartOutreachDatabaseService.contactsTable,
        where: 'group_id = ?',
        whereArgs: <Object>[scheduleId],
      );
      await txn.delete(
        SmartOutreachDatabaseService.schedulesTable,
        where: 'id = ?',
        whereArgs: <Object>[scheduleId],
      );
    });
  }

  Future<void> startScheduleNow(int scheduleId) async {
    final bundle = await getScheduleById(scheduleId);
    final phoneNumbers = _phoneNumbersFor(bundle?.contacts ?? const []);

    await _nativeSchedulerService.triggerGroupNow(
      scheduleId,
      phoneNumbers: phoneNumbers,
    );
  }

  Future<void> openBatterySettings() {
    return _nativeSchedulerService.openBatterySettings();
  }

  List<String> _phoneNumbersFor(List<SmartOutreachContactModel> contacts) {
    return contacts
        .map((contact) => contact.phone.trim())
        .where((number) => number.isNotEmpty)
        .toList(growable: false);
  }

  Future<List<SmartOutreachCallLogEntry>> getCallLogs({
    int? scheduleId,
    int limit = 200,
  }) async {
    final db = await _databaseService.database;
    final rows = await db.query(
      SmartOutreachDatabaseService.callLogsTable,
      where: scheduleId == null ? null : 'group_id = ?',
      whereArgs: scheduleId == null ? null : <Object>[scheduleId],
      orderBy: 'called_at DESC',
      limit: limit,
    );
    return rows.map(SmartOutreachCallLogEntry.fromMap).toList(growable: false);
  }

  Future<SmartOutreachCallStats> getCallStats() async {
    final db = await _databaseService.database;

    Future<int> count(String sql) async {
      final rows = await db.rawQuery(sql);
      return (rows.first['c'] as num?)?.toInt() ?? 0;
    }

    return SmartOutreachCallStats(
      total: await count(
        'SELECT COUNT(*) AS c FROM '
        '${SmartOutreachDatabaseService.callLogsTable}',
      ),
      answered: await count(
        'SELECT COUNT(*) AS c FROM '
        '${SmartOutreachDatabaseService.callLogsTable} '
        "WHERE status = 'answered'",
      ),
      notAnswered: await count(
        'SELECT COUNT(*) AS c FROM '
        '${SmartOutreachDatabaseService.callLogsTable} '
        "WHERE status = 'not_answered'",
      ),
      failed: await count(
        'SELECT COUNT(*) AS c FROM '
        '${SmartOutreachDatabaseService.callLogsTable} '
        "WHERE status = 'failed'",
      ),
    );
  }

  Future<void> clearAllCallLogs() async {
    final db = await _databaseService.database;
    await db.delete(SmartOutreachDatabaseService.callLogsTable);
  }

  Future<void> clearCallLogsForSchedule(int scheduleId) async {
    final db = await _databaseService.database;
    await db.delete(
      SmartOutreachDatabaseService.callLogsTable,
      where: 'group_id = ?',
      whereArgs: <Object>[scheduleId],
    );
  }

  Future<SmartOutreachScheduleBundle?> _hydrateBundle(
    Database db,
    Map<String, dynamic> scheduleRow,
  ) async {
    final schedule = SmartOutreachScheduleModel.fromMap(scheduleRow);
    final contactsRows = await db.query(
      SmartOutreachDatabaseService.contactsTable,
      where: 'group_id = ?',
      whereArgs: <Object>[schedule.id ?? -1],
      orderBy: 'sort_order ASC',
    );
    return SmartOutreachScheduleBundle(
      schedule: schedule,
      contacts: contactsRows
          .map(SmartOutreachContactModel.fromMap)
          .toList(growable: false),
    );
  }

  Future<List<SmartOutreachScheduleBundle>> _hydrateBundles(
    Database db,
    List<Map<String, dynamic>> scheduleRows,
  ) async {
    final result = <SmartOutreachScheduleBundle>[];
    for (final row in scheduleRows) {
      final bundle = await _hydrateBundle(db, row);
      if (bundle != null) {
        result.add(bundle);
      }
    }
    return result;
  }
}
