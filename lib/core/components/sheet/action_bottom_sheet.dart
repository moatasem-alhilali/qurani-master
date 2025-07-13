import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ActionBottomSheet on BuildContext {
  void showActionBottomSheet({
    required List<ActionSheetItem> actions,
    String? title,
    String? message,
    ActionSheetItem? cancelAction,
    bool showCancelButton = true,
    Color? backgroundColor,
    Color? barrierColor,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    showModalBottomSheet<void>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useSafeArea: true,
      useRootNavigator: true,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.4),
      builder: (context) {
        return ActionBottomSheetContent(
          title: title,
          message: message,
          actions: actions,
          cancelAction: cancelAction,
          showCancelButton: showCancelButton,
          backgroundColor: backgroundColor,
          titleStyle: titleStyle,
          messageStyle: messageStyle,
        );
      },
    );
  }
}

class ActionSheetItem {
  const ActionSheetItem({
    required this.title,
    this.onTap,
    this.textColor,
    this.backgroundColor,
    this.icon,
    this.isDestructive = false,
    this.isDisabled = false,
    this.textStyle,
  });
  final String title;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? backgroundColor;
  final IconData? icon;
  final bool isDestructive;
  final bool isDisabled;
  final TextStyle? textStyle;
}

class ActionBottomSheetContent extends StatefulWidget {
  const ActionBottomSheetContent({
    required this.actions,
    super.key,
    this.title,
    this.message,
    this.cancelAction,
    this.showCancelButton = true,
    this.backgroundColor,
    this.titleStyle,
    this.messageStyle,
  });
  final String? title;
  final String? message;
  final List<ActionSheetItem> actions;
  final ActionSheetItem? cancelAction;
  final bool showCancelButton;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  @override
  State<ActionBottomSheetContent> createState() =>
      _ActionBottomSheetContentState();
}

class _ActionBottomSheetContentState extends State<ActionBottomSheetContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0,
              _slideAnimation.value * MediaQuery.of(context).size.height * 0.5),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main actions container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header section
                        if (widget.title != null || widget.message != null)
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
                            child: Column(
                              children: [
                                if (widget.title != null)
                                  Text(
                                    widget.title!,
                                    style: widget.titleStyle ??
                                        TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                if (widget.title != null &&
                                    widget.message != null)
                                  SizedBox(height: 4.h),
                                if (widget.message != null)
                                  Text(
                                    widget.message!,
                                    style: widget.messageStyle ??
                                        TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[600],
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          ),

                        // Actions
                        ...widget.actions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final action = entry.value;
                          final isLast = index == widget.actions.length - 1;

                          return _ActionItem(
                            action: action,
                            isLast: isLast,
                            onTap: () {
                              _dismissSheet();
                              action.onTap?.call();
                            },
                          );
                        }),
                      ],
                    ),
                  ),

                  // Cancel button
                  if (widget.showCancelButton) SizedBox(height: 8.h),
                  if (widget.showCancelButton)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _ActionItem(
                        action: widget.cancelAction ??
                            ActionSheetItem(
                              title: 'Cancel',
                              textColor: Colors.blue,
                              textStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        isLast: true,
                        onTap: () {
                          _dismissSheet();
                          widget.cancelAction?.onTap?.call();
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.action,
    super.key,
    this.isLast = false,
    this.onTap,
  });
  final ActionSheetItem action;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.isDisabled ? null : onTap,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
          bottom: isLast ? Radius.circular(16.r) : Radius.zero,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: action.backgroundColor,
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (action.icon != null) ...[
                Icon(
                  action.icon,
                  size: 20.sp,
                  color: action.isDisabled
                      ? Colors.grey
                      : action.isDestructive
                          ? Colors.red
                          : action.textColor ?? Colors.blue,
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                action.title,
                style: action.textStyle ??
                    TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: action.isDisabled
                          ? Colors.grey
                          : action.isDestructive
                              ? Colors.red
                              : action.textColor ?? Colors.blue,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
