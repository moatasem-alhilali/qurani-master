class CurrentAudioModel {
  String? imageReader;
  String? nameReader;
  String? nameSurah;
  int? indexSurah;
  String? identifier;
  int? countSurahVerse;
  CurrentAudioModel({
    this.countSurahVerse,
    this.imageReader,
    this.nameReader,
    this.nameSurah,
    required this.identifier,
    required this.indexSurah,
  });
}
