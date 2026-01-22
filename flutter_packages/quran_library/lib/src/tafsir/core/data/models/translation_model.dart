part of '../../../tafsir.dart';

class TranslationModel {
  final String surahAyah;
  final String text;
  final Map<String, String> footnotes;

  TranslationModel({
    required this.surahAyah,
    required this.text,
    this.footnotes = const {},
  });

  factory TranslationModel.fromJson(String key, Map<String, dynamic> json) {
    return TranslationModel(
      surahAyah: key,
      text: json['t'] ?? '',
      footnotes: Map<String, String>.from(json['f'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahAyah': surahAyah,
      'text': text,
      'footnotes': footnotes,
    };
  }

  // استخراج رقم السورة والآية
  int get surahNumber => int.parse(surahAyah.split(':').first);
  int get ayahNumber => int.parse(surahAyah.split(':').last);

  // تنظيف النص من HTML tags مع الاحتفاظ بأرقام الحواشي
  String get cleanText {
    return text
        .replaceAllMapped(
            RegExp(r'<sup foot_note="[^"]*">(\d+)</sup>'),
            (match) =>
                ' (${match.group(1)})') // تحويل <sup>1</sup> إلى (1) مع مسافة
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false),
            '\n') // استبدال <br /> بـ \n
        .replaceAll(RegExp(r'<[^>]*>'), '') // إزالة أي HTML tags أخرى
        .replaceAll(RegExp(r'\s+'),
            ' ') // تنظيف المسافات المتعددة (لكن ليس السطور الجديدة)
        .replaceAll(RegExp(r'[ \t]+'), ' ') // تنظيف المسافات والتابات فقط
        .trim();
  }

  // استخراج أرقام الحواشي من النص بالترتيب الصحيح
  List<String> get footnoteNumbers {
    final matches =
        RegExp(r'<sup foot_note="([^"]*)">\d+</sup>').allMatches(text);
    return matches
        .map((match) => match.group(1) ?? '')
        .where((id) => id.isNotEmpty)
        .toList();
  }

  // تنظيف نص واحد من HTML tags
  String _cleanHtmlText(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false),
            '\n') // استبدال <br /> بـ \n
        .replaceAll(RegExp(r'<[^>]*>'), '') // إزالة أي HTML tags أخرى
        .replaceAll(RegExp(r'[ \t]+'), ' ') // تنظيف المسافات والتابات فقط
        .trim();
  }

  // الحصول على الحواشي مرتبة حسب ظهورها في النص مع أرقامها (مع تنظيف HTML)
  List<MapEntry<int, MapEntry<String, String>>>
      get orderedFootnotesWithNumbers {
    final orderedIds = footnoteNumbers;
    final result = <MapEntry<int, MapEntry<String, String>>>[];

    for (int i = 0; i < orderedIds.length; i++) {
      final id = orderedIds[i];
      if (footnotes.containsKey(id)) {
        result.add(MapEntry(
            i + 1, // رقم الحاشية (1, 2, 3, ...)
            MapEntry(id, _cleanHtmlText(footnotes[id]!))));
      }
    }

    return result;
  }

  // الحصول على الحواشي مرتبة حسب ظهورها في النص
  List<MapEntry<String, String>> get orderedFootnotes {
    final orderedIds = footnoteNumbers;
    return orderedIds
        .where((id) => footnotes.containsKey(id))
        .map((id) => MapEntry(id, footnotes[id]!))
        .toList();
  }
}

class TranslationsModel {
  final Map<String, TranslationModel> translations;

  TranslationsModel({required this.translations});

  factory TranslationsModel.fromJson(String str) {
    final jsonData = json.decode(str) as Map<String, dynamic>;
    final translations = <String, TranslationModel>{};

    for (final entry in jsonData.entries) {
      if (entry.value is Map<String, dynamic>) {
        translations[entry.key] =
            TranslationModel.fromJson(entry.key, entry.value);
      }
    }

    return TranslationsModel(translations: translations);
  }

  List<TranslationModel> getTranslationsAsList() {
    return translations.values.toList()
      ..sort((a, b) {
        final surahComparison = a.surahNumber.compareTo(b.surahNumber);
        if (surahComparison != 0) return surahComparison;
        return a.ayahNumber.compareTo(b.ayahNumber);
      });
  }

  TranslationModel? getTranslationBySurahAyah(int surah, int ayah) {
    return translations['$surah:$ayah'];
  }
}
