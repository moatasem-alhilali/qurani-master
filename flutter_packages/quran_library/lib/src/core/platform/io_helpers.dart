/// Platform-specific helper for File, Directory, and Platform operations.
/// This file provides static methods that wrap the native dart:io types
/// and provide stub implementations for web platforms.
///
/// On native platforms (dart:io available), these methods delegate to real dart:io types.
/// On web platforms, these throw UnsupportedError since file system operations
/// are not available.
library;

export 'io_helpers_stub.dart' if (dart.library.io) 'io_helpers_io.dart'
    show
        File,
        Directory,
        Platform,
        FileSystemEntity,
        getApplicationDocumentsDirectory,
        getTemporaryDirectory;
