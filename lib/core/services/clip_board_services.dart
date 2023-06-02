import 'package:flutter/services.dart';
import 'package:quran_app/core/util/toast_manager.dart';

class ClipBoardServices {
  //
  static Future<void> copyText({required String text,  String ?message}) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    );
    ToastServes.showToast(message: message);
  }
}
