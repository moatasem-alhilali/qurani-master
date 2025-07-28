import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quran_app/core/widgets/app_scaffold/elastic_text_refresh_header.dart';
import 'package:quran_app/core/widgets/app_scaffold/refresh_widget.dart';

enum SliverChildPosition { start, end, custom }

class AppSliverWidget extends StatefulWidget {
  const AppSliverWidget({
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

  final EdgeInsetsGeometry? padding;

  final Widget? refreshHeader;
  final bool isElasticTextRefreshHeader;
  final void Function()? onRefresh;

  @override
  State<AppSliverWidget> createState() => _AppSliverWidgetState();
}

class _AppSliverWidgetState extends State<AppSliverWidget> {
  final _refreshController = RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
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
        slivers: _buildSlivers(context),
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
