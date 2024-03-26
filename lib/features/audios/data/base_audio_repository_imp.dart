import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/core/services/api_serves.dart';
import 'package:quran_app/core/services/audio_service.dart';
import 'package:quran_app/features/audios/data/base_audio_repository.dart';
import 'package:quran_app/main.dart';

class BaseAudioRepositoryImpl implements BaseAudioRepository {
  @override
  Future<Either<Failure, List<dynamic>>> famousReader(String id) async {
    try {
      var url = "/quran/get-category/$id/ar/json";
      final result = await DioHelper.get(
        url: url,
      );
      var data = result.data['recitations'];
      logger.i('get famous Reader');
      return right(data);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, List>> famousReaderDetail(String url) async {
    try {
      final result = await DioHelper.get(
        url: url,
      );
      var data = result.data['attachments'];
      logger.i('get famous Reader Detail');
      return right(data);
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
        urls.add(element['url']);
      }
      AudioService audioService = AudioService();
      await audioService.initAudiosNetworks(urls);
      return right(audioService.audioPlayer);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> quranLearnChild() async {
    try {
      var url = ApiServes.quranLearnForChild;
      final result = await DioHelper.get(
        url: url,
      );
      var data = result.data['data'];
      logger.i('get quran Learn Child');
      return right(data);
    } catch (e) {
      logger.e(e);
      return left(ServerFailure('غير قادر على معالجة العملية'));
    }
  }
}
