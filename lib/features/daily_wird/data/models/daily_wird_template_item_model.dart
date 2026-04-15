import 'package:equatable/equatable.dart';

class DailyWirdTemplateItem extends Equatable {
  const DailyWirdTemplateItem({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.timeCategory,
    required this.hasCounter,
    required this.hasAudio,
    required this.audioUrl,
    required this.orderIndex,
    required this.isActive,
    required this.isCustomizable,
    required this.contentMode,
    required this.referenceKeys,
    required this.activeDays,
    this.referenceKey,
    this.countRequired,
    this.defaultCountStep,
    this.countUnit,
  });

  factory DailyWirdTemplateItem.fromJson(Map<String, dynamic> json) {
    return DailyWirdTemplateItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      category: json['category'] as String? ?? '',
      timeCategory: json['time_category'] as String? ?? 'anytime',
      hasCounter: json['has_counter'] == true,
      hasAudio: json['has_audio'] == true,
      audioUrl: json['audio_url'] as String?,
      orderIndex: _toInt(json['order_index']),
      isActive: json['is_active'] != false,
      isCustomizable: json['is_customizable'] != false,
      contentMode: json['content_mode'] as String? ?? 'single',
      referenceKey: json['reference_key'] as String?,
      referenceKeys: (json['reference_keys'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      activeDays: (json['active_days'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .map((day) => day.toLowerCase())
          .toList(),
      countRequired: _nullableInt(json['count_required']),
      defaultCountStep: _nullableInt(json['default_count_step']),
      countUnit: json['count_unit'] as String?,
    );
  }

  final String id;
  final String title;
  final String type;
  final String category;
  final String timeCategory;
  final bool hasCounter;
  final bool hasAudio;
  final String? audioUrl;
  final int orderIndex;
  final bool isActive;
  final bool isCustomizable;
  final String contentMode;
  final String? referenceKey;
  final List<String> referenceKeys;
  final List<String> activeDays;
  final int? countRequired;
  final int? defaultCountStep;
  final String? countUnit;

  bool get isCollection => contentMode == 'collection';

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        category,
        timeCategory,
        hasCounter,
        hasAudio,
        audioUrl,
        orderIndex,
        isActive,
        isCustomizable,
        contentMode,
        referenceKey,
        referenceKeys,
        activeDays,
        countRequired,
        defaultCountStep,
        countUnit,
      ];
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}

int? _nullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value');
}
