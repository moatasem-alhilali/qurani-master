/// Conditional export for platform information implementations.
/// Exports PlatformInfoIO on native platforms (dart:io available)
/// and PlatformInfoStub on web platforms.
library;

export 'platform_info_stub.dart' if (dart.library.io) 'platform_info_io.dart';
