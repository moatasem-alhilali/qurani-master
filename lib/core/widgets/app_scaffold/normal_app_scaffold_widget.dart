import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_sliver_widget.dart';
import 'package:quran_app/core/widgets/app_scaffold/default_header_delegate_widget.dart';

class NormalAppScaffoldWidget extends StatefulWidget {
  const NormalAppScaffoldWidget({
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
    this.scrollController,
    this.back = true,
    this.toolbarHeight = kToolbarHeight,
    this.actions,
    this.slivers,
    this.showLargeHeader = true,
    this.showSmallHeader = true,
    this.trailing,
    this.initialOffset = 100,
    this.sliverChildPosition = SliverChildPosition.start,
  });
  final Widget? body;
  final Future<void> Function()? onRefresh;
  final Widget? background;
  final Widget? leading;
  final Widget? trailing;
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
  final bool showLargeHeader;
  final bool showSmallHeader;
  final double? initialOffset;
  final SliverChildPosition sliverChildPosition;
  final ScrollController? scrollController;
  @override
  State<NormalAppScaffoldWidget> createState() =>
      _NormalAppScaffoldWidgetState();
}

class _NormalAppScaffoldWidgetState extends State<NormalAppScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      backgroundColor: context.scaffoldBackgroundColor,
      bottomNavigationBar: widget.bottomNavigationBar ?? const SizedBox(),
      body: SafeArea(
        child: NestedScrollView(
          controller: widget.scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverPersistentHeader(
              pinned: true,
              delegate: DefaultHeaderDelegateWidget(
                backgroundColor: context.scaffoldBackgroundColor,
                height: 54,
                titleText: widget.title ?? '',
                leading: widget.leading,
                trailing: widget.trailing,
                title: widget.titleWidget,
              ),
            ),
          ],
          body: Material(
            color: context.scaffoldBackgroundColor,
            child: AppSliverWidget(
              padding: EdgeInsets.all(8.sp),
              sliverChildPosition: widget.sliverChildPosition,
              slivers: widget.slivers,
              onRefresh: widget.onRefresh,
              child: widget.body ?? const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
