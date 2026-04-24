import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';

class FloatingAdhkarBuiltInSource {
  static const Set<String> _excludedKeys = {
    'quran_general',
    'surah_mulk',
    'surah_kahf',
  };

  Future<List<FloatingAdhkarItem>> loadItems() async {
    final raw = await JsonLoaderService.loadJsonObject(
      JsonLoaderService.dailyWirdProgramPath,
    );
    final contentLibrary = Map<String, dynamic>.from(
      raw['content_library'] as Map? ?? const {},
    );

    final seenTexts = <String>{};
    final results = <FloatingAdhkarItem>[];

    for (final entry in contentLibrary.entries) {
      final value = entry.value;
      if (_excludedKeys.contains(entry.key) || value is! Map) {
        continue;
      }

      final item = Map<String, dynamic>.from(value);
      final text = (item['text'] as String? ?? '').trim();
      final title = (item['title'] as String? ?? '').trim();
      final source = (item['source'] as String? ?? 'مكتبة التطبيق').trim();

      if (text.isEmpty) {
        continue;
      }

      final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (!seenTexts.add(normalized)) {
        continue;
      }

      results.add(
        FloatingAdhkarItem(
          id: 'builtin:${entry.key}',
          title: title.isEmpty ? 'ذكر افتراضي' : title,
          text: text,
          sourceType: FloatingAdhkarSourceType.builtIn,
          sourceLabel: source,
          originalTitle: title.isEmpty ? 'ذكر افتراضي' : title,
          originalText: text,
        ),
      );
    }

    results.sort((a, b) => a.title.compareTo(b.title));
    return results;
  }
}
