class ArabicNumbers {
 static String convert(number) {
    if (number is int) {
      String replace1 = number.toString().replaceAll('0', '٠');
      String replace2 = replace1.replaceAll('1', '١');
      String replace3 = replace2.replaceAll('2', '٢');
      String replace4 = replace3.replaceAll('3', '٣');
      String replace5 = replace4.replaceAll('4', '٤');
      String replace6 = replace5.replaceAll('5', '٥');
      String replace7 = replace6.replaceAll('6', '٦');
      String replace8 = replace7.replaceAll('7', '٧');
      String replace9 = replace8.replaceAll('8', '٨');
      String replace10 = replace9.replaceAll('9', '٩');
      return replace10;
    } else {
      String replace1 = number.replaceAll('0', '٠');
      String replace2 = replace1.replaceAll('1', '١');
      String replace3 = replace2.replaceAll('2', '٢');
      String replace4 = replace3.replaceAll('3', '٣');
      String replace5 = replace4.replaceAll('4', '٤');
      String replace6 = replace5.replaceAll('5', '٥');
      String replace7 = replace6.replaceAll('6', '٦');
      String replace8 = replace7.replaceAll('7', '٧');
      String replace9 = replace8.replaceAll('8', '٨');
      String replace10 = replace9.replaceAll('9', '٩');
      return replace10;
    }
  }
}
