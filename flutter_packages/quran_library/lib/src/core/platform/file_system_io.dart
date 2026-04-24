import 'dart:io';

import 'package:path_provider/path_provider.dart' as pp;

import 'file_system_platform.dart';

/// Native implementation of FileSystemPlatform using dart:io.
/// This is used on Android, iOS, Windows, macOS, and Linux.
class FileSystemIO implements FileSystemPlatform {
  @override
  Future<String> getTemporaryDirectory() async {
    return (await pp.getTemporaryDirectory()).path;
  }

  @override
  Future<String> getApplicationDocumentsDirectory() async {
    return (await pp.getApplicationDocumentsDirectory()).path;
  }

  @override
  Future<bool> fileExists(String path) async {
    return File(path).exists();
  }

  @override
  Future<void> writeFile(String path, List<int> bytes) async {
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
  }

  @override
  Future<List<int>> readFile(String path) async {
    return File(path).readAsBytes();
  }

  @override
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<bool> directoryExists(String path) async {
    return Directory(path).exists();
  }

  @override
  Future<void> createDirectory(String path) async {
    await Directory(path).create(recursive: true);
  }
}
