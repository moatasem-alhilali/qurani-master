import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/jsons/moast_reader_text.dart';
import 'package:quran_app/core/jsons/quran_text.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';

class AudioPlayerRepo {
  //Audio Player object
  static late AudioPlayer audioPlayerDetail;
  static late AudioPlayer audioPlayerOnlineListen;
  //init Audio Player Detail
  static void initAudioPlayerDetail({required String filePath}) {
    audioPlayerDetail = AudioPlayer()..setFilePath(filePath);
  }

  static int currentSurah = 0;
  static int currentReader = 0;
  static List<AudioSource> audioSource = [];

  //!current audio data
  static CurrentAudioModel currentAudioData = CurrentAudioModel(
    countSurahVerse: myQuranText[0]['count'] as int,
    imageReader: mostReaderData[0]['image'] as String,
    nameReader: mostReaderData[0]['name'] as String,
    nameSurah: myQuranText[0]['titleAr'] as String,
    identifier: mostReaderData[0]['identifier'] as String,
    indexSurah: 1,
  );

  //play Audio Online Listen Seek To
  static Future<void> playAudioOnlineListenSeekTo({required int index}) async {
    await audioPlayerOnlineListen.seek(
      const Duration(),
      index: index,
    );
  }

//init Player Online Listen audio Source
  static Future<void> initPlayerOnlineListenAudioSource() async {
    //init the audio source
    audioPlayerOnlineListen = AudioPlayer();
    audioSource.clear();

    //insert url to list of Audio Source
    for (var i = 1; i <= 114; i++) {
      final url =
          'https://cdn.islamic.network/quran/audio-surah/128/${currentAudioData.identifier}/$i.mp3';
      //

      final audio = AudioSource.uri(Uri.parse(url));
      print(audio);
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
  }
}
