part of '/quran.dart';

extension TextSpanExtension on String {
  List<TextSpan> customTextSpans() {
    String text = this;

    // Insert line breaks after specific punctuation marks unless they are within square brackets
    text = text.replaceAllMapped(
        RegExp(r'(\.|\:)(?![^\[]*\])\s*'), (match) => '${match[0]}\n');

    final RegExp regExpQuotes = RegExp(r'\"(.*?)\"');
    final RegExp regExpBraces = RegExp(r'\{(.*?)\}');
    final RegExp regExpParentheses = RegExp(r'\((.*?)\)');
    final RegExp regExpSquareBrackets = RegExp(r'\[(.*?)\]');
    final RegExp regExpDash = RegExp(r'\-(.*?)\-');

    final Iterable<Match> matchesQuotes = regExpQuotes.allMatches(text);
    final Iterable<Match> matchesBraces = regExpBraces.allMatches(text);
    final Iterable<Match> matchesParentheses =
        regExpParentheses.allMatches(text);
    final Iterable<Match> matchesSquareBrackets =
        regExpSquareBrackets.allMatches(text);
    final Iterable<Match> matchesDash = regExpDash.allMatches(text);

    final List<Match> allMatches = [
      ...matchesQuotes,
      ...matchesBraces,
      ...matchesParentheses,
      ...matchesSquareBrackets,
      ...matchesDash
    ]..sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    List<TextSpan> spans = [];

    for (final Match match in allMatches) {
      if (match.start >= lastMatchEnd && match.end <= text.length) {
        final String preText = text.substring(lastMatchEnd, match.start);
        final String matchedText = text.substring(match.start, match.end);
        final bool isBraceMatch = regExpBraces.hasMatch(matchedText);
        final bool isParenthesesMatch = regExpParentheses.hasMatch(matchedText);
        final bool isSquareBracketMatch =
            regExpSquareBrackets.hasMatch(matchedText);
        final bool isDashMatch = regExpDash.hasMatch(matchedText);

        if (preText.isNotEmpty) {
          spans.add(TextSpan(text: preText));
        }

        TextStyle matchedTextStyle;
        if (isBraceMatch) {
          matchedTextStyle = const TextStyle(
              color: Color(0xff008000),
              fontFamily: 'hafs',
              package: "quran_library");
        } else if (isParenthesesMatch) {
          matchedTextStyle = const TextStyle(
              color: Color(0xff008000),
              fontFamily: 'hafs',
              package: "quran_library");
        } else if (isSquareBracketMatch) {
          matchedTextStyle = const TextStyle(color: Color(0xff814714));
        } else if (isDashMatch) {
          matchedTextStyle = const TextStyle(color: Color(0xff814714));
        } else {
          matchedTextStyle = const TextStyle(
              color: Color(0xffa24308),
              fontFamily: 'naskh',
              package: "quran_library");
        }

        spans.add(TextSpan(
          text: matchedText,
          style: matchedTextStyle,
        ));

        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  List<InlineSpan> toFlutterText(bool isDark) {
    final dom.Document document = html_parser.parse(this);
    final List<InlineSpan> children = [];

    void parseNode(dom.Node node, TextStyle? parentStyle) {
      if (node is dom.Element) {
        TextStyle? textStyle;
        switch (node.localName) {
          case 'br':
            // Convert <br> tags to newline characters
            children.add(TextSpan(
                text: '\n',
                style: parentStyle ??
                    TextStyle(color: AppColors.getTextColor(isDark))));
            return;
          case 'qpc-hafs':
            textStyle = parentStyle?.merge(const TextStyle(
                  color: Color(0xff008000),
                  fontFamily: 'hafs',
                  package: "quran_library",
                )) ??
                const TextStyle(
                  color: Color(0xff008000),
                  fontFamily: 'hafs',
                  package: "quran_library",
                );
            return;
          case 'p':
            textStyle = parentStyle?.merge(TextStyle(
                  color: AppColors.getTextColor(isDark),
                )) ??
                TextStyle(color: AppColors.getTextColor(isDark));
            // Process children of paragraph
            for (var child in node.nodes) {
              parseNode(child, textStyle);
            }
            // After </p>, ensure a single newline
            bool needsNewline = true;
            if (children.isNotEmpty && children.last is TextSpan) {
              final lastText = (children.last as TextSpan).text ?? '';
              if (lastText.endsWith('\n')) needsNewline = false;
            }
            if (needsNewline) {
              children.add(TextSpan(text: '\n', style: textStyle));
            }
            return;
          case 'span':
            if (node.classes.contains('c5')) {
              textStyle =
                  parentStyle?.merge(const TextStyle(color: Color(0xff008000)));
            } else if (node.classes.contains('qpc-hafs')) {
              textStyle = parentStyle?.merge(const TextStyle(
                color: Color(0xff008000),
                fontFamily: 'hafs',
                package: "quran_library",
              ));
            } else if (node.classes.contains('c4')) {
              textStyle =
                  parentStyle?.merge(const TextStyle(color: Color(0xff814714)));
            } else if (node.classes.contains('c2')) {
              textStyle =
                  parentStyle?.merge(const TextStyle(color: Color(0xff814714)));
            } else if (node.classes.contains('c1')) {
              textStyle =
                  parentStyle?.merge(const TextStyle(color: Color(0xffa24308)));
            } else {
              textStyle = parentStyle
                  ?.merge(TextStyle(color: AppColors.getTextColor(isDark)));
            }
            break;
          case 'div':
            textStyle = parentStyle
                ?.merge(TextStyle(color: AppColors.getTextColor(isDark)));
            break;
          default:
            textStyle = parentStyle
                ?.merge(TextStyle(color: AppColors.getTextColor(isDark)));
        }

        for (var child in node.nodes) {
          parseNode(child, textStyle);
        }
      } else if (node is dom.Text) {
        // النص الخام
        String rawText = node.text;
        // تنقيحات طفيفة للمسافات/الفواصل كما كانت سابقًا
        final cleanedText = rawText
            .trim()
            .replaceAllMapped(RegExp(r'\s"'), (match) => ' "')
            .replaceAllMapped(RegExp(r'"\s'), (match) => '" ')
            .replaceAllMapped(RegExp(r',(?=\S)'), (match) => ', ')
            .replaceAll(RegExp(r'<[^>]+>'), ' ')
            .replaceAllMapped(RegExp(r'(?<=\S)(?=<|$)'), (match) => ' ');

        // تطبيق تنسيق خاص على المقاطع بين الأقواس/المعقوفات/المربعات/الشرطات
        final RegExp regExpBraces = RegExp(r'\{(.*?)\}');
        final RegExp regExpParentheses = RegExp(r'\((.*?)\)');
        final RegExp regExpSquareBrackets = RegExp(r'\[(.*?)\]');
        final RegExp regExpDash = RegExp(r'\-(.*?)\-');
        final RegExp regExpAngle = RegExp(r'«(.*?)»');

        final Iterable<Match> matchesBraces =
            regExpBraces.allMatches(cleanedText);
        final Iterable<Match> matchesParentheses =
            regExpParentheses.allMatches(cleanedText);
        final Iterable<Match> matchesSquareBrackets =
            regExpSquareBrackets.allMatches(cleanedText);
        final Iterable<Match> matchesDash = regExpDash.allMatches(cleanedText);
        final Iterable<Match> matchesAngle =
            regExpAngle.allMatches(cleanedText);

        final List<Match> allMatches = [
          ...matchesBraces,
          ...matchesParentheses,
          ...matchesSquareBrackets,
          ...matchesDash,
          ...matchesAngle
        ]..sort((a, b) => a.start.compareTo(b.start));

        if (allMatches.isEmpty) {
          // لا توجد أنماط خاصة؛ أضف النص كما هو بأسلوب الأب
          children.add(TextSpan(
              text: cleanedText,
              style: parentStyle ??
                  TextStyle(color: AppColors.getTextColor(isDark))));
        } else {
          int last = 0;
          for (final m in allMatches) {
            if (m.start < last || m.end > cleanedText.length) continue;

            // مقطع قبل المطابقة
            final pre = cleanedText.substring(last, m.start);
            if (pre.isNotEmpty) {
              children.add(TextSpan(
                  text: pre,
                  style: parentStyle ??
                      TextStyle(color: AppColors.getTextColor(isDark))));
            }

            final matchText = cleanedText.substring(m.start, m.end);
            final bool isBraceMatch = regExpBraces.hasMatch(matchText);
            final bool isParenthesesMatch =
                regExpParentheses.hasMatch(matchText);
            final bool isSquareBracketMatch =
                regExpSquareBrackets.hasMatch(matchText);
            final bool isDashMatch = regExpDash.hasMatch(matchText);
            final bool isAngleMatch = regExpAngle.hasMatch(matchText);

            // أنماط خاصة كما طُلب
            TextStyle special;
            if (isBraceMatch) {
              special = const TextStyle(
                  color: Color(0xff008000),
                  fontFamily: 'hafs',
                  package: "quran_library");
            } else if (isParenthesesMatch) {
              special = const TextStyle(
                  color: Color(0xff008000),
                  fontFamily: 'hafs',
                  package: "quran_library");
            } else if (isSquareBracketMatch) {
              special = const TextStyle(color: Color(0xff814714));
            } else if (isDashMatch) {
              special = const TextStyle(color: Color(0xff814714));
            } else if (isAngleMatch) {
              // نفترض أن <<>> تمثل ملاحظة/اقتباس مشابه لـ [] من حيث اللون بدون أسطر إضافية
              special = const TextStyle(color: Color(0xff814714));
            } else {
              // افتراضي: أسلوب الأب
              special = parentStyle ??
                  TextStyle(color: AppColors.getTextColor(isDark));
            }

            // دمج مع أسلوب الأب للحفاظ على الحجم/الوزن مع تغيير اللون/الخط المطلوب
            final applied = (parentStyle ?? const TextStyle()).merge(special);

            // في حالة الأقواس المربعة، أضف أسطرًا قبل/بعد كما كان السلوك السابق
            if (isSquareBracketMatch) {
              // children.add(TextSpan(
              //     text: '\n',
              //     style: parentStyle ??
              //         TextStyle(color: AppColors.getTextColor(isDark))));
              children.add(TextSpan(text: matchText, style: applied));
              // children.add(TextSpan(
              //     text: '\n',
              //     style: parentStyle ??
              //         TextStyle(color: AppColors.getTextColor(isDark))));
            } else {
              children.add(TextSpan(text: matchText, style: applied));
            }

            last = m.end;
          }

          // الباقي بعد آخر مطابقة
          if (last < cleanedText.length) {
            children.add(TextSpan(
                text: cleanedText.substring(last),
                style: parentStyle ??
                    TextStyle(color: AppColors.getTextColor(isDark))));
          }
        }
      }
    }

    for (var node in document.body?.nodes ?? []) {
      parseNode(node, null);
    }

    return children;
  }
}
