import 'dart:convert';

import 'package:equatable/equatable.dart';

class DailyWirdContentEntry extends Equatable {
  const DailyWirdContentEntry({
    required this.key,
    required this.title,
    required this.text,
    required this.source,
    required this.fadhl,
  });

  factory DailyWirdContentEntry.fromJson(
      String key, Map<String, dynamic> json) {
    return DailyWirdContentEntry(
      key: key,
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      source: json['source'] as String? ?? '',
      fadhl: json['fadhl'] as String? ?? '',
    );
  }

  factory DailyWirdContentEntry.fromMap(Map<String, dynamic> map) {
    return DailyWirdContentEntry(
      key: map['key'] as String? ?? '',
      title: map['title'] as String? ?? '',
      text: map['text'] as String? ?? '',
      source: map['source'] as String? ?? '',
      fadhl: map['fadhl'] as String? ?? '',
    );
  }

  final String key;
  final String title;
  final String text;
  final String source;
  final String fadhl;

  Map<String, dynamic> toMap() => {
        'key': key,
        'title': title,
        'text': text,
        'source': source,
        'fadhl': fadhl,
      };

  static String encodeList(List<DailyWirdContentEntry> items) {
    return jsonEncode(items.map((item) => item.toMap()).toList());
  }

  static List<DailyWirdContentEntry> decodeList(String? value) {
    if (value == null || value.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(value) as List<dynamic>;
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(DailyWirdContentEntry.fromMap)
        .toList();
  }

  @override
  List<Object?> get props => [key, title, text, source, fadhl];
}
