// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
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
    final sheetShape = ShapeDecoration(
      color: context.background,
      shape: const RoundedRectangleBorder(
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
              decoration: sheetShape,
              child: body,
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
