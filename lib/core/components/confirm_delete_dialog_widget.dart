import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/theme/theme_data.dart';

Future<bool?> showDeleteConfirmationDialog<T>(
  BuildContext context, {
  String? message,
  String? title,
}) async {
  return showGeneralDialog<bool?>(
    context: context,
    barrierLabel: '',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // Custom animation curves
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.elasticOut,
      );

      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );

      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4 * animation.value,
          sigmaY: 4 * animation.value,
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1).animate(curvedAnimation),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: AlertDialog(
              backgroundColor: FxColors.background,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              contentPadding: const EdgeInsets.all(40),
              content: _AnimatedDialogContent(
                animation: animation,
                title: title,
                message: message,
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _AnimatedDialogContent extends StatelessWidget {
  const _AnimatedDialogContent({
    required this.animation,
    this.title,
    this.message,
  });
  final Animation<double> animation;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    // Staggered animations for content elements
    final iconAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0, 0.6, curve: Curves.easeOut),
    );

    final titleAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    );

    final messageAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    );

    final buttonAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: iconAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.5),
              end: Offset.zero,
            ).animate(iconAnimation),
            child: Icon(
              Icons.close,
              color: FxColors.error,
              size: 48.h,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        FadeTransition(
          opacity: titleAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.5, 0),
              end: Offset.zero,
            ).animate(titleAnimation),
            child: Text(
              title ?? 'حذف الذكر؟',
              style: titleMedium(context).copyWith(
                color: FxColors.secondary,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        FadeTransition(
          opacity: messageAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-0.5, 0),
              end: Offset.zero,
            ).animate(messageAnimation),
            child: Text(
              message ?? 'هل أنت متأكد من حذف الذكر؟',
              style: titleMedium(context).copyWith(
                color: FxColors.gray1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        FadeTransition(
          opacity: buttonAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(buttonAnimation),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ProgressButtonState(
                    onPressed: () => Navigator.of(context).pop(false),
                    text: 'إلغاء',
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ProgressButtonState(
                    onPressed: () => Navigator.of(context).pop(true),
                    text: 'حذف',
                    defaultColor: FxColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
