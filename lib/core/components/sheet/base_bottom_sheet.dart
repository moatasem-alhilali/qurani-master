import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension BaseBottomSheet on BuildContext {
  Future<T?> showBaseBottomSheet<T>({
    Widget? child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
    Color? backgroundColor,
    Color? barrierColor,
    BorderRadius? borderRadius,
    Duration? animationDuration,
  }) {
   return  showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useSafeArea: true,
      useRootNavigator: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.3),
      transitionAnimationController: AnimationController(
        duration: animationDuration ?? const Duration(milliseconds: 300),
        vsync: Navigator.of(this),
      ),
      builder: (context) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, (1 - value) * 100),
              child: Container(
                height: height,
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: MediaQuery.of(context).viewPadding.top + 40.h,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.white,
                  borderRadius: borderRadius ??
                      const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 40,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    // Content
                    if (child != null)
                      Expanded(
                        child: child,
                      ),
                    if (child == null) const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
