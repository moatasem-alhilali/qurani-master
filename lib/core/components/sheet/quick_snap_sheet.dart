import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension QuickSnapSheet on BuildContext {
  void showQuickSnapSheet({
    required Widget child,
    double? height,
    List<double>? snapHeights,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    Color? barrierColor,
    VoidCallback? onDismissed,
    bool showHandle = true,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Duration animationDuration = const Duration(milliseconds: 250),
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
        return QuickSnapSheetContent(
          height: height,
          snapHeights: snapHeights,
          backgroundColor: backgroundColor,
          onDismissed: onDismissed,
          showHandle: showHandle,
          padding: padding,
          borderRadius: borderRadius,
          animationDuration: animationDuration,
          child: child,
        );
      },
    );
  }
}

class QuickSnapSheetContent extends StatefulWidget {
  const QuickSnapSheetContent({
    required this.child,
    super.key,
    this.height,
    this.snapHeights,
    this.backgroundColor,
    this.onDismissed,
    this.showHandle = true,
    this.padding,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 250),
  });
  final Widget child;
  final double? height;
  final List<double>? snapHeights;
  final Color? backgroundColor;
  final VoidCallback? onDismissed;
  final bool showHandle;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Duration animationDuration;

  @override
  State<QuickSnapSheetContent> createState() => _QuickSnapSheetContentState();
}

class _QuickSnapSheetContentState extends State<QuickSnapSheetContent>
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
        curve: Curves.easeOutQuart,
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
      begin: 0.98,
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
    final screenHeight = MediaQuery.of(context).size.height;
    final defaultHeight = screenHeight * 0.3;
    final sheetHeight = widget.height ?? defaultHeight;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 8) {
              _dismissSheet();
            }
          },
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value * sheetHeight),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: sheetHeight,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? Colors.white,
                      borderRadius: widget.borderRadius ??
                          BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 25,
                          offset: const Offset(0, -5),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 50,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle bar
                        if (widget.showHandle)
                          GestureDetector(
                            onTap: _dismissSheet,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Center(
                                child: Container(
                                  width: 45.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.35),
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Content
                        Expanded(
                          child: Padding(
                            padding: widget.padding ?? EdgeInsets.all(16.w),
                            child: widget.child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper extension for showing quick content with predefined heights
extension QuickSnapSheetSizes on BuildContext {
  void showSmallSnapSheet({
    required Widget child,
    bool isDismissible = true,
    Color? backgroundColor,
    VoidCallback? onDismissed,
  }) {
    showQuickSnapSheet(
      child: child,
      height: MediaQuery.of(this).size.height * 0.25,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      onDismissed: onDismissed,
    );
  }

  void showMediumSnapSheet({
    required Widget child,
    bool isDismissible = true,
    Color? backgroundColor,
    VoidCallback? onDismissed,
  }) {
    showQuickSnapSheet(
      child: child,
      height: MediaQuery.of(this).size.height * 0.4,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      onDismissed: onDismissed,
    );
  }

  void showLargeSnapSheet({
    required Widget child,
    bool isDismissible = true,
    Color? backgroundColor,
    VoidCallback? onDismissed,
  }) {
    showQuickSnapSheet(
      child: child,
      height: MediaQuery.of(this).size.height * 0.6,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      onDismissed: onDismissed,
    );
  }
}

// Helper widget for quick list actions
class QuickActionList extends StatelessWidget {
  const QuickActionList({
    required this.actions,
    super.key,
    this.title,
    this.titleStyle,
    this.padding,
  });
  final List<QuickActionItem> actions;
  final String? title;
  final TextStyle? titleStyle;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: padding ?? EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Text(
              title!,
              style: titleStyle ??
                  TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
            ),
          ),
        ],
        Expanded(
          child: ListView.separated(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: actions.length,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final action = actions[index];
              return _QuickActionTile(action: action);
            },
          ),
        ),
      ],
    );
  }
}

class QuickActionItem {
  const QuickActionItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.isDestructive = false,
  });
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool isDestructive;
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.action,
    super.key,
  });
  final QuickActionItem action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          action.onTap?.call();
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: action.backgroundColor ?? Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              if (action.icon != null) ...[
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: action.isDestructive
                        ? Colors.red.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    action.icon,
                    size: 20.sp,
                    color: action.iconColor ??
                        (action.isDestructive ? Colors.red : Colors.blue),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            action.isDestructive ? Colors.red : Colors.black87,
                      ),
                    ),
                    if (action.subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        action.subtitle!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18.sp,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
