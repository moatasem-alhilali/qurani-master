import 'dart:async';
import 'dart:typed_data' show Uint8List;

/// Web stub implementations for File, Directory, and Platform helpers.
/// These are used on web platforms (including WASM) where dart:io is not available.
/// All operations throw UnsupportedError since web platforms don't have direct
/// file system access in the same way as native platforms.

/// Stub class for File on web platforms.
/// All operations throw UnsupportedError.
class File {
  File(this.path);

  final String path;

  bool existsSync() {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<bool> exists() async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<void> create({bool recursive = false}) async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<void> delete() async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<Uint8List> readAsBytes() async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<String> readAsString() async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<void> writeAsBytes(List<int> bytes, {bool flush = false}) async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<void> writeAsString(String contents, {bool flush = false}) async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  IOSink openWrite() {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<int> length() async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Directory get parent {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }
}

/// Stub class for Directory on web platforms.
/// All operations throw UnsupportedError.
class Directory {
  Directory(this.path);

  final String path;

  bool existsSync() {
    throw UnsupportedError(
      'Directory operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<bool> exists() async {
    throw UnsupportedError(
      'Directory operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<void> create({bool recursive = false}) async {
    throw UnsupportedError(
      'Directory operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Stream<FileSystemEntity> list(
      {bool recursive = false, bool followLinks = true}) {
    throw UnsupportedError(
      'Directory operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<void> delete({bool recursive = false}) async {
    throw UnsupportedError(
      'Directory operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }
}

/// Stub class for FileSystemEntity on web platforms.
class FileSystemEntity {
  final String path;

  FileSystemEntity(this.path);
}

/// Stub class for IOSink on web platforms.
class IOSink {
  IOSink();

  Future<void> add(List<int> data) async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<void> close() async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  Future<void> flush() async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }
}

/// Stub class for Platform on web platforms.
class Platform {
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

  /// The path separator for the platform.
  static const String pathSeparator = '/';
}

/// Stub for getApplicationDocumentsDirectory on web platforms.
Future<Directory> getApplicationDocumentsDirectory() async {
  throw UnsupportedError(
    'File system operations are not supported on web platform. '
    'Use web-specific APIs like IndexedDB or browser storage instead.',
  );
}

/// Stub for getTemporaryDirectory on web platforms.
Future<Directory> getTemporaryDirectory() async {
  throw UnsupportedError(
    'File system operations are not supported on web platform. '
    'Use web-specific APIs like IndexedDB or browser storage instead.',
  );
}

/// Extension to add Uint8List support to File (stub)
extension FileUint8ListExtension on File {
  /// Read file as Uint8List
  Future<Uint8List> readAsBytesUint8List() async {
    throw UnsupportedError(
      'File operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }
}
