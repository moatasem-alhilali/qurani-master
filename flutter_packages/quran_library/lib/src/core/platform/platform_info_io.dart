import 'dart:io' show Platform;

/// Native implementation of platform information using dart:io.
/// This is used on Android, iOS, Windows, macOS, and Linux.
class PlatformInfo {
  /// Whether the app is running on web platform.
  static const bool isWeb = false;

  /// Whether the app is running on Android.
  static bool get isAndroid => Platform.isAndroid;

  /// Whether the app is running on iOS.
  static bool get isIOS => Platform.isIOS;

  /// Whether the app is running on Windows.
  static bool get isWindows => Platform.isWindows;

  /// Whether the app is running on Linux.
  static bool get isLinux => Platform.isLinux;

  /// Whether the app is running on macOS.
  static bool get isMacOS => Platform.isMacOS;

  /// The operating system name (e.g., 'android', 'ios', 'windows', etc.).
  static String get operatingSystem => Platform.operatingSystem;
}
