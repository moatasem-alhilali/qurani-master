import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_sliver_widget.dart';
import 'package:quran_app/core/widgets/app_scaffold/back_icon_widget.dart';
import 'package:quran_app/core/widgets/app_scaffold/elastic_text_refresh_header.dart';
import 'package:quran_app/core/widgets/app_scaffold/refresh_widget.dart';

class AppSliverCollapsingToolbarWidget extends StatefulWidget {
  const AppSliverCollapsingToolbarWidget({
    this.child,
    this.slivers,
    this.sliverChildPosition = SliverChildPosition.start,
    this.customChildIndex,
    this.footer,
    this.bottomNavigationBar,
    this.scaffoldKey,
    this.statusBarColor,
    this.scaffoldBackgroundColor,
    this.statusBarIconLight,
    this.resizeToAvoidBottomInset,
    this.useTopSafeArea,
    this.useBottomSafeArea,
    this.padding,
    this.backgroundWidget,
    this.drawer,
    this.appBar,
    this.appBarTitle,
    this.onBack,
    this.isCenterTitle,
    this.refreshHeader,
    this.onRefresh,
    this.isElasticTextRefreshHeader = true,
    this.hasAppBar = true,
    this.showLargeHeader = true,
    this.showSmallHeader = true,
    this.leading,
    this.trailing,
    this.floatingActionButton,
    super.key,
  });

  final Widget? child;
  final List<Widget>? slivers;
  final SliverChildPosition sliverChildPosition;
  final int? customChildIndex;
  final Widget? footer;
  final Widget? bottomNavigationBar;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Color? scaffoldBackgroundColor;
  final bool? statusBarIconLight;
  final bool? resizeToAvoidBottomInset;
  final bool? useTopSafeArea;
  final bool? useBottomSafeArea;
  final Widget? backgroundWidget;
  final Widget? drawer;
  final Color? statusBarColor;
  final Widget? appBar;
  final bool? hasAppBar;
  final String? appBarTitle;
  final VoidCallback? onBack;
  final bool? isCenterTitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? floatingActionButton;
  final bool showLargeHeader;
  final bool showSmallHeader;

  final EdgeInsetsGeometry? padding;

  final Widget? refreshHeader;
  final bool isElasticTextRefreshHeader;
  final void Function()? onRefresh;

  @override
  State<AppSliverCollapsingToolbarWidget> createState() =>
      _AppSliverCollapsingToolbarWidgetState();
}

class _AppSliverCollapsingToolbarWidgetState
    extends State<AppSliverCollapsingToolbarWidget> {
  final _refreshController = RefreshController();

// toolbar logic
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollOffset.value = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  double _titleOpacity(double offset) {
    const start = 40.0;
    const end = 90.0;
    if (offset <= start) return 0;
    if (offset >= end) return 1;
    return (offset - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.scaffoldBackgroundColor,
      child: RefreshWidget(
        controller: _refreshController,
        header: widget.isElasticTextRefreshHeader
            ? const ElasticTextRefreshHeader()
            : widget.refreshHeader,
        onRefresh: widget.onRefresh == null
            ? widget.isElasticTextRefreshHeader
                ? _refreshController.refreshCompleted
                : null
            : () {
                widget.onRefresh!.call();
                _refreshController.refreshCompleted();
              },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            if (widget.showLargeHeader)
              SliverAppBar(
                expandedHeight: 110,
                backgroundColor: context.scaffoldBackgroundColor,
                elevation: 0,
                leading: const SizedBox(),
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    const min = kToolbarHeight;
                    const double max = 110;
                    final t = ((constraints.maxHeight - min) / (max - min))
                        .clamp(0.0, 1.0);
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: t,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 22),
                                child: Text(
                                  widget.appBarTitle ?? '',
                                  style: context.titleLarge?.copyWith(
                                    fontSize: 32.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            if (widget.showSmallHeader)
              SliverPersistentHeader(
                pinned: true,
                delegate: SmallHeaderDelegateWidget(
                  backgroundColor: context.scaffoldBackgroundColor,
                  height: 54,
                  scrollOffsetNotifier: _scrollOffset,
                  titleOpacityFn: _titleOpacity,
                  titleText: widget.appBarTitle ?? '',
                  leading: widget.leading,
                  trailing: widget.trailing,
                ),
              ),
            ..._buildSlivers(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSlivers(BuildContext context) {
    final childSliver = SliverPadding(
      padding: EdgeInsets.only(top: 16.h),
      sliver: SliverToBoxAdapter(
        child: SafeArea(
          top: false,
          bottom: widget.useBottomSafeArea ?? true,
          child: Padding(
            padding: widget.padding ??
                EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                  // left: 16.w,
                  // right: 16.w,
                ),
            child: widget.child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );

    final slivers = List<Widget>.of(widget.slivers ?? []);
    if (widget.slivers != null) {
      // Insert child based on position
      switch (widget.sliverChildPosition) {
        case SliverChildPosition.start:
          slivers.insert(0, childSliver);
        case SliverChildPosition.end:
          slivers.add(childSliver);
        case SliverChildPosition.custom:
          final idx = (widget.customChildIndex ?? 0).clamp(0, slivers.length);
          slivers.insert(idx, childSliver);
      }

      return slivers;
    } else {
      // Only child
      return [childSliver];
    }
  }
}

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
