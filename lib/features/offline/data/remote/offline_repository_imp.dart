import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/core/services/audio_service.dart';
import 'package:quran_app/features/offline/data/models/offline_file_model.dart';
import 'package:quran_app/features/offline/data/database/database_offline_service.dart';
import 'package:quran_app/main.dart';

abstract class OfflineRepository {
  Future<Either<Failure, List<OfflineFileModel>>> index();
  Future<Either<Failure, bool>> add(OfflineFileModel data);
  Future<Either<Failure, AudioPlayer>> initAudio(List url);

  //
}

class OfflineRepositoryImpl implements OfflineRepository {
  final _offlineService = DatabaseOfflineService();

  @override
  Future<Either<Failure, List<OfflineFileModel>>> index() async {
    try {
      final data = await _offlineService.getAll();
      logger.i('✔️ fetched offline audios');
      return right(data);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, bool>> add(OfflineFileModel data) async {
    try {
      await _offlineService.insert(data);
      logger.i('✔️ inserted offline audio');
      return right(true);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, AudioPlayer>> initAudio(List data) async {
    try {
      List<String> urls = data.map<String>((e) => e['path'] as String).toList();

      final audioService = AudioService();
      await audioService.initAudiosNetworks(urls, offline: true);

      return right(audioService.audioPlayer);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  Future<Either<Failure, List<OfflineFileModel>>> getByType(String type) async {
    try {
      final filtered = await _offlineService.getByType(type);
      return right(filtered);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('حدث خطأ أثناء التصفية حسب النوع'));
    }
  }
}
