import 'package:equatable/equatable.dart';
import 'package:quran_app/main.dart';

/// Model for handling download links from various sources
class DownloadLinkModel extends Equatable {
  const DownloadLinkModel({
    required this.url,
    required this.provider,
    required this.isDirectDownload,
    this.fileName,
    this.fileSize,
    this.checksum,
    this.description,
  });

  /// Factory constructor from JSON/Map
  factory DownloadLinkModel.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';
    final provider =
        DownloadProvider.fromString(json['provider'] as String? ?? '');

    return DownloadLinkModel(
      url: url,
      provider: provider,
      isDirectDownload:
          json['is_direct_download'] as bool? ?? _isDirectDownloadUrl(url),
      fileName: json['file_name'] as String?,
      fileSize: json['file_size'] as String?,
      checksum: json['checksum'] as String?,
      description: json['description'] as String?,
    );
  }

  /// Factory constructor to detect provider from URL
  factory DownloadLinkModel.fromUrl(String url) {
    final provider = DownloadProvider.fromUrl(url);
    logger.d('provider: ${provider.name}');
    return DownloadLinkModel(
      url: url,
      provider: provider,
      isDirectDownload: _isDirectDownloadUrl(url),
    );
  }

  final String url;
  final DownloadProvider provider;
  final bool isDirectDownload;
  final String? fileName;
  final String? fileSize;
  final String? checksum;
  final String? description;

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'provider': provider.name,
      'is_direct_download': isDirectDownload,
      'file_name': fileName,
      'file_size': fileSize,
      'checksum': checksum,
      'description': description,
    };
  }

  /// Check if the URL is a direct download link
  static bool _isDirectDownloadUrl(String url) {
    // Check common direct download patterns
    final directPatterns = [
      '.apk',
      '.ipa',
      '.zip',
      '.rar',
      '/download/',
      'drive.google.com/uc?',
      'github.com/releases/download/',
    ];

    final lowerUrl = url.toLowerCase();
    return directPatterns.any(lowerUrl.contains);
  }

  /// Get the processed download URL (for providers that need special handling)
  String getProcessedUrl() {
    switch (provider) {
      case DownloadProvider.googleDrive:
        return _processGoogleDriveUrl(url);
      case DownloadProvider.mediafire:
        return url; // Mediafire requires web view handling
      case DownloadProvider.dropbox:
        return _processDropboxUrl(url);
      case DownloadProvider.github:
        return url; // GitHub releases are usually direct
      case DownloadProvider.direct:
      case DownloadProvider.unknown:
        return url;
    }
  }

  /// Process Google Drive URL for direct download
  String _processGoogleDriveUrl(String url) {
    // Convert Google Drive sharing URL to direct download URL
    final fileIdRegex = RegExp('/file/d/([a-zA-Z0-9-_]+)');
    final match = fileIdRegex.firstMatch(url);

    if (match != null) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }

    return url;
  }

  /// Process Dropbox URL for direct download
  String _processDropboxUrl(String url) {
    // Convert Dropbox sharing URL to direct download URL
    if (url.contains('dropbox.com') && url.contains('?dl=0')) {
      return url.replaceAll('?dl=0', '?dl=1');
    }

    return url;
  }

  /// Get estimated download approach
  DownloadApproach get downloadApproach {
    if (isDirectDownload) {
      return DownloadApproach.direct;
    }

    switch (provider) {
      case DownloadProvider.mediafire:
      case DownloadProvider.unknown:
        return DownloadApproach.webView;
      case DownloadProvider.googleDrive:
      case DownloadProvider.dropbox:
      case DownloadProvider.github:
        return DownloadApproach.processedDirect;
      case DownloadProvider.direct:
        return DownloadApproach.direct;
    }
  }

  @override
  List<Object?> get props => [
        url,
        provider,
        isDirectDownload,
        fileName,
        fileSize,
        checksum,
        description,
      ];
}

/// Download providers/sources
enum DownloadProvider {
  direct,
  googleDrive,
  mediafire,
  dropbox,
  github,
  unknown;

  /// Get display name
  String get displayName {
    switch (this) {
      case DownloadProvider.direct:
        return 'رابط مباشر';
      case DownloadProvider.googleDrive:
        return 'Google Drive';
      case DownloadProvider.mediafire:
        return 'Mediafire';
      case DownloadProvider.dropbox:
        return 'Dropbox';
      case DownloadProvider.github:
        return 'GitHub';
      case DownloadProvider.unknown:
        return 'مصدر غير معروف';
    }
  }

  /// Detect provider from URL
  static DownloadProvider fromUrl(String url) {
    final lowerUrl = url.toLowerCase();

    if (lowerUrl.contains('drive.google.com')) {
      return DownloadProvider.googleDrive;
    } else if (lowerUrl.contains('mediafire.com')) {
      return DownloadProvider.mediafire;
    } else if (lowerUrl.contains('dropbox.com')) {
      return DownloadProvider.dropbox;
    } else if (lowerUrl.contains('github.com')) {
      return DownloadProvider.github;
    } else if (lowerUrl.contains('.apk') || lowerUrl.contains('/download/')) {
      return DownloadProvider.direct;
    }

    return DownloadProvider.unknown;
  }

  /// Create from string name
  static DownloadProvider fromString(String name) {
    return DownloadProvider.values.firstWhere(
      (provider) => provider.name == name.toLowerCase(),
      orElse: () => DownloadProvider.unknown,
    );
  }
}

/// Download approach strategy
enum DownloadApproach {
  /// Direct download using HTTP client
  direct,

  /// Download using processed URL (like Google Drive)
  processedDirect,

  /// Download using WebView (like Mediafire)
  webView;

  /// Get display description
  String get description {
    switch (this) {
      case DownloadApproach.direct:
        return 'تحميل مباشر من داخل التطبيق';
      case DownloadApproach.processedDirect:
        return 'تحميل محسن من داخل التطبيق';
      case DownloadApproach.webView:
        return 'تحميل عبر المتصفح المدمج';
    }
  }
}
