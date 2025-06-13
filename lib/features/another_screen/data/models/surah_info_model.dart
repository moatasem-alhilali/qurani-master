class SurahInfoModel {
  SurahInfoModel({
    required this.id,
    required this.surah,
    required this.audio,
    required this.image,
    required this.ayaatiha,
    required this.maeniAsamuha,
    required this.sababTasmiatiha,
    required this.asmawuha,
    required this.maqsiduhaAleamu,
    required this.sababNuzuliha,
    required this.fadluha,
    required this.munasabatiha,
  });

  factory SurahInfoModel.fromJson(Map<String, dynamic> json) {
    return SurahInfoModel(
      id: json['id'] as int,
      surah: json['surah'] as String,
      audio: json['audio'] as String,
      image: json['image'] as String,
      ayaatiha: json['ayaatiha'] as String,
      maeniAsamuha: json['maeni_asamuha'] as String,
      sababTasmiatiha: json['sabab_tasmiatiha'] as String,
      asmawuha: json['asmawuha'] as String,
      maqsiduhaAleamu: json['maqsiduha_aleamu'] as String,
      sababNuzuliha: json['sabab_nuzuliha'] as String,
      fadluha: List<String>.from(json['fadluha'] as Iterable<dynamic>),
      munasabatiha:
          List<String>.from(json['munasabatiha'] as Iterable<dynamic>),
    );
  }
  final int id;
  final String surah;
  final String audio;
  final String image;
  final String ayaatiha;
  final String maeniAsamuha;
  final String sababTasmiatiha;
  final String asmawuha;
  final String maqsiduhaAleamu;
  final String sababNuzuliha;
  final List<String> fadluha;
  final List<String> munasabatiha;
}
