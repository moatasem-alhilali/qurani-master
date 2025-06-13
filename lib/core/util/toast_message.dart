import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static late FToast fToast;

  static init(BuildContext context) {
    fToast = FToast();
    fToast.init(context);
  }

  static showToast({
    String? text,
    int seconds = 2,
    Color? backgroundColor,
  }) {
    final Widget toast = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        // color: backgroundColor ?? ColorsManager.customPrimary.,
      ),
      child: Text(
        text ?? 'مرحبا',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: seconds),
    );
  }
}
