import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/generic/query/query_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/core/widgets/error_retry_widget.dart';

/// Extension to build **Sliver** widgets based on QueryState<T>.
/// Handles loading, error (with Failure), success, initial, and empty cases.
/// Provides automatic refresh fallback if [refresh] is not provided.
///
/// ====
/// Example usage with generic params:
///
/// 1. List fetch (param type: void)
/// ```dart
/// BlocBuilder<QueryBloc<List<User>, void>, QueryState<List<User>>>(
///   builder: (context, state) => state.buildSliverQueryWidget<void>(
///     onSuccess: (users) => SliverList(
///       delegate: SliverChildBuilderDelegate(
///         (context, i) => UserCard(users[i]),
///         childCount: users.length,
///       ),
///     ),
///     onLoading: buildSliverLoadingSkeleton(
///       itemCount: 3,
///       skeletonBuilder: (i) => UserCard.skeleton(), // أي widget dummy
///     ),
///     context: context, // required for auto-refresh
///     params: null,     // pass null for void
///     isList: true,
///   ),
/// )
/// ```
///
/// 2. Single object fetch (param type: String, e.g. id)
/// ```dart
/// BlocBuilder<QueryBloc<User, String>, QueryState<User>>(
///   builder: (context, state) => state.buildSliverQueryWidget<String>(
///     onSuccess: (user) => SliverToBoxAdapter(child: UserProfile(user: user)),
///     context: context,
///     params: userId,
///   ),
/// )
/// ```
///
/// 3. With custom filter (param type: FilterModel)
/// ```dart
/// BlocBuilder<QueryBloc<List<Product>, FilterModel>, QueryState<List<Product>>>(
///   builder: (context, state) => state.buildSliverQueryWidget<FilterModel>(
///     onSuccess: (products) => SliverList(
///       delegate: SliverChildBuilderDelegate(
///         (context, i) => ProductCard(products[i]),
///         childCount: products.length,
///       ),
///     ),
///     onLoading: buildSliverLoadingSkeleton(
///       itemCount: 4,
///       skeletonBuilder: (i) => ProductCard.skeleton(),
///     ),
///     context: context,
///     params: activeFilter,
///     isList: true,
///   ),
/// )
/// ```
///
/// - For void params, always use `params: null` and call with `buildSliverQueryWidget<void>()`.
/// - For any other param, pass the actual value (`params: ...`), and specify the type `buildSliverQueryWidget<TheParamType>()`.
///
/// If you don't provide [refresh], the extension will auto-refresh using [context] and [params] (if provided).
/// This ensures DRY code and safe auto-retry in all screens.
///
/// Author: [Your Name]
/// Date: [Commit Date]
///
extension QueryStateSliverWidgetX<T> on QueryState<T> {
  /// Builds sliver widget for QueryState (success, loading, error, initial, empty).
  /// [onSuccess]: required sliver widget when data is available (must be SliverList, SliverGrid, or SliverToBoxAdapter)
  /// [onLoading]: sliver for loading state (optional)
  /// [onError]: sliver/callback for error state (receives Failure and refresh)
  /// [onEmpty]: sliver for empty list/object (optional)
  /// [onInitial]: sliver for initial state (optional)
  /// [refresh]: callback for retry/refresh (optional, will auto-generate if not provided and context is given)
  /// [isList]: set true if T is List<Model>
  /// [context]: pass BuildContext if you want automatic refresh
  /// [params]: pass param if your QueryBloc needs it for fetching (e.g. id, filter)
  Widget buildSliverQueryWidget<P>({
    required Widget Function(T data) onSuccess,
    Widget? onLoading,
    Widget Function(Failure failure, VoidCallback refresh)? onError,
    Widget? onEmpty,
    Widget? onInitial,
    VoidCallback? refresh,
    bool isList = false,
    BuildContext? context,
    P? params,
  }) {
    VoidCallback? defaultRefresh;
    if (refresh == null && context != null) {
      defaultRefresh = () {
        try {
          context.read<QueryBloc<T, P>>().add(FetchRequested<P>(params as P));
        } catch (e) {
          // Silently ignore if Bloc type or params are incorrect
        }
      };
    }

    switch (status) {
      case RequestState.initial:
        return onInitial != null
            ? _asSliver(onInitial)
            : const SliverFillRemaining(child: SizedBox());
      case RequestState.loading:
        return onLoading != null
            ? _asSliver(onLoading)
            : const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              );
      case RequestState.error:
        final failure =
            this.failure ?? ServerFailure('Unknown error');
        if (onError != null) {
          return _asSliver(
            onError(failure, refresh ?? defaultRefresh ?? () {}),
          );
        }
        return SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorRetryWidget(
            message: failure.message,
           
            onRetry: refresh ?? defaultRefresh,
          ),
        );
      case RequestState.success:
        if (isList && (data is List && (data! as List).isEmpty)) {
          return onEmpty != null
              ? _asSliver(onEmpty)
              : const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No items to display')),
                );
        }
        if (data == null) {
          return onEmpty != null
              ? _asSliver(onEmpty)
              : const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No data available')),
                );
        }
        return onSuccess(data as T);
    }
  }
}

/// Helper: wraps a regular widget as sliver
Widget _asSliver(Widget? child) {
  if (child == null) return const SliverToBoxAdapter(child: SizedBox());
  if (child is SliverList ||
      child is SliverGrid ||
      child is SliverFillRemaining ||
      child is SliverToBoxAdapter ||
      child is SliverPadding ||
      child is SliverAppBar) {
    // Already a sliver
    return child;
  }
  return SliverToBoxAdapter(child: child);
}

/// Helper to easily build a shimmer/dummy sliver loading skeleton
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
