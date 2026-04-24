import 'package:equatable/equatable.dart';

class FloatingAdhkarBuiltInOverride extends Equatable {
  const FloatingAdhkarBuiltInOverride({
    required this.itemId,
    required this.isDeleted,
    required this.updatedAt,
    this.customTitle,
    this.customText,
  });

  factory FloatingAdhkarBuiltInOverride.fromMap(Map<String, dynamic> map) {
    return FloatingAdhkarBuiltInOverride(
      itemId: map['item_id'] as String,
      customTitle: map['custom_title'] as String?,
      customText: map['custom_text'] as String?,
      isDeleted: map['is_deleted'] == 1,
      updatedAt: DateTime.tryParse(map['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final String itemId;
  final String? customTitle;
  final String? customText;
  final bool isDeleted;
  final DateTime updatedAt;

  bool get hasCustomTitle =>
      customTitle != null && customTitle!.trim().isNotEmpty;
  bool get hasCustomText => customText != null && customText!.trim().isNotEmpty;
  bool get hasAnyOverride => hasCustomTitle || hasCustomText || isDeleted;

  Map<String, dynamic> toMap() => {
        'item_id': itemId,
        'custom_title': customTitle,
        'custom_text': customText,
        'is_deleted': isDeleted ? 1 : 0,
        'updated_at': updatedAt.toIso8601String(),
      };

  FloatingAdhkarBuiltInOverride copyWith({
    String? customTitle,
    String? customText,
    bool? isDeleted,
    DateTime? updatedAt,
    bool clearCustomTitle = false,
    bool clearCustomText = false,
  }) {
    return FloatingAdhkarBuiltInOverride(
      itemId: itemId,
      customTitle: clearCustomTitle ? null : customTitle ?? this.customTitle,
      customText: clearCustomText ? null : customText ?? this.customText,
      isDeleted: isDeleted ?? this.isDeleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        customTitle,
        customText,
        isDeleted,
        updatedAt,
      ];
}
