import 'package:quran_app/l10n/l10n.dart';

enum SmartOutreachActionType {
  callOnly,
}

extension SmartOutreachActionTypeX on SmartOutreachActionType {
  String get dbValue => 'call_only';

  String get label => L10nService.current.outreachActionCallOnly;

  static SmartOutreachActionType fromDbValue(String raw) {
    return SmartOutreachActionType.callOnly;
  }
}
