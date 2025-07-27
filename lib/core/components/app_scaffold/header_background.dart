import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

class HeaderBackground extends StatelessWidget {
  const HeaderBackground({
    super.key,
    this.title,
    this.titleWidget,
  });

  final String? title;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/logo/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 80.h,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                context.scaffoldBackgroundColor.withOpacity(0.8),
                context.scaffoldBackgroundColor.withOpacity(0.1),
              ],
            ),
          ),
        ),
        Center(
          child: titleWidget ??
              (title?.isNotEmpty == true
                  ? title!.autoSize(context, maxLines: 3)
                  : const SizedBox()),
        ),
      ],
    );
  }
}
