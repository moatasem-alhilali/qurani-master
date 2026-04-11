import 'package:equatable/equatable.dart';

class WordExplanation extends Equatable {
  const WordExplanation({
    required this.word,
    required this.meaning,
  });

  factory WordExplanation.fromJson(Map<String, dynamic> json) {
    return WordExplanation(
      word: json['word'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
    );
  }

  final String word;
  final String meaning;

  @override
  List<Object?> get props => [word, meaning];
}

class WirdModel extends Equatable {
  const WirdModel({
    required this.title,
    required this.text,
    required this.counter,
    required this.type,
    required this.virtue,
    required this.source,
    required this.sourceUrl,
    required this.audioUrl,
    required this.hadithText,
    required this.wordExplanations,
  });

  factory WirdModel.fromJson(Map<String, dynamic> json) {
    final explanations =
        (json['word_explanations'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(WordExplanation.fromJson)
            .toList();

    return WirdModel(
      title: json['title'] as String? ?? '',
      text: json['text'] as String,
      counter: _toInt(json['counter']),
      type: _toInt(json['type']),
      virtue: json['virtue'] as String? ?? '',
      source: json['source'] as String? ?? '',
      sourceUrl: json['source_url'] as String? ?? '',
      audioUrl: json['audio_url'] as String? ?? '',
      hadithText: json['hadith_text'] as String? ?? '',
      wordExplanations: explanations,
    );
  }
  final String title;
  final String text;
  final int counter;
  final int type;
  final String virtue;
  final String source;
  final String sourceUrl;
  final String audioUrl;
  final String hadithText;
  final List<WordExplanation> wordExplanations;

  bool isForPeriod(bool isMorning) {
    if (type == 0) return true;
    if (isMorning) return type == 1;
    return type == 2;
  }

  @override
  List<Object?> get props => [
        title,
        text,
        counter,
        type,
        virtue,
        source,
        sourceUrl,
        audioUrl,
        hadithText,
        wordExplanations,
      ];
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
