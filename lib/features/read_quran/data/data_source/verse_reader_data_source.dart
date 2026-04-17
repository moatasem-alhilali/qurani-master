import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_library/src/audio/audio.dart';

class VerseReaderDataSource {
  VerseReaderDataSource(this.fullQuranDataClient);
  final dynamic fullQuranDataClient;

  List<ReaderInfo> get allReaders => ReadersConstants.activeAyahReaders;

  VerseReaderModel _mapToVerseReader(ReaderInfo r) {
    return VerseReaderModel(
      id: r.index,
      identifier: r.readerNamePath,
      language: 'ar',
      name: r.name,
      englishName: r.name, // ReadersConstants doesn't have English names separate
      format: 'audio',
      type: 'ayah',
    );
  }

  Future<List<VerseReaderModel>> getAll() async {
    return allReaders.map(_mapToVerseReader).toList();
  }

  Future<VerseReaderModel?> getByIdentifier(String identifier) async {
    try {
      final r = allReaders.firstWhere((r) => r.readerNamePath == identifier);
      return _mapToVerseReader(r);
    } catch (_) {
      return null;
    }
  }

  Future<List<VerseReaderModel>> searchByName(String query) async {
    final filtered = allReaders.where((r) => r.name.contains(query)).toList();
    return filtered.map(_mapToVerseReader).toList();
  }
}
