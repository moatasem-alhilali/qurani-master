import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/smart_outreach/data/database/smart_outreach_database_service.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_schedule_model.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_notification_service.dart';
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

class SmartOutreachScheduleRepository {
  SmartOutreachScheduleRepository({
    required SmartOutreachDatabaseService databaseService,
    required SmartOutreachValidationService validationService,
    required SmartOutreachNotificationService notificationService,
  })  : _databaseService = databaseService,
        _validationService = validationService,
        _notificationService = notificationService;

  final SmartOutreachDatabaseService _databaseService;
  final SmartOutreachValidationService _validationService;
  final SmartOutreachNotificationService _notificationService;

  final DatabaseService _db = DatabaseService();

  Future<List<SmartOutreachScheduleBundle>> getAllSchedules() async {
    await _databaseService.ensureTables();
    final db = await _db.database;

    final schedulesRows = await db.query(
      SmartOutreachDatabaseService.schedulesTable,
      orderBy: 'daily_hour ASC, daily_minute ASC, updated_at DESC',
    );

    final contactsRows = await db.query(
      SmartOutreachDatabaseService.contactsTable,
      orderBy: 'schedule_id ASC, contact_order ASC',
    );

    final contactsBySchedule = <int, List<SmartOutreachContactModel>>{};
    for (final row in contactsRows) {
      final contact = SmartOutreachContactModel.fromMap(row);
      contactsBySchedule.putIfAbsent(
          contact.scheduleId, () => <SmartOutreachContactModel>[]);
      contactsBySchedule[contact.scheduleId]!.add(contact);
    }

    return schedulesRows.map((row) {
      final schedule = SmartOutreachScheduleModel.fromMap(row);
      final contacts = (contactsBySchedule[schedule.id ?? -1] ??
          const <SmartOutreachContactModel>[])
        ..sort((a, b) => a.order.compareTo(b.order));

      return SmartOutreachScheduleBundle(
        schedule: schedule,
        contacts: List<SmartOutreachContactModel>.from(contacts),
      );
    }).toList();
  }

  Future<SmartOutreachScheduleBundle?> getScheduleById(int scheduleId) async {
    await _databaseService.ensureTables();
    final db = await _db.database;

    final scheduleRows = await db.query(
      SmartOutreachDatabaseService.schedulesTable,
      where: 'id = ?',
      whereArgs: [scheduleId],
      limit: 1,
    );

    if (scheduleRows.isEmpty) {
      return null;
    }

    final schedule = SmartOutreachScheduleModel.fromMap(scheduleRows.first);

    final contactsRows = await db.query(
      SmartOutreachDatabaseService.contactsTable,
      where: 'schedule_id = ?',
      whereArgs: [scheduleId],
      orderBy: 'contact_order ASC',
    );

    final contacts = contactsRows
        .map(SmartOutreachContactModel.fromMap)
        .toList(growable: false);

    return SmartOutreachScheduleBundle(
      schedule: schedule,
      contacts: contacts,
    );
  }

  Future<SmartOutreachSaveScheduleResult> saveSchedule({
    int? scheduleId,
    required String title,
    String? note,
    required int hour,
    required int minute,
    required bool isEnabled,
    String? smsTemplate,
    required List<SmartOutreachContactDraft> contacts,
  }) async {
    await _databaseService.ensureTables();

    final validation = _validationService.validateScheduleDraft(
      title: title,
      contacts: contacts,
      isEnabled: isEnabled,
    );

    if (!validation.isValid) {
      return SmartOutreachSaveScheduleResult(validation: validation);
    }

    final now = DateTime.now();
    final db = await _db.database;

    var createdAt = now;
    if (scheduleId != null) {
      final existing = await getScheduleById(scheduleId);
      if (existing != null) {
        createdAt = existing.schedule.createdAt;
      }
    }

    final scheduleModel = SmartOutreachScheduleModel(
      id: scheduleId,
      title: title.trim(),
      note: note?.trim().isEmpty == true ? null : note?.trim(),
      hour: hour,
      minute: minute,
      isEnabled: isEnabled,
      smsTemplate:
          smsTemplate?.trim().isEmpty == true ? null : smsTemplate?.trim(),
      createdAt: createdAt,
      updatedAt: now,
    );

    final savedScheduleId = await db.transaction<int>((txn) async {
      late int finalScheduleId;

      if (scheduleId == null) {
        finalScheduleId = await txn.insert(
          SmartOutreachDatabaseService.schedulesTable,
          scheduleModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        finalScheduleId = scheduleId;
        await txn.update(
          SmartOutreachDatabaseService.schedulesTable,
          scheduleModel.toMap(),
          where: 'id = ?',
          whereArgs: [scheduleId],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        await txn.delete(
          SmartOutreachDatabaseService.contactsTable,
          where: 'schedule_id = ?',
          whereArgs: [scheduleId],
        );

        await txn.update(
          SmartOutreachDatabaseService.sessionsTable,
          {
            'status': SmartOutreachSessionStatus.abandoned.dbValue,
            'completed_at': now.toIso8601String(),
          },
          where: 'schedule_id = ? AND status = ?',
          whereArgs: [scheduleId, SmartOutreachSessionStatus.active.dbValue],
        );
      }

      for (var i = 0; i < contacts.length; i++) {
        final model = contacts[i].toModel(
          scheduleId: finalScheduleId,
          order: i,
        );

        await txn.insert(
          SmartOutreachDatabaseService.contactsTable,
          model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return finalScheduleId;
    });

    final savedBundle = await getScheduleById(savedScheduleId);
    if (savedBundle != null && savedBundle.schedule.isEnabled) {
      await _notificationService.scheduleDailyFor(savedBundle.schedule);
    } else {
      await _notificationService.cancelForSchedule(savedScheduleId);
    }

    return SmartOutreachSaveScheduleResult(
      validation: SmartOutreachValidationResult.valid(),
      scheduleId: savedScheduleId,
    );
  }

  Future<SmartOutreachValidationResult> toggleScheduleEnabled(
    int scheduleId,
    bool enabled,
  ) async {
    await _databaseService.ensureTables();

    final bundle = await getScheduleById(scheduleId);
    if (bundle == null) {
      return SmartOutreachValidationResult.invalid(
        <String>['لم يتم العثور على الجدول.'],
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

    final now = DateTime.now().toIso8601String();
    await _db.update(
      SmartOutreachDatabaseService.schedulesTable,
      {
        'is_enabled': enabled ? 1 : 0,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [scheduleId],
    );

    final updatedBundle = await getScheduleById(scheduleId);
    if (updatedBundle == null) {
      return SmartOutreachValidationResult.invalid(
        <String>['لم يتم العثور على الجدول.'],
      );
    }

    if (enabled) {
      await _notificationService.scheduleDailyFor(updatedBundle.schedule);
    } else {
      await _notificationService.cancelForSchedule(scheduleId);
    }

    return SmartOutreachValidationResult.valid();
  }

  Future<void> deleteSchedule(int scheduleId) async {
    await _databaseService.ensureTables();

    final db = await _db.database;
    await db.transaction((txn) async {
      final sessions = await txn.query(
        SmartOutreachDatabaseService.sessionsTable,
        columns: <String>['id'],
        where: 'schedule_id = ?',
        whereArgs: [scheduleId],
      );

      for (final session in sessions) {
        final sessionId = (session['id'] as num?)?.toInt();
        if (sessionId == null) {
          continue;
        }

        await txn.delete(
          SmartOutreachDatabaseService.contactResultsTable,
          where: 'session_id = ?',
          whereArgs: [sessionId],
        );
      }

      await txn.delete(
        SmartOutreachDatabaseService.sessionsTable,
        where: 'schedule_id = ?',
        whereArgs: [scheduleId],
      );

      await txn.delete(
        SmartOutreachDatabaseService.contactsTable,
        where: 'schedule_id = ?',
        whereArgs: [scheduleId],
      );

      await txn.delete(
        SmartOutreachDatabaseService.schedulesTable,
        where: 'id = ?',
        whereArgs: [scheduleId],
      );
    });

    await _notificationService.cancelForSchedule(scheduleId);
  }

  Future<bool> schedulePreviewNotification(int scheduleId) async {
    await _databaseService.ensureTables();

    final bundle = await getScheduleById(scheduleId);
    if (bundle == null) {
      return false;
    }

    return _notificationService.schedulePreviewInFiveSeconds(bundle.schedule);
  }

  Future<bool> scheduleSnoozeNotification(int scheduleId) async {
    await _databaseService.ensureTables();

    final bundle = await getScheduleById(scheduleId);
    if (bundle == null) {
      return false;
    }

    return _notificationService.scheduleSnoozeInFiveMinutes(bundle.schedule);
  }
}
