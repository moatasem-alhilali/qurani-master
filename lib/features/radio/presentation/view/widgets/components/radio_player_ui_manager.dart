import 'package:quran_app/core/package/flutter_sliding_box.dart';

class RadioPlayerUiManager {
  RadioPlayerUiManager._();

  static final RadioPlayerUiManager instance = RadioPlayerUiManager._();

  final BoxController boxController = BoxController();
  bool _pendingOpen = false;

  bool get pendingOpen => _pendingOpen;

  void clearPending() => _pendingOpen = false;

  void openBox() {
    _pendingOpen = true;
    if (boxController.isAttached) {
      boxController
        ..showBox()
        ..openBox();
    }
  }

  void closeBox() {
    _pendingOpen = false;
    if (boxController.isAttached) {
      boxController.closeBox();
    }
  }
}
