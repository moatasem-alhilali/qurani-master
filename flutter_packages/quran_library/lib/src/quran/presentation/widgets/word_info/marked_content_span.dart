part of '/quran.dart';

/// يبني TextSpan مع تمييز (colored) لبعض المقاطع داخل النص.
///
/// يدعم:
/// - `@ ... /` (ويستبدل `/` بمسافة واحدة)
/// - `{ ... }` (يُلوّن ما داخلها)
/// - `( ... )` (يُلوّن ما داخلها)
TextSpan buildMarkedContentSpan({
  required String content,
  required TextStyle baseStyle,
  required TextStyle markedStyle,
  TextStyle? curlyInnerStyle,
}) {
  if (content.isEmpty) return TextSpan(text: '', style: baseStyle);

  // تطبيع بسيط للنص:
  // - حذف أسطر جديدة (\n) وتحويلها لمسافة
  // - حذف &quot;
  // - دعم <br>, <br/>, <br /> (تحويلها لمسافة)
  String normalized = content
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ')
      .replaceAll('&quot;', '')
      .replaceAll('\n', ' ')
      .replaceAll('\r', ' ')
      .replaceAll('---{عند الوصل}---', '\n---{عند الوصل}---\n');

  // تقليل تكرار المسافات بعد التطبيع.
  normalized = normalized.replaceAll(RegExp(r'[ \t]{2,}'), ' ');

  final spans = <InlineSpan>[];
  int i = 0;
  while (i < normalized.length) {
    final atIndex = normalized.indexOf('@', i);
    final curlyIndex = normalized.indexOf('{', i);
    final parenIndex = normalized.indexOf('(', i);

    int next = normalized.length;
    String? marker;
    if (atIndex != -1 && atIndex < next) {
      next = atIndex;
      marker = '@';
    }
    if (curlyIndex != -1 && curlyIndex < next) {
      next = curlyIndex;
      marker = '{';
    }
    if (parenIndex != -1 && parenIndex < next) {
      next = parenIndex;
      marker = '(';
    }

    if (marker == null) {
      spans.add(TextSpan(text: normalized.substring(i), style: baseStyle));
      break;
    }

    if (next > i) {
      spans
          .add(TextSpan(text: normalized.substring(i, next), style: baseStyle));
    }

    if (marker == '@') {
      final end = normalized.indexOf('/', next + 1);
      if (end == -1) {
        spans.add(TextSpan(text: normalized.substring(next), style: baseStyle));
        break;
      }

      if (end > next + 1) {
        spans.add(
          TextSpan(
            text: normalized.substring(next + 1, end),
            style: markedStyle,
          ),
        );
      }

      // نستبدل '/' بمسافة واحدة (بدون مضاعفة المسافات إن كان بعدها فراغ).
      final nextIndex = end + 1;
      final hasNext = nextIndex < normalized.length;
      final nextIsWhitespace =
          hasNext ? RegExp(r'\s').hasMatch(normalized[nextIndex]) : false;
      if (!nextIsWhitespace) {
        spans.add(TextSpan(text: ' ', style: baseStyle));
      }

      i = end + 1;
      continue;
    }

    if (marker == '{') {
      final end = normalized.indexOf('}', next + 1);
      if (end == -1) {
        spans.add(TextSpan(text: normalized.substring(next), style: baseStyle));
        break;
      }

      // استبدال الأقواس المعقوفة بأقواس مزخرفة.
      final curlyBracketStyle = baseStyle.copyWith(
        fontFamily: 'hafs',
        package: 'quran_library',
      );
      spans.add(TextSpan(text: '﴿', style: curlyBracketStyle));
      if (end > next + 1) {
        final curlyStyle = (curlyInnerStyle ?? markedStyle).copyWith(
          fontFamily: 'hafs',
          package: 'quran_library',
        );
        spans.add(
          TextSpan(
            text: normalized.substring(next + 1, end),
            style: curlyStyle,
          ),
        );
      }
      spans.add(TextSpan(text: '﴾', style: curlyBracketStyle));
      i = end + 1;
      continue;
    }

    // marker == '('
    final end = normalized.indexOf(')', next + 1);
    if (end == -1) {
      spans.add(TextSpan(text: normalized.substring(next), style: baseStyle));
      break;
    }

    spans.add(TextSpan(text: '(', style: baseStyle));
    if (end > next + 1) {
      spans.add(
        TextSpan(
          text: normalized.substring(next + 1, end),
          style: markedStyle,
        ),
      );
    }
    spans.add(TextSpan(text: ')', style: baseStyle));
    i = end + 1;
  }

  return TextSpan(children: spans, style: baseStyle);
}
