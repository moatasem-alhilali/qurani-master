class LastReadQuranInfoModel {
  LastReadQuranInfoModel({
    required this.page,
    required this.date,
    required this.surah,
  });

  factory LastReadQuranInfoModel.fromJson(Map<String, dynamic> json) =>
      LastReadQuranInfoModel(
        page: json['page'] as String,
        date: json['date'] as String,
        surah: json['surah'] as String,
      );
  final String page;
  final String date;
  final String surah;

  Map<String, dynamic> toJson() => {
        'page': page,
        'date': date,
        'surah': surah,
      };
}
