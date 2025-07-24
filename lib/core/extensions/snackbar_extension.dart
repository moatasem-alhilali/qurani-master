
import 'package:quran_app/core/extensions/snackbar_export.dart';

extension CustomPositionSnackbar on BuildContext {
  void showCustomSnackbar(
    String message, {
    SnackBarType style = SnackBarType.success,
    Duration duration = const Duration(milliseconds: 2400),
    SnackbarPosition position = SnackbarPosition.bottom,
    double? customOffset,
  }) {
    final overlay = Overlay.of(this);

    final media = MediaQuery.of(this);
    final bottomPadding = media.padding.bottom;
    final topPadding = media.padding.top;

    double? top;
    double? bottom;
    var alignment = Alignment.bottomCenter;
    var beginOffset = const Offset(0, 1);
    const endOffset = Offset.zero;

    switch (position) {
      case SnackbarPosition.top:
        top = customOffset ?? topPadding + 12;
        alignment = Alignment.topCenter;
        beginOffset = const Offset(0, -1);
      case SnackbarPosition.center:
        top = (media.size.height / 2) - 28;
        alignment = Alignment.center;
        beginOffset = const Offset(0, 1);
      case SnackbarPosition.bottom:
        bottom = customOffset ?? bottomPadding;
        alignment = Alignment.bottomCenter;
        beginOffset = const Offset(0, 1);
    }

    final controller = AnimationController(
      duration: const Duration(milliseconds: 340),
      vsync: Navigator.of(this),
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => IgnorePointer(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: top,
                bottom: bottom,
                left: 12,
                right: 12,
                child: Align(
                  alignment: alignment,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: beginOffset,
                      end: endOffset,
                    ).animate(animation),
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedSnackbarWidget(
                        message: message,
                        style: style,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    overlay.insert(entry);
    controller.forward();

    Future.delayed(duration, () async {
      await controller.reverse();
      entry.remove();
      controller.dispose();
    });
  }
}
