import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/app_scaffold/header_background.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class MainSliverAppBar extends StatelessWidget {
  const MainSliverAppBar({
    super.key,
    this.leading,
    this.title = '',
    this.titleWidget,
    this.bottom,
    this.expandedHeight,
    this.toolbarHeight = kToolbarHeight,
  });

  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final PreferredSizeWidget? bottom;
  final double? expandedHeight;
  final double toolbarHeight;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: toolbarHeight,
      expandedHeight: expandedHeight ?? 90.h,
      backgroundColor: context.surfaceColor,
      leading: leading,
      bottom: bottom,
      actions: const [],
      flexibleSpace: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: FlexibleSpaceBar(
          background: HeaderBackground(
            title: title,
            titleWidget: titleWidget,
          ),
        ),
      ),
    );
  }
}
