import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/server_failure/failure.dart';

abstract class BaseAudioRepository {
  Future<Either<Failure, List<dynamic>>> famousReader(String id);
  Future<Either<Failure, List<dynamic>>> famousReaderDetail(String id);
  Future<Either<Failure, AudioPlayer>> initAudio(List url);

  //
}
