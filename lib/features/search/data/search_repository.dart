import 'package:dartz/dartz.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/features/search/data/model/aya.dart';

abstract class SearchRepository {
  Future<Either<Failure, dynamic>> searchMosoaa(String text);
  Future<Either<Failure, List<dynamic>>> historySearchMosoaa();
  Future<Either<Failure, List<Aya>>> searchQuran(text, limit, offset);
  Future<Either<Failure, List<Aya>>> searchSurah(text);
}
