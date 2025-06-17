class SubihModel {
  SubihModel({
    required this.title,
    required this.content,
    required this.createdAt,
    this.id,
    this.isCustom = false,
  });

  factory SubihModel.fromJson(Map<String, dynamic> json) => SubihModel(
        id: json['id'] as int?,
        title: json['title'] as String,
        content: json['content'] as String,
        isCustom: json['is_custom'] == 1,
        createdAt: DateTime.parse(
          json['created_at'] as String,
        ),
      );
  final int? id;
  final String title; // النص المختصر: مثل "سبحان الله"
  final String content; // الفضل أو الشرح
  final bool isCustom; // هل مضاف من المستخدم؟ (يُمكن حذفه وتعديله)
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'is_custom': isCustom ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  SubihModel copyWith({
    int? id,
    String? title,
    String? content,
    bool? isCustom,
    DateTime? createdAt,
  }) {
    return SubihModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SubihLogModel {
  SubihLogModel({
    required this.subihId,
    required this.timestamp,
    this.id,
  });

  factory SubihLogModel.fromJson(Map<String, dynamic> json) => SubihLogModel(
        id: json['id'] as int?,
        subihId: json['subih_id'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
  final int? id;
  final int subihId;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'id': id,
        'subih_id': subihId,
        'timestamp': timestamp.toIso8601String(),
      };
}

class SubihSummaryModel {
  SubihSummaryModel({
    required this.subihId,
    required this.date,
    required this.count,
    this.id,
  });

  factory SubihSummaryModel.fromJson(Map<String, dynamic> json) =>
      SubihSummaryModel(
        id: json['id'] as int?,
        subihId: json['subih_id'] as int,
        date: DateTime.parse(json['date'] as String),
        count: json['count'] as int,
      );
  final int? id;
  final int subihId;
  final DateTime date;
  final int count;

  Map<String, dynamic> toJson() => {
        'id': id,
        'subih_id': subihId,
        'date': date.toIso8601String(),
        'count': count,
      };
}

class SubihAnalytics {
  SubihAnalytics({
    required this.subih,
    required this.count,
  });
  final SubihModel subih;
  final int count;
}
