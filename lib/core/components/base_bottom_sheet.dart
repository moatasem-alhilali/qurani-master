import 'package:flutter/material.dart';

void showBottomSheetFunction({
  required BuildContext context,
  required Widget child,
  double? height,
  Color? backgroundColor,
}) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: backgroundColor ?? Theme.of(context).splashColor,
    elevation: 0,
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    builder: (context) {
      return child;
    },
  );
}
