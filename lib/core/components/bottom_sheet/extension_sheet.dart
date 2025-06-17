import 'dart:async';
import 'dart:ui';

// import 'package:ecommerce_project/core/components/bottom_sheet/smooth_sheet.dart';
import 'package:flutter/material.dart';
// import 'package:smooth_sheets/smooth_sheets.dart';
// import '/core/components/bottom_sheet/base_component_show.dart';
import 'package:quran_app/core/components/bottom_sheet/smooth_sheet.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

extension ExtensionSheet on BuildContext {
  void showBlurBottomSheet({
    required Widget Function(
      BuildContext context,
      ScrollController scrollController,
    ) builder,
  }) {
    showModalBottomSheet<void>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useSafeArea: true,
      useRootNavigator: true,
      isDismissible: false,
      barrierColor: Colors.white.withOpacity(0.3),
      builder: (context) {
        return Stack(
          children: [
            // Blurred Background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                // color: Colors.black.withOpacity(0.2),
                decoration: const BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width, // Adjust width
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black,
                  //   ),
                  // ],
                ),
                child: DraggableScrollableSheet(
                  initialChildSize: 0.33,
                  minChildSize: 0.2,
                  maxChildSize: 0.8,
                  expand: false,
                  snap: true,
                  builder: builder,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //
  Future<void> showSmoothSheet({required Widget child}) {
    return Navigator.push(
      this,
      ModalSheetRoute(
        swipeDismissible: true,
        builder: (context) => child,
      ),
    );
  }

  Future<void> showSmoothSheetStyle({
    required Widget child,
    Widget? bottomBar,
    String? title,
    Color? backgroundColor,
  }) {
    return Navigator.push(
      this,
      ModalSheetRoute(
        // swipeDismissible: true,
        builder: (context) => SmoothSheet(
          backgroundColor: backgroundColor,
          body: child,
          bottomBar: bottomBar,
          title: title,
        ),
      ),
    );
  }
}
