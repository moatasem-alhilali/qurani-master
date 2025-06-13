class ArabicNumbers {
  static String convert(dynamic number) {
    if (number is int) {
      final replace1 = number.toString().replaceAll('0', '٠');
      final replace2 = replace1.replaceAll('1', '١');
      final replace3 = replace2.replaceAll('2', '٢');
      final replace4 = replace3.replaceAll('3', '٣');
      final replace5 = replace4.replaceAll('4', '٤');
      final replace6 = replace5.replaceAll('5', '٥');
      final replace7 = replace6.replaceAll('6', '٦');
      final replace8 = replace7.replaceAll('7', '٧');
      final replace9 = replace8.replaceAll('8', '٨');
      final replace10 = replace9.replaceAll('9', '٩');
      return replace10;
    } else {
      final replace1 = number.toString().replaceAll('0', '٠');
      final replace2 = replace1.replaceAll('1', '١');
      final replace3 = replace2.replaceAll('2', '٢');
      final replace4 = replace3.replaceAll('3', '٣');
      final replace5 = replace4.replaceAll('4', '٤');
      final replace6 = replace5.replaceAll('5', '٥');
      final replace7 = replace6.replaceAll('6', '٦');
      final replace8 = replace7.replaceAll('7', '٧');
      final replace9 = replace8.replaceAll('8', '٨');
      final replace10 = replace9.replaceAll('9', '٩');
      return replace10;
    }
  }
}
