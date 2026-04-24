/// Abstract interface for file system operations across platforms.
/// This allows the package to work on both native platforms (Android, iOS, etc.)
/// and web platforms (WASM) by providing platform-specific implementations.
abstract class FileSystemPlatform {
  /// Gets the temporary directory path for the platform.
  Future<String> getTemporaryDirectory();

  /// Gets the application documents directory path for the platform.
  Future<String> getApplicationDocumentsDirectory();

  /// Checks if a file exists at the given path.
  Future<bool> fileExists(String path);

  /// Writes bytes to a file at the given path.
  Future<void> writeFile(String path, List<int> bytes);

  /// Reads bytes from a file at the given path.
  Future<List<int>> readFile(String path);

  /// Deletes a file at the given path.
  Future<void> deleteFile(String path);

  /// Checks if a directory exists at the given path.
  Future<bool> directoryExists(String path);

  /// Creates a directory at the given path.
  Future<void> createDirectory(String path);
}
