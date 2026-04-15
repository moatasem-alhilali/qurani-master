import 'package:equatable/equatable.dart';

class DailyWirdCustomization extends Equatable {
  const DailyWirdCustomization({
    required this.itemId,
    required this.isHidden,
    required this.updatedAt,
    this.customCountRequired,
    this.orderIndex,
  });

  factory DailyWirdCustomization.fromMap(Map<String, dynamic> map) {
    return DailyWirdCustomization(
      itemId: map['item_id'] as String? ?? '',
      isHidden: map['is_hidden'] == 1,
      customCountRequired: map['custom_count_required'] as int?,
      orderIndex: map['order_index'] as int?,
      updatedAt: DateTime.tryParse(map['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final String itemId;
  final bool isHidden;
  final int? customCountRequired;
  final int? orderIndex;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() => {
        'item_id': itemId,
        'is_hidden': isHidden ? 1 : 0,
        'custom_count_required': customCountRequired,
        'order_index': orderIndex,
        'updated_at': updatedAt.toIso8601String(),
      };

  DailyWirdCustomization copyWith({
    String? itemId,
    bool? isHidden,
    int? customCountRequired,
    int? orderIndex,
    DateTime? updatedAt,
    bool clearCustomCountRequired = false,
    bool clearOrderIndex = false,
  }) {
    return DailyWirdCustomization(
      itemId: itemId ?? this.itemId,
      isHidden: isHidden ?? this.isHidden,
      customCountRequired: clearCustomCountRequired
          ? null
          : customCountRequired ?? this.customCountRequired,
      orderIndex: clearOrderIndex ? null : orderIndex ?? this.orderIndex,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        isHidden,
        customCountRequired,
        orderIndex,
        updatedAt,
      ];
}
