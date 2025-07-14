import 'package:equatable/equatable.dart';

/// Model for app version information from Firebase Remote Config
class AppVersionModel extends Equatable {
  const AppVersionModel({
    required this.latestVersion,
    required this.currentVersion,
    required this.downloadUrl,
    required this.isUpdateRequired,
    required this.isUpdateAvailable,
    this.releaseNotes,
    this.minimumRequiredVersion,
    this.updatePriority = UpdatePriority.normal,
    this.downloadSize,
    this.lastChecked,
  });

  /// Factory constructor from Firebase Remote Config data
  factory AppVersionModel.fromRemoteConfig({
    required Map<String, dynamic> remoteConfigData,
    required String currentVersion,
  }) {
    final latestVersion = remoteConfigData['latest_version'] as String? ?? '';
    final minimumVersion =
        remoteConfigData['minimum_required_version'] as String?;
    final downloadUrl = remoteConfigData['download_url'] as String? ?? '';
    final releaseNotes = remoteConfigData['release_notes'] as String?;
    final downloadSize = remoteConfigData['download_size'] as String?;
    final updatePriorityString =
        remoteConfigData['update_priority'] as String? ?? 'normal';

    final updatePriority = UpdatePriority.values.firstWhere(
      (priority) => priority.name == updatePriorityString,
      orElse: () => UpdatePriority.normal,
    );

    final isUpdateAvailable = _isVersionNewer(latestVersion, currentVersion);
    final isUpdateRequired = minimumVersion != null &&
        _isVersionNewer(minimumVersion, currentVersion);

    return AppVersionModel(
      latestVersion: latestVersion,
      currentVersion: currentVersion,
      downloadUrl: downloadUrl,
      isUpdateRequired: isUpdateRequired,
      isUpdateAvailable: isUpdateAvailable,
      releaseNotes: releaseNotes,
      minimumRequiredVersion: minimumVersion,
      updatePriority: updatePriority,
      downloadSize: downloadSize,
      lastChecked: DateTime.now(),
    );
  }

  /// Factory constructor from cached data
  factory AppVersionModel.fromCache(Map<String, dynamic> cached) {
    return AppVersionModel(
      latestVersion: cached['latest_version'] as String? ?? '',
      currentVersion: cached['current_version'] as String? ?? '',
      downloadUrl: cached['download_url'] as String? ?? '',
      isUpdateRequired: cached['is_update_required'] as bool? ?? false,
      isUpdateAvailable: cached['is_update_available'] as bool? ?? false,
      releaseNotes: cached['release_notes'] as String?,
      minimumRequiredVersion: cached['minimum_required_version'] as String?,
      updatePriority: UpdatePriority.values.firstWhere(
        (priority) =>
            priority.name == (cached['update_priority'] as String? ?? 'normal'),
        orElse: () => UpdatePriority.normal,
      ),
      downloadSize: cached['download_size'] as String?,
      lastChecked: cached['last_checked'] != null
          ? DateTime.fromMillisecondsSinceEpoch(cached['last_checked'] as int)
          : null,
    );
  }

  final String latestVersion;
  final String currentVersion;
  final String downloadUrl;
  final bool isUpdateRequired;
  final bool isUpdateAvailable;
  final String? releaseNotes;
  final String? minimumRequiredVersion;
  final UpdatePriority updatePriority;
  final String? downloadSize;
  final DateTime? lastChecked;

  /// Convert to JSON for caching
  Map<String, dynamic> toCache() {
    return {
      'latest_version': latestVersion,
      'current_version': currentVersion,
      'download_url': downloadUrl,
      'is_update_required': isUpdateRequired,
      'is_update_available': isUpdateAvailable,
      'release_notes': releaseNotes,
      'minimum_required_version': minimumRequiredVersion,
      'update_priority': updatePriority.name,
      'download_size': downloadSize,
      'last_checked': lastChecked?.millisecondsSinceEpoch,
    };
  }

  /// Check if cached data is still valid (not older than specified duration)
  bool isCacheValid([Duration maxAge = const Duration(hours: 6)]) {
    if (lastChecked == null) return false;
    return DateTime.now().difference(lastChecked!) < maxAge;
  }

  /// Create a copy with updated values
  AppVersionModel copyWith({
    String? latestVersion,
    String? currentVersion,
    String? downloadUrl,
    bool? isUpdateRequired,
    bool? isUpdateAvailable,
    String? releaseNotes,
    String? minimumRequiredVersion,
    UpdatePriority? updatePriority,
    String? downloadSize,
    DateTime? lastChecked,
  }) {
    return AppVersionModel(
      latestVersion: latestVersion ?? this.latestVersion,
      currentVersion: currentVersion ?? this.currentVersion,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      isUpdateRequired: isUpdateRequired ?? this.isUpdateRequired,
      isUpdateAvailable: isUpdateAvailable ?? this.isUpdateAvailable,
      releaseNotes: releaseNotes ?? this.releaseNotes,
      minimumRequiredVersion:
          minimumRequiredVersion ?? this.minimumRequiredVersion,
      updatePriority: updatePriority ?? this.updatePriority,
      downloadSize: downloadSize ?? this.downloadSize,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }

  /// Helper method to compare version strings
  static bool _isVersionNewer(String newVersion, String currentVersion) {
    if (newVersion.isEmpty || currentVersion.isEmpty) return false;

    // Handle identical versions quickly
    if (newVersion == currentVersion) return false;

    try {
      // Split and parse version parts, handling non-numeric parts
      final newParts = newVersion.split('.').map((part) {
        final parsed = int.tryParse(part.trim());
        return parsed ?? 0; // Default to 0 for non-numeric parts
      }).toList();

      final currentParts = currentVersion.split('.').map((part) {
        final parsed = int.tryParse(part.trim());
        return parsed ?? 0; // Default to 0 for non-numeric parts
      }).toList();

      // Ensure both lists have the same length by padding with zeros
      final maxLength = newParts.length > currentParts.length
          ? newParts.length
          : currentParts.length;

      while (newParts.length < maxLength) newParts.add(0);
      while (currentParts.length < maxLength) currentParts.add(0);

      // Compare each part from left to right
      for (var i = 0; i < maxLength; i++) {
        final newPart = newParts[i];
        final currentPart = currentParts[i];

        if (newPart > currentPart) return true;
        if (newPart < currentPart) return false;
        // If equal, continue to next part
      }

      return false; // All parts are equal
    } catch (e) {
      // If comparison fails, fall back to string comparison
      return newVersion.compareTo(currentVersion) > 0;
    }
  }

  @override
  List<Object?> get props => [
        latestVersion,
        currentVersion,
        downloadUrl,
        isUpdateRequired,
        isUpdateAvailable,
        releaseNotes,
        minimumRequiredVersion,
        updatePriority,
        downloadSize,
        lastChecked,
      ];

  @override
  String toString() {
    return 'AppVersionModel('
        'current: $currentVersion, '
        'latest: $latestVersion, '
        'updateAvailable: $isUpdateAvailable, '
        'updateRequired: $isUpdateRequired, '
        'priority: ${updatePriority.name}, '
        'downloadUrl: ${downloadUrl.isNotEmpty ? "present" : "empty"}, '
        'lastChecked: $lastChecked'
        ')';
  }
}

/// Update priority levels
enum UpdatePriority {
  low,
  normal,
  high,
  critical;

  /// Get display text for the priority
  String get displayText {
    switch (this) {
      case UpdatePriority.low:
        return 'تحديث اختياري';
      case UpdatePriority.normal:
        return 'تحديث عادي';
      case UpdatePriority.high:
        return 'تحديث مهم';
      case UpdatePriority.critical:
        return 'تحديث ضروري';
    }
  }

  /// Get color for the priority
  String get colorHex {
    switch (this) {
      case UpdatePriority.low:
        return '#4CAF50'; // Green
      case UpdatePriority.normal:
        return '#2196F3'; // Blue
      case UpdatePriority.high:
        return '#FF9800'; // Orange
      case UpdatePriority.critical:
        return '#F44336'; // Red
    }
  }
}
