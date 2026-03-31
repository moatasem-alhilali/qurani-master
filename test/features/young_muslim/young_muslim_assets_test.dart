import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final catalogFile = File('assets/json/young_muslim/catalog.json');
  final quizzesFile = File('assets/json/young_muslim/quizzes.json');

  group('Young Muslim assets', () {
    test('catalog uses normalized asset paths and bumped seed version', () {
      final catalog =
          jsonDecode(catalogFile.readAsStringSync()) as Map<String, dynamic>;
      final series =
          (catalog['series'] as List<dynamic>).cast<Map<String, dynamic>>();

      expect((catalog['version'] as num).toInt(), greaterThan(1));
      expect(
        series.every((item) {
          final fileName = item['file_name'] as String;
          return fileName.startsWith('assets/json/young_muslim/playlists/') &&
              !fileName.contains('quran_stories');
        }),
        isTrue,
      );
    });

    test('quizzes include video, series, true_false and direct questions', () {
      final quizzes =
          jsonDecode(quizzesFile.readAsStringSync()) as Map<String, dynamic>;
      final quizSets =
          (quizzes['quiz_sets'] as List<dynamic>).cast<Map<String, dynamic>>();
      final questions = quizSets
          .expand((quizSet) => (quizSet['questions'] as List<dynamic>))
          .cast<Map<String, dynamic>>()
          .toList();

      expect((quizzes['version'] as num).toInt(), greaterThan(1));
      expect(quizSets.any((quizSet) => quizSet['level'] == 'video'), isTrue);
      expect(quizSets.any((quizSet) => quizSet['level'] == 'series'), isTrue);
      expect(questions.any((question) => question['type'] == 'true_false'),
          isTrue);
      expect(questions.any((question) => question['type'] == 'direct'), isTrue);
    });
  });
}
