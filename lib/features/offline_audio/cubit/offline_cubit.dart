import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/quran_audio/controller/repository/controller_download.dart';

part 'offline_state.dart';

class OfflineCubit extends Cubit<OfflineState> {
  OfflineCubit() : super(OfflineInitial());

  static OfflineCubit get(context) => BlocProvider.of(context);

  bool isDownload = false;
  double progress = 0;

  //
  Future<void> downloadAudio() async {
    String audioPath = "";
    await notifyHelper.displayNotification(
      title: "بدأ تنزيل سورة ${AudioPlayerHelper.currentAudioData.nameSurah}",
      body: "سيتم اشعارك عند الانتهاء من التنزيل",
    );
    isDownload = true;

    emit(DownloadAudioOfflineLoadingState());
    try {
      Dio dio = Dio();

      String urlAudioReader =
          "https://cdn.islamic.network/quran/audio-surah/128";
      //  String path = await _getFilePath("${widget.nameReader}/${widget.nameSurah}/${widget.url!}");

      //get the path
      audioPath = await _getFilePath(
        filename:
            "${AudioPlayerHelper.currentAudioData.nameReader}/${AudioPlayerHelper.currentAudioData.nameSurah}/${AudioPlayerHelper.currentAudioData.identifier}/${AudioPlayerHelper.currentAudioData.indexSurah}.mp3",
      );

      //url
      String url =
          "$urlAudioReader/${AudioPlayerHelper.currentAudioData.identifier}/${AudioPlayerHelper.currentAudioData.indexSurah}.mp3";
      //download the audio
      await dio.download(
        url,
        audioPath,
        onReceiveProgress: (receivedBytes, totalBytes) {
          progress = (receivedBytes / totalBytes * 100).round().toDouble();
          emit(DownloadAudioOfflineSuccessState());
        },
        deleteOnError: true,
      );

      //

      //insert audio
      await DownloadController.insertAudio(
        audio_path: audioPath,
      );
      await notifyHelper.displayNotification(
        title:
            "تم تنزيل سورة ${AudioPlayerHelper.currentAudioData.nameSurah} يمكنك سماعها من خلال تطبيقنا",
        body: " يمكنك سماعها من خلال تطبيقنا",
      );
      isDownload = false;
      getAudioPath();
      emit(DownloadAudioOfflineSuccessState());
    } catch (e) {
      isDownload = false;

      print(e);
      await notifyHelper.displayNotification(
          title: "السورة محمله بالفعل",
          body:
              "هناك خطأ في تنزيل سورة${AudioPlayerHelper.currentAudioData.nameSurah}");
      emit(DownloadAudioOfflineErrorState());
    }
  }

  //get Audio Path
  void getAudioPath() async {
    emit(GetAudioOfflineLoadingState());
    try {
      final data = await DownloadController.getAudioPath();
      quranAudioDataGlobal = data;

      emit(GetAudioOfflineSuccessState());
    } catch (e) {
      print(e);
      emit(GetAudioOfflineErrorState());
    }
  }

  //get File Path
  static Future<String> _getFilePath({
    required String filename,
  }) async {
    var dir = await getApplicationDocumentsDirectory();

    return "${dir.path}/$filename";
  }
}
