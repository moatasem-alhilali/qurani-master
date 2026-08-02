import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

class BackIconWidget extends StatelessWidget {
  const BackIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        highlightColor: context.surfaceColor.withOpacity(0.5),
        overlayColor: context.surfaceColor.withOpacity(0.5),
        shadowColor: context.surfaceColor.withOpacity(0.5),
        surfaceTintColor: context.surfaceColor.withOpacity(0.5),
        shape: const CircleBorder(),
      ),
      padding: const EdgeInsets.all(12),
      constraints: BoxConstraints(
        minWidth: 50.h,
        minHeight: 50.h,
        maxWidth: 50.h,
        maxHeight: 50.h,
      ),
      onPressed: () {
        context.pop();
      },
      icon: const AppIcon(
        AppIcons.backRight,
        size: 50,
        // color: Colors.black,
      ),
    );
  }
}
