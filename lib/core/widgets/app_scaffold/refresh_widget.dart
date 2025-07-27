import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class RefreshWidget extends StatelessWidget {
  const RefreshWidget({
    required this.child,
    required this.controller,
    this.onRefresh,
    this.onLoading,
    this.header,
    this.enablePullUp = false,
    super.key,
  });

  final Widget child;
  final RefreshController controller;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final bool enablePullUp;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      onRefresh: onRefresh,
      enablePullUp: enablePullUp,
      onLoading: onLoading,
      enablePullDown: onRefresh != null,
      footer: const ClassicFooter(
        idleText: '',
        noDataText: '',
        loadingText: '',
        failedText: '',
        canLoadingText: '',
      ),
      header: header ??
          MaterialClassicHeader(
            color: context.primaryColor,
          ),
      child: child,
    );
  }
}
