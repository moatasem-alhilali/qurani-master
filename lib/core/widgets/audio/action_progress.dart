import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class ActionProgress extends StatelessWidget {
  const ActionProgress({
    required this.audioPlayer,
    required this.currentIndex,
    required this.onPressed,
    required this.itemIndex,
    super.key,
  });

  final AudioPlayer audioPlayer;
  final int currentIndex;
  final int itemIndex;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        return StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            final currentPlaying = currentIndex == itemIndex;

            if (!(playing ?? false) || !currentPlaying) {
              return CircleAvatar(
                radius: 18,
                backgroundColor: context.primaryColor,
                child: FittedBox(
                  child: IconButton(
                    onPressed: () {
                      audioPlayer
                        ..seek(Duration.zero, index: itemIndex)
                        ..play();
                      onPressed();
                    },
                    icon: const Icon(Icons.play_arrow_outlined),
                  ),
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return CircleAvatar(
                radius: 18,
                backgroundColor: Colors.redAccent,
                child: FittedBox(
                  child: IconButton(
                    onPressed: audioPlayer.pause,
                    icon: const Icon(
                      Icons.stop_circle_outlined,
                    ),
                  ),
                ),
              );
            } else {
              return CircleAvatar(
                radius: 18,
                backgroundColor: context.primaryColor,
                child: const Icon(Icons.play_arrow_rounded),
              );
            }
          },
        );
      },
    );
  }
}
