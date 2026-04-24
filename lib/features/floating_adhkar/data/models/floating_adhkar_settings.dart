import 'package:equatable/equatable.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';

class FloatingAdhkarSettings extends Equatable {
  const FloatingAdhkarSettings({
    required this.enabled,
    required this.intervalMinutes,
    required this.visibleSeconds,
    required this.includeBuiltIn,
    required this.includeCustom,
    required this.mixSources,
    required this.updatedAt,
    this.lastItemId,
    this.lastSourceType,
  });

  factory FloatingAdhkarSettings.defaults() {
    return FloatingAdhkarSettings(
      enabled: false,
      intervalMinutes: 60,
      visibleSeconds: 20,
      includeBuiltIn: true,
      includeCustom: true,
      mixSources: true,
      updatedAt: DateTime.now(),
    );
  }

  factory FloatingAdhkarSettings.fromMap(Map<String, dynamic> map) {
    return FloatingAdhkarSettings(
      enabled: map['is_enabled'] == 1,
      intervalMinutes: (map['interval_minutes'] as int?) ?? 60,
      visibleSeconds: (map['visible_seconds'] as int?) ?? 20,
      includeBuiltIn: map['include_builtin'] != 0,
      includeCustom: map['include_custom'] != 0,
      mixSources: map['mix_sources'] != 0,
      lastItemId: map['last_item_id'] as String?,
      lastSourceType: FloatingAdhkarSourceTypeX.fromStorage(
        map['last_source'] as String?,
      ),
      updatedAt: DateTime.tryParse(map['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final bool enabled;
  final int intervalMinutes;
  final int visibleSeconds;
  final bool includeBuiltIn;
  final bool includeCustom;
  final bool mixSources;
  final String? lastItemId;
  final FloatingAdhkarSourceType? lastSourceType;
  final DateTime updatedAt;

  bool get hasAnySource => includeBuiltIn || includeCustom;

  Map<String, dynamic> toMap() => {
        'id': 1,
        'is_enabled': enabled ? 1 : 0,
        'interval_minutes': intervalMinutes,
        'visible_seconds': visibleSeconds,
        'include_builtin': includeBuiltIn ? 1 : 0,
        'include_custom': includeCustom ? 1 : 0,
        'mix_sources': mixSources ? 1 : 0,
        'last_item_id': lastItemId,
        'last_source': lastSourceType?.storageValue,
        'updated_at': updatedAt.toIso8601String(),
      };

  FloatingAdhkarSettings copyWith({
    bool? enabled,
    int? intervalMinutes,
    int? visibleSeconds,
    bool? includeBuiltIn,
    bool? includeCustom,
    bool? mixSources,
    String? lastItemId,
    FloatingAdhkarSourceType? lastSourceType,
    DateTime? updatedAt,
    bool clearLastItem = false,
    bool clearLastSource = false,
  }) {
    return FloatingAdhkarSettings(
      enabled: enabled ?? this.enabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      visibleSeconds: visibleSeconds ?? this.visibleSeconds,
      includeBuiltIn: includeBuiltIn ?? this.includeBuiltIn,
      includeCustom: includeCustom ?? this.includeCustom,
      mixSources: mixSources ?? this.mixSources,
      lastItemId: clearLastItem ? null : lastItemId ?? this.lastItemId,
      lastSourceType:
          clearLastSource ? null : lastSourceType ?? this.lastSourceType,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        enabled,
        intervalMinutes,
        visibleSeconds,
        includeBuiltIn,
        includeCustom,
        mixSources,
        lastItemId,
        lastSourceType,
        updatedAt,
      ];
}
