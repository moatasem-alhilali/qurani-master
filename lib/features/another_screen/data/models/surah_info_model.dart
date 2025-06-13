class SurahInfoModel {
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
      id: json['id'],
      surah: json['surah'],
      audio: json['audio'],
      image: json['image'],
      ayaatiha: json['ayaatiha'],
      maeniAsamuha: json['maeni_asamuha'],
      sababTasmiatiha: json['sabab_tasmiatiha'],
      asmawuha: json['asmawuha'],
      maqsiduhaAleamu: json['maqsiduha_aleamu'],
      sababNuzuliha: json['sabab_nuzuliha'],
      fadluha: List<String>.from(json['fadluha']),
      munasabatiha: List<String>.from(json['munasabatiha']),
    );
  }
}
