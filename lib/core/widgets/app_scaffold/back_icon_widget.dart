import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';

class BackIconWidget extends StatelessWidget {
  const BackIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: context.primaryColor,
        highlightColor: context.primaryColor.withOpacity(0.5),
        overlayColor: context.primaryColor.withOpacity(0.5),
        shadowColor: context.primaryColor.withOpacity(0.5),
        surfaceTintColor: context.primaryColor.withOpacity(0.5),
        shape: const CircleBorder(),
      ),
      constraints: BoxConstraints(
        minWidth: 18.h,
        minHeight: 18.h,
        maxWidth: 20.h,
        maxHeight: 20.h,
      ),
      onPressed: () {
        context.pop();
      },
      icon: const FittedBox(
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}
