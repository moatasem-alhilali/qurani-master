part of '/quran.dart';

/// Data source types for Quran data
enum DataSourceType {
  /// Data from local asset JSON file
  local,

  /// Data from remote URL
  remote,

  /// Data requires downloaded fonts (special case for Mushaf fonts)
  downloaded,
}

/// Data source configuration for Quran recitations
class DataSource {
  final DataSourceType type;
  final String? localPath;
  final String? url;

  const DataSource.local(String path)
      : type = DataSourceType.local,
        localPath = path,
        url = null;

  const DataSource.remote(String remoteUrl)
      : type = DataSourceType.remote,
        localPath = null,
        url = remoteUrl;

  const DataSource.downloaded()
      : type = DataSourceType.downloaded,
        localPath = null,
        url = null;
}

/// Quran recitation types with their configurations
enum QuranRecitation {
  /// حفص - الخط الأساسي
  hafs(
    recitationIndex: 0,
    arabicName: 'الخط الأساسي (حفص)',
    englishName: 'Hafs',
    fontFamily: 'hafs',
    dataSource: DataSource.local('quran_hafs.json'),
  ),

  /// حفص - خط المصحف (requires download)
  hafsMushaf(
    recitationIndex: 1,
    arabicName: 'خط المصحف (حفص)',
    englishName: 'Hafs Mushaf',
    fontFamily: 'hafs',
    dataSource: DataSource.downloaded(),
  ),

  /// حفص - خط التجويد (requires download)
  hafsMushafTajweed(
    recitationIndex: 2,
    arabicName: 'خط التجويد (حفص)',
    englishName: 'Hafs Mushaf Tajweed',
    fontFamily: 'p',
    dataSource: DataSource.downloaded(),
  );

  /// ورش - خط المصحف
  // warsh(
  //   recitationIndex: 2,
  //   arabicName: 'خط المصحف (ورش)',
  //   englishName: 'Warsh',
  //   fontFamily: 'warsh',
  //   dataSource: DataSource.remote(
  //     'https://raw.githubusercontent.com/alheekmahlib/data/main/packages/quran_library/content/warshData_v2-1.json',
  //   ),
  // );

  const QuranRecitation({
    required this.recitationIndex,
    required this.arabicName,
    required this.englishName,
    required this.fontFamily,
    required this.dataSource,
  });

  /// Index for compatibility with existing font selection system
  final int recitationIndex;

  /// Arabic display name
  final String arabicName;

  /// English display name
  final String englishName;

  /// Font family name to use for this recitation
  final String fontFamily;

  /// Data source configuration
  final DataSource dataSource;

  /// Get recitation by index
  static QuranRecitation fromIndex(int idx) {
    return QuranRecitation.values.firstWhere(
      (r) => r.recitationIndex == idx,
      orElse: () => QuranRecitation.hafs,
    );
  }

  /// Check if this recitation requires downloaded fonts
  bool get requiresDownload => dataSource.type == DataSourceType.downloaded;

  /// Check if this recitation loads from remote URL
  bool get isRemote => dataSource.type == DataSourceType.remote;

  /// Check if this recitation loads from local assets
  bool get isLocal => dataSource.type == DataSourceType.local;
}
