import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/util/my_extensions.dart';

Future<void> showMyDialogFunction({
  required BuildContext context,
  required Widget child,
  bool animate = true,
  bool back = false,
  double? height,
  double? width,
}) async {
  showGeneralDialog(
    context: context,
    transitionDuration: 500.milliseconds,
    pageBuilder: (context, animation, secondaryAnimation) {
      return WillPopScope(
        onWillPop: () async {
          return back;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: child,
            ),
          ),
        ).animate().fade(),
      );
    },
  );
}

Future<void> showMyDialogStyleFunction({
  required BuildContext context,
  required Widget child,
  bool animate = true,
  bool back = false,
  double? height,
  double? width,
}) async {
  showGeneralDialog(
    context: context,
    useRootNavigator: true,
    transitionDuration: 500.milliseconds,
    pageBuilder: (context, animation, secondaryAnimation) {
      return WillPopScope(
        onWillPop: () async {
          return back;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Align(
              child: Container(
                height: height ?? context.getHight(60),
                width: width ?? context.getWidth(90),
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: child,
                ),
              ),
            ),
          ),
        ).animate().fade(),
      );
    },
  );
}
