import 'package:dartz/dartz.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/features/categories/data/category_repository.dart';
import 'package:quran_app/main.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<Either<Failure, List<dynamic>>> categoriesData(
    int id,
    String url,
  ) async {
    try {
      final resUrl = url.contains("viewitems")
          ? "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/categories/viewitems/$id/showall/ar/showall/json"
          : "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/categories/viewcat/$id/ar/showall/json";

      // logger.d(resUrl);
      final result = await DioHelper.get(url: resUrl);
      var data = result.data;
      logger.i('get categories Data');
      return right(data);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  //المصاحف
  @override
  Future<Either<Failure, dynamic>> categoryDetail(String url) async {
    try {
      final result = await DioHelper.get(url: url);
      var data = result.data;
      return right(data);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

//
}
