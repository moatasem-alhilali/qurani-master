import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Exit confirmation. Uses [AdaptiveAlertDialog] so it shows a native Cupertino
/// alert on iPhone and a Material dialog on Android (previously it forced a
/// Cupertino alert on both platforms). [AdaptiveAlertDialog] dismisses itself
/// before invoking each action, so the callbacks must not pop the route.
void showMyAlert({
  required BuildContext context,
}) {
  AdaptiveAlertDialog.show(
    context: context,
    title: 'تنبيه',
    message: 'هل أنت متأكد من الخروج من التطبيق',
    actions: [
      AlertAction(
        title: 'لا',
        style: AlertActionStyle.cancel,
        onPressed: () {},
      ),
      AlertAction(
        title: 'نعم',
        style: AlertActionStyle.destructive,
        onPressed: () async {
          await SystemNavigator.pop();
        },
      ),
    ],
  );
}
