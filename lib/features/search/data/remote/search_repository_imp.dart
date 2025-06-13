import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/search/data/database/database_search_engine_service.dart';
import 'package:quran_app/features/search/data/model/aya.dart';
import 'package:quran_app/features/search/data/remote/aya_repository.dart';
import 'package:quran_app/main.dart';

abstract class SearchRepository {
  Future<Either<Failure, dynamic>> searchMosoaa(String text);
  Future<Either<Failure, List<dynamic>>> historySearchMosoaa();
  Future<Either<Failure, List<Aya>>> searchQuran(
      String text, int limit, int offset);
  Future<Either<Failure, List<Aya>>> searchSurah(String text);
}

class SearchRepositoryImpl implements SearchRepository {
  final _searchEngineService = DatabaseSearchEngineService();

  @override
  Future<Either<Failure, dynamic>> searchMosoaa(String text) async {
    try {
      final url = 'https://islam-ai-api.p.rapidapi.com/api/bot?question=$text';
      logger.i(url);

      final result = await DioHelper.get(
        url: url,
        options: Options(
          headers: {
            'X-RapidAPI-Key':
                '2acebf38b7mshaf3ab3ac85f7eb4p1c09edjsn5e7a9656c71b',
            'X-RapidAPI-Host': 'islam-ai-api.p.rapidapi.com',
          },
        ),
      );

      final answer = result.data['response'];
      await _searchEngineService.addEntry(
        question: text,
        answer: answer as String,
      );

      return right(result.data);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, List>> historySearchMosoaa() async {
    try {
      final res = await _searchEngineService.getAllEntries();
      return right(res);
    } catch (e) {
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, List<Aya>>> searchQuran(
      String text, int limit, int offset) async {
    try {
      final convertedText = convertArabicToEnglishNumbers(text);
      final ayaRepository = sl.get<AyaRepository>();
      final result = await ayaRepository.search(convertedText, limit, offset);
      return right(result);
    } catch (e) {
      return left(AssetFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, List<Aya>>> searchSurah(String text) async {
    try {
      final convertedText = convertArabicToEnglishNumbers(text);
      final ayaRepository = sl.get<AyaRepository>();
      final result = await ayaRepository.surahSearch(convertedText);

      // extract unique surahs
      final uniqueSurahs = <int, Aya>{};
      for (final aya in result) {
        uniqueSurahs.putIfAbsent(aya.surahNum, () => aya);
      }

      return right(uniqueSurahs.values.toList());
    } catch (e) {
      return left(AssetFailure('غير قادر على معالجة العملية'));
    }
  }
}
