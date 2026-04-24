/// Web stub implementation of platform information.
/// This is used on web platforms (including WASM) where dart:io is not available.
class PlatformInfo {
  /// Whether the app is running on web platform.
  static const bool isWeb = true;

  /// Whether the app is running on Android.
  static const bool isAndroid = false;

  /// Whether the app is running on iOS.
  static const bool isIOS = false;

  /// Whether the app is running on Windows.
  static const bool isWindows = false;

  /// Whether the app is running on Linux.
  static const bool isLinux = false;

  /// Whether the app is running on macOS.
  static const bool isMacOS = false;

  /// The operating system name (always 'web' for web platforms).
  static const String operatingSystem = 'web';
}
