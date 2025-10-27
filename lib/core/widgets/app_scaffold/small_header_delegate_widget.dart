import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/back_icon_widget.dart';

class SmallHeaderDelegateWidget extends SliverPersistentHeaderDelegate {
  SmallHeaderDelegateWidget({
    required this.height,
    required this.backgroundColor,
    required this.scrollOffsetNotifier,
    required this.titleOpacityFn,
    required this.titleText,
    this.title,
    this.trailing,
    this.leading,
  });
  final double height;
  final Color backgroundColor;
  final String titleText;
  final Widget? trailing;
  final Widget? title;
  final Widget? leading;
  final ValueNotifier<double> scrollOffsetNotifier;
  final double Function(double) titleOpacityFn;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: ValueListenableBuilder<double>(
        valueListenable: scrollOffsetNotifier,
        builder: (context, offset, _) {
          final titleOpacity = titleOpacityFn(offset);
          return Row(
            children: [
              leading ?? const BackIconWidget(),
              if (leading != null) const SizedBox(width: 8),
              Opacity(
                opacity: titleOpacity,
                child: Row(
                  children: [
                    if (titleText.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.only(start: 8, end: 8),
                        child: Text(
                          titleText,
                          style: context.titleMedium?.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (titleText.isEmpty && title != null)
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.only(start: 8, end: 8),
                        child: title,
                      ),
                  ],
                ),
              ),
              const Spacer(),
              trailing ?? const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SmallHeaderDelegateWidget oldDelegate) =>
      backgroundColor != oldDelegate.backgroundColor ||
      titleText != oldDelegate.titleText ||
      scrollOffsetNotifier != oldDelegate.scrollOffsetNotifier;
}
