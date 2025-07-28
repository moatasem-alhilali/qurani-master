
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GestureDetectorWidget extends StatelessWidget {
  const GestureDetectorWidget({
    super.key,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onLongPress,
    this.behavior = HitTestBehavior.opaque,
    this.hapticEnabled = true,
    this.child,
  });

  final void Function()? onTap;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onTapCancel;
  final void Function(DragStartDetails)? onVerticalDragStart;
  final void Function(DragUpdateDetails)? onVerticalDragUpdate;
  final void Function(DragEndDetails)? onVerticalDragEnd;
  final void Function()? onVerticalDragCancel;
  final void Function(DragStartDetails)? onHorizontalDragStart;
  final void Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final void Function(DragEndDetails)? onHorizontalDragEnd;
  final void Function()? onHorizontalDragCancel;
  final void Function()? onLongPress;
  final HitTestBehavior behavior;
  final Widget? child;
  final bool hapticEnabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? () {
              onTap?.call();
              if (hapticEnabled) {
                HapticFeedback.mediumImpact();
              }
            }
          : null,
      onTapDown: onTapDown != null
          ? (details) {
              onTapDown?.call(details);
              if (hapticEnabled) {
                HapticFeedback.lightImpact();
              }
            }
          : null,
      onTapUp: onTapUp != null
          ? (details) {
              onTapUp?.call(details);
              if (hapticEnabled) {
                HapticFeedback.mediumImpact();
              }
            }
          : null,
      onTapCancel: onTapCancel != null
          ? () {
              onTapCancel?.call();
              if (hapticEnabled) {
                HapticFeedback.lightImpact();
              }
            }
          : null,
      onVerticalDragStart: onVerticalDragStart != null
          ? (details) {
              onVerticalDragStart?.call(details);
              if (hapticEnabled) {
                HapticFeedback.mediumImpact();
              }
            }
          : null,
      onVerticalDragUpdate: onVerticalDragUpdate != null
          ? (details) {
              onVerticalDragUpdate?.call(details);
              if (hapticEnabled) {
                HapticFeedback.selectionClick();
              }
            }
          : null,
      onVerticalDragEnd: onVerticalDragEnd != null
          ? (details) {
              onVerticalDragEnd?.call(details);
              if (hapticEnabled) {
                HapticFeedback.mediumImpact();
              }
            }
          : null,
      onVerticalDragCancel: onVerticalDragCancel != null
          ? () {
              onVerticalDragCancel?.call();
              if (hapticEnabled) {
                HapticFeedback.lightImpact();
              }
            }
          : null,
      onHorizontalDragStart: onHorizontalDragStart != null
          ? (details) {
              onHorizontalDragStart?.call(details);
              if (hapticEnabled) {
                HapticFeedback.mediumImpact();
              }
            }
          : null,
      onHorizontalDragEnd: onHorizontalDragEnd != null
          ? (details) {
              onHorizontalDragEnd?.call(details);
              if (hapticEnabled) {
                HapticFeedback.mediumImpact();
              }
            }
          : null,
      onHorizontalDragUpdate: onHorizontalDragUpdate != null
          ? (details) {
              onHorizontalDragUpdate?.call(details);
              if (hapticEnabled) {
                HapticFeedback.mediumImpact();
              }
            }
          : null,
      onHorizontalDragCancel: onHorizontalDragCancel != null
          ? () {
              onHorizontalDragCancel?.call();
              if (hapticEnabled) {
                HapticFeedback.lightImpact();
              }
            }
          : null,
      onLongPress: onLongPress != null
          ? () {
              onLongPress?.call();
              if (hapticEnabled) {
                HapticFeedback.heavyImpact();
              }
            }
          : null,
      behavior: behavior,
      child: child,
    );
  }
}
