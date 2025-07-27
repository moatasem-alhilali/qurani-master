import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/quran_widgets/enhanced_spiritual_loading_widget.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/theme_data.dart';

/// Extension on RequestState enum to handle different states with widgets
///
/// Example usage:
/// ```dart
/// state.handle(
///   onSuccess: () => Text('Success!'),
///   onLoading: CircularProgressIndicator(),
///   onError: Text('Error occurred'),
///   list: myList,
/// )
/// ```
extension RequestStateWidget on RequestState {
  /// Handles different request states and returns appropriate widgets
  ///
  /// Parameters:
  /// - onSuccess: Required callback that returns widget for success state
  /// - onInitial: Optional widget to show in initial state (defaults to empty SizedBox)
  /// - onLoading: Optional widget to show in loading state (defaults to CircularProgressIndicator)
  /// - onError: Optional widget to show in error state (defaults to error message)
  /// - onEmptyList: Optional widget to show when list is empty (defaults to "No items found")
  /// - onNullObject: Optional widget to show when object is null (defaults to "No data available")
  /// - list: Optional list to check if empty in success state
  Widget handle<T>({
    required Widget Function() onSuccess,
    Widget? onInitial,
    Widget? onLoading,
    Widget? onError,
    Function? onRefresh,
    Widget? onEmptyList,
    Widget? onNullObject,
    List<T>? list,
    BuildContext? context,
  }) {
    switch (this) {
      case RequestState.initial:
        // Return initial widget or empty SizedBox if not provided
        return onInitial ?? const SizedBox();

      case RequestState.loading:
        // Return loading widget or default loading indicator
        return onLoading ??
            Center(
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
            );

      case RequestState.error:
        // Return error widget or default error message
        return Column(
          children: [
            const EnhancedSpiritualLoadingWidget(
              showText: false,
            ),
            SizedBox(height: 16.h),
            onError ??
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      onRefresh?.call();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('هناك خطأ ما يرجى المحاولة مرة أخرى'),
                  ),
                ),
          ],
        );

      case RequestState.success:
        // Check if list is provided and empty
        if (list != null && list.isEmpty) {
          return Column(
            children: [
              const EnhancedSpiritualLoadingWidget(
                showText: false,
                size: 250,
                // showParticles: false,
              ),
              SizedBox(height: 16.h),
              onEmptyList ??
                  Center(
                    child: Text(
                      'لا يوجد بيانات',
                      style: context?.titleMedium?.copyWith(
                        color: context.gray1,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
            ],
          );
        }

        // Return success widget callback result
        return onSuccess();
    }
  }
}
