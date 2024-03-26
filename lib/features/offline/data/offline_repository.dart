import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/server_failure/failure.dart';

abstract class OfflineRepository {
  Future<Either<Failure, List<dynamic>>> index();
  Future<Either<Failure, bool>> add(Map<String, dynamic> data);
  Future<Either<Failure, AudioPlayer>> initAudio(List url);

  //
}
