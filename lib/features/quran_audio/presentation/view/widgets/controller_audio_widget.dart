import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/models_public/position_data_model.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ProgressWithControllerWidget extends StatelessWidget {
  const ProgressWithControllerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranAudioBloc, QuranAudioState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: StreamBuilder<PositionData>(
                stream: positionDataStreamOfOnlineListing(state),
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: ProgressBar(
                      progressBarColor: context.primaryScheme,
                      baseBarColor: context.primaryScheme.withOpacity(0.24),
                      bufferedBarColor: context.primaryScheme.withOpacity(0.24),
                      thumbColor: context.primaryScheme,
                      barHeight: 8,
                      thumbRadius: 5,
                      timeLabelTextStyle: titleMedium(context),
                      timeLabelLocation: TimeLabelLocation.sides,
                      progress: ISCONNECTED
                          ? positionData?.position ?? Duration.zero
                          : Duration.zero,
                      buffered: ISCONNECTED
                          ? positionData?.bufferedPosition ?? Duration.zero
                          : Duration.zero,
                      total: ISCONNECTED
                          ? positionData?.duration ?? Duration.zero
                          : Duration.zero,
                      onSeek:
                          ISCONNECTED ? state.audioPlayerSource!.seek : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //icon controller

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  Row(
                    children: [
                      //next
                      _AnimatedControlButton(
                        backgroundColor: Colors.white,
                        onTap: () async {
                          context.read<QuranAudioBloc>().add(
                                PlayAudioNextOrPreviousEvent(
                                  isNext: true,
                                ),
                              );
                        },
                        child: const Icon(
                          Icons.skip_next_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),

                      //!Controller audio
                      BlocBuilder<QuranAudioBloc, QuranAudioState>(
                        builder: (context, state) {
                          if (state.loadAudioSourceState ==
                              RequestState.loading) {
                            return const _AnimatedLoadingIndicator();
                          }
                          if (state.loadAudioSourceState ==
                              RequestState.error) {
                            return _AnimatedControlButton(
                              backgroundColor: context.primaryScheme,
                              onTap: () {
                                context.read<QuranAudioBloc>().add(
                                      PlayAudioNextOrPreviousEvent(
                                        isNext: true,
                                      ),
                                    );
                              },
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                              ),
                            );
                          }

                          return _ActionProgress(
                            currentIndex: 0,
                            itemIndex: 0,
                            audioPlayer: state.audioPlayerSource!,
                          );
                        },
                      ),

                      const SizedBox(
                        width: 20,
                      ),

                      //back
                      _AnimatedControlButton(
                        backgroundColor: Colors.white,
                        onTap: () async {
                          context.read<QuranAudioBloc>().add(
                                PlayAudioNextOrPreviousEvent(
                                  isNext: false,
                                ),
                              );
                        },
                        child: const Icon(
                          Icons.skip_previous_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedControlButton extends StatefulWidget {
  const _AnimatedControlButton({
    required this.child,
    required this.onTap,
    required this.backgroundColor,
  });
  final Widget child;
  final VoidCallback onTap;
  final Color backgroundColor;

  @override
  State<_AnimatedControlButton> createState() => _AnimatedControlButtonState();
}

class _AnimatedControlButtonState extends State<_AnimatedControlButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    _rotationController.forward().then((_) {
      _rotationController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _rotationController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: StyleButtonWrap(
              onTap: _handleTap,
              child: CircleAvatar(
                backgroundColor: widget.backgroundColor,
                child: FittedBox(
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedLoadingIndicator extends StatefulWidget {
  const _AnimatedLoadingIndicator();

  @override
  State<_AnimatedLoadingIndicator> createState() =>
      _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<_AnimatedLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              context.primaryScheme,
            ),
          ),
        );
      },
    );
  }
}

Stream<PositionData> positionDataStreamOfOnlineListing(QuranAudioState state) =>
    Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      state.audioPlayerSource?.positionStream ?? Stream.value(Duration.zero),
      state.audioPlayerSource?.bufferedPositionStream ??
          Stream.value(Duration.zero),
      state.audioPlayerSource?.durationStream ?? Stream.value(Duration.zero),
      (position, bufferedPosition, duration) {
        return PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        );
      },
    );

class _ActionProgress extends StatefulWidget {
  const _ActionProgress({
    required this.audioPlayer,
    required this.currentIndex,
    required this.itemIndex,
    super.key,
  });

  final AudioPlayer audioPlayer;
  final int currentIndex;
  final int itemIndex;

  @override
  State<_ActionProgress> createState() => _ActionProgressState();
}

class _ActionProgressState extends State<_ActionProgress>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _colorController;
  late AnimationController _scaleController;
  late Animation<double> _iconRotation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _iconRotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.elasticOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.9,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    _colorController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handlePlayPause() {
    _iconController.forward().then((_) => _iconController.reverse());
    _scaleController.forward().then((_) => _scaleController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    _colorAnimation = ColorTween(
      begin: context.primaryScheme,
      end: Colors.redAccent,
    ).animate(_colorController);

    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        return StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            final currentPlaying = widget.currentIndex == widget.itemIndex;

            // Update color animation based on playing state
            if (playing == true && currentPlaying) {
              _colorController.forward();
            } else {
              _colorController.reverse();
            }

            return AnimatedBuilder(
              animation: Listenable.merge([
                _iconController,
                _colorController,
                _scaleController,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _iconRotation.value * 0.1,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: _colorAnimation.value,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return RotationTransition(
                            turns: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: _buildIconButton(
                          playing,
                          currentPlaying,
                          processingState,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildIconButton(
    bool? playing,
    bool currentPlaying,
    ProcessingState? processingState,
  ) {
    if (!(playing ?? false) || !currentPlaying) {
      return IconButton(
        key: const ValueKey('play'),
        onPressed: () {
          _handlePlayPause();
          widget.audioPlayer.play();
        },
        icon: const Icon(
          Icons.play_arrow_outlined,
          color: Colors.white,
          size: 28,
        ),
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        key: const ValueKey('pause'),
        onPressed: () {
          _handlePlayPause();
          widget.audioPlayer.pause();
        },
        icon: const Icon(
          Icons.pause_outlined,
          color: Colors.white,
          size: 28,
        ),
      );
    } else {
      return const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 28,
        key: ValueKey('completed'),
      );
    }
  }
}
