part of '/quran.dart';

/// Recognizer يدعم ضغط مطوّل قصير (للكلمة) وضغط مطوّل أطول (للآية)
/// داخل TextSpan.
///
/// نستخدمه لأن TextSpan لا يدعم أكثر من recognizer واحد.
class TapLongPressRecognizer extends TapGestureRecognizer {
  TapLongPressRecognizer({
    this.shortHoldDuration = const Duration(milliseconds: 250),
    this.longHoldDuration = const Duration(milliseconds: 500),
  }) {
    onTapDown = _handleTapDown;
    onTapUp = _handleTapUp;
    onTapCancel = _handleTapCancel;
  }

  final Duration shortHoldDuration;
  final Duration longHoldDuration;

  VoidCallback? onShortHoldStartCallback;
  VoidCallback? onShortHoldCompleteCallback;
  void Function(LongPressStartDetails details)? onLongHoldStartCallback;

  /// يُستدعى عند الضغط السريع العادي (بدون ضغط مطوّل).
  /// إذا لم يُعيَّن، يتم استدعاء [QuranCtrl.instance.showControlToggle] كسلوك افتراضي.
  VoidCallback? onQuickTapCallback;

  Timer? _shortTimer;
  Timer? _longTimer;
  bool _didShortHold = false;
  bool _didLongHold = false;
  TapDownDetails? _lastTapDown;

  void _handleTapDown(TapDownDetails details) {
    _lastTapDown = details;
    _didShortHold = false;
    _didLongHold = false;

    _shortTimer?.cancel();
    _longTimer?.cancel();

    _shortTimer = Timer(shortHoldDuration, () {
      _didShortHold = true;
      onShortHoldStartCallback?.call();
    });

    _longTimer = Timer(longHoldDuration, () {
      _didLongHold = true;
      final d = _lastTapDown;
      if (d == null) return;
      onLongHoldStartCallback?.call(
        LongPressStartDetails(
          globalPosition: d.globalPosition,
          localPosition: d.localPosition,
        ),
      );
    });
  }

  void _handleTapCancel() {
    _shortTimer?.cancel();
    _shortTimer = null;
    _longTimer?.cancel();
    _longTimer = null;
    _lastTapDown = null;
    _didShortHold = false;
    _didLongHold = false;
  }

  void _handleTapUp(TapUpDetails details) {
    _shortTimer?.cancel();
    _shortTimer = null;
    _longTimer?.cancel();
    _longTimer = null;

    final wasLongHold = _didLongHold;

    if (_didShortHold && !_didLongHold) {
      onShortHoldCompleteCallback?.call();
    }

    _lastTapDown = null;
    _didShortHold = false;
    _didLongHold = false;

    // بعد الضغط المطوّل لا نمسح التحديد — toggleAyahSelection عمل update بالفعل
    if (!wasLongHold) {
      // أثناء السكرول التلقائي: إيقاف/استئناف مع إظهار/إخفاء عناصر التحكم
      final autoScroll = AutoScrollCtrl.instance;
      if (autoScroll.state.isActive.value) {
        autoScroll.togglePause();
        return;
      }

      if (onQuickTapCallback != null) {
        onQuickTapCallback!();
      } else {
        QuranCtrl.instance.showControlToggle();
      }
    }
  }

  @override
  void dispose() {
    _shortTimer?.cancel();
    _longTimer?.cancel();
    super.dispose();
  }
}
