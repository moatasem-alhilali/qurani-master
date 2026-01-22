part of '/quran.dart';

const _english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
const _arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

/// Extension on the [String] class to provide additional utility methods.
extension StringExtensions on String {
  /// Inserts the given [text] at the specified [index] in the original string.
  ///
  /// This method returns a new string with the [text] inserted at the [index] position.
  ///
  /// Example:
  /// ```dart
  /// String original = "HelloWorld";
  /// String result = original.insert(" ", 5);
  /// print(result); // Outputs: "Hello World"
  /// ```
  ///
  /// Throws a [RangeError] if [index] is out of bounds.
  String insert(String text, int index) =>
      substring(0, index) + text + substring(index);

  /// Converts English numerals in the string to Arabic numerals.
  ///
  /// This method iterates through each English numeral and replaces it with
  /// the corresponding Arabic numeral.
  ///
  /// Example:
  ///
  /// ```dart
  /// String englishNumber = "123";
  /// String arabicNumber = englishNumber.toArabic();
  /// print(arabicNumber); // Output: "١٢٣"
  /// ```
  ///
  /// Returns:
  /// A new string with English numerals replaced by Arabic numerals.
  String toArabic() {
    String number = this;
    for (int i = 0; i < _english.length; i++) {
      number = number.replaceAll(_english[i], _arabic[i]);
    }
    return number;
  }
}
