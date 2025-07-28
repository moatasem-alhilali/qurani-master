import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/server_failure/failure.dart';

typedef AsyncAction<T, P> = Future<Either<Failure, T>> Function(P params);

/// ActionBloc<T, P>
/// ===========================================
/// Generic BLoC for handling one-off async actions (login, submit, update, delete, ...),
/// with type-safe error handling (Either<Failure, T>).
///
/// ### Usage with GetIt Dependency Injection
///
/// ```dart
/// getIt.registerFactory<ActionBloc<void, LoginParams>>(
///   () => ActionBloc<void, LoginParams>(
///     action: (params) => getIt<AuthRepository>().login(params),
///   ),
/// );
/// ```
///
/// **In your UI:**
/// ```dart
/// BlocProvider<ActionBloc<void, LoginParams>>(
///   create: (_) => getIt<ActionBloc<void, LoginParams>>(),
///   child: LoginFormWidget(),
/// )
/// ```
///
/// **Dispatch actions:**
/// ```dart
/// context.read<ActionBloc<void, LoginParams>>().add(
///   ActionRequested(LoginParams(email, password)),
/// );
/// ```
///
/// **Use with BlocConsumer:**
/// ```dart
/// BlocConsumer<ActionBloc<void, LoginParams>, ActionState<void>>(
///   listener: (context, state) {
///     if (state.status == RequestState.success) { ... }
///     if (state.status == RequestState.error) {
///       showSnackbar(state.failure?.message ?? 'خطأ غير معروف');
///     }
///   },
///   builder: (context, state) {
///     if (state.status == RequestState.loading) return CircularProgressIndicator();
///     return LoginForm(...);
///   },
/// )
/// ```
///
/// **Reset error:**
/// ```dart
/// context.read<ActionBloc<void, LoginParams>>().add(const ActionErrorCleared());
/// ```
///
/// ---
/// Author: [Your Name]
/// Date: [Commit Date]
///

class ActionBloc<T, P> extends Bloc<ActionEvent<P>, ActionState<T>> {
  ActionBloc({required this.action}) : super(ActionState<T>()) {
    on<ActionRequested<P>>((event, emit) async {
      emit(state.copyWith(status: RequestState.loading, failure: null));
      final either = await action(event.params);
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
      // Optional: reset to initial after success/error if you prefer (uncomment):
      // emit(state.copyWith(status: RequestState.initial, failure: null));
    });

    on<ActionErrorCleared<P>>((event, emit) {
      emit(state.copyWith(status: RequestState.initial, failure: null));
    });
  }

  final AsyncAction<T, P> action;
}

/// ---- Event/State Definitions ----

abstract class ActionEvent<T> {
  const ActionEvent();
}

class ActionRequested<T> extends ActionEvent<T> {
  const ActionRequested(this.params);
  final T params;
}

class ActionErrorCleared<T> extends ActionEvent<T> {
  const ActionErrorCleared();
}

/// ActionState<T> now holds a Failure object (not just string error)
class ActionState<T> {
  const ActionState({
    this.status = RequestState.initial,
    this.failure,
    this.data,
  });
  final RequestState status;
  final Failure? failure;
  final T? data;

  ActionState<T> copyWith({
    RequestState? status,
    Failure? failure,
    T? data,
  }) {
    return ActionState<T>(
      status: status ?? this.status,
      failure: failure,
      data: data ?? this.data,
    );
  }
}
