import 'package:dartz/dartz.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/features/read_quran/data/data_source/surah_verse_reader_data_source.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';

class SurahVerseReaderDataRepo {
  SurahVerseReaderDataRepo(this.surahVerseReaderDataSource);
  final SurahVerseReaderDataSource surahVerseReaderDataSource;

  Future<Either<Failure, List<SurahVerseReaderModel>>> getAll() async {
    try {
      final res = await surahVerseReaderDataSource.getAll();
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, SurahVerseReaderModel?>> getByIdentifier(
    String identifier,
  ) async {
    try {
      final res = await surahVerseReaderDataSource.getByIdentifier(identifier);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<SurahVerseReaderModel>>> searchByName(
    String query,
  ) async {
    try {
      final res = await surahVerseReaderDataSource.searchByName(query);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
