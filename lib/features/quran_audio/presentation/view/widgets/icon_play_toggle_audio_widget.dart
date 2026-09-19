import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/l10n/l10n.dart';

/// زرّ التشغيل/الإيقاف الرئيسي في مشغّل الصوت.
///
/// هو العنصر المرتفع الوحيد في المشغّل: دائرة ذهبية بأيقونة متحرّكة، وما حوله
/// من أزرار يبقى بلا تعبئة حتى يبقى هو البطل.
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

        // keep animation in sync with player state (useful for external
        // triggers)
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
    final skin = AppSkin.of(context);
    final diameter = widget.radius * 2;
    final onGold = skin.isDark ? AppColors.brandNight : AppColors.brandIvory;

    return Semantics(
      label: context.l10n.quranAudioPlayPause,
      button: true,
      child: InkWell(
        onTap: widget.onPressed ??
            () {
              if (processingState == ProcessingState.completed) {
                widget.audioPlayer.play();
                return;
              }
              _handlePlayPause(playing);
            },
        borderRadius: BorderRadius.circular(999.r),
        child: Ink(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.gold,
            shape: BoxShape.circle,
            boxShadow: skin.raisedShadow,
          ),
          child: Center(
            child: processingState == ProcessingState.completed
                ? Icon(
                    Icons.play_arrow_rounded,
                    color: onGold,
                    size: widget.radius,
                  )
                : AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _animationController,
                    color: onGold,
                    size: widget.radius,
                  ),
          ),
        ),
      ),
    );
  }
}
