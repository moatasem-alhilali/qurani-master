import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension CenterModalSheet on BuildContext {
  void showCenterModalSheet({
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool showCloseButton = true,
    Color? backgroundColor,
    Color? barrierColor,
    VoidCallback? onDismissed,
    EdgeInsets? padding,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    double? maxWidth,
    double? maxHeight,
    Duration animationDuration = const Duration(milliseconds: 400),
    bool resizeToAvoidBottomInset = true,
    Widget? titleWidget,
    List<Widget>? actions,
  }) {
    showGeneralDialog(
      context: this,
      barrierDismissible: isDismissible,
      barrierLabel: '',
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
      transitionDuration: animationDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return CenterModalSheetContent(
          child: child,
          title: title,
          showCloseButton: showCloseButton,
          backgroundColor: backgroundColor,
          onDismissed: onDismissed,
          padding: padding,
          margin: margin,
          borderRadius: borderRadius,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          animationDuration: animationDuration,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          titleWidget: titleWidget,
          actions: actions,
          animation: animation,
        );
      },
    );
  }
}

class CenterModalSheetContent extends StatefulWidget {
  final Widget child;
  final String? title;
  final bool showCloseButton;
  final Color? backgroundColor;
  final VoidCallback? onDismissed;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final double? maxWidth;
  final double? maxHeight;
  final Duration animationDuration;
  final bool resizeToAvoidBottomInset;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Animation<double> animation;

  const CenterModalSheetContent({
    Key? key,
    required this.child,
    this.title,
    this.showCloseButton = true,
    this.backgroundColor,
    this.onDismissed,
    this.padding,
    this.margin,
    this.borderRadius,
    this.maxWidth,
    this.maxHeight,
    this.animationDuration = const Duration(milliseconds: 400),
    this.resizeToAvoidBottomInset = true,
    this.titleWidget,
    this.actions,
    required this.animation,
  }) : super(key: key);

  @override
  State<CenterModalSheetContent> createState() =>
      _CenterModalSheetContentState();
}

class _CenterModalSheetContentState extends State<CenterModalSheetContent>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _rotationController = AnimationController(
      duration:
          Duration(milliseconds: widget.animationDuration.inMilliseconds + 200),
      vsync: this,
    );

    // Scale animation with bounce effect
    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutQuart,
    ));

    // Rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOutBack,
    ));

    // Slide animation
    _slideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutExpo,
    ));

    _scaleController.forward();
    _rotationController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _dismissSheet() {
    _scaleController.reverse();
    _rotationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onDismissed?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _rotationController]),
      builder: (context, child) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              if (widget.showCloseButton) {
                _dismissSheet();
              }
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: widget.margin ?? EdgeInsets.all(24.w),
              child: Center(
                child: SingleChildScrollView(
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: GestureDetector(
                            onTap:
                                () {}, // Prevent dismissal when tapping on content
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    widget.maxWidth ?? screenSize.width * 0.9,
                                maxHeight:
                                    widget.maxHeight ?? screenSize.height * 0.8,
                              ),
                              child: IntrinsicHeight(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color:
                                        widget.backgroundColor ?? Colors.white,
                                    borderRadius: widget.borderRadius ??
                                        BorderRadius.circular(20.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 30,
                                        offset: const Offset(0, 10),
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 60,
                                        offset: const Offset(0, 20),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Header section
                                      if (widget.title != null ||
                                          widget.titleWidget != null ||
                                          widget.showCloseButton)
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.fromLTRB(
                                              20.w, 20.h, 20.w, 0),
                                          child: Row(
                                            children: [
                                              // Title or custom title widget
                                              if (widget.titleWidget != null)
                                                Expanded(
                                                    child: widget.titleWidget!)
                                              else if (widget.title != null)
                                                Expanded(
                                                  child: Text(
                                                    widget.title!,
                                                    style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                )
                                              else
                                                const Spacer(),

                                              // Actions
                                              if (widget.actions != null)
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: widget.actions!,
                                                ),

                                              // Close button
                                              if (widget.showCloseButton)
                                                GestureDetector(
                                                  onTap: _dismissSheet,
                                                  child: Container(
                                                    width: 32.w,
                                                    height: 32.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 18.sp,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),

                                      // Content
                                      Flexible(
                                        child: Padding(
                                          padding: widget.padding ??
                                              EdgeInsets.fromLTRB(
                                                  20.w, 16.h, 20.w, 20.h),
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
                      ),
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

// Helper extension for common modal types
extension CenterModalSheetTypes on BuildContext {
  void showFormModal({
    required Widget child,
    String? title,
    bool isDismissible = true,
    VoidCallback? onDismissed,
    List<Widget>? actions,
  }) {
    showCenterModalSheet(
      child: child,
      title: title,
      isDismissible: isDismissible,
      onDismissed: onDismissed,
      actions: actions,
      resizeToAvoidBottomInset: true,
      animationDuration: const Duration(milliseconds: 450),
    );
  }

  void showConfirmationModal({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    showCenterModalSheet(
      child: ConfirmationModalContent(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
      showCloseButton: false,
      isDismissible: false,
    );
  }

  void showInfoModal({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    IconData? icon,
    Color? iconColor,
  }) {
    showCenterModalSheet(
      child: InfoModalContent(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
        icon: icon,
        iconColor: iconColor,
      ),
      showCloseButton: false,
    );
  }
}

// Helper widget for confirmation dialogs
class ConfirmationModalContent extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmationModalContent({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  cancelText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDestructive ? Colors.red : Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  confirmText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Helper widget for info dialogs
class InfoModalContent extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor;

  const InfoModalContent({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.onPressed,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: (iconColor ?? Colors.blue).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28.sp,
              color: iconColor ?? Colors.blue,
            ),
          ),
          SizedBox(height: 16.h),
        ],
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
