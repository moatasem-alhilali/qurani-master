import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/generic/query/query_bloc.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/core/widgets/error_retry_widget.dart';

/// Extension to build UI widgets based on QueryState<T>.
/// Handles loading, error (with Failure), success, initial, and empty cases.
/// Provides automatic refresh fallback if [refresh] is not provided.
///
/// Example usage with generic params:
///
/// 1. List fetch (param type: void)
/// ```dart
/// BlocBuilder<QueryBloc<List<User>, void>, QueryState<List<User>>>(
///   builder: (context, state) => state.buildQueryWidget<void>(
///     onSuccess: (users) => UserList(users: users),
///     context: context,      // required for auto-refresh
///     params: null,          // pass null for void
///     isList: true,
///   ),
/// )
/// ```
///
/// 2. Single object fetch (param type: String, e.g. id)
/// ```dart
/// BlocBuilder<QueryBloc<User, String>, QueryState<User>>(
///   builder: (context, state) => state.buildQueryWidget<String>(
///     onSuccess: (user) => UserProfile(user: user),
///     context: context,      // required for auto-refresh
///     params: userId,        // pass the id you want to fetch
///   ),
/// )
/// ```
///
/// 3. With custom filter (param type: FilterModel)
/// ```dart
/// BlocBuilder<QueryBloc<List<Product>, FilterModel>, QueryState<List<Product>>>(
///   builder: (context, state) => state.buildQueryWidget<FilterModel>(
///     onSuccess: (products) => ProductList(products: products),
///     context: context,
///     params: activeFilter,  // any object matching your QueryBloc's P
///     isList: true,
///   ),
/// )
/// ```
///
/// - For void params, always use `params: null` and call with `buildQueryWidget<void>()`.
/// - For any other param, pass the actual value (`params: ...`), and specify the type `buildQueryWidget<TheParamType>()`.
///
/// If you don't provide [refresh], the extension will auto-refresh using [context] and [params] (if provided).
/// This ensures DRY code and safe auto-retry in all screens.
///
/// Author: [Your Name]
/// Date: [Commit Date]
///
extension QueryStateWidgetX<T> on QueryState<T> {
  /// Builds widget for QueryState (success, loading, error, initial, empty).
  /// [onSuccess]: required widget when data is available
  /// [onLoading]: widget for loading state (optional)
  /// [onError]: widget/callback for error state (receives Failure and refresh)
  /// [onEmpty]: widget for empty list/object (optional)
  /// [onInitial]: widget for initial state (optional)
  /// [refresh]: callback for retry/refresh (optional, will auto-generate if not provided and context is given)
  /// [isList]: set true if T is List<Model>
  /// [context]: pass BuildContext if you want automatic refresh
  /// [params]: pass param if your QueryBloc needs it for fetching (e.g. id, filter)
  Widget buildQueryWidget<P>({
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
        return onInitial ?? const SizedBox();
      case RequestState.loading:
        return onLoading ??
            const Center(
              child: CircularProgressIndicator(),
            );
      case RequestState.error:
        final failure = this.failure ?? ServerFailure('Unknown error');
        return onError != null
            ? onError(failure, refresh ?? defaultRefresh ?? () {})
            : ErrorRetryWidget(
                message: failure.message,
                onRetry: refresh ?? defaultRefresh,
              );
      case RequestState.success:
        if (isList && (data is List && (data! as List).isEmpty)) {
          return onEmpty ??
              Center(
                child: Column(
                  children: [
                    Text(
                      'لا يوجد بيانات للعرض',
                      style: context?.bodyMedium?.copyWith(
                        color: context.onSurfaceColor,
                      ),
                    ),
                  ],
                ),
              );
        }
        if (data == null) {}
        return onSuccess(data as T);
    }
  }
}
