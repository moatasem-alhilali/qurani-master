import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({super.key, required this.url, this.offline = false});
  final String url;
  final bool offline;
  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.offline) {
      _controller = VideoPlayerController.file(
        File(widget.url),
      )..initialize().then((_) {
          setState(() {});

          _controller.addListener(() {
            setState(() {});
          });
        });
    } else {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          widget.url,
        ),
      )..initialize().then((_) {
          setState(() {});

          _controller.addListener(() {
            setState(() {});
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.getHight(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // if (!_controller.value.isPlaying)

              _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(),
              Positioned.fill(
                child: AnimatedContainer(
                  duration: 500.milliseconds,
                  decoration: BoxDecoration(
                    color: !_controller.value.isPlaying
                        ? Colors.black.withOpacity(0.7)
                        : Colors.transparent,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: !_controller.value.isPlaying
                          ? Colors.white
                          : Colors.transparent,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_controller.value.isInitialized)
            ProgressBar(
              baseBarColor: FxColors.primary.withOpacity(0.5),
              bufferedBarColor: FxColors.primary,
              progressBarColor: FxColors.primary,
              thumbColor: Colors.red,
              timeLabelType: TimeLabelType.totalTime,
              progress: _controller.value.position,
              // buffered: _controller.value.buffered.last.end,
              total: _controller.value.duration,
              onSeek: (duration) {
                _controller.seekTo(duration);
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class DurationState {
  const DurationState(
      {required this.progress, required this.buffered, required this.total});
  final Duration progress;
  final Duration buffered;
  final Duration total;
}
