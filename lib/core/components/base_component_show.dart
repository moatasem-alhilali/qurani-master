import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/helper/cash/cash_helper.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/main_view.dart';

Future<void> showMyBottomSheetFunction({
  required BuildContext context,
  required Widget child,
  Color? backgroundColor,
  bool isScroll = true,
  FutureOr<void> Function()? whenCompleted,
}) async {
  showModalBottomSheet(
    context: context,
    backgroundColor: backgroundColor ?? FxColors.background,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    elevation: 0,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    builder: (context) {
      return AnimatedPadding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const HeaderStyle(),
              if (isScroll)
                SingleChildScrollView(
                  child: child.animate().fade(duration: 1.seconds),
                ),
              if (!isScroll) child
            ],
          ),
        ),
      );
    },
  );
}

class HeaderStyle extends StatelessWidget {
  const HeaderStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: context.getHight(1),
            width: context.getWidth(3),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey,
            ),
          ),
          Container(
            height: context.getHight(1),
            width: context.getWidth(10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey,
            ),
          ),
          Container(
            height: context.getHight(1),
            width: context.getWidth(3),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

///When the null safety throw an error customize the ui
void customErrorBuild() {
  ErrorWidget.builder = (FlutterErrorDetails detail) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Colors.yellow,
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        detail.exception.toString(),
      ),
    );
  };
}

//-------------------------EXIT---------------------------
Future<void> showMyExitDialogFunction({
  required BuildContext context,
}) async {
  showGeneralDialog(
    context: context,
    useRootNavigator: true,
    transitionDuration: 500.milliseconds,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Container(
              width: context.getWidth(70),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              // padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HeaderStyle(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'هل أنت متأكد من الخروج',
                      style: titleMedium(context)
                          .copyWith(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: context.getScreenWidth(),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: FxColors.primary),
                            child: Text(
                              'تراجع',
                              style: titleMedium(context)
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            exit(0);
                            // context.pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                            ),
                            child: Text(
                              'الخروج',
                              style: titleMedium(context)
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fade();
    },
  );
}

//-------------------------EXIT---------------------------

Future<void> showMyResetDataDialogFunction({
  required BuildContext context,
}) async {
  showGeneralDialog(
    context: context,
    useRootNavigator: true,
    transitionDuration: 500.milliseconds,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Container(
              width: context.getWidth(70),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              // padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HeaderStyle(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'سوف نقوم بحذف بيانات تسجيل الدخول السابقه',
                      style: titleMedium(context).copyWith(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.getScreenWidth(),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: FxColors.primary),
                            child: Text(
                              'تراجع',
                              style: titleMedium(context)
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            GetHelperCash.resetData();
                            context.pushAndRemoveUntil(const MyApp());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                            ),
                            child: Text(
                              'موافق',
                              style: titleMedium(context)
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fade();
    },
  );
}
