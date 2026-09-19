import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/l10n/l10n.dart';

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
  final l10n = context.l10n;
  final message = StringBuffer(l10n.coreUpdateAvailableMessage(storeVersion));
  if (releaseNotes != null && releaseNotes.isNotEmpty) {
    message.write('\n\n${l10n.coreUpdateWhatsNew}\n$releaseNotes');
  }

  return AdaptiveAlertDialog.show(
    context: context,
    title: l10n.coreUpdateAvailableTitle,
    message: message.toString(),
    icon: Icons.system_update_alt_rounded,
    iconSize: 40,
    actions: [
      AlertAction(
        title: l10n.commonLater,
        style: AlertActionStyle.cancel,
        onPressed: () => onLater?.call(),
      ),
      AlertAction(
        title: l10n.coreUpdateNow,
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
