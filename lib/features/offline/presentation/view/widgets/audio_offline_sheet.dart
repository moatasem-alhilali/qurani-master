import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/widgets/audio/custom_progress.dart';
import 'package:quran_app/main.dart';

class AudioOfflineSheet extends StatefulWidget {
  const AudioOfflineSheet({super.key, this.data});
  final dynamic data;

  @override
  State<AudioOfflineSheet> createState() => _AudioOfflineSheetState();
}

class _AudioOfflineSheetState extends State<AudioOfflineSheet> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    var path = widget.data['path'];

    logger.i(path);
    try {
      await _audioPlayer.setFilePath(path);
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void dispose() {
    _audioPlayer.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressAudio(
          audioPlayer: _audioPlayer,
          isOffline: true,
        ),
        const SizedBox(height: 5),
        Text(
          "الوصف:  ${widget.data['description']}",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(4),
          // margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: FxColors.third,
          ),
          child: Text(
            "مسار التنزيل: \n  ${widget.data['path']}",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
