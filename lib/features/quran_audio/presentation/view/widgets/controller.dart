import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';

class Controller extends StatelessWidget {
  const Controller({required this.audioPlayer, super.key});
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<PlayerState>(
        stream: audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;
          if (!(playing ?? false)) {
            return CircleAvatar(
              backgroundColor: context.primaryScheme,
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
              backgroundColor: context.primaryScheme,
              child: const Icon(Icons.play_arrow_rounded),
            );
          }
        },
      ),
    );
  }
}
