import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/core/services/audio_service.dart';
import 'package:quran_app/features/offline/data/offline_repository.dart';
import 'package:quran_app/main.dart';

class OfflineRepositoryImpl implements OfflineRepository {
  @override
  Future<Either<Failure, List<dynamic>>> index() async {
    try {
      final data = await DBHelper.get('offlines');
      logger.i('get offline audio');
      return right(data);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, bool>> add(Map<String, dynamic> data) async {
    try {
      final result = await DBHelper.insert('offlines', data);
      logger.i('get famous Reader Detail');
      return right(true);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, AudioPlayer>> initAudio(dynamic data) async {
    try {
      List<String> urls = [];
      for (var element in data) {
        urls.add(element['path']);
      }
      AudioService audioService = AudioService();
      await audioService.initAudiosNetworks(urls, offline: true);
      return right(audioService.audioPlayer);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }
}
