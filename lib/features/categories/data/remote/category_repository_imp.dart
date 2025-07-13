import 'package:dartz/dartz.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/data/model/section_type_model.dart';
import 'package:quran_app/main.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<SectionTypeModel>>> getCategories(String url);
  Future<Either<Failure, dynamic>> categoryDetail(String url);
  Future<Either<Failure, List<CategoryDetailModel>>> categoryDetailOptions(
    String url,
  );
}

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<Either<Failure, List<SectionTypeModel>>> getCategories(
    String url,
  ) async {
    try {
      // logger.d(resUrl);
      final result = await DioHelper.get(url: url);
      final data = result.data;
      logger.i('get categories Data');
      return right(
        (data as List<dynamic>)
            .map((e) => SectionTypeModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryDetailModel>>> categoryDetailOptions(
    String url,
  ) async {
    try {
      final result = await DioHelper.get(url: url);
      final data = result.data;
      return right(
        (data['data'] as List<dynamic>)
            .map((e) => CategoryDetailModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, CategoryDetailModel>> categoryDetail(
    String url,
  ) async {
    try {
      final result = await DioHelper.get(url: url);
      final data = result.data;
      logger.i(data);
      return right(CategoryDetailModel.fromJson(data as Map<String, dynamic>));
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

//
}
