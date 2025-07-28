import 'dart:async';

import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quran_app/features/home/presentation/view/widgets/random_ayah_widget.dart';

/// Custom RefreshIndicator with Retractable Elastic Text
class ElasticTextRefreshHeader extends RefreshIndicator {
  const ElasticTextRefreshHeader({
    this.refreshTextAlignment,
    super.key,
    super.height = 132,
    super.refreshStyle = RefreshStyle.UnFollow,
  });

  final Alignment? refreshTextAlignment;

  @override
  State<StatefulWidget> createState() {
    return _ElasticTextRefreshHeaderState();
  }
}

class _ElasticTextRefreshHeaderState
    extends RefreshIndicatorState<ElasticTextRefreshHeader>
    with TickerProviderStateMixin {
  late AnimationController? _animationController;
  late AnimationController _dismissCtl;

  @override
  void initState() {
    super.initState();
    _dismissCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1,
    );
    _animationController = AnimationController(
      vsync: this,
      upperBound: 50,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void onOffsetChange(double offset) {
    final realOffset = offset - 44.0;
    if (!_animationController!.isAnimating) {
      _animationController!.value = realOffset;
    }
  }

  @override
  Future<void> readyToRefresh() async {
    await _dismissCtl.animateTo(0);
    await _animationController!.animateTo(0);
  }

  @override
  void resetValue() {
    _animationController!.reset();
    _dismissCtl.value = 1.0;
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    Widget? child;

    // Show different content based on the refresh status
    if (mode == RefreshStatus.refreshing ||
        mode == RefreshStatus.completed ||
        mode == RefreshStatus.canRefresh) {
      child = Container(
        width: double.infinity,
        height: double.infinity,
        alignment: widget.refreshTextAlignment ?? Alignment.bottomCenter,
        child: const RandomAyahWidget(),
      );
    } else {
      // Idle or Can Refresh status, show retractable text
      child = const SizedBox.shrink();
    }

    return SizedBox(
      height: 132 + MediaQuery.of(context).padding.top,
      child: Align(alignment: Alignment.bottomCenter, child: child),
    );
  }

  @override
  void dispose() {
    _dismissCtl.dispose();
    _animationController!.dispose();
    super.dispose();
  }
}
