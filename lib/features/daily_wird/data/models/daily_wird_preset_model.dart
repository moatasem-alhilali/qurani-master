import 'package:equatable/equatable.dart';

class DailyWirdPreset extends Equatable {
  const DailyWirdPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.itemIds,
  });

  factory DailyWirdPreset.fromJson(Map<String, dynamic> json) {
    return DailyWirdPreset(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      itemIds: (json['item_ids'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
    );
  }

  final String id;
  final String name;
  final String description;
  final List<String> itemIds;

  @override
  List<Object?> get props => [id, name, description, itemIds];
}
