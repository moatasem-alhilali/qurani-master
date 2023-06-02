import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class ToastServes {
  static FToast? fToast;

  static showToastCancel({String? message, required BuildContext context}) {
    Widget toastWithButton = Container(
      // height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              fToast!.removeCustomToast();
            },
            child: const Icon(
              Icons.remove_circle_outline_sharp,
              color: Colors.red,
              size: 40,
            ),
          ),
          Text(
            message ?? "هل تريد حفظ مكان قرائتك",
            softWrap: true,
            style: titleMedium(context).copyWith(color: Colors.black),
          ),
        ],
      ),
    );
    fToast!.showToast(
      child: toastWithButton,
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 10),
    );
  }

  //!
  static showToast({String? message}) {
    Fluttertoast.showToast(
      msg: message ?? 'This is a Top Long Toast',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      webShowClose: true,
      backgroundColor: const Color(0xff2f2f2f),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
