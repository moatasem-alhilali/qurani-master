/// Conditional export for file system platform implementations.
/// Exports FileSystemIO on native platforms (dart:io available)
/// and FileSystemWeb on web platforms.
library;

export 'file_system_web.dart' if (dart.library.io) 'file_system_io.dart';
