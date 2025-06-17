import 'dart:async';
import 'dart:ui';

// import 'package:ecommerce_project/core/components/bottom_sheet/smooth_sheet.dart';
import 'package:flutter/material.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
// import 'package:smooth_sheets/smooth_sheets.dart';
// import '/core/components/bottom_sheet/base_component_show.dart';
import 'smooth_sheet.dart';

extension ExtensionSheet on BuildContext {
  void showBlurBottomSheet(
      {Widget Function(BuildContext context, ScrollController scrollController)?
          builder}) {
    showModalBottomSheet(
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
                width: MediaQuery.of(context).size.width * 0.85, // Adjust width
                decoration: BoxDecoration(
                  // color: Colors.black,
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
                  initialChildSize: 0.33, // Default visible height (40%)
                  minChildSize: 0.2, // Minimum height (20%)
                  maxChildSize: 0.8, // Maximum height (80%)
                  expand: false, // Prevents taking full screen
                  builder: builder ??
                      (context, scrollController) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: List.generate(
                                20,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text("Item ${index + 1}",
                                      style: const TextStyle(fontSize: 16)),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                ),
              ),
            ),
            // Bottom Sheet Content
            // DraggableScrollableSheet(
            //   initialChildSize: 0.4,
            //   minChildSize: 0.2,
            //   maxChildSize: 0.8,
            //   builder:builder?? (context, scrollController) {
            //     return  Container(
            //       decoration: const BoxDecoration(
            //         color: Colors.white,
            //         borderRadius:
            //             BorderRadius.vertical(top: Radius.circular(20)),
            //       ),
            //       padding: const EdgeInsets.all(16),
            //       child: ListView(
            //         controller: scrollController,
            //         children: const [
            //           Text("This is a blurred bottom sheet",
            //               style: TextStyle(
            //                   fontSize: 18, fontWeight: FontWeight.bold)),
            //           SizedBox(height: 10),
            //           Text("You can add any content here."),
            //         ],
            //       ),
            //     );
            //   },
            // ),
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

