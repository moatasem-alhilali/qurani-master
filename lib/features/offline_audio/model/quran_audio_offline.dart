class QuranAudioModel {
  int? id;
  String? audio_path;
  String? count_verse;
  String? nameSurah;
  String? nameReader;
  String? imageReader;

  QuranAudioModel({
    this.id,
    this.nameReader,
    this.audio_path,
    this.count_verse,
    this.nameSurah,
    this.imageReader,
  });

  QuranAudioModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameSurah = json['nameSurah'];
    audio_path = json['audio_path'];
    count_verse = json['count_verse'];
    nameReader = json['nameReader'];
    imageReader = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameSurah': nameSurah,
      'audio_path': audio_path,
      'count_verse': count_verse,
      'nameReader': nameReader,
      'image': imageReader,
    };
  }
}
