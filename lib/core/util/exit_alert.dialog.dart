import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:quran_app/l10n/l10n.dart';

/// Exit confirmation. Uses [AdaptiveAlertDialog] so it shows a native Cupertino
/// alert on iPhone and a Material dialog on Android (previously it forced a
/// Cupertino alert on both platforms). [AdaptiveAlertDialog] dismisses itself
/// before invoking each action, so the callbacks must not pop the route.
void showMyAlert({
  required BuildContext context,
}) {
  final l10n = context.l10n;
  AdaptiveAlertDialog.show(
    context: context,
    title: l10n.coreExitDialogTitle,
    message: l10n.coreExitDialogMessage,
    actions: [
      AlertAction(
        title: l10n.commonNo,
        style: AlertActionStyle.cancel,
        onPressed: () {},
      ),
      AlertAction(
        title: l10n.commonYes,
        style: AlertActionStyle.destructive,
        onPressed: () async {
          await SystemNavigator.pop();
        },
      ),
    ],
  );
}
