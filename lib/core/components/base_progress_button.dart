import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import '/core/failure/request_state.dart';

class MyProgressButton extends StatelessWidget {
  MyProgressButton({
    super.key,
    this.state = RequestState.defaults,
    this.text = "add",
    this.onPressed,
    this.border,
    this.width,
    this.height,
    this.borderRadius,
    this.defaultColor,
    this.marginVertical,
    this.colorText,
    this.isBorderColor = false,
  });
  RequestState state;
  String? text;
  double? width;
  double? height;
  double? borderRadius;
  Color? defaultColor;
  Color? colorText;
  Border? border;
  double? marginVertical;
  void Function()? onPressed;
  bool isBorderColor;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: getWidth(state, width, context),
      margin: EdgeInsets.symmetric(vertical: marginVertical ?? 5),
      curve: Curves.easeInOutBack,
      height: height ?? context.getHight(7),
      duration: 300.milliseconds,
      decoration: BoxDecoration(
        border: isBorderColor
            ? Border.all(color: defaultColor ?? FxColors.primary, width: 2)
            : null,
        borderRadius: BorderRadius.circular(borderRadius ?? 23),
        color: isBorderColor ? null : getBackColor(state, defaultColor),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: getWidget(state, text, context, colorText)
            .animate()
            .fade(duration: 1.seconds),
      ),
    );
  }
}

//color
Color? getBackColor(RequestState state, Color? defaultColor) {
  switch (state) {
    case RequestState.defaults:
      return defaultColor ?? FxColors.primary;
    case RequestState.loading:
      return FxColors.primary;

    case RequestState.success:
      return Colors.green;

    case RequestState.error:
      return Colors.red;
  }
  return null;
}

//Widget
Widget getWidget(RequestState state, String? text, context, Color? colorText) {
  switch (state) {
    case RequestState.defaults:
      return Text(
        text ?? "إضافة",
        style: titleMedium(context).copyWith(
          color: colorText ?? Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      );
    case RequestState.loading:
      return const CircularProgressIndicator(
        color: Colors.white,
      );

    case RequestState.success:
      return const CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.check,
          color: Colors.black,
        ),
      );

    case RequestState.error:
      return const CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.cancel,
          color: Colors.white,
        ),
      );
  }
}

//width
double? getWidth(RequestState state, double? width, BuildContext context) {
  switch (state) {
    case RequestState.defaults:
      return width ?? context.getWidth(80);
    case RequestState.loading:
      return context.getWidth(70);
    case RequestState.success:
      return context.getWidth(70);

    case RequestState.error:
      return context.getWidth(70);
  }
  return null;
}
