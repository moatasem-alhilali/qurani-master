import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_schedule_model.dart';

class SmartOutreachNativeSchedulerService {
  static const MethodChannel _channel = MethodChannel(
    'com.tamaneena.tamaneena_app/smart_outreach',
  );

  Future<void> scheduleGroup(
    SmartOutreachScheduleModel schedule, {
    List<String> phoneNumbers = const <String>[],
  }) async {
    if (!(Platform.isAndroid || Platform.isIOS) || schedule.id == null) {
      return;
    }

    await _channel.invokeMethod<void>(
      'scheduleGroup',
      <String, dynamic>{
        'groupId': schedule.id,
        'title': schedule.title,
        'time': schedule.scheduleTime,
        'days': jsonEncode(
          schedule.isDaily ? const <int>[] : schedule.scheduleDays,
        ),
        'phoneNumbers': phoneNumbers,
      },
    );
  }

  Future<void> cancelGroup(int scheduleId) async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return;
    }

    await _channel.invokeMethod<void>(
      'cancelGroup',
      <String, dynamic>{'groupId': scheduleId},
    );
  }

  Future<void> triggerGroupNow(
    int scheduleId, {
    List<String> phoneNumbers = const <String>[],
  }) async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return;
    }

    await _channel.invokeMethod<void>(
      'triggerGroupNow',
      <String, dynamic>{
        'groupId': scheduleId,
        'phoneNumbers': phoneNumbers,
      },
    );
  }

  Future<void> openBatterySettings() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return;
    }

    await _channel.invokeMethod<void>('openBatterySettings');
  }
}
