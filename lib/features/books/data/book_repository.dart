import 'package:dartz/dartz.dart';
import 'package:quran_app/core/server_failure/failure.dart';

abstract class BookRepository {
  Future<Either<Failure, List<dynamic>>> index(int limit);

}
