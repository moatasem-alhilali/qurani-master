enum SmartOutreachActionType {
  callOnly,
  smsOnly,
  callThenSms,
}

extension SmartOutreachActionTypeX on SmartOutreachActionType {
  String get dbValue {
    switch (this) {
      case SmartOutreachActionType.callOnly:
        return 'call_only';
      case SmartOutreachActionType.smsOnly:
        return 'sms_only';
      case SmartOutreachActionType.callThenSms:
        return 'call_then_sms';
    }
  }

  String get label {
    switch (this) {
      case SmartOutreachActionType.callOnly:
        return 'اتصال فقط';
      case SmartOutreachActionType.smsOnly:
        return 'رسالة نصية فقط';
      case SmartOutreachActionType.callThenSms:
        return 'اتصال ثم رسالة نصية';
    }
  }

  bool get includesCall =>
      this == SmartOutreachActionType.callOnly ||
      this == SmartOutreachActionType.callThenSms;

  bool get includesSms =>
      this == SmartOutreachActionType.smsOnly ||
      this == SmartOutreachActionType.callThenSms;

  static SmartOutreachActionType fromDbValue(String raw) {
    switch (raw) {
      case 'call_only':
        return SmartOutreachActionType.callOnly;
      case 'sms_only':
        return SmartOutreachActionType.smsOnly;
      case 'call_then_sms':
        return SmartOutreachActionType.callThenSms;
      default:
        return SmartOutreachActionType.callOnly;
    }
  }
}

enum SmartOutreachContactResultType {
  answered,
  notAnswered,
  smsSent,
  skipped,
}

extension SmartOutreachContactResultTypeX on SmartOutreachContactResultType {
  String get dbValue {
    switch (this) {
      case SmartOutreachContactResultType.answered:
        return 'answered';
      case SmartOutreachContactResultType.notAnswered:
        return 'not_answered';
      case SmartOutreachContactResultType.smsSent:
        return 'sms_sent';
      case SmartOutreachContactResultType.skipped:
        return 'skipped';
    }
  }

  String get label {
    switch (this) {
      case SmartOutreachContactResultType.answered:
        return 'تم الرد';
      case SmartOutreachContactResultType.notAnswered:
        return 'لم يتم الرد';
      case SmartOutreachContactResultType.smsSent:
        return 'تم إرسال الرسالة';
      case SmartOutreachContactResultType.skipped:
        return 'تم التخطي';
    }
  }

  static SmartOutreachContactResultType fromDbValue(String raw) {
    switch (raw) {
      case 'answered':
        return SmartOutreachContactResultType.answered;
      case 'not_answered':
        return SmartOutreachContactResultType.notAnswered;
      case 'sms_sent':
        return SmartOutreachContactResultType.smsSent;
      case 'skipped':
        return SmartOutreachContactResultType.skipped;
      default:
        return SmartOutreachContactResultType.skipped;
    }
  }
}

enum SmartOutreachSessionStatus {
  active,
  completed,
  abandoned,
}

extension SmartOutreachSessionStatusX on SmartOutreachSessionStatus {
  String get dbValue {
    switch (this) {
      case SmartOutreachSessionStatus.active:
        return 'active';
      case SmartOutreachSessionStatus.completed:
        return 'completed';
      case SmartOutreachSessionStatus.abandoned:
        return 'abandoned';
    }
  }

  static SmartOutreachSessionStatus fromDbValue(String raw) {
    switch (raw) {
      case 'active':
        return SmartOutreachSessionStatus.active;
      case 'completed':
        return SmartOutreachSessionStatus.completed;
      case 'abandoned':
        return SmartOutreachSessionStatus.abandoned;
      default:
        return SmartOutreachSessionStatus.active;
    }
  }
}

enum SmartOutreachSessionTriggerSource {
  notification,
  manual,
  recovery,
}

extension SmartOutreachSessionTriggerSourceX
    on SmartOutreachSessionTriggerSource {
  String get dbValue {
    switch (this) {
      case SmartOutreachSessionTriggerSource.notification:
        return 'notification';
      case SmartOutreachSessionTriggerSource.manual:
        return 'manual';
      case SmartOutreachSessionTriggerSource.recovery:
        return 'recovery';
    }
  }

  static SmartOutreachSessionTriggerSource fromDbValue(String raw) {
    switch (raw) {
      case 'notification':
        return SmartOutreachSessionTriggerSource.notification;
      case 'manual':
        return SmartOutreachSessionTriggerSource.manual;
      case 'recovery':
        return SmartOutreachSessionTriggerSource.recovery;
      default:
        return SmartOutreachSessionTriggerSource.manual;
    }
  }
}
