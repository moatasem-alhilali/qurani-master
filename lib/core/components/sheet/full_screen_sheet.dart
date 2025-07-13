import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension FullScreenSheet on BuildContext {
  void showFullScreenSheet({
    required Widget child,
    String? title,
    bool showCloseButton = true,
    bool isDismissible = true,
    Color? backgroundColor,
    Color? barrierColor,
    VoidCallback? onDismissed,
    Widget? leading,
    List<Widget>? actions,
    PreferredSizeWidget? appBar,
    Duration animationDuration = const Duration(milliseconds: 350),
  }) {
    showModalBottomSheet<void>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useSafeArea: true,
      useRootNavigator: true,
      isDismissible: isDismissible,
      enableDrag: false,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
      builder: (context) {
        return FullScreenSheetContent(
          title: title,
          showCloseButton: showCloseButton,
          backgroundColor: backgroundColor,
          onDismissed: onDismissed,
          leading: leading,
          actions: actions,
          appBar: appBar,
          animationDuration: animationDuration,
          child: child,
        );
      },
    );
  }
}

class FullScreenSheetContent extends StatefulWidget {
  const FullScreenSheetContent({
    required this.child,
    super.key,
    this.title,
    this.showCloseButton = true,
    this.backgroundColor,
    this.onDismissed,
    this.leading,
    this.actions,
    this.appBar,
    this.animationDuration = const Duration(milliseconds: 350),
  });
  final Widget child;
  final String? title;
  final bool showCloseButton;
  final Color? backgroundColor;
  final VoidCallback? onDismissed;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? appBar;
  final Duration animationDuration;

  @override
  State<FullScreenSheetContent> createState() => _FullScreenSheetContentState();
}

class _FullScreenSheetContentState extends State<FullScreenSheetContent>
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
        curve: Curves.easeOutExpo,
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
      begin: 0.9,
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0, _slideAnimation.value * MediaQuery.of(context).size.height),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Custom App Bar or Default Header
                    if (widget.appBar != null)
                      widget.appBar!
                    else
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          16.w,
                          MediaQuery.of(context).viewPadding.top + 8.h,
                          16.w,
                          16.h,
                        ),
                        decoration: BoxDecoration(
                          color: widget.backgroundColor ?? Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Leading widget or close button
                            if (widget.leading != null)
                              widget.leading!
                            else if (widget.showCloseButton)
                              GestureDetector(
                                onTap: _dismissSheet,
                                child: Container(
                                  width: 32.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 20.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),

                            // Title
                            if (widget.title != null) ...[
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Text(
                                  widget.title!,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ] else
                              const Spacer(),

                            // Actions
                            if (widget.actions != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: widget.actions!,
                              ),
                          ],
                        ),
                      ),

                    // Content
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.r),
                        ),
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper widget for creating action buttons in the header
class SheetActionButton extends StatelessWidget {
  const SheetActionButton({
    required this.text,
    super.key,
    this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.isDestructive = false,
    this.isDisabled = false,
  });
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final bool isDestructive;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? (isDestructive ? Colors.red : Colors.blue),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDisabled ? Colors.grey : textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}

// Helper widget for creating icon buttons in the header
class SheetIconButton extends StatelessWidget {
  const SheetIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: size ?? 20.sp,
          color: color ?? Colors.grey[600],
        ),
      ),
    );
  }
}
