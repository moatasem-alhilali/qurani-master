import 'package:dartz/dartz.dart';
import 'package:quran_app/core/server_failure/failure.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<dynamic>>> categoriesData(int id, String url);
  Future<Either<Failure, dynamic>> categoryDetail(String url);

}
