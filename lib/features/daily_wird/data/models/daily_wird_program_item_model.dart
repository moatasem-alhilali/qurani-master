import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_content_model.dart';

class DailyWirdItem extends Equatable {
  const DailyWirdItem({
    required this.id,
    required this.title,
    required this.type,
    required this.contentText,
    required this.countCompleted,
    required this.hasCounter,
    required this.hasAudio,
    required this.timeCategory,
    required this.isActive,
    required this.orderIndex,
    required this.createdAt,
    required this.contentEntries,
    this.countRequired,
    this.audioUrl,
    this.fadhl,
    this.source,
    this.countUnit,
  });

  factory DailyWirdItem.fromMap(Map<String, dynamic> map) {
    return DailyWirdItem(
      id: map['item_id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      type: map['type'] as String? ?? '',
      contentText: map['content_text'] as String? ?? '',
      countRequired: map['count_required'] as int?,
      countCompleted: (map['count_completed'] as int?) ?? 0,
      hasCounter: map['has_counter'] == 1,
      hasAudio: map['has_audio'] == 1,
      audioUrl: map['audio_url'] as String?,
      timeCategory: map['time_category'] as String? ?? 'anytime',
      isActive: map['is_active'] != 0,
      orderIndex: (map['order_index'] as int?) ?? 0,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.now(),
      contentEntries: DailyWirdContentEntry.decodeList(
        map['content_entries_json'] as String?,
      ),
      fadhl: map['fadhl'] as String?,
      source: map['source'] as String?,
      countUnit: map['count_unit'] as String?,
    );
  }

  final String id;
  final String title;
  final String type;
  final String contentText;
  final int? countRequired;
  final int countCompleted;
  final bool hasCounter;
  final bool hasAudio;
  final String? audioUrl;
  final String timeCategory;
  final bool isActive;
  final int orderIndex;
  final DateTime createdAt;
  final List<DailyWirdContentEntry> contentEntries;
  final String? fadhl;
  final String? source;
  final String? countUnit;

  bool get isCompleted {
    if (!isActive) {
      return true;
    }
    if (hasCounter) {
      return countRequired != null && countCompleted >= countRequired!;
    }
    return countCompleted > 0;
  }

  String get status => isCompleted ? 'completed' : 'not_completed';

  double get progress {
    if (!isActive) {
      return 1;
    }
    if (!hasCounter) {
      return isCompleted ? 1 : 0;
    }
    final required = countRequired ?? 0;
    if (required <= 0) {
      return 0;
    }
    return (countCompleted / required).clamp(0, 1).toDouble();
  }

  Map<String, dynamic> toMap(String programDate) => {
        'program_date': programDate,
        'item_id': id,
        'title': title,
        'type': type,
        'content_text': contentText,
        'count_required': countRequired,
        'count_completed': countCompleted,
        'has_counter': hasCounter ? 1 : 0,
        'has_audio': hasAudio ? 1 : 0,
        'audio_url': audioUrl,
        'time_category': timeCategory,
        'is_active': isActive ? 1 : 0,
        'order_index': orderIndex,
        'created_at': createdAt.toIso8601String(),
        'content_entries_json':
            DailyWirdContentEntry.encodeList(contentEntries),
        'fadhl': fadhl,
        'source': source,
        'count_unit': countUnit,
      };

  DailyWirdItem copyWith({
    String? id,
    String? title,
    String? type,
    String? contentText,
    int? countRequired,
    int? countCompleted,
    bool? hasCounter,
    bool? hasAudio,
    String? audioUrl,
    String? timeCategory,
    bool? isActive,
    int? orderIndex,
    DateTime? createdAt,
    List<DailyWirdContentEntry>? contentEntries,
    String? fadhl,
    String? source,
    String? countUnit,
    bool clearAudioUrl = false,
    bool clearFadhl = false,
    bool clearSource = false,
    bool clearCountUnit = false,
  }) {
    return DailyWirdItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      contentText: contentText ?? this.contentText,
      countRequired: countRequired ?? this.countRequired,
      countCompleted: countCompleted ?? this.countCompleted,
      hasCounter: hasCounter ?? this.hasCounter,
      hasAudio: hasAudio ?? this.hasAudio,
      audioUrl: clearAudioUrl ? null : audioUrl ?? this.audioUrl,
      timeCategory: timeCategory ?? this.timeCategory,
      isActive: isActive ?? this.isActive,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      contentEntries: contentEntries ?? this.contentEntries,
      fadhl: clearFadhl ? null : fadhl ?? this.fadhl,
      source: clearSource ? null : source ?? this.source,
      countUnit: clearCountUnit ? null : countUnit ?? this.countUnit,
    );
  }

  static String encodeList(List<DailyWirdItem> items) {
    return jsonEncode(items.map((item) => item.id).toList());
  }

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        contentText,
        countRequired,
        countCompleted,
        hasCounter,
        hasAudio,
        audioUrl,
        timeCategory,
        isActive,
        orderIndex,
        createdAt,
        contentEntries,
        fadhl,
        source,
        countUnit,
      ];
}
