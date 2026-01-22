part of '/quran.dart';

class SajdaFontsModel {
  final int id;
  final bool recommended;
  final bool obligatory;

  SajdaFontsModel(
      {required this.id, required this.recommended, required this.obligatory});

// factory SajdaFontsModel._fromJson(Map<String, dynamic> json) {
//   return SajdaFontsModel(
//     id: json['id'],
//     recommended: json['recommended'],
//     obligatory: json['obligatory'] ??
//         false, // Assuming obligatory might not always be present
//   );
// }
}
