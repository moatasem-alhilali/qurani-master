import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/search/data/model/aya.dart';
import 'package:quran_app/features/search/data/aya_repository.dart';
import 'package:quran_app/features/search/data/search_repository.dart';
import 'package:quran_app/main.dart';

class SearchRepositoryImpl implements SearchRepository {
  @override
  Future<Either<Failure, dynamic>> searchMosoaa(String text) async {
    try {
      var url = "https://islam-ai-api.p.rapidapi.com/api/bot?question=$text";
      logger.i(url);
      final result = await DioHelper.get(
        url: url,
        options: Options(
          headers: {
            'X-RapidAPI-Key':
                '2acebf38b7mshaf3ab3ac85f7eb4p1c09edjsn5e7a9656c71b',
            'X-RapidAPI-Host': 'islam-ai-api.p.rapidapi.com'
          },
        ),
      );

      DBHelper.insert(
        'search_engine_mosoaa',
        {
          "question": text,
          "answer": result.data['response'],
          "created_at": DateTime.now().toString(),
        },
      );
      var data = result.data;
      logger.i(data);
      return right(data);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, List>> historySearchMosoaa() async {
    try {
      final res = await DBHelper.get('search_engine_mosoaa');
      return right(res);
    } catch (e) {
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, List<Aya>>> searchQuran(
      text, pageSize, pageNumber) async {
    try {
      String convertedText = convertArabicToEnglishNumbers(text);

      final AyaRepository ayaRepository = sl.get<AyaRepository>();

      final List<Aya> result =
          await ayaRepository.search(convertedText, pageSize, pageNumber);
      return right(result);
    } catch (e) {
      return left(AssetFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, List<Aya>>> searchSurah(text) async {
    try {
      var surahList = <Aya>[];

      String convertedText = convertArabicToEnglishNumbers(text);

      final AyaRepository ayaRepository = sl.get<AyaRepository>();

      final List<Aya> result = await ayaRepository.surahSearch(convertedText);
      var uniqueSurahs = <int, Aya>{};
      for (var aya in result) {
        if (!uniqueSurahs.containsKey(aya.surahNum)) {
          uniqueSurahs[aya.surahNum] = aya;
        }
        surahList.addAll(uniqueSurahs.values);
      }
      return right(surahList);
    } catch (e) {
      return left(AssetFailure('غير قادر على معالجة العملية'));
    }
  }
}
