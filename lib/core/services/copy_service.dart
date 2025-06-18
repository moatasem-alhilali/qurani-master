import 'package:flutter/services.dart';
import 'package:quran_app/core/util/toast_manager.dart';

class CopyService {
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    );

    ToastServes.showToast(message: 'تم النسخ بنجاح');
    HapticFeedback.lightImpact();
  }
}
