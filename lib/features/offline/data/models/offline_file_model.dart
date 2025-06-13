class OfflineFileModel {
  final int? id; // optional, for DB use
  final String path;
  final String type;
  final String title;
  final String url;
  final String description;
  final String time;

  OfflineFileModel({
    this.id,
    required this.path,
    required this.type,
    required this.title,
    required this.url,
    required this.description,
    required this.time,
  });

  /// Creates an instance from a map (e.g., from database)
  factory OfflineFileModel.fromJson(Map<String, dynamic> json) {
    return OfflineFileModel(
      id: json['id'],
      path: json['path'],
      type: json['type'],
      title: json['title'],
      url: json['url'],
      description: json['description'],
      time: json['time'],
    );
  }

  /// Converts instance to a map (e.g., for inserting into database)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'path': path,
      'type': type,
      'title': title,
      'url': url,
      'description': description,
      'time': time,
    };
  }
}
