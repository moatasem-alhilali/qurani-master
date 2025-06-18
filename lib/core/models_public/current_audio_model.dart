class CurrentQuranAudioModel {
  CurrentQuranAudioModel({
    required this.identifier,
    required this.indexSurah,
    this.countSurahVerse,
    this.imageReader,
    this.nameReader,
    this.nameSurah,
  });
  String? imageReader;
  String? nameReader;
  String? nameSurah;
  int? indexSurah;
  String? identifier;
  String? countSurahVerse;

  CurrentQuranAudioModel copyWith({
    String? imageReader,
    String? nameReader,
    String? nameSurah,
    int? indexSurah,
    String? identifier,
    String? countSurahVerse,
  }) {
    return CurrentQuranAudioModel(
      imageReader: imageReader ?? this.imageReader,
      nameReader: nameReader ?? this.nameReader,
      nameSurah: nameSurah ?? this.nameSurah,
      indexSurah: indexSurah ?? this.indexSurah,
      identifier: identifier ?? this.identifier,
      countSurahVerse: countSurahVerse ?? this.countSurahVerse,
    );
  }
}
