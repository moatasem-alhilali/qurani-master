import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/colors_extension.dart';

class SamsungSettingsHeaderDemo extends StatefulWidget {
  const SamsungSettingsHeaderDemo({super.key});
  @override
  State<SamsungSettingsHeaderDemo> createState() =>
      _SamsungSettingsHeaderDemoState();
}

class _SamsungSettingsHeaderDemoState extends State<SamsungSettingsHeaderDemo> {
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
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final bgColor = context.scaffoldBackgroundColor;
    final titleColor = isDark ? Colors.amber.shade200 : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Material(
          color: bgColor,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 110,
                backgroundColor: bgColor,
                elevation: 0,
                leading: const SizedBox(),
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    const min = kToolbarHeight;
                    const double max = 110;
                    final t = ((constraints.maxHeight - min) / (max - min))
                        .clamp(0.0, 1.0);
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: t,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 22),
                                child: Text(
                                  'Settings',
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: titleColor,
                                    fontWeight: FontWeight.bold,
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
              SliverPersistentHeader(
                pinned: true,
                delegate: _SmallHeaderDelegate(
                  backgroundColor: bgColor,
                  titleColor: titleColor,
                  height: 54,
                  scrollOffsetNotifier: _scrollOffset,
                  titleOpacityFn: _titleOpacity,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 20,
                  color: bgColor,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.settings, color: Colors.blue[600]),
                        title: Text(
                          'Setting Item ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    );
                  },
                  childCount: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SmallHeaderDelegate({
    required this.height,
    required this.backgroundColor,
    required this.titleColor,
    required this.scrollOffsetNotifier,
    required this.titleOpacityFn,
  });
  final double height;
  final Color backgroundColor;
  final Color titleColor;
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
              Opacity(
                opacity: titleOpacity,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.search, color: titleColor, size: 26),
                onPressed: () {},
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SmallHeaderDelegate oldDelegate) =>
      backgroundColor != oldDelegate.backgroundColor ||
      titleColor != oldDelegate.titleColor ||
      scrollOffsetNotifier != oldDelegate.scrollOffsetNotifier;
}
