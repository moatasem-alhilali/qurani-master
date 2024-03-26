import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/theme/themeData.dart';

class Controller extends StatelessWidget {
  const Controller({Key? key, required this.audioPlayer}) : super(key: key);
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: StreamBuilder<PlayerState>(
        stream: audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;
          if (!(playing ?? false)) {
            return CircleAvatar(
              backgroundColor: FxColors.primary,
              child: IconButton(
                onPressed: audioPlayer.play,
                icon: const Icon(Icons.play_arrow_outlined),
              ),
            );
          } else if (processingState != ProcessingState.completed) {
            return CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: IconButton(
                onPressed: audioPlayer.pause,
                icon: const Icon(
                  Icons.stop_circle_outlined,
                ),
              ),
            );
          } else {
            return CircleAvatar(
              backgroundColor: FxColors.primary,
              child: const Icon(Icons.play_arrow_rounded),
            );
          }
        },
      ),
    );
  }
}
