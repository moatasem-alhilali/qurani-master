import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';

extension RequestStateWidget on RequestState {
  Widget handle({
    required Widget Function() onSuccess,
    Widget? onInitial,
    Widget? onLoading,
    Widget? onError,
  }) {
    switch (this) {
      case RequestState.initial:
        return onInitial ?? const SizedBox();
      case RequestState.loading:
        return onLoading ?? const Center(child: CircularProgressIndicator());
      case RequestState.error:
        return onError ?? const SizedBox();
      case RequestState.success:
        return onSuccess();
    }
  }
}
