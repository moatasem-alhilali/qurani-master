import 'package:just_audio/just_audio.dart';
import 'package:quran_app/main.dart';

class AudioService {
  late AudioPlayer audioPlayer;
  AudioService() {
    audioPlayer = AudioPlayer();
  }

  List<AudioSource>? setAudioSource(List<String> urls, {bool offline = false}) {
    try {
      return urls.map((url) {
        logger.i(url);
        return offline
            ? AudioSource.file(url)
            : AudioSource.uri(Uri.parse(url));
      }).toList();
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  Future<void> initAudiosNetworks(List<String> urls,
      {bool offline = false}) async {
    try {
      final audioSource = setAudioSource(urls, offline: offline);
      if (audioSource != null && audioSource.isNotEmpty) {
        await audioPlayer.setAudioSource(
          ConcatenatingAudioSource(
            useLazyPreparation: true,
            shuffleOrder: DefaultShuffleOrder(),
            children: [...audioSource],
          ),
          initialIndex: 0,
          initialPosition: Duration.zero,
        );
      }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> playSeek(int index) async {
    await audioPlayer.seek(
      const Duration(seconds: 0),
      index: index,
    );
  }

  Future<void> playSeekToNext() async {
    await audioPlayer.seekToNext();
  }

  Future<void> playSeekToPrevious() async {
    await audioPlayer.seekToPrevious();
  }
}
