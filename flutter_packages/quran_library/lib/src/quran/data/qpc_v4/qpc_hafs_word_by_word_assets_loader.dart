part of '/quran.dart';

class QpcHafsWordByWordStore {
  final Map<int, String> textByKey;

  const QpcHafsWordByWordStore({required this.textByKey});

  static int key({required int surah, required int ayah, required int word}) {
    // Safe composite key: surah<=114, ayah<=286, word usually <=~200.
    return surah * 1000000 + ayah * 1000 + word;
  }

  String? textFor({required int surah, required int ayah, required int word}) {
    return textByKey[key(surah: surah, ayah: ayah, word: word)];
  }
}

class QpcHafsWordByWordAssetsLoader {
  static const _wbwGzPath =
      'packages/quran_library/assets/jsons/qpc-hafs-word-by-word.json.gz';

  static Future<QpcHafsWordByWordStore> load() async {
    const jsonService = GzipJsonAssetService();
    final decoded = await jsonService.loadJsonDynamic(_wbwGzPath);
    if (decoded is! Map) {
      throw const FormatException(
          'qpc-hafs-word-by-word.json must be a JSON Map');
    }

    final map = <int, String>{};
    for (final value in decoded.values) {
      if (value is! Map) continue;
      final v = Map<String, dynamic>.from(value);
      final surah = int.tryParse(v['surah']?.toString() ?? '');
      final ayah = int.tryParse(v['ayah']?.toString() ?? '');
      final word = int.tryParse(v['word']?.toString() ?? '');
      final text = (v['text'] ?? '').toString();
      if (surah == null || ayah == null || word == null) continue;
      if (text.isEmpty) continue;
      map[QpcHafsWordByWordStore.key(surah: surah, ayah: ayah, word: word)] =
          text;
    }

    return QpcHafsWordByWordStore(textByKey: map);
  }
}
