import 'package:flutter/material.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

class BaseHome extends StatelessWidget {
  const BaseHome({
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
      backgroundColor: FxColors.background,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              toolbarHeight: toolbarHeight,
              expandedHeight: expandedHeight ?? 130,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: leading ?? const SizedBox(),
              actions: [
                if (back)
                  Padding(
                    padding: const EdgeInsets.all(8),
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
              flexibleSpace: FlexibleSpaceBar(
                title: titleWidget ??
                    title!.autoSize(context, maxLines: 4, color: Colors.grey),
                centerTitle: true,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/logo/bg.jpg',
                      fit: BoxFit.cover,
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
              color: Theme.of(context).splashColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
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
