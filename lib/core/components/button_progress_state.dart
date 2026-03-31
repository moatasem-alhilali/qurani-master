// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:ecommerce_project/core/themes/extension_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';

/// A customizable progress button that changes its appearance based on its state.
///
/// This button can display different states such as default, loading, success, and error.
/// It also supports custom text, icons, and animations for each state.
class ProgressButtonState extends StatelessWidget {
  const ProgressButtonState({
    super.key,
    this.state = RequestState.initial,
    this.text = 'Add',
    this.onPressed,
    this.border,
    this.width,
    this.height,
    this.borderRadius,
    this.defaultColor,
    this.marginVertical,
    this.colorText,
    this.icon,
    this.textLoading,
    this.textSuccess,
    this.isBorderColor = false,
    this.widthStateChange = true,
    this.iconAliment = Alignment.centerRight,
    this.shouldDisplayIconLoading = true,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  /// Animation duration for state changes
  final Duration animationDuration;

  /// should display icon in loading
  final bool shouldDisplayIconLoading;

  /// The text to display when the button is in the loading state.
  final String? textLoading;

  /// The text to display when the button is in the success state.
  final String? textSuccess;

  /// Whether the button's width should change based on its state.
  final bool? widthStateChange;

  /// An optional icon to display alongside the button text.
  final Widget? icon;

  /// The current state of the button.
  final RequestState state;

  /// The text to display when the button is in the default state.
  final String? text;

  /// The width of the button.
  final double? width;

  /// The height of the button.
  final double? height;

  /// The border radius of the button.
  final double? borderRadius;

  /// The default background color of the button.
  final Color? defaultColor;

  /// The color of the button text.
  final Color? colorText;

  /// The border of the button.
  final Border? border;

  /// The vertical margin around the button.
  final double? marginVertical;

  /// The callback function to execute when the button is pressed.
  final void Function()? onPressed;

  /// Whether the button should use a border color instead of a background color.
  final bool isBorderColor;

  final Alignment iconAliment;

  @override
  Widget build(BuildContext context) {
    return StyleButtonWrap(
      onTap: () {
        if (state == RequestState.initial || state == RequestState.error) {
          HapticFeedback.lightImpact();
          onPressed?.call();
        }
      },
      child: AnimatedContainer(
        width: width,
        margin: EdgeInsets.symmetric(vertical: marginVertical ?? 5),
        curve: Curves.easeOutQuart,
        height: height ?? 42.h,
        duration: animationDuration,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: isBorderColor
              ? border ?? Border.all(color: context.primaryColor)
              : null,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          color: isBorderColor
              ? null
              : _getBackgroundColor(state, defaultColor, context),
          boxShadow: [
            if (state != RequestState.initial && !isBorderColor)
              BoxShadow(
                color: _getBackgroundColor(state, defaultColor, context)
                        ?.withOpacity(0.3) ??
                    Colors.transparent,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: animationDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: _getWidget(state, text, context, colorText, icon: icon),
        ),
      ),
    );
  }

  /// Returns the background color of the button based on its state.
  Color? _getBackgroundColor(
    RequestState state,
    Color? defaultColor,
    BuildContext context,
  ) {
    switch (state) {
      case RequestState.initial:
        return defaultColor ?? context.primaryColor;
      case RequestState.loading:
        return context.primaryColor;
      case RequestState.success:
        return Colors.green;
      case RequestState.error:
        return Colors.red;
    }
  }

  /// Returns the widget to display inside the button based on its state.
  Widget _getWidget(
    RequestState state,
    String? text,
    BuildContext context,
    Color? colorText, {
    Widget? icon,
  }) {
    switch (state) {
      case RequestState.initial:
        return Row(
          key: const ValueKey('default'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconAliment == Alignment.centerRight) ...[
              if (icon != null) icon,
              if (icon != null) const SizedBox(width: 8),
            ],
            Text(
              text ?? 'Add',
              style: TextStyle(
                color: colorText ?? Colors.white,
                fontSize: 20.sp,
              ),
            ),
            if (iconAliment == Alignment.centerLeft) ...[
              if (icon != null) const SizedBox(width: 8),
              if (icon != null) icon,
            ],
          ],
        );
      case RequestState.loading:
        return Row(
          key: const ValueKey('loading'),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: textLoading != null,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  textLoading ?? '',
                  style: TextStyle(
                    color: colorText ?? Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            if (shouldDisplayIconLoading)
              SizedBox(
                width: 20.r,
                height: 20.r,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  strokeWidth: 3,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorText ?? Colors.white),
                ),
              ),
          ],
        );
      case RequestState.success:
        return Row(
          key: const ValueKey('success'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: textSuccess != null,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  textSuccess ?? '',
                  style: TextStyle(
                    color: colorText ?? Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.check_circle_outline,
              color: colorText ?? Colors.white,
              size: 24.r,
            ),
          ],
        );
      case RequestState.error:
        return Icon(
          Icons.error_outline,
          color: colorText ?? Colors.white,
          size: 24.r,
          key: const ValueKey('error'),
        );
    }
  }
}

// // --------------------

class StyleButtonWrap extends StatelessWidget {
  const StyleButtonWrap({
    required this.child,
    this.shape,
    this.color,
    this.onLongPress,
    this.onTap,
    this.disabledColor,
    this.disable,
    this.padding,
    this.height,
    this.minWidth,
    super.key,
  });

  final ShapeBorder? shape;
  final Color? color;
  final Color? disabledColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? child;
  final double? minWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool? disable;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      shape: shape,
      color: color,
      disabledColor: disabledColor ?? color,
      height: height,
      padding: padding,
      minWidth: minWidth,
      onPressed: true == disable
          ? null
          : () {
              onTap?.call();
              HapticFeedback.lightImpact();
            },
      child: child,
    );
  }
}

// /// A wrapper widget that adds a tap animation to its child.
// ///
// /// This widget scales down its child when tapped and scales it back up when the tap is released.
// class StyleButtonWrap extends StatefulWidget {
//   final Widget child;
//   final VoidCallback? onTap;
//   final VoidCallback? onLongPress;

//   const StyleButtonWrap({
//     required this.child,
//     super.key,
//     this.onTap,
//     this.onLongPress,
//   });

//   @override
//   _StyleButtonWrapState createState() => _StyleButtonWrapState();
// }

// class _StyleButtonWrapState extends State<StyleButtonWrap>
//     with SingleTickerProviderStateMixin {
//   static const int _clickAnimationDurationMillis = 100;
//   static const double _minScaleValue = 0.95;

//   late final AnimationController _animationController;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: _clickAnimationDurationMillis),
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 1,
//       end: _minScaleValue,
//     ).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   /// Handles the tap event by playing the animation and invoking the callback.
//   Future<void> _handleTap() async {
//     await _animationController.forward();
//     await _animationController.reverse();
//     HapticFeedback.lightImpact();
//     widget.onTap?.call();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _handleTap,
//       onTapDown: (_) => _animationController.forward(),
//       onTapCancel: () => _animationController.reverse(),
//       onLongPress: () {
//         // HapticFeedback.lightImpact();
//         widget.onLongPress?.call();
//       },
//       child: AnimatedBuilder(
//         animation: _scaleAnimation,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _scaleAnimation.value,
//             child: child,
//           );
//         },
//         child: widget.child,
//       ),
//     );
//   }
// }

/// A base widget that provides a tap effect with a ripple animation.
///
/// This widget is used to wrap other widgets and add a ripple effect when tapped.
class BaseOnTap extends StatelessWidget {
  const BaseOnTap({
    super.key,
    this.onTap,
    this.child,
  });
  final void Function()? onTap;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.red,
      hoverColor: Colors.red,
      splashColor: Colors.red,
      borderRadius: BorderRadius.circular(8.r),
      overlayColor:
          WidgetStatePropertyAll(context.primaryColor.withOpacity(0.1)),
      onTap: () {
        // HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: child,
    );
  }
}
