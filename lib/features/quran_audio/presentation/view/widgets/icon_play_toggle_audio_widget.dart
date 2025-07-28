import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/widgets/icon_button_widget.dart';

//

class IconPlayToggleAudioWidget extends StatefulWidget {
  const IconPlayToggleAudioWidget({
    required this.audioPlayer,
    this.radius = 22,
    this.onPressed,
    this.backgroundColor,
    super.key,
  });

  final AudioPlayer audioPlayer;
  final double radius;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  @override
  State<IconPlayToggleAudioWidget> createState() =>
      _IconPlayToggleAudioWidgetState();
}

class _IconPlayToggleAudioWidgetState extends State<IconPlayToggleAudioWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
      value: 0, // 0: play icon, 1: pause icon
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePlayPause(bool playing) {
    // animate icon
    if (playing) {
      _animationController.reverse(); // to play icon
      widget.audioPlayer.pause();
    } else {
      _animationController.forward(); // to pause icon
      widget.audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: widget.audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing ?? false;

        // keep animation in sync with player state (useful for external triggers)
        if (playing &&
            _animationController.status != AnimationStatus.forward &&
            _animationController.value == 0) {
          _animationController.forward();
        }
        if (!playing &&
            _animationController.status != AnimationStatus.reverse &&
            _animationController.value == 1) {
          _animationController.reverse();
        }

        return _buildIconButton(playing, processingState);
      },
    );
  }

  Widget _buildIconButton(
    bool playing,
    ProcessingState? processingState,
  ) {
    if (processingState == ProcessingState.completed) {
      return const Icon(
        Icons.play_arrow_rounded,
        // size: 28,
      );
    }

    return IconButtonWidget(
      tooltip: 'تشغيل/إيقاف',
      onPressed: widget.onPressed ??
          () {
            _handlePlayPause(playing);
          },
      icon: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: _animationController,
        // size: 28,
      ),
    );
  }
}
