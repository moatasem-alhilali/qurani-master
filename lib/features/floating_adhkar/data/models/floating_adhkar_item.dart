import 'package:equatable/equatable.dart';
import 'package:quran_app/l10n/l10n.dart';

enum FloatingAdhkarSourceType {
  builtIn,
  custom,
}

extension FloatingAdhkarSourceTypeX on FloatingAdhkarSourceType {
  String get storageValue {
    switch (this) {
      case FloatingAdhkarSourceType.builtIn:
        return 'built_in';
      case FloatingAdhkarSourceType.custom:
        return 'custom';
    }
  }

  String label(L10n l10n) {
    switch (this) {
      case FloatingAdhkarSourceType.builtIn:
        return l10n.floatingAdhkarSourceBuiltIn;
      case FloatingAdhkarSourceType.custom:
        return l10n.floatingAdhkarSourceCustom;
    }
  }

  static FloatingAdhkarSourceType? fromStorage(String? value) {
    switch (value) {
      case 'built_in':
        return FloatingAdhkarSourceType.builtIn;
      case 'custom':
        return FloatingAdhkarSourceType.custom;
      default:
        return null;
    }
  }
}

class FloatingAdhkarItem extends Equatable {
  const FloatingAdhkarItem({
    required this.id,
    required this.title,
    required this.text,
    required this.sourceType,
    required this.sourceLabel,
    this.customAdhkarId,
    this.originalTitle,
    this.originalText,
    this.isDeleted = false,
  });

  final String id;
  final String title;
  final String text;
  final FloatingAdhkarSourceType sourceType;
  final String sourceLabel;
  final int? customAdhkarId;
  final String? originalTitle;
  final String? originalText;
  final bool isDeleted;

  bool get isCustom => sourceType == FloatingAdhkarSourceType.custom;
  bool get isBuiltIn => sourceType == FloatingAdhkarSourceType.builtIn;
  bool get isBuiltInEdited =>
      isBuiltIn &&
      ((originalTitle ?? title) != title || (originalText ?? text) != text);

  String get normalizedText => text.replaceAll('\n', ' ').trim();

  FloatingAdhkarItem copyWith({
    String? title,
    String? text,
    String? sourceLabel,
    int? customAdhkarId,
    String? originalTitle,
    String? originalText,
    bool? isDeleted,
  }) {
    return FloatingAdhkarItem(
      id: id,
      title: title ?? this.title,
      text: text ?? this.text,
      sourceType: sourceType,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      customAdhkarId: customAdhkarId ?? this.customAdhkarId,
      originalTitle: originalTitle ?? this.originalTitle,
      originalText: originalText ?? this.originalText,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        text,
        sourceType,
        sourceLabel,
        customAdhkarId,
        originalTitle,
        originalText,
        isDeleted,
      ];
}
