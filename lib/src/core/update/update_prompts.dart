import 'package:flutter/material.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';

/// Shows the iOS "update available" dialog. "Update now" opens the App Store
/// page; "later" dismisses and invokes [onLater] (used to remember the skipped
/// version on the launch flow). Reused by both the launch prompt and the manual
/// "check for updates" action so the UX stays identical.
Future<void> showIosUpdateDialog(
  BuildContext context, {
  required String storeVersion,
  String? storeUrl,
  String? releaseNotes,
  VoidCallback? onLater,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('يتوفر تحديث جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الإصدار $storeVersion متاح الآن على App Store.'),
              if (releaseNotes != null && releaseNotes.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'الجديد في هذا الإصدار:',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 160),
                  child: SingleChildScrollView(
                    child: Text(releaseNotes),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onLater?.call();
              },
              child: const Text('لاحقاً'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (storeUrl != null && storeUrl.isNotEmpty) {
                  UrlLauncherUtils.launchWebUrl(storeUrl);
                }
              },
              child: const Text('تحديث الآن'),
            ),
          ],
        ),
      );
    },
  );
}
