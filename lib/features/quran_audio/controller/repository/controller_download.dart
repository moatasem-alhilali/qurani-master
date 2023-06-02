import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_app/core/local/db.dart';
import 'package:quran_app/features/offline_audio/model/quran_audio_offline.dart';

import 'audio_player_helper.dart';

class DownloadController {
  static String audioPath = "";
  //download the audio
  static Future<double> downloadAudio() async {
    Dio dio = Dio();

    double progress = 0;
    String urlAudioReader = "https://cdn.islamic.network/quran/audio-surah/128";
    //url
    String url =
        "$urlAudioReader/${AudioPlayerHelper.currentAudioData.identifier}/${AudioPlayerHelper.currentAudioData.indexSurah}.mp3";

    //get the path
    audioPath = await _getFilePath(
      filename:
          "${AudioPlayerHelper.currentAudioData.nameReader}/${AudioPlayerHelper.currentAudioData.nameSurah}/${AudioPlayerHelper.currentAudioData.identifier}.mp3",
    );

    //download the audio
    await dio.download(
      url,
      audioPath,
      onReceiveProgress: (receivedBytes, totalBytes) {
        progress = (receivedBytes / totalBytes * 100).clamp(0.0, 100.0);

        print('Download progress: ${receivedBytes / totalBytes * 100}%');
      },
      deleteOnError: true,
    );

    return progress;
  }

  //get File Path
  static Future<String> _getFilePath({
    required String filename,
  }) async {
    var dir = await getApplicationDocumentsDirectory();

    return "${dir.path}/$filename";
  }

  //insert audio
  static Future<int> insertAudio({
    required String audio_path,
  }) async {
    QuranAudioModel quranAudioModel = QuranAudioModel(
      audio_path: audio_path,
      count_verse:
          AudioPlayerHelper.currentAudioData.countSurahVerse.toString(),
      nameReader: AudioPlayerHelper.currentAudioData.nameReader,
      nameSurah: AudioPlayerHelper.currentAudioData.nameSurah,
      imageReader: AudioPlayerHelper.currentAudioData.imageReader,
    );
    return await DBHelperAudio.addAudio(quranAudioModel);
  }

  //get Audio Path
  static Future<List<QuranAudioModel>> getAudioPath() async {
    List<QuranAudioModel> data = [];
    final result = await DBHelperAudio.getAllAudio();
    for (var element in result) {
      data.add(QuranAudioModel.fromJson(element));
    }
    print(data);
    return data;
  }
}
