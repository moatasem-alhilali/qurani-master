import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

class BackSliverAppBar extends StatelessWidget {
  const BackSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 50.h,
      pinned: true,
      elevation: 0,
      backgroundColor: context.surfaceColor,
      foregroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(12),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: context.primaryColor,
          child: FittedBox(
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const AppIcon(
                AppIcons.back,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
