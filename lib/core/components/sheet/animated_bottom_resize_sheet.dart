import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

extension AnimatedBottomResizeSheet on BuildContext {
  void showAnimatedBottomResizeSheet({
    required Widget Function(ScrollController scrollController) builder,
    double initialHeight = 0.4,
    double minHeight = 0.2,
    double maxHeight = 0.9,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    Color? barrierColor,
    VoidCallback? onDismissed,
    Duration animationDuration = const Duration(milliseconds: 400),
  }) {
    showModalBottomSheet<void>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useSafeArea: true,
      useRootNavigator: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.4),
      builder: (context) {
        return AnimatedBottomSheetContent(
          initialHeight: initialHeight,
          minHeight: minHeight,
          maxHeight: maxHeight,
          backgroundColor: backgroundColor,
          onDismissed: onDismissed,
          animationDuration: animationDuration,
          builder: builder,
        );
      },
    );
  }
}

class AnimatedBottomSheetContent extends StatefulWidget {
  const AnimatedBottomSheetContent({
    required this.builder,
    super.key,
    this.initialHeight = 0.4,
    this.minHeight = 0.2,
    this.maxHeight = 0.9,
    this.backgroundColor,
    this.onDismissed,
    this.animationDuration = const Duration(milliseconds: 400),
  });
  final Widget Function(ScrollController scrollController) builder;
  final double initialHeight;
  final double minHeight;
  final double maxHeight;
  final Color? backgroundColor;
  final VoidCallback? onDismissed;
  final Duration animationDuration;

  @override
  State<AnimatedBottomSheetContent> createState() =>
      _AnimatedBottomSheetContentState();
}

class _AnimatedBottomSheetContentState extends State<AnimatedBottomSheetContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismissSheet() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onDismissed?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: widget.animationDuration,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              _slideAnimation.value * MediaQuery.of(context).size.height,
            ),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: DraggableScrollableSheet(
                  initialChildSize: widget.initialHeight,
                  minChildSize: widget.minHeight,
                  maxChildSize: widget.maxHeight,
                  expand: false,
                  snap: true,
                  snapSizes: [
                    widget.minHeight,
                    widget.initialHeight,
                    widget.maxHeight,
                  ],
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ??
                            context.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, -8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Enhanced Handle bar with gesture
                          GestureDetector(
                            onTap: _dismissSheet,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Center(
                                child: Container(
                                  width: 50.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(2.5.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Content
                          Expanded(
                            child: widget.builder(scrollController),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
