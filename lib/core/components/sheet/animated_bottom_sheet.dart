import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

extension AnimatedBottomSheet on BuildContext {
  void showAnimatedBottomSheet({
    required Widget child,
    double initialHeight = 0.4,
    double minHeight = 0.2,
    double maxHeight = 0.9,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    Color? barrierColor,
    Widget? header,
    bool isScrollable = true,
    bool isExpanded = true,
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
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.4),
      builder: (context) {
        return AnimatedBottomSheetContent(
          initialHeight: initialHeight,
          minHeight: minHeight,
          maxHeight: maxHeight,
          backgroundColor: backgroundColor ?? context.scaffoldBackgroundColor,
          onDismissed: onDismissed,
          animationDuration: animationDuration,
          header: header,
          isScrollable: isScrollable,
          isExpanded: isExpanded,
          isDismissible: isDismissible,
          child: child,
        );
      },
    );
  }
}

class AnimatedBottomSheetContent extends StatefulWidget {
  const AnimatedBottomSheetContent({
    required this.child,
    this.header,
    super.key,
    this.initialHeight = 0.4,
    this.minHeight = 0.2,
    this.maxHeight = 0.9,
    this.backgroundColor,
    this.onDismissed,
    this.animationDuration = const Duration(milliseconds: 400),
    this.isScrollable = true,
    this.isExpanded = true,
    this.isDismissible = true,
  });
  final Widget child;
  final Widget? header;
  final double initialHeight;
  final double minHeight;
  final double maxHeight;
  final Color? backgroundColor;
  final VoidCallback? onDismissed;
  final Duration animationDuration;
  final bool isScrollable;
  final bool isExpanded;
  final bool isDismissible;
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
        curve: Curves.easeOutCirc,
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
        curve: Curves.easeOut,
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
                  expand: widget.isExpanded,
                  snap: true,
                  snapSizes: [
                    widget.minHeight,
                    widget.initialHeight,
                    widget.maxHeight,
                  ],
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ?? Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
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
                                    color: Colors.grey.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(2.5.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (widget.header != null) widget.header!,

                          // Content
                          Expanded(
                            child: widget.isScrollable
                                ? SingleChildScrollView(
                                    controller: scrollController,
                                    child: widget.child,
                                  )
                                : widget.child,
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
