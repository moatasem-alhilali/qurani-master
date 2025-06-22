import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

class BaseHomeWidget extends StatelessWidget {
  const BaseHomeWidget({
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
  });
  final Widget body;
  final Future<void> Function()? onRefresh;
  final Widget? background;
  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final bool back;
  final bool isScroll;
  final Widget? bottomNavigationBar;
  final double? expandedHeight;
  final PreferredSizeWidget? bottom;
  final double toolbarHeight;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final Widget? floatingActionButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: context.scaffoldBackgroundColor,
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

                leading: Padding(
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
            SliverAppBar(
              toolbarHeight: toolbarHeight,
              expandedHeight: 90.h,
              backgroundColor: context.scaffoldBackgroundColor,
              leading: leading ?? const SizedBox(),
              actions: const [],
              bottom: bottom,
              flexibleSpace: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.asset(
                          'assets/logo/bg.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 80.h,
                          // height: double.infinity,
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                            colors: [
                              context.scaffoldBackgroundColor.withOpacity(0.8),
                              context.scaffoldBackgroundColor.withOpacity(0.1),
                            ],
                            stops: const [
                              1,
                              1,
                            ],
                          ),
                        ),
                      ),
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(15),
                      //   child: BackdropFilter(
                      //     filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      //     child: SizedBox(
                      //       height: 80.h,
                      //       width: double.infinity,
                      //     ),
                      //   ),
                      // ),
                      Center(
                        child: titleWidget ??
                            title!.autoSize(
                              context,
                              maxLines: 4,
                              // color: context.onPrimary,
                            ),
                      ),
                    ],
                  ),
                  // centerTitle: true,
                ),
              ),
            ),
          ],
          body: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.symmetric(
              // horizontal: 10.sp,
              vertical: 10.sp,
            ),
            decoration: BoxDecoration(
              // color: context.onBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(4.sp),
                    child: isScroll
                        ? SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: body,
                          )
                        : body,
                  ),
                ),
                bottomNavigationBar ?? const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
