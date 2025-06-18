import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';
import 'package:quran_app/features/quran_audio/data/models/quran_reader_model.dart';
import 'package:quran_app/main.dart';

abstract class QuranAudioPlayerRepo {
  Future<List<QuranReaderModel>> loadMostReaderData();
  Future<List<SurahInfoModel>> loadSurahInfoData();
  Future<AudioPlayer> initPlayerFile(String filePath);
  Future<AudioPlayer> initPlayerNetwork(String filePath);
  Future<AudioPlayer> initPlayerOnlineListenAudioSource({
    required CurrentQuranAudioModel currentAudioData,
    int currentSurah = 0,
    int currentReader = 0,
  });
  CurrentQuranAudioModel getCurrentAudioData({
    required List<SurahInfoModel> surahInfoData,
    required List<QuranReaderModel> mostReaderData,
  });
}

class QuranAudioPlayerRepoImpl implements QuranAudioPlayerRepo {
  @override
  CurrentQuranAudioModel getCurrentAudioData({
    required List<SurahInfoModel> surahInfoData,
    required List<QuranReaderModel> mostReaderData,
  }) {
    try {
      final currentAudioData = CurrentQuranAudioModel(
        countSurahVerse: surahInfoData[0].ayaatiha,
        imageReader: mostReaderData[0].image,
        nameReader: mostReaderData[0].name,
        nameSurah: surahInfoData[0].surah,
        identifier: mostReaderData[0].identifier,
        indexSurah: 0,
      );
      return currentAudioData;
    } catch (e) {
      logger.e('error get current audio data $e');
      rethrow;
    }
  }

  @override
  Future<AudioPlayer> initPlayerOnlineListenAudioSource({
    required CurrentQuranAudioModel currentAudioData,
    int currentSurah = 0,
    int currentReader = 0,
  }) async {
    try {
      final audioSource = <AudioSource>[];

      //init the audio source
      final audioPlayerOnlineListen = AudioPlayer();
      audioSource.clear();

      //insert url to list of Audio Source
      for (var i = 1; i <= 114; i++) {
        final url =
            'https://cdn.islamic.network/quran/audio-surah/128/${currentAudioData.identifier}/$i.mp3';
        //

        final audio = AudioSource.uri(Uri.parse(url));
        audioSource.add(audio);
      }

      //set Audio Source
      await audioPlayerOnlineListen.setAudioSource(
        ConcatenatingAudioSource(
          shuffleOrder: DefaultShuffleOrder(),
          children: [...audioSource],
        ),
        initialIndex: currentSurah,
        initialPosition: Duration.zero,
      );
      logger.i('Load Audio Source: ${audioPlayerOnlineListen.duration}');
      return audioPlayerOnlineListen;
    } catch (e) {
      logger.e('error load audio source $e');
      rethrow;
    }
  }

  @override
  Future<AudioPlayer> initPlayerFile(String filePath) async {
    final audioPlayer = AudioPlayer();
    await audioPlayer.setFilePath(
      filePath,
    );
    return audioPlayer;
  }

  @override
  Future<AudioPlayer> initPlayerNetwork(String url) async {
    final audioPlayer = AudioPlayer();
    await audioPlayer.setUrl(
      url,
    );
    return audioPlayer;
  }

  @override
  Future<List<QuranReaderModel>> loadMostReaderData() async {
    try {
      final list = await JsonLoaderService.loadJsonList(
        JsonLoaderService.mostReaderPath,
      );

      final names = list.map(QuranReaderModel.fromJson).toList();
      logger.i('Load Most Reader Data: ${names.length}');
      return names;
    } catch (e) {
      logger.e('error load most reader data $e');
      rethrow;
    }
  }

  @override
  Future<List<SurahInfoModel>> loadSurahInfoData() async {
    try {
      final list = await JsonLoaderService.loadJsonList(
        JsonLoaderService.surahInfoPath,
      );
      final models = list.map(SurahInfoModel.fromJson).toList();
      logger.i('Load Surah Info Data: ${models.length}');
      return models;
    } catch (e) {
      logger.e('error load surah info data $e');
      rethrow;
    }
  }
}
