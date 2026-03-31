part of '/quran.dart';

class BannerStyle {
  ///[bannerImagePath] if you wanna add banner as image you can provide the path
  final String? bannerImagePath;

  ///[bannerImageWidth] if you wanna add the width for the banner image
  final double? bannerImageWidth;

  ///[bannerImageHeight] if you wanna add the height for the banner image
  final double? bannerImageHeight;

  ///[isImage] if you wanna add banner as svg you can set it to true
  final bool? isImage;

  ///[bannerSvgPath] if you wanna add banner as svg you can provide the path
  final String? bannerSvgPath;

  ///[bannerSvgWidth] if you wanna add the width for the banner svg
  final double? bannerSvgWidth;

  ///[bannerSvgHeight] if you wanna add the height for the banner svg
  final double? bannerSvgHeight;

  ///[svgBannerColor] if you wanna change the color for the banner svg
  final Color? svgBannerColor;

  BannerStyle({
    this.isImage,
    this.bannerImagePath,
    this.bannerImageWidth,
    this.bannerImageHeight,
    this.bannerSvgPath,
    this.bannerSvgWidth,
    this.bannerSvgHeight,
    this.svgBannerColor,
  });

  BannerStyle copyWith({
    String? bannerImagePath,
    double? bannerImageWidth,
    double? bannerImageHeight,
    bool? isImage,
    String? bannerSvgPath,
    double? bannerSvgWidth,
    double? bannerSvgHeight,
    Color? svgBannerColor,
  }) {
    return BannerStyle(
      bannerImagePath: bannerImagePath ?? this.bannerImagePath,
      bannerImageWidth: bannerImageWidth ?? this.bannerImageWidth,
      bannerImageHeight: bannerImageHeight ?? this.bannerImageHeight,
      isImage: isImage ?? this.isImage,
      bannerSvgPath: bannerSvgPath ?? this.bannerSvgPath,
      bannerSvgWidth: bannerSvgWidth ?? this.bannerSvgWidth,
      bannerSvgHeight: bannerSvgHeight ?? this.bannerSvgHeight,
      svgBannerColor: svgBannerColor ?? this.svgBannerColor,
    );
  }

  factory BannerStyle.defaults({required bool isDark}) {
    return BannerStyle(
      isImage: false,
      bannerSvgPath: AssetsPath.assets.surahSvgBanner,
      bannerSvgHeight: 30.0,
      bannerSvgWidth: 120.0,
      bannerImagePath: '',
      bannerImageHeight: 50,
      bannerImageWidth: double.infinity,
      svgBannerColor: null,
    );
  }

  factory BannerStyle.downloadFonts({required bool isDark}) {
    return BannerStyle(
      isImage: false,
      bannerSvgPath: isDark
          ? AssetsPath.assets.surahSvgBannerDark
          : AssetsPath.assets.surahSvgBanner,
      bannerSvgHeight: 30.0,
      bannerSvgWidth: 120.0,
      bannerImagePath: '',
      bannerImageHeight: 50,
      bannerImageWidth: double.infinity,
      svgBannerColor: null,
    );
  }

  factory BannerStyle.textScale({required bool isDark}) {
    return BannerStyle(
      isImage: false,
      bannerSvgPath: AssetsPath.assets.surahSvgBanner,
      bannerSvgHeight: 40.0,
      bannerSvgWidth: 150.0,
      bannerImagePath: '',
      bannerImageHeight: 50,
      bannerImageWidth: double.infinity,
      svgBannerColor: null,
    );
  }
}
