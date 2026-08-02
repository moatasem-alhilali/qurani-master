import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';

/// Shows the "update available" dialog using [AdaptiveAlertDialog], so it
/// renders a native Cupertino alert on iPhone (iOS 26+ uses the native iOS 26
/// alert) and a Material dialog on Android — matching each platform.
///
/// "Update now" opens the App Store page; "later" dismisses and invokes
/// [onLater] (used to remember the skipped version on the launch flow). Reused
/// by the launch prompt, the home reminder tile, and the manual "check for
/// updates" action so the UX stays identical everywhere.
///
/// Note: [AdaptiveAlertDialog] dismisses the dialog itself before invoking each
/// action's `onPressed`, so the callbacks here must not pop the route.
Future<void> showIosUpdateDialog(
  BuildContext context, {
  required String storeVersion,
  String? storeUrl,
  String? releaseNotes,
  VoidCallback? onLater,
}) {
  final message =
      StringBuffer('الإصدار $storeVersion متاح الآن على App Store.');
  if (releaseNotes != null && releaseNotes.isNotEmpty) {
    message.write('\n\nالجديد في هذا الإصدار:\n$releaseNotes');
  }

  return AdaptiveAlertDialog.show(
    context: context,
    title: 'يتوفر تحديث جديد',
    message: message.toString(),
    icon: Icons.system_update_alt_rounded,
    iconSize: 40,
    actions: [
      AlertAction(
        title: 'لاحقاً',
        style: AlertActionStyle.cancel,
        onPressed: () => onLater?.call(),
      ),
      AlertAction(
        title: 'تحديث الآن',
        style: AlertActionStyle.primary,
        onPressed: () {
          if (storeUrl != null && storeUrl.isNotEmpty) {
            UrlLauncherUtils.launchWebUrl(storeUrl);
          }
        },
      ),
    ],
  );
}
