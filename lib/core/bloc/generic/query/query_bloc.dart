import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/server_failure/failure.dart';

typedef QueryFunction<T, P> = Future<Either<Failure, T>> Function(P params);

/// QueryBloc<T, P>
/// =======================================
/// Generic BLoC for unified async data fetching (query) with support for any result (single model, list, etc),
/// and robust error handling using Either<Failure, T>.
///
/// ### Usage with GetIt Dependency Injection:
///
/// ```dart
/// // Registering a QueryBloc for fetching all users (List<User>)
/// getIt.registerFactory<QueryBloc<List<User>, void>>(
///   () => QueryBloc<List<User>, void>(
///     fetch: (_) => getIt<UserRepository>().getAllUsers(),
///   ),
/// );
///
/// // Registering for fetching a single user by id (User)
/// getIt.registerFactory<QueryBloc<User, String>>(
///   () => QueryBloc<User, String>(
///     fetch: (id) => getIt<UserRepository>().getUserById(id),
///   ),
/// );
/// ```
///
/// **Providing the QueryBloc in your widget tree:**
///
/// ```dart
/// BlocProvider<QueryBloc<List<User>, void>>(
///   create: (_) => getIt<QueryBloc<List<User>, void>>()..add(const FetchRequested(null)),
///   child: UserListScreen(),
/// )
/// ```
///
/// **Using with BlocBuilder:**
///
/// ```dart
/// BlocBuilder<QueryBloc<List<User>, void>, QueryState<List<User>>>(
///   builder: (context, state) => state.buildQueryWidget(
///     onSuccess: (users) => UserList(users: users),
///     onLoading: const CircularProgressIndicator(),
///     onError: (failure, refresh) => ErrorWidget(
///       message: failure.message,
///       code: failure.code,
///       statusCode: failure.statusCode,
///       onRetry: refresh,
///     ),
///     onEmpty: const Center(child: Text('No users found')),
///     refresh: () => context.read<QueryBloc<List<User>, void>>().add(const FetchRequested(null)),
///     isList: true,
///   ),
/// )
/// ```
///
/// **To refetch or clear errors:**
///
/// ```dart
/// context.read<QueryBloc<List<User>, void>>().add(const FetchRequested(null));
/// context.read<QueryBloc<List<User>, void>>().add(const FetchClearError());
/// ```
///
/// ---
///
/// Features:
/// - Type-safe, handles any data type (single, list, etc)
/// - Handles errors with custom Failure object, not just strings
/// - Designed for scalable and maintainable architecture
/// - Easily integrates with DI (GetIt) and UI (BlocBuilder)
///
/// Author: [Your Name]
/// Date: [Commit Date]
///

class QueryBloc<T, P> extends Bloc<QueryEvent<P>, QueryState<T>> {
  QueryBloc({required this.fetch}) : super(QueryState<T>()) {
    on<FetchRequested<P>>((event, emit) async {
      emit(state.copyWith(status: RequestState.loading, failure: null));
      // await Future.delayed(const Duration(seconds: 5));
      final either = await fetch(event.params);
      either.fold(
        (failure) => emit(
          state.copyWith(
            status: RequestState.error,
            failure: failure,
          ),
        ),
        (data) => emit(
          state.copyWith(
            status: RequestState.success,
            data: data,
            failure: null,
          ),
        ),
      );
    });

    on<FetchClearError<P>>((event, emit) {
      emit(state.copyWith(status: RequestState.initial, failure: null));
    });
  }

  final QueryFunction<T, P> fetch;
}

// QueryState<T>
class QueryState<T> {
  const QueryState({
    this.status = RequestState.initial,
    this.data,
    this.failure,
  });
  final RequestState status;
  final T? data;
  final Failure? failure;

  QueryState<T> copyWith({
    RequestState? status,
    T? data,
    Failure? failure,
  }) {
    return QueryState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      failure: failure,
    );
  }
}

abstract class QueryEvent<P> {}

class FetchRequested<P> extends QueryEvent<P> {
  FetchRequested(this.params);
  final P params;
}

class FetchClearError<P> extends QueryEvent<P> {
  FetchClearError();
}
