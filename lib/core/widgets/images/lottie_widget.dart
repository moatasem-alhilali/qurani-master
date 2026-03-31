import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatefulWidget {
  const LottieWidget({
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.repeat = true,
    this.autoplay = true,
    this.frameRate = FrameRate.max,
    this.errorWidget,
    this.loadingWidget,
    this.onLoaded,
    this.onError,
    this.onComplete,
    this.controller,
    this.options,
    super.key,
  });

  /// Path to the Lottie animation file
  final String path;

  /// Width of the widget
  final double? width;

  /// Height of the widget
  final double? height;

  /// How the animation should be fitted within the widget
  final BoxFit fit;

  /// Whether the animation should repeat
  final bool repeat;

  /// Whether the animation should autoplay
  final bool autoplay;

  /// Frame rate for the animation
  final FrameRate frameRate;

  /// Widget to show when there's an error loading the animation
  final Widget? errorWidget;

  /// Widget to show while loading the animation
  final Widget? loadingWidget;

  /// Callback when animation is loaded
  final void Function(LottieComposition)? onLoaded;

  /// Callback when there's an error loading the animation
  final void Function(dynamic)? onError;

  /// Callback when animation completes
  final VoidCallback? onComplete;

  /// External animation controller
  final AnimationController? controller;

  /// Additional Lottie options
  final LottieOptions? options;

  @override
  State<LottieWidget> createState() => _LottieWidgetState();
}

class _LottieWidgetState extends State<LottieWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isLoaded = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Use external controller if provided, otherwise create our own
    _controller = widget.controller ?? AnimationController(vsync: this);

    // Add listener for completion callback
    if (widget.onComplete != null) {
      _controller.addStatusListener(_onStatusChanged);
    }
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  void dispose() {
    // Only dispose if we created the controller (not external)
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeStatusListener(_onStatusChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading widget while not loaded
    if (!_isLoaded && widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Lottie.asset(
        widget.path,
        controller: _controller,
        fit: widget.fit,
        frameRate: widget.frameRate,
        repeat: widget.repeat,
        addRepaintBoundary: true,
        onLoaded: (composition) {
          setState(() {
            _isLoaded = true;
          });

          // Configure the AnimationController with the duration
          _controller.duration = composition.duration;

          // Start animation if autoplay is enabled
          if (widget.autoplay) {
            _controller.forward();
          }

          // Call onLoaded callback
          if (widget.onLoaded != null) {
            widget.onLoaded!(composition);
          }
        },
        errorBuilder: (context, error, stackTrace) {
          setState(() {
            _hasError = true;
            _errorMessage = error.toString();
          });

          // Call onError callback
          if (widget.onError != null) {
            widget.onError!(error);
          }

          return widget.errorWidget ?? _buildDefaultErrorWidget();
        },
        options: widget.options,
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 24.sp,
            color: Colors.grey[600],
          ),
          SizedBox(height: 8.h),
          Text(
            'Failed to load animation',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: 4.h),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Play the animation
  void play() {
    if (_isLoaded && !_controller.isAnimating) {
      _controller.forward();
    }
  }

  /// Pause the animation
  void pause() {
    if (_isLoaded && _controller.isAnimating) {
      _controller.stop();
    }
  }

  /// Stop and reset the animation
  void stop() {
    if (_isLoaded) {
      _controller.reset();
    }
  }

  /// Get the current animation controller
  AnimationController get controller => _controller;

  /// Check if animation is loaded
  bool get isLoaded => _isLoaded;

  /// Check if there's an error
  bool get hasError => _hasError;
}

/// Extension to provide easy access to LottieWidget methods
extension LottieWidgetExtension on State {
  void playLottie(GlobalKey<_LottieWidgetState> key) {
    key.currentState?.play();
  }

  void pauseLottie(GlobalKey<_LottieWidgetState> key) {
    key.currentState?.pause();
  }

  void stopLottie(GlobalKey<_LottieWidgetState> key) {
    key.currentState?.stop();
  }
}
