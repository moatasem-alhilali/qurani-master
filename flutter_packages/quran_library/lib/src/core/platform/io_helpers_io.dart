/// Platform-specific helper for File, Directory, and Platform operations.
/// This file provides exports from dart:io for native platforms.
library;

import 'dart:io' show Directory, File;
import 'dart:typed_data' show Uint8List;

import 'package:path_provider/path_provider.dart' as path_provider;

export 'dart:io' show File, Directory, Platform, FileSystemEntity;

/// Get the application documents directory.
Future<Directory> getApplicationDocumentsDirectory() async {
  return await path_provider.getApplicationDocumentsDirectory();
}

/// Get the temporary directory.
Future<Directory> getTemporaryDirectory() async {
  return await path_provider.getTemporaryDirectory();
}

/// Extension to add Uint8List support to File
extension FileUint8ListExtension on File {
  /// Read file as Uint8List
  Future<Uint8List> readAsBytesUint8List() async {
    return Uint8List.fromList(await readAsBytes());
  }
}
