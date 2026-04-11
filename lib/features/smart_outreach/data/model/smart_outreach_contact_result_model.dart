import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';

class SmartOutreachContactResultModel {
  const SmartOutreachContactResultModel({
    this.id,
    required this.sessionId,
    required this.contactId,
    required this.resultType,
    required this.timestamp,
  });

  factory SmartOutreachContactResultModel.fromMap(Map<String, dynamic> map) {
    return SmartOutreachContactResultModel(
      id: map['id'] as int?,
      sessionId: (map['session_id'] as num?)?.toInt() ?? 0,
      contactId: (map['contact_id'] as num?)?.toInt() ?? 0,
      resultType: SmartOutreachContactResultTypeX.fromDbValue(
        (map['result_type'] as String? ?? 'skipped').trim(),
      ),
      timestamp: DateTime.tryParse((map['timestamp'] as String?) ?? '') ??
          DateTime.now(),
    );
  }

  final int? id;
  final int sessionId;
  final int contactId;
  final SmartOutreachContactResultType resultType;
  final DateTime timestamp;

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'session_id': sessionId,
      'contact_id': contactId,
      'result_type': resultType.dbValue,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
