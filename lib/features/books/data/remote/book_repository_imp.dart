import 'package:dartz/dartz.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/core/services/api_serves.dart';
import 'package:quran_app/features/books/data/remote/book_repository.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/l10n/l10n.dart';

class BookRepositoryImpl implements BookRepository {
  @override
  Future<Either<Failure, List<dynamic>>> index(int limit) async {
    try {
      final url = '${ApiServes.books}/$limit/25/json';
      final result = await DioHelper.get(
        url: url,
      );
      final data = result.data['data'];
      logger.i('get books');
      return right(data as List<dynamic>);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure(L10nService.current.categoriesRequestFailed));
    }
  }
}
