import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/connectivity/connectivity_bloc.dart';

/// A widget that disables tap interactions when the user is offline.
///
/// Wrap any tappable widget (like InkWell, GestureDetector, buttons) with this widget
/// to automatically disable tap interactions when the device has no internet connection.
class DisableWhenOffline extends StatelessWidget {
  /// The child widget to be wrapped.
  final Widget child;

  /// Optional callback to execute when a tap attempt occurs while offline.
  final VoidCallback? onOfflineTap;

  /// Whether to show visual indication that the widget is disabled when offline.
  final bool showDisabledState;

  const DisableWhenOffline({
    super.key,
    required this.child,
    this.onOfflineTap,
    this.showDisabledState = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        final isConnected = state.isConnected;

        if (isConnected) {
          // When online, show the child normally
          return child;
        } else {
          // When offline, create a stack with the original widget and an invisible
          // overlay that intercepts taps
          return Stack(
            children: [
              // The original child with reduced opacity if needed
              Opacity(
                opacity: showDisabledState ? 0.5 : 1.0,
                child: IgnorePointer(
                  // Block interactions with the actual child
                  ignoring: true,
                  child: child,
                ),
              ),
              // Transparent overlay that captures taps
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    // ToastHelper.showError('لا يوجد اتصال بالانترنت');
                    onOfflineTap?.call();
                  },
                  // Make sure the overlay is invisible
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
