part of '/quran.dart';

/// A widget that displays the Basmallah (بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ).
///
/// This widget is typically used at the beginning of a text or a section
/// to invoke the name of Allah, the Most Gracious, the Most Merciful.
class BasmallahWidget extends StatelessWidget {
  /// A widget that displays the Basmallah (In the name of Allah) image.
  ///
  /// The image displayed depends on the [surahNumber]. If the [surahNumber] is 95 or 97,
  /// a specific Basmallah image is shown. Otherwise, a default Basmallah image is displayed.
  ///
  /// The appearance of the Basmallah image can be customized using the [basmalaStyle].
  ///
  /// Example usage:
  ///
  /// ```dart
  /// BasmallahWidget(
  ///   surahNumber: 1,
  ///   basmalaStyle: BasmalaStyle(
  ///     basmalaWidth: 200,
  ///     basmalaHeight: 50,
  ///     basmalaColor: Colors.black,
  ///   ),
  /// )
  /// ```
  ///
  /// The [BasmalaStyle] class allows you to specify the width, height, and color of the Basmallah image.
  const BasmallahWidget({
    super.key,
    required this.surahNumber,
    this.basmalaStyle,
  });

  /// The number of the Surah (chapter) in the Quran.
  ///
  /// This is used to identify and reference a specific Surah.
  ///
  /// Example:
  /// ```dart
  /// final int surahNumber = 1; // Al-Fatiha
  /// ```
  final int surahNumber;

  /// The style to be applied to the Basmala text.
  ///
  /// This property allows you to customize the appearance of the Basmala text
  /// by providing a [BasmalaStyle] object. If no style is provided, the default
  /// style will be used.
  ///
  final BasmalaStyle? basmalaStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: basmalaStyle?.verticalPadding ?? 24.0),
      child: Center(
        child: Text(
          surahNumber == 2
              ? 'ﲚﲛﲞﲤ'
              : surahNumber == 95 || surahNumber == 97
                  ? 'ﭗﲫﲮﲴ'
                  : 'ﲪﲫﲮﲴ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'bismillah',
            fontSize: basmalaStyle?.basmalaFontSize ?? 50,
            height: 2,
            color: basmalaStyle?.basmalaColor ?? Colors.black,
            package: 'quran_library',
          ),
        ),
      ),
    );
  }
}
