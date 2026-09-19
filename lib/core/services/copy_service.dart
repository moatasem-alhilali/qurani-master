import 'package:flutter/services.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/l10n/l10n.dart';

class CopyService {
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    );

    ToastServes.showToast(message: L10nService.current.coreCopiedSuccessfully);
    HapticFeedback.lightImpact();
  }
}
