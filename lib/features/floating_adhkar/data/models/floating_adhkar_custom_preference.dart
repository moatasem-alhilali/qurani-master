import 'package:equatable/equatable.dart';

class FloatingAdhkarCustomPreference extends Equatable {
  const FloatingAdhkarCustomPreference({
    required this.subihId,
    required this.isEnabled,
    required this.updatedAt,
  });

  factory FloatingAdhkarCustomPreference.fromMap(Map<String, dynamic> map) {
    return FloatingAdhkarCustomPreference(
      subihId: (map['subih_id'] as int?) ?? 0,
      isEnabled: map['is_enabled'] != 0,
      updatedAt: DateTime.tryParse(map['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final int subihId;
  final bool isEnabled;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() => {
        'subih_id': subihId,
        'is_enabled': isEnabled ? 1 : 0,
        'updated_at': updatedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [subihId, isEnabled, updatedAt];
}
