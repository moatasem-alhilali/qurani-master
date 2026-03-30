import 'dart:convert';

import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';

List<String> _decodeStringList(dynamic value) {
  if (value == null) {
    return const [];
  }
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }
  if (value is String && value.isNotEmpty) {
    final decoded = jsonDecode(value);
    if (decoded is List) {
      return decoded.map((item) => item.toString()).toList();
    }
  }
  return const [];
}

String _encodeStringList(List<String> value) => jsonEncode(value);

DateTime? _parseDate(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

class YoungMuslimCategoryModel extends YoungMuslimCategoryEntity {
  const YoungMuslimCategoryModel({
    required super.id,
    required super.titleAr,
    required super.titleEn,
    required super.description,
    required super.bannerImage,
    required super.thumbnail,
    required super.sourceKey,
    required super.tags,
    required super.order,
    required super.audience,
    required super.language,
    required super.contentType,
    required super.seriesIds,
    required super.accentStart,
    required super.accentEnd,
  });

  factory YoungMuslimCategoryModel.fromJson(Map<String, dynamic> json) {
    return YoungMuslimCategoryModel(
      id: json['id'] as String,
      titleAr: (json['title_ar'] ?? '') as String,
      titleEn: (json['title_en'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      bannerImage: (json['banner_image'] ?? '') as String,
      thumbnail: (json['thumbnail'] ?? '') as String,
      sourceKey: (json['source_key'] ?? '') as String,
      tags: _decodeStringList(json['tags']),
      order: (json['order'] as num?)?.toInt() ?? 0,
      audience: (json['audience'] ?? 'kids') as String,
      language: (json['language'] ?? 'ar') as String,
      contentType: (json['content_type'] ?? 'story_series') as String,
      seriesIds: _decodeStringList(json['series_ids']),
      accentStart: (json['accent_start'] ?? '#39A96B') as String,
      accentEnd: (json['accent_end'] ?? '#8FE388') as String,
    );
  }

  factory YoungMuslimCategoryModel.fromDb(Map<String, dynamic> json) {
    return YoungMuslimCategoryModel(
      id: json['id'] as String,
      titleAr: (json['title_ar'] ?? '') as String,
      titleEn: (json['title_en'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      bannerImage: (json['banner_image'] ?? '') as String,
      thumbnail: (json['thumbnail'] ?? '') as String,
      sourceKey: (json['source_key'] ?? '') as String,
      tags: _decodeStringList(json['tags_json']),
      order: (json['sort_order'] as num?)?.toInt() ?? 0,
      audience: (json['audience'] ?? 'kids') as String,
      language: (json['language'] ?? 'ar') as String,
      contentType: (json['content_type'] ?? 'story_series') as String,
      seriesIds: _decodeStringList(json['series_ids_json']),
      accentStart: (json['accent_start'] ?? '#39A96B') as String,
      accentEnd: (json['accent_end'] ?? '#8FE388') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title_ar': titleAr,
      'title_en': titleEn,
      'description': description,
      'banner_image': bannerImage,
      'thumbnail': thumbnail,
      'source_key': sourceKey,
      'tags_json': _encodeStringList(tags),
      'sort_order': order,
      'audience': audience,
      'language': language,
      'content_type': contentType,
      'series_ids_json': _encodeStringList(seriesIds),
      'accent_start': accentStart,
      'accent_end': accentEnd,
    };
  }
}

class YoungMuslimSeriesModel extends YoungMuslimSeriesEntity {
  const YoungMuslimSeriesModel({
    required super.id,
    required super.categoryId,
    required super.titleAr,
    required super.titleEn,
    required super.description,
    required super.bannerImage,
    required super.thumbnail,
    required super.fileName,
    required super.sourceKey,
    required super.tags,
    required super.order,
    required super.audience,
    required super.language,
    required super.contentType,
    required super.accentStart,
    required super.accentEnd,
    required super.playlistId,
    required super.playlistUrl,
    required super.totalVideos,
    required super.totalDurationSeconds,
    required super.isFeatured,
  });

  factory YoungMuslimSeriesModel.fromJson(Map<String, dynamic> json) {
    return YoungMuslimSeriesModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      titleAr: (json['title_ar'] ?? '') as String,
      titleEn: (json['title_en'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      bannerImage: (json['banner_image'] ?? '') as String,
      thumbnail: (json['thumbnail'] ?? '') as String,
      fileName: (json['file_name'] ?? '') as String,
      sourceKey: (json['source_key'] ?? '') as String,
      tags: _decodeStringList(json['tags']),
      order: (json['order'] as num?)?.toInt() ?? 0,
      audience: (json['audience'] ?? 'kids') as String,
      language: (json['language'] ?? 'ar') as String,
      contentType: (json['content_type'] ?? 'story_series') as String,
      accentStart: (json['accent_start'] ?? '#39A96B') as String,
      accentEnd: (json['accent_end'] ?? '#8FE388') as String,
      playlistId: (json['playlist_id'] ?? '') as String,
      playlistUrl: (json['playlist_url'] ?? '') as String,
      totalVideos: (json['total_videos'] as num?)?.toInt() ?? 0,
      totalDurationSeconds:
          (json['total_duration_seconds'] as num?)?.toInt() ?? 0,
      isFeatured: (json['is_featured'] ?? false) as bool,
    );
  }

  factory YoungMuslimSeriesModel.fromDb(Map<String, dynamic> json) {
    return YoungMuslimSeriesModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      titleAr: (json['title_ar'] ?? '') as String,
      titleEn: (json['title_en'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      bannerImage: (json['banner_image'] ?? '') as String,
      thumbnail: (json['thumbnail'] ?? '') as String,
      fileName: (json['file_name'] ?? '') as String,
      sourceKey: (json['source_key'] ?? '') as String,
      tags: _decodeStringList(json['tags_json']),
      order: (json['sort_order'] as num?)?.toInt() ?? 0,
      audience: (json['audience'] ?? 'kids') as String,
      language: (json['language'] ?? 'ar') as String,
      contentType: (json['content_type'] ?? 'story_series') as String,
      accentStart: (json['accent_start'] ?? '#39A96B') as String,
      accentEnd: (json['accent_end'] ?? '#8FE388') as String,
      playlistId: (json['playlist_id'] ?? '') as String,
      playlistUrl: (json['playlist_url'] ?? '') as String,
      totalVideos: (json['total_videos'] as num?)?.toInt() ?? 0,
      totalDurationSeconds:
          (json['total_duration_seconds'] as num?)?.toInt() ?? 0,
      isFeatured: (json['is_featured'] == 1 || json['is_featured'] == true),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'title_ar': titleAr,
      'title_en': titleEn,
      'description': description,
      'banner_image': bannerImage,
      'thumbnail': thumbnail,
      'file_name': fileName,
      'source_key': sourceKey,
      'tags_json': _encodeStringList(tags),
      'sort_order': order,
      'audience': audience,
      'language': language,
      'content_type': contentType,
      'accent_start': accentStart,
      'accent_end': accentEnd,
      'playlist_id': playlistId,
      'playlist_url': playlistUrl,
      'total_videos': totalVideos,
      'total_duration_seconds': totalDurationSeconds,
      'is_featured': isFeatured ? 1 : 0,
    };
  }
}

class YoungMuslimVideoModel extends YoungMuslimVideoEntity {
  const YoungMuslimVideoModel({
    required super.id,
    required super.youtubeVideoId,
    required super.categoryId,
    required super.seriesId,
    required super.title,
    required super.normalizedTitle,
    required super.titleSlug,
    required super.topicTitle,
    required super.topicSlug,
    required super.description,
    required super.thumbnailUrl,
    required super.youtubeUrl,
    required super.durationSeconds,
    required super.durationHuman,
    required super.episodeNumber,
    required super.partNumber,
    required super.viewCount,
    required super.language,
    required super.contentType,
    required super.isIntro,
    required super.isOutro,
    required super.isBehindTheScenes,
    required super.orderIndex,
    super.isFavorite,
    super.isWatchLater,
    super.positionSeconds,
    super.progressPercent,
    super.isCompleted,
    super.watchCount,
    super.lastWatchedAt,
    super.completedAt,
  });

  factory YoungMuslimVideoModel.fromAssetJson(Map<String, dynamic> json) {
    return YoungMuslimVideoModel(
      id: json['video_key'] as String,
      youtubeVideoId: json['id'] as String,
      categoryId: json['category_id'] as String,
      seriesId: json['series_id'] as String,
      title: (json['title'] ?? '') as String,
      normalizedTitle: (json['normalized_title'] ?? '') as String,
      titleSlug: (json['title_slug'] ?? '') as String,
      topicTitle: (json['topic_title'] ?? '') as String,
      topicSlug: (json['topic_slug'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      thumbnailUrl: (json['thumbnail'] ?? '') as String,
      youtubeUrl: (json['url'] ?? '') as String,
      durationSeconds: (json['duration'] as num?)?.toInt() ?? 0,
      durationHuman: (json['duration_human'] ?? '') as String,
      episodeNumber: (json['episode_number'] as num?)?.toInt(),
      partNumber: (json['part_number'] as num?)?.toInt(),
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      language: (json['language'] ?? 'ar') as String,
      contentType: (json['content_type'] ?? 'story_series') as String,
      isIntro: (json['is_intro'] ?? false) as bool,
      isOutro: (json['is_outro'] ?? false) as bool,
      isBehindTheScenes: (json['is_bts'] ?? false) as bool,
      orderIndex: (json['index'] as num?)?.toInt() ?? 0,
    );
  }

  factory YoungMuslimVideoModel.fromDb(Map<String, dynamic> json) {
    return YoungMuslimVideoModel(
      id: json['id'] as String,
      youtubeVideoId: json['youtube_video_id'] as String,
      categoryId: json['category_id'] as String,
      seriesId: json['series_id'] as String,
      title: (json['title'] ?? '') as String,
      normalizedTitle: (json['normalized_title'] ?? '') as String,
      titleSlug: (json['title_slug'] ?? '') as String,
      topicTitle: (json['topic_title'] ?? '') as String,
      topicSlug: (json['topic_slug'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      thumbnailUrl: (json['thumbnail'] ?? '') as String,
      youtubeUrl: (json['youtube_url'] ?? '') as String,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt() ?? 0,
      durationHuman: (json['duration_human'] ?? '') as String,
      episodeNumber: (json['episode_number'] as num?)?.toInt(),
      partNumber: (json['part_number'] as num?)?.toInt(),
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      language: (json['language'] ?? 'ar') as String,
      contentType: (json['content_type'] ?? 'story_series') as String,
      isIntro: json['is_intro'] == 1 || json['is_intro'] == true,
      isOutro: json['is_outro'] == 1 || json['is_outro'] == true,
      isBehindTheScenes: json['is_bts'] == 1 || json['is_bts'] == true,
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true,
      isWatchLater:
          json['is_watch_later'] == 1 || json['is_watch_later'] == true,
      positionSeconds: (json['position_seconds'] as num?)?.toInt() ?? 0,
      progressPercent: (json['progress_percent'] as num?)?.toDouble() ?? 0,
      isCompleted: json['is_completed'] == 1 || json['is_completed'] == true,
      watchCount: (json['watch_count'] as num?)?.toInt() ?? 0,
      lastWatchedAt: _parseDate(json['last_watched_at']),
      completedAt: _parseDate(json['completed_at']),
    );
  }

  YoungMuslimVideoModel mergeUserState({
    bool isFavorite = false,
    bool isWatchLater = false,
    int positionSeconds = 0,
    double progressPercent = 0,
    bool isCompleted = false,
    int watchCount = 0,
    DateTime? lastWatchedAt,
    DateTime? completedAt,
  }) {
    return YoungMuslimVideoModel(
      id: id,
      youtubeVideoId: youtubeVideoId,
      categoryId: categoryId,
      seriesId: seriesId,
      title: title,
      normalizedTitle: normalizedTitle,
      titleSlug: titleSlug,
      topicTitle: topicTitle,
      topicSlug: topicSlug,
      description: description,
      thumbnailUrl: thumbnailUrl,
      youtubeUrl: youtubeUrl,
      durationSeconds: durationSeconds,
      durationHuman: durationHuman,
      episodeNumber: episodeNumber,
      partNumber: partNumber,
      viewCount: viewCount,
      language: language,
      contentType: contentType,
      isIntro: isIntro,
      isOutro: isOutro,
      isBehindTheScenes: isBehindTheScenes,
      orderIndex: orderIndex,
      isFavorite: isFavorite,
      isWatchLater: isWatchLater,
      positionSeconds: positionSeconds,
      progressPercent: progressPercent,
      isCompleted: isCompleted,
      watchCount: watchCount,
      lastWatchedAt: lastWatchedAt,
      completedAt: completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'youtube_video_id': youtubeVideoId,
      'category_id': categoryId,
      'series_id': seriesId,
      'title': title,
      'normalized_title': normalizedTitle,
      'title_slug': titleSlug,
      'topic_title': topicTitle,
      'topic_slug': topicSlug,
      'description': description,
      'thumbnail': thumbnailUrl,
      'youtube_url': youtubeUrl,
      'duration_seconds': durationSeconds,
      'duration_human': durationHuman,
      'episode_number': episodeNumber,
      'part_number': partNumber,
      'view_count': viewCount,
      'language': language,
      'content_type': contentType,
      'is_intro': isIntro ? 1 : 0,
      'is_outro': isOutro ? 1 : 0,
      'is_bts': isBehindTheScenes ? 1 : 0,
      'order_index': orderIndex,
      'searchable_text':
          '$title $normalizedTitle $topicTitle $description $language $contentType',
    };
  }
}

class YoungMuslimQuizOptionModel extends YoungMuslimQuizOptionEntity {
  const YoungMuslimQuizOptionModel({
    required super.id,
    required super.text,
  });

  factory YoungMuslimQuizOptionModel.fromJson(Map<String, dynamic> json) {
    return YoungMuslimQuizOptionModel(
      id: (json['id'] ?? '') as String,
      text: (json['text'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}

class YoungMuslimQuizQuestionModel extends YoungMuslimQuizQuestionEntity {
  const YoungMuslimQuizQuestionModel({
    required super.id,
    required super.type,
    required super.prompt,
    required super.options,
    required super.correctOptionId,
    required super.correctAnswerText,
    required super.explanation,
    required super.orderIndex,
  });

  factory YoungMuslimQuizQuestionModel.fromJson(
    Map<String, dynamic> json, {
    required int orderIndex,
  }) {
    return YoungMuslimQuizQuestionModel(
      id: json['id'] as String,
      type: (json['type'] ?? 'multiple_choice') as String,
      prompt: (json['prompt'] ?? '') as String,
      options: (json['options'] as List<dynamic>? ?? const [])
          .map(
            (option) => YoungMuslimQuizOptionModel.fromJson(
              option as Map<String, dynamic>,
            ),
          )
          .toList(),
      correctOptionId: json['correct_option_id'] as String?,
      correctAnswerText: (json['correct_answer_text'] ?? '') as String,
      explanation: (json['explanation'] ?? '') as String,
      orderIndex: orderIndex,
    );
  }

  factory YoungMuslimQuizQuestionModel.fromDb(Map<String, dynamic> json) {
    final rawOptions = json['options_json'] as String? ?? '[]';
    final decodedOptions = (jsonDecode(rawOptions) as List<dynamic>)
        .map(
          (item) => YoungMuslimQuizOptionModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();

    return YoungMuslimQuizQuestionModel(
      id: json['id'] as String,
      type: (json['type'] ?? 'multiple_choice') as String,
      prompt: (json['prompt'] ?? '') as String,
      options: decodedOptions,
      correctOptionId: json['correct_option_id'] as String?,
      correctAnswerText: (json['correct_answer_text'] ?? '') as String,
      explanation: (json['explanation'] ?? '') as String,
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap(String quizId) {
    return {
      'id': id,
      'quiz_id': quizId,
      'type': type,
      'prompt': prompt,
      'options_json': jsonEncode(
        options
            .map(
              (option) => (option as YoungMuslimQuizOptionModel).toJson(),
            )
            .toList(),
      ),
      'correct_option_id': correctOptionId,
      'correct_answer_text': correctAnswerText,
      'explanation': explanation,
      'order_index': orderIndex,
    };
  }
}

class YoungMuslimQuizSetModel extends YoungMuslimQuizSetEntity {
  const YoungMuslimQuizSetModel({
    required super.id,
    required super.categoryId,
    required super.seriesId,
    required super.videoId,
    required super.level,
    required super.title,
    required super.xpReward,
    required super.passingScore,
    required super.questions,
  });

  factory YoungMuslimQuizSetModel.fromJson(Map<String, dynamic> json) {
    final questions = (json['questions'] as List<dynamic>? ?? const [])
        .asMap()
        .entries
        .map(
          (entry) => YoungMuslimQuizQuestionModel.fromJson(
            entry.value as Map<String, dynamic>,
            orderIndex: entry.key,
          ),
        )
        .toList();

    return YoungMuslimQuizSetModel(
      id: json['id'] as String,
      categoryId: (json['category_id'] ?? '') as String,
      seriesId: (json['series_id'] ?? '') as String,
      videoId: json['video_id'] as String?,
      level: (json['level'] ?? 'video') as String,
      title: (json['title'] ?? '') as String,
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
      passingScore: (json['passing_score'] as num?)?.toInt() ?? 0,
      questions: questions,
    );
  }

  factory YoungMuslimQuizSetModel.fromDb(
    Map<String, dynamic> json,
    List<YoungMuslimQuizQuestionModel> questions,
  ) {
    return YoungMuslimQuizSetModel(
      id: json['id'] as String,
      categoryId: (json['category_id'] ?? '') as String,
      seriesId: (json['series_id'] ?? '') as String,
      videoId: json['video_id'] as String?,
      level: (json['level'] ?? 'video') as String,
      title: (json['title'] ?? '') as String,
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
      passingScore: (json['passing_score'] as num?)?.toInt() ?? 0,
      questions: questions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'series_id': seriesId,
      'video_id': videoId,
      'level': level,
      'title': title,
      'xp_reward': xpReward,
      'passing_score': passingScore,
    };
  }
}

class YoungMuslimAchievementModel extends YoungMuslimAchievementEntity {
  const YoungMuslimAchievementModel({
    required super.id,
    required super.titleAr,
    required super.titleEn,
    required super.description,
    required super.type,
    required super.threshold,
    required super.xpReward,
    required super.icon,
    super.isUnlocked,
    super.unlockedAt,
  });

  factory YoungMuslimAchievementModel.fromJson(Map<String, dynamic> json) {
    return YoungMuslimAchievementModel(
      id: json['id'] as String,
      titleAr: (json['title_ar'] ?? '') as String,
      titleEn: (json['title_en'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      type: (json['type'] ?? '') as String,
      threshold: (json['threshold'] as num?)?.toInt() ?? 0,
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
      icon: (json['icon'] ?? 'emoji_events') as String,
    );
  }

  factory YoungMuslimAchievementModel.fromDb(Map<String, dynamic> json) {
    return YoungMuslimAchievementModel(
      id: json['id'] as String,
      titleAr: (json['title_ar'] ?? '') as String,
      titleEn: (json['title_en'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      type: (json['type'] ?? '') as String,
      threshold: (json['threshold'] as num?)?.toInt() ?? 0,
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
      icon: (json['icon'] ?? 'emoji_events') as String,
      isUnlocked: json['is_unlocked'] == 1 || json['is_unlocked'] == true,
      unlockedAt: _parseDate(json['unlocked_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title_ar': titleAr,
      'title_en': titleEn,
      'description': description,
      'type': type,
      'threshold': threshold,
      'xp_reward': xpReward,
      'icon': icon,
    };
  }
}

class YoungMuslimRewardsSummaryModel extends YoungMuslimRewardsSummaryEntity {
  const YoungMuslimRewardsSummaryModel({
    required super.xp,
    required super.level,
    required super.completedVideos,
    required super.completedSeries,
    required super.correctAnswers,
    required super.watchLaterItems,
    required super.perfectQuizzes,
    required super.unlockedAchievements,
  });

  factory YoungMuslimRewardsSummaryModel.fromDb(Map<String, dynamic> json) {
    return YoungMuslimRewardsSummaryModel(
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      completedVideos: (json['completed_videos'] as num?)?.toInt() ?? 0,
      completedSeries: (json['completed_series'] as num?)?.toInt() ?? 0,
      correctAnswers: (json['correct_answers'] as num?)?.toInt() ?? 0,
      watchLaterItems: (json['watch_later_items'] as num?)?.toInt() ?? 0,
      perfectQuizzes: (json['perfect_quizzes'] as num?)?.toInt() ?? 0,
      unlockedAchievements:
          (json['unlocked_achievements'] as num?)?.toInt() ?? 0,
    );
  }

  factory YoungMuslimRewardsSummaryModel.initial() {
    return const YoungMuslimRewardsSummaryModel(
      xp: 0,
      level: 1,
      completedVideos: 0,
      completedSeries: 0,
      correctAnswers: 0,
      watchLaterItems: 0,
      perfectQuizzes: 0,
      unlockedAchievements: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'summary_id': 1,
      'xp': xp,
      'level': level,
      'completed_videos': completedVideos,
      'completed_series': completedSeries,
      'correct_answers': correctAnswers,
      'watch_later_items': watchLaterItems,
      'perfect_quizzes': perfectQuizzes,
      'unlocked_achievements': unlockedAchievements,
      'last_updated_at': DateTime.now().toIso8601String(),
    };
  }
}

class YoungMuslimRewardRuleModel {
  const YoungMuslimRewardRuleModel({
    required this.key,
    required this.value,
  });

  final String key;
  final int value;

  factory YoungMuslimRewardRuleModel.fromJson(
    MapEntry<String, dynamic> entry,
  ) {
    return YoungMuslimRewardRuleModel(
      key: entry.key,
      value: (entry.value as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rule_key': key,
      'value': value,
    };
  }
}
