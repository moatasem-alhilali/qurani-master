part of '/quran.dart';

/// Extension on `QuranCtrl` to provide additional functionality related to fonts download widget.
///
/// This extension adds methods and properties to the `QuranCtrl` class that are
/// specifically related to handling the fonts download widget in the application.
extension FontsDownloadWidgetExtension on QuranCtrl {
  /// A widget that displays the fonts download option.
  ///
  /// This widget provides a UI element for downloading fonts.
  ///
  /// [context] is the BuildContext in which the widget is built.
  ///
  /// Returns a Widget that represents the fonts download option.
  @Deprecated(
      'استخدم FontsDownloadWidget من presentation/widgets بدل هذا الـ extension.')
  Widget fontsDownloadWidget(BuildContext context,
      {DownloadFontsDialogStyle? downloadFontsDialogStyle,
      String? languageCode,
      bool isDark = false,
      bool? isFontsLocal = false}) {
    return FontsDownloadWidget(
      downloadFontsDialogStyle: downloadFontsDialogStyle,
      languageCode: languageCode,
      isDark: isDark,
      isFontsLocal: isFontsLocal ?? false,
      ctrl: this,
    );
  }
}
