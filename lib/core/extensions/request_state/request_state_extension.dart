import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';

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
  /// Handles different request states and returns appropriate widgets with smooth animations
  ///
  /// Parameters:
  /// - onSuccess: Required callback that returns widget for success state
  /// - onInitial: Optional widget to show in initial state (defaults to empty SizedBox)
  /// - onLoading: Optional widget to show in loading state (defaults to CircularProgressIndicator)
  /// - onError: Optional widget to show in error state (defaults to error message)
  /// - onEmptyList: Optional widget to show when list is empty (defaults to "No items found")
  /// - onNullObject: Optional widget to show when object is null (defaults to "No data available")
  /// - list: Optional list to check if empty in success state
  /// - animationDuration: Duration for state transitions (defaults to 300ms)
  Widget when<T>({
    required Widget Function() onSuccess,
    Widget? onInitial,
    Widget? onLoading,
    Widget? onError,
    Function? onRefresh,
    Widget? onEmptyList,
    Widget? onNullObject,
    List<T>? list,
    BuildContext? context,
    Duration animationDuration = const Duration(milliseconds: 300),
  }) {
    return AnimatedSwitcher(
      duration: animationDuration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: _buildStateWidget<T>(
        onSuccess: onSuccess,
        onInitial: onInitial,
        onLoading: onLoading,
        onError: onError,
        onRefresh: onRefresh,
        onEmptyList: onEmptyList,
        onNullObject: onNullObject,
        list: list,
        context: context,
      ),
    );
  }

  /// Internal method to build the appropriate widget based on current state
  Widget _buildStateWidget<T>({
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
        return Container(
          key: const ValueKey('initial_state'),
          child: onInitial ?? const SizedBox(),
        );

      case RequestState.loading:
        // Return loading widget or default loading indicator
        return Container(
          key: const ValueKey('loading_state'),
          child: onLoading ??
              Center(
                child: CircularProgressIndicator(
                  color: context?.primaryColor,
                ),
              ),
        );

      case RequestState.error:
        // Return error widget or default error message
        return Container(
          key: const ValueKey('error_state'),
          child: Column(
            children: [
              onError ??
                  Center(
                    child: Column(
                      children: [
                      
                        TextButton.icon(
                          onPressed: () {
                            onRefresh?.call();
                          },
                          icon: const Icon(Icons.refresh),
                          label: Text(
                            'هناك خطأ ما يرجى المحاولة مرة أخرى',
                            style: context?.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        );

      case RequestState.success:
        // Check if list is provided and empty
        if (list != null && list.isEmpty) {
          return Container(
            key: const ValueKey('empty_list_state'),
            child: onEmptyList ??
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                     
                      Positioned(
                        bottom: 60.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            'لا يوجد بيانات',
                            style: context?.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          );
        }

        // Return success widget callback result
        return Container(
          key: const ValueKey('success_state'),
          child: onSuccess(),
        );
    }
  }
}
