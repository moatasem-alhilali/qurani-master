import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_sliver_widget.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

class AppScaffoldWidget extends StatelessWidget {
  const AppScaffoldWidget({
    this.body,
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
    this.toolbarHeight = kToolbarHeight,
    this.actions,
    this.slivers,
  });
  final Widget? body;
  final Future<void> Function()? onRefresh;
  final Widget? background;
  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final bool back;
  final Widget? bottomNavigationBar;
  final double? expandedHeight;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final double toolbarHeight;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? slivers;
  final Widget? floatingActionButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: context.scaffoldBackgroundColor,
      bottomNavigationBar: bottomNavigationBar ?? const SizedBox(),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            if (back)
              SliverAppBar(
                expandedHeight: 50.h,
                backgroundColor: context.scaffoldBackgroundColor,
                // snap: true,
                // floating: true,
                pinned: true,
                elevation: 0,
                actions: actions ?? const [],
                bottom: bottom,

                title: titleWidget ??
                    title!.autoSize(
                      context,
                      maxLines: 4,
                      // color: context.onPrimary,
                    ),
                centerTitle: true,

                leading: leading ??
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: context.primaryScheme,
                        child: FittedBox(
                          child: IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
              ),
          ],
          body: AppSliverWidget(
            slivers: slivers,
            onRefresh: onRefresh,
            child: body ?? const SizedBox(),
          ),
        ),
      ),
    );
  }
}
