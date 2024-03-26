import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';

class SnackBarMessage {
  static void showTimerSnackbar({
    required BuildContext context,
    void Function()? onVisible,
    Color? backgroundColor,
    Widget? child,
    double? height,
    String? text,
    void Function()? onEnd,
    int seconds = 5,
    DismissDirection dismissDirection = DismissDirection.horizontal,
  }) {
    final snackbar = SnackBar(
      backgroundColor: backgroundColor,
      duration: Duration(seconds: seconds),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: SizedBox(
        height: height ?? context.getHight(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.white,
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                return;
              },
              child: Container(
                color: Colors.grey[850],
                child: Text(
                  'تراجع',
                  style: TextStyle(
                    color: Colors.blue[100],
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1.1,
                ),
              ),
            ),
            SizedBox(
              height: height ?? context.getHight(4),
              child: const VerticalDivider(
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                text ?? 'جاري الحذف',
                style: titleMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxHeight: 22.0),
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: seconds * 1000.toDouble()),
                duration: Duration(seconds: seconds),
                onEnd: onEnd,
                builder: (context, double value, child) {
                  return Stack(
                    fit: StackFit.loose,
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 27.0,
                        width: 25.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          value: value / (seconds * 1000),
                          color: Colors.grey[850],
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Center(
                        child: Text(
                          (seconds - (value / 1000)).toInt().toString(),
                          textScaleFactor: 0.90,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  static void show({
    String? title,
    required BuildContext context,
    void Function()? onVisible,
    Color? backgroundColor,
    double? height,
    int seconds = 3,
    IconData? icon,
    RequestState state = RequestState.defaults,
    DismissDirection dismissDirection = DismissDirection.horizontal,
  }) {
    final snackbar = SnackBar(
      backgroundColor: _getStatusBackGround(state, backgroundColor),
      duration: Duration(seconds: seconds),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: SizedBox(
        height: height ?? context.getHight(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height ?? context.getHight(4),
              child: const VerticalDivider(
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                title ?? 'جاري الحذف',
                style: titleMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: FxColors.secondary,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _getIcon(state, icon),
                      // size: context.getHight(4),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }
}

Color _getStatusBackGround(RequestState state, Color? backgroundColor) {
  switch (state) {
    case RequestState.defaults:
      return backgroundColor ?? FxColors.background;

    case RequestState.loading:
      return backgroundColor ?? FxColors.primary;
    case RequestState.success:
      return backgroundColor ?? Colors.green;

    case RequestState.error:
      return backgroundColor ?? Colors.red;
  }
}

IconData _getIcon(RequestState state, IconData? icon) {
  switch (state) {
    case RequestState.defaults:
      return icon ?? Icons.cancel;
    case RequestState.loading:
      return icon ?? Icons.cancel;

    case RequestState.success:
      return icon ?? Icons.check_circle;

    case RequestState.error:
      return icon ?? Icons.cancel;
  }
}
