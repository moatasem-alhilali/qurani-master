import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/app_scaffold/back_sliver_app_bar.dart';
import 'package:quran_app/core/components/app_scaffold/main_sliver_app_bar.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

class AppScaffoldWidget extends StatelessWidget {
  const AppScaffoldWidget({
    required this.body,
    super.key,
    this.background,
    this.title = '',
    this.leading,
    this.bottom,
    this.onRefresh,
    this.expandedHeight,
    this.bottomNavigationBar,
    this.titleWidget,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.back = true,
    this.isScroll = true,
    this.toolbarHeight = kToolbarHeight,
    this.scrollController,
  });

  final Widget body;
  final Widget? background;
  final String? title;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final Future<void> Function()? onRefresh;
  final double? expandedHeight;
  final Widget? bottomNavigationBar;
  final Widget? titleWidget;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool back;
  final bool isScroll;
  final double toolbarHeight;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: context.background,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: SafeArea(
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, _) => [
            if (back) const BackSliverAppBar(),
            MainSliverAppBar(
              leading: leading,
              toolbarHeight: toolbarHeight,
              bottom: bottom,
              expandedHeight: expandedHeight,
              title: title,
              titleWidget: titleWidget,
            ),
          ],
          body: Container(
            margin: EdgeInsets.symmetric(vertical: 10.sp),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(4.sp),
                    child: isScroll
                        ? CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverToBoxAdapter(child: body),
                            ],
                          )
                        : body,
                  ),
                ),
                if (bottomNavigationBar != null) bottomNavigationBar!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
