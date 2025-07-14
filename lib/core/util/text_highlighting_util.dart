import 'package:flutter/material.dart';

/// Optimized text highlighting utility for search results
class TextHighlightingUtil {
  static const Map<String, String> _arabicDiacriticsMap = {
    'أ': 'ا',
    'إ': 'ا',
    'آ': 'ا',
    'إٔ': 'ا',
    'إٕ': 'ا',
    'إٓ': 'ا',
    'أَ': 'ا',
    'إَ': 'ا',
    'آَ': 'ا',
    'إُ': 'ا',
    'إٌ': 'ا',
    'إً': 'ا',
    'ة': 'ه',
    'ً': '',
    'ٌ': '',
    'ٍ': '',
    'َ': '',
    'ُ': '',
    'ِ': '',
    'ّ': '',
    'ْ': '',
    'ـ': '',
    'ٰ': '',
    'ٖ': '',
    'ٗ': '',
    'ٕ': '',
    'ٓ': '',
    'ۖ': '',
    'ۗ': '',
    'ۘ': '',
    'ۙ': '',
    'ۚ': '',
    'ۛ': '',
    'ۜ': '',
    '۝': '',
    '۞': '',
    '۟': '',
    '۠': '',
    'ۡ': '',
    'ۢ': '',
  };

  /// Efficiently removes Arabic diacritics for better text matching
  static String _removeDiacritics(String input) {
    if (input.isEmpty) return input;

    final buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      final mappedChar = _arabicDiacriticsMap[char];
      if (mappedChar != null) {
        if (mappedChar.isNotEmpty) {
          buffer.write(mappedChar);
        }
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// Creates highlighted TextSpans for search results with optimized performance
  static List<TextSpan> highlightSearchTerms(
    String text,
    String searchTerm, {
    TextStyle? defaultStyle,
    TextStyle? highlightStyle,
  }) {
    // Early return for empty inputs
    if (text.isEmpty || searchTerm.isEmpty) {
      return [TextSpan(text: text, style: defaultStyle)];
    }

    // Split search term into multiple words for better highlighting
    final searchWords = searchTerm
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (searchWords.isEmpty) {
      return [TextSpan(text: text, style: defaultStyle)];
    }

    // Create a normalized version for searching but keep original for display
    final normalizedText = _removeDiacritics(text.toLowerCase());
    final allMatches = <MapEntry<int, int>>[];

    for (final searchWord in searchWords) {
      final normalizedSearchWord = _removeDiacritics(searchWord.toLowerCase());
      if (normalizedSearchWord.isEmpty) continue;

      var searchIndex = 0;
      while (searchIndex < normalizedText.length) {
        final matchIndex =
            normalizedText.indexOf(normalizedSearchWord, searchIndex);
        if (matchIndex == -1) break;

        // Find the corresponding positions in the original text
        final originalStart = _findOriginalPosition(text, matchIndex);
        final originalEnd = _findOriginalPosition(
          text,
          matchIndex + normalizedSearchWord.length,
        );

        allMatches.add(MapEntry(originalStart, originalEnd));
        searchIndex = matchIndex + 1; // Allow overlapping matches
      }
    }

    // Sort and merge overlapping matches
    allMatches.sort((a, b) => a.key.compareTo(b.key));
    final mergedMatches = _mergeOverlappingMatches(allMatches);

    // Build TextSpans
    final spans = <TextSpan>[];
    var currentIndex = 0;

    for (final match in mergedMatches) {
      // Add text before the match
      if (match.key > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, match.key),
            style: defaultStyle,
          ),
        );
      }

      // Add the highlighted match
      spans.add(
        TextSpan(
          text: text.substring(match.key, match.value),
          style: highlightStyle ?? _defaultHighlightStyle,
        ),
      );

      currentIndex = match.value;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: defaultStyle,
        ),
      );
    }

    return spans.isNotEmpty
        ? spans
        : [TextSpan(text: text, style: defaultStyle)];
  }

  /// Finds the position in the original text that corresponds to a position in the normalized text
  static int _findOriginalPosition(
      String originalText, int normalizedPosition) {
    var originalIndex = 0;
    var normalizedIndex = 0;

    while (originalIndex < originalText.length &&
        normalizedIndex < normalizedPosition) {
      final char = originalText[originalIndex];
      final normalizedChar = _removeDiacritics(char.toLowerCase());

      if (normalizedChar.isNotEmpty) {
        normalizedIndex++;
      }
      originalIndex++;
    }

    // If we've reached the target position, include any trailing diacritics
    while (originalIndex < originalText.length) {
      final char = originalText[originalIndex];
      final normalizedChar = _removeDiacritics(char.toLowerCase());

      // If this character would add to the normalized text, stop
      if (normalizedChar.isNotEmpty) {
        break;
      }
      originalIndex++;
    }

    return originalIndex;
  }

  /// Merges overlapping matches
  static List<MapEntry<int, int>> _mergeOverlappingMatches(
    List<MapEntry<int, int>> matches,
  ) {
    if (matches.isEmpty) return matches;

    final merged = <MapEntry<int, int>>[];

    for (final match in matches) {
      if (merged.isEmpty || merged.last.value < match.key) {
        merged.add(match);
      } else {
        // Merge overlapping matches
        final lastMatch = merged.removeLast();
        merged.add(
          MapEntry(
            lastMatch.key,
            match.value > lastMatch.value ? match.value : lastMatch.value,
          ),
        );
      }
    }

    return merged;
  }

  /// Default highlight style for search terms
  static const TextStyle _defaultHighlightStyle = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.yellow,
  );

  /// Creates a RichText widget with highlighted search terms
  static Widget createHighlightedText(
    String text,
    String searchTerm, {
    TextStyle? defaultStyle,
    TextStyle? highlightStyle,
    TextAlign? textAlign,
  }) {
    return RichText(
      text: TextSpan(
        children: highlightSearchTerms(
          text,
          searchTerm,
          defaultStyle: defaultStyle,
          highlightStyle: highlightStyle,
        ),
      ),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
