import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_library/src/audio/audio.dart';

class SurahVerseReaderDataSource {
  SurahVerseReaderDataSource(this.fullQuranDataClient);
  final dynamic fullQuranDataClient;

  List<ReaderInfo> get allReaders => ReadersConstants.activeSurahReaders;

  SurahVerseReaderModel _mapToSurahVerseReader(ReaderInfo r) {
    return SurahVerseReaderModel(
      id: r.index,
      identifier: r.readerNamePath,
      language: 'ar',
      name: r.name,
      englishName: r.name,
      format: 'audio',
      type: 'surah',
    );
  }

  Future<List<SurahVerseReaderModel>> getAll() async {
    return allReaders.map(_mapToSurahVerseReader).toList();
  }

  Future<SurahVerseReaderModel?> getByIdentifier(String identifier) async {
    try {
      final r = allReaders.firstWhere((r) => r.readerNamePath == identifier);
      return _mapToSurahVerseReader(r);
    } catch (_) {
      return null;
    }
  }

  Future<List<SurahVerseReaderModel>> searchByName(String query) async {
    final filtered = allReaders.where((r) => r.name.contains(query)).toList();
    return filtered.map(_mapToSurahVerseReader).toList();
  }
}
