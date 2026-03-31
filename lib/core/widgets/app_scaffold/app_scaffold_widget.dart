import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/small_header_delegate_widget.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_sliver_widget.dart';

class AppScaffoldWidget extends StatefulWidget {
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
    this.showLargeHeader = true,
    this.showSmallHeader = true,
    this.trailing,
    this.initialOffset = 100,
    this.sliverChildPosition= SliverChildPosition.start,
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

  @override
  State<AppScaffoldWidget> createState() => _AppScaffoldWidgetState();
}

class _AppScaffoldWidgetState extends State<AppScaffoldWidget> {
// toolbar logic
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollOffset.value = _scrollController.offset;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.initialOffset != null) {
        _scrollController.jumpTo(widget.initialOffset!);
        _scrollOffset.value = widget.initialOffset!;
        _scrollController.animateTo(
          widget.initialOffset!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
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
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
                                child: widget.titleWidget != null
                                    ? widget.titleWidget!
                                    : Text(
                                        widget.title ?? '',
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
