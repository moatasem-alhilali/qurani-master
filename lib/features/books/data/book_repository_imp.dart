import 'package:dartz/dartz.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/core/services/api_serves.dart';
import 'package:quran_app/features/books/data/book_repository.dart';
import 'package:quran_app/main.dart';

class BookRepositoryImpl implements BookRepository {
  @override
  Future<Either<Failure, List<dynamic>>> index(int limit) async {
    try {
      var url = "${ApiServes.books}/$limit/25/json";
      final result = await DioHelper.get(
        url: url,
      );
      var data = result.data['data'];
      logger.i('get books');
      return right(data);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }
}
