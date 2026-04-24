import 'file_system_platform.dart';

/// Web stub implementation of FileSystemPlatform.
/// This is used on web platforms (including WASM) where dart:io is not available.
/// All operations throw UnsupportedError since web platforms don't have direct
/// file system access in the same way as native platforms.
class FileSystemWeb implements FileSystemPlatform {
  @override
  Future<String> getTemporaryDirectory() {
    throw UnsupportedError(
      'File system operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  @override
  Future<String> getApplicationDocumentsDirectory() {
    throw UnsupportedError(
      'File system operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  @override
  Future<bool> fileExists(String path) {
    throw UnsupportedError(
      'File system operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  @override
  Future<void> writeFile(String path, List<int> bytes) {
    throw UnsupportedError(
      'File system operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  @override
  Future<List<int>> readFile(String path) {
    throw UnsupportedError(
      'File system operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  @override
  Future<void> deleteFile(String path) {
    throw UnsupportedError(
      'File system operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  @override
  Future<bool> directoryExists(String path) {
    throw UnsupportedError(
      'File system operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }

  @override
  Future<void> createDirectory(String path) {
    throw UnsupportedError(
      'File system operations are not supported on web platform. '
      'Use web-specific APIs like IndexedDB or browser storage instead.',
    );
  }
}
