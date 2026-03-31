part of '/quran.dart';

/// A class that defines the style for a Surah name.
///
/// This class contains properties to customize the appearance of a Surah name,
/// including its color, width, and height.
class SurahNameStyle {
  /// The color of the Surah name.
  final Color? surahNameColor;

  ///[surahNameSize] if you wanna add the size for the surah name
  final double? surahNameSize;

  /// Creates a new instance of [SurahNameStyle].
  ///
  /// All parameters are optional and can be null.
  SurahNameStyle({
    this.surahNameColor,
    this.surahNameSize,
  });
}
