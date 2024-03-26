import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';

class BaseUiScreen extends StatelessWidget {
  const BaseUiScreen({
    super.key,
    required this.child,
    this.background,
    this.title,
    this.leading,
    this.bottom,
    this.secondSliver = true,
    this.onRefresh,
    this.expandedHeight,
    this.bottomNavigationBar,
    this.titleSecondSliver,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.pinnedSecondSliver = false,
    this.toolbarHeight = kToolbarHeight,
  });
  final Widget child;
  final Future<void> Function()? onRefresh;
  final bool secondSliver;
  final Widget? background;
  final Widget? leading;
  final Widget? title;
  final Widget? titleSecondSliver;
  final Widget? bottomNavigationBar;
  final double? expandedHeight;
  final PreferredSizeWidget? bottom;
  final double toolbarHeight;
  final bool pinnedSecondSliver;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final Widget? floatingActionButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: FxColors.third,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              toolbarHeight: toolbarHeight,
              expandedHeight: expandedHeight ?? 130,
              backgroundColor: FxColors.third,
              leading: leading ?? const SizedBox(),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: FxColors.primary,
                    child: FittedBox(
                      child: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              bottom: bottom,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: title,
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      "assets/logo/bg.jpg",
                      fit: BoxFit.cover,
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       begin: FractionalOffset.bottomCenter,
                    //       end: FractionalOffset.topCenter,
                    //       colors: [
                    //         DarkColors.background.withOpacity(0.8),
                    //         DarkColors.background.withOpacity(0.1),
                    //       ],
                    //       stops: const [
                    //         0.1,
                    //         1,
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: FractionalOffset.bottomCenter,
                          end: FractionalOffset.topCenter,
                          colors: [
                            FxColors.third,
                            FxColors.primarySecondary.withOpacity(0.5),
                          ],
                          stops: const [
                            0.1,
                            1,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // centerTitle: true,
              ),
            ),
          ],
          body: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: FxColors.secondary.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RefreshIndicator(
                      onRefresh: onRefresh ?? () async {},
                      child: child,
                    ),
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
