import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/quran_widgets/enhanced_spiritual_loading_widget.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/core/widgets/error_retry_widget.dart';

/// Extension on RequestState to build appropriate sliver widgets.
/// All returned widgets are always valid slivers.
/// Example:
/// ```dart
/// state.whenSliver(
///   onSuccess: () => SliverList(...),
///   onLoading: buildSliverLoadingSkeleton(...), // أو أي sliver
///   onError: buildErrorSliver(...), // أو افتراضي
///   sliverList: myList,
///   onEmptyList: buildEmptySliver(...), // أو افتراضي
/// )
/// ```
extension RequestStateSliverX on RequestState {
  Widget whenSliver<T>({
    required Widget Function() onSuccess,
    Widget? onInitial,
    Widget? onLoading,
    Widget? onError,
    Function? onRefresh,
    Widget? onEmptyList,
    List<T>? sliverList,
    BuildContext? context,
    Duration animationDuration = const Duration(milliseconds: 250),
    Failure? failure,
  }) {
    return _buildSliverStateWidget<T>(
      onSuccess: onSuccess,
      onInitial: onInitial,
      onLoading: onLoading,
      onError: onError,
      onRefresh: onRefresh,
      onEmptyList: onEmptyList,
      sliverList: sliverList,
      context: context,
      failure: failure,
    );
  }

  Widget _buildSliverStateWidget<T>({
    required Widget Function() onSuccess,
    Widget? onInitial,
    Widget? onLoading,
    Widget? onError,
    Function? onRefresh,
    Widget? onEmptyList,
    List<T>? sliverList,
    BuildContext? context,
    Failure? failure,
  }) {
    // Helper to always return valid sliver
    Widget asSliver(Widget? w) {
      if (w == null) return const SliverToBoxAdapter(child: SizedBox());
      if (w is SliverList ||
          w is SliverGrid ||
          w is SliverFillRemaining ||
          w is SliverToBoxAdapter ||
          w is SliverPadding ||
          w is SliverAppBar) return w;
      return SliverToBoxAdapter(child: w);
    }

    switch (this) {
      case RequestState.initial:
        return onInitial != null
            ? asSliver(onInitial)
            : const SliverFillRemaining(
                hasScrollBody: false,
                child: SizedBox(),
              );
      case RequestState.loading:
        return onLoading != null
            ? asSliver(onLoading)
            : SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    children: [
                      const EnhancedSpiritualLoadingWidget(
                        showText: false,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'جاري تحميل ...',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: context?.gray1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
      case RequestState.error:
        return onError != null
            ? asSliver(onError)
            : SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorRetryWidget(
                  message: failure?.message ?? 'حدث خطأ أثناء تحميل البيانات',
                  onRetry: () => onRefresh?.call(),
                ),
              );
      case RequestState.success:
        if (sliverList != null && sliverList.isEmpty) {
          return onEmptyList != null
              ? asSliver(onEmptyList)
              : SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      children: [
                        const EnhancedSpiritualLoadingWidget(
                          showText: false,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'لا يوجد بيانات للعرض',
                          style: context?.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        }
        // success: always returns sliver
        final res = onSuccess();
        return asSliver(res);
    }
  }
}

/// General-purpose sliver skeleton loader for use in onLoading of sliver-based screens
Widget buildSliverLoadingSkeleton({
  required int itemCount,
  required Widget Function(int index) skeletonBuilder,
}) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) => skeletonBuilder(index),
      childCount: itemCount,
    ),
  );
}
