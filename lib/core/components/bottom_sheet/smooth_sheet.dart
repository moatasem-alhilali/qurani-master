// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/bottom_sheet/header_sheet_style.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class SmoothSheet extends StatelessWidget {
  const SmoothSheet({
    required this.body,
    super.key,
    this.bottomBar,
    this.title,
    this.backgroundColor,
  });
  final Widget body;
  final Color? backgroundColor;

  final String? title;
  final Widget? bottomBar;
  @override
  Widget build(BuildContext context) {
    const sheetShape = ShapeDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
    return SafeArea(
      bottom: false,
      child: PopScope(
        onPopInvoked: onPopInvoked,
        child: SheetKeyboardDismissible(
          dismissBehavior: const SheetKeyboardDismissBehavior.onDragDown(
            isContentScrollAware: true,
          ),
          child: ScrollableSheet(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: sheetShape,
              child: SheetContentScaffold(
                backgroundColor: backgroundColor,
                resizeBehavior: const ResizeScaffoldBehavior.avoidBottomInset(
                  // Make the bottom bar visible when the keyboard is open.
                  maintainBottomBar: true,
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeaderStyleSheet(),
                      ],
                    ),
                    // if (canBack)
                    Padding(
                      padding: EdgeInsets.only(
                        right: 8.0.sp,
                        left: 8.0.sp,
                        bottom: 8.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: titleMedium(context)
                                  .copyWith(fontSize: 18.sp),
                            ),
                          BaseOnTap(
                            onTap: () {
                              // context.pop();
                            },
                            child: CircleAvatar(
                              backgroundColor: const Color(0xffdddddd),
                              radius: 12.sp,
                              child: const Icon(
                                Icons.clear,
                                color: Color(0xff6c7072),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(child: body),
                    body,
                  ],
                ),
                bottomBar: bottomBar,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onPopInvoked(bool didPop) async {
    if (didPop) {
      // Already popped.
      return;
    }
  }
}

// final bottomBar = StickyBottomBarVisibility(
//   child: BottomAppBar(
//     child: Row(
//       children: [
//         _FolderSelector(controller),
//         const Spacer(),
//         _SubmitButton(controller),
//       ],
//     ),
//   ),
// );
