enum SmartOutreachActionType {
  callOnly,
}

extension SmartOutreachActionTypeX on SmartOutreachActionType {
  String get dbValue => 'call_only';

  String get label => 'اتصال فقط';

  static SmartOutreachActionType fromDbValue(String raw) {
    return SmartOutreachActionType.callOnly;
  }
}
