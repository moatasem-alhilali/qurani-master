import 'package:equatable/equatable.dart';

enum YoungMuslimStatusFilter {
  all,
  completed,
  inProgress,
  favorites,
  watchLater,
}

class YoungMuslimFilters extends Equatable {
  const YoungMuslimFilters({
    this.categoryId,
    this.seriesId,
    this.language,
    this.contentType,
    this.status = YoungMuslimStatusFilter.all,
  });

  final String? categoryId;
  final String? seriesId;
  final String? language;
  final String? contentType;
  final YoungMuslimStatusFilter status;

  bool get hasActiveFilters =>
      categoryId != null ||
      seriesId != null ||
      language != null ||
      contentType != null ||
      status != YoungMuslimStatusFilter.all;

  YoungMuslimFilters copyWith({
    String? categoryId,
    String? seriesId,
    String? language,
    String? contentType,
    YoungMuslimStatusFilter? status,
    bool clearCategory = false,
    bool clearSeries = false,
    bool clearLanguage = false,
    bool clearContentType = false,
  }) {
    return YoungMuslimFilters(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      seriesId: clearSeries ? null : (seriesId ?? this.seriesId),
      language: clearLanguage ? null : (language ?? this.language),
      contentType: clearContentType ? null : (contentType ?? this.contentType),
      status: status ?? this.status,
    );
  }

  static const empty = YoungMuslimFilters();

  @override
  List<Object?> get props => [
        categoryId,
        seriesId,
        language,
        contentType,
        status,
      ];
}

class YoungMuslimCategoryEntity extends Equatable {
  const YoungMuslimCategoryEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.description,
    required this.bannerImage,
    required this.thumbnail,
    required this.sourceKey,
    required this.tags,
    required this.order,
    required this.audience,
    required this.language,
    required this.contentType,
    required this.seriesIds,
    required this.accentStart,
    required this.accentEnd,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final String description;
  final String bannerImage;
  final String thumbnail;
  final String sourceKey;
  final List<String> tags;
  final int order;
  final String audience;
  final String language;
  final String contentType;
  final List<String> seriesIds;
  final String accentStart;
  final String accentEnd;

  @override
  List<Object?> get props => [
        id,
        titleAr,
        titleEn,
        description,
        bannerImage,
        thumbnail,
        sourceKey,
        tags,
        order,
        audience,
        language,
        contentType,
        seriesIds,
        accentStart,
        accentEnd,
      ];
}

class YoungMuslimSeriesEntity extends Equatable {
  const YoungMuslimSeriesEntity({
    required this.id,
    required this.categoryId,
    required this.titleAr,
    required this.titleEn,
    required this.description,
    required this.bannerImage,
    required this.thumbnail,
    required this.fileName,
    required this.sourceKey,
    required this.tags,
    required this.order,
    required this.audience,
    required this.language,
    required this.contentType,
    required this.accentStart,
    required this.accentEnd,
    required this.playlistId,
    required this.playlistUrl,
    required this.totalVideos,
    required this.totalDurationSeconds,
    required this.isFeatured,
  });

  final String id;
  final String categoryId;
  final String titleAr;
  final String titleEn;
  final String description;
  final String bannerImage;
  final String thumbnail;
  final String fileName;
  final String sourceKey;
  final List<String> tags;
  final int order;
  final String audience;
  final String language;
  final String contentType;
  final String accentStart;
  final String accentEnd;
  final String playlistId;
  final String playlistUrl;
  final int totalVideos;
  final int totalDurationSeconds;
  final bool isFeatured;

  @override
  List<Object?> get props => [
        id,
        categoryId,
        titleAr,
        titleEn,
        description,
        bannerImage,
        thumbnail,
        fileName,
        sourceKey,
        tags,
        order,
        audience,
        language,
        contentType,
        accentStart,
        accentEnd,
        playlistId,
        playlistUrl,
        totalVideos,
        totalDurationSeconds,
        isFeatured,
      ];
}

class YoungMuslimVideoEntity extends Equatable {
  const YoungMuslimVideoEntity({
    required this.id,
    required this.youtubeVideoId,
    required this.categoryId,
    required this.seriesId,
    required this.title,
    required this.normalizedTitle,
    required this.titleSlug,
    required this.topicTitle,
    required this.topicSlug,
    required this.description,
    required this.thumbnailUrl,
    required this.youtubeUrl,
    required this.durationSeconds,
    required this.durationHuman,
    required this.episodeNumber,
    required this.partNumber,
    required this.viewCount,
    required this.language,
    required this.contentType,
    required this.isIntro,
    required this.isOutro,
    required this.isBehindTheScenes,
    required this.orderIndex,
    this.isFavorite = false,
    this.isWatchLater = false,
    this.positionSeconds = 0,
    this.progressPercent = 0,
    this.isCompleted = false,
    this.watchCount = 0,
    this.lastWatchedAt,
    this.completedAt,
  });

  final String id;
  final String youtubeVideoId;
  final String categoryId;
  final String seriesId;
  final String title;
  final String normalizedTitle;
  final String titleSlug;
  final String topicTitle;
  final String topicSlug;
  final String description;
  final String thumbnailUrl;
  final String youtubeUrl;
  final int durationSeconds;
  final String durationHuman;
  final int? episodeNumber;
  final int? partNumber;
  final int viewCount;
  final String language;
  final String contentType;
  final bool isIntro;
  final bool isOutro;
  final bool isBehindTheScenes;
  final int orderIndex;
  final bool isFavorite;
  final bool isWatchLater;
  final int positionSeconds;
  final double progressPercent;
  final bool isCompleted;
  final int watchCount;
  final DateTime? lastWatchedAt;
  final DateTime? completedAt;

  bool get hasProgress => positionSeconds > 0 && !isCompleted;

  int get remainingSeconds {
    if (durationSeconds <= 0) {
      return 0;
    }
    return durationSeconds > positionSeconds
        ? durationSeconds - positionSeconds
        : 0;
  }

  YoungMuslimVideoEntity copyWith({
    bool? isFavorite,
    bool? isWatchLater,
    int? positionSeconds,
    double? progressPercent,
    bool? isCompleted,
    int? watchCount,
    DateTime? lastWatchedAt,
    DateTime? completedAt,
  }) {
    return YoungMuslimVideoEntity(
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
      isFavorite: isFavorite ?? this.isFavorite,
      isWatchLater: isWatchLater ?? this.isWatchLater,
      positionSeconds: positionSeconds ?? this.positionSeconds,
      progressPercent: progressPercent ?? this.progressPercent,
      isCompleted: isCompleted ?? this.isCompleted,
      watchCount: watchCount ?? this.watchCount,
      lastWatchedAt: lastWatchedAt ?? this.lastWatchedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        youtubeVideoId,
        categoryId,
        seriesId,
        title,
        normalizedTitle,
        titleSlug,
        topicTitle,
        topicSlug,
        description,
        thumbnailUrl,
        youtubeUrl,
        durationSeconds,
        durationHuman,
        episodeNumber,
        partNumber,
        viewCount,
        language,
        contentType,
        isIntro,
        isOutro,
        isBehindTheScenes,
        orderIndex,
        isFavorite,
        isWatchLater,
        positionSeconds,
        progressPercent,
        isCompleted,
        watchCount,
        lastWatchedAt,
        completedAt,
      ];
}

class YoungMuslimQuizOptionEntity extends Equatable {
  const YoungMuslimQuizOptionEntity({
    required this.id,
    required this.text,
  });

  final String id;
  final String text;

  @override
  List<Object?> get props => [id, text];
}

class YoungMuslimQuizQuestionEntity extends Equatable {
  const YoungMuslimQuizQuestionEntity({
    required this.id,
    required this.type,
    required this.prompt,
    required this.options,
    required this.correctOptionId,
    required this.correctAnswerText,
    required this.explanation,
    required this.orderIndex,
  });

  final String id;
  final String type;
  final String prompt;
  final List<YoungMuslimQuizOptionEntity> options;
  final String? correctOptionId;
  final String correctAnswerText;
  final String explanation;
  final int orderIndex;

  @override
  List<Object?> get props => [
        id,
        type,
        prompt,
        options,
        correctOptionId,
        correctAnswerText,
        explanation,
        orderIndex,
      ];
}

class YoungMuslimQuizSetEntity extends Equatable {
  const YoungMuslimQuizSetEntity({
    required this.id,
    required this.categoryId,
    required this.seriesId,
    required this.videoId,
    required this.level,
    required this.title,
    required this.xpReward,
    required this.passingScore,
    required this.questions,
  });

  final String id;
  final String categoryId;
  final String seriesId;
  final String? videoId;
  final String level;
  final String title;
  final int xpReward;
  final int passingScore;
  final List<YoungMuslimQuizQuestionEntity> questions;

  bool get isSeriesLevel => level == 'series';

  @override
  List<Object?> get props => [
        id,
        categoryId,
        seriesId,
        videoId,
        level,
        title,
        xpReward,
        passingScore,
        questions,
      ];
}

class YoungMuslimAchievementEntity extends Equatable {
  const YoungMuslimAchievementEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.description,
    required this.type,
    required this.threshold,
    required this.xpReward,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final String description;
  final String type;
  final int threshold;
  final int xpReward;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  YoungMuslimAchievementEntity copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return YoungMuslimAchievementEntity(
      id: id,
      titleAr: titleAr,
      titleEn: titleEn,
      description: description,
      type: type,
      threshold: threshold,
      xpReward: xpReward,
      icon: icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleAr,
        titleEn,
        description,
        type,
        threshold,
        xpReward,
        icon,
        isUnlocked,
        unlockedAt,
      ];
}

class YoungMuslimRewardsSummaryEntity extends Equatable {
  const YoungMuslimRewardsSummaryEntity({
    required this.xp,
    required this.level,
    required this.completedVideos,
    required this.completedSeries,
    required this.correctAnswers,
    required this.watchLaterItems,
    required this.perfectQuizzes,
    required this.unlockedAchievements,
  });

  final int xp;
  final int level;
  final int completedVideos;
  final int completedSeries;
  final int correctAnswers;
  final int watchLaterItems;
  final int perfectQuizzes;
  final int unlockedAchievements;

  int get xpIntoCurrentLevel => xp - ((level - 1) * 100);
  int get nextLevelXpTarget => level * 100;

  @override
  List<Object?> get props => [
        xp,
        level,
        completedVideos,
        completedSeries,
        correctAnswers,
        watchLaterItems,
        perfectQuizzes,
        unlockedAchievements,
      ];
}

class YoungMuslimDashboardEntity extends Equatable {
  const YoungMuslimDashboardEntity({
    required this.categories,
    required this.series,
    required this.continueWatching,
    required this.recentlyWatched,
    required this.favorites,
    required this.watchLater,
    required this.suggestions,
    required this.searchResults,
    required this.rewardsSummary,
    required this.achievements,
  });

  final List<YoungMuslimCategoryEntity> categories;
  final List<YoungMuslimSeriesEntity> series;
  final List<YoungMuslimVideoEntity> continueWatching;
  final List<YoungMuslimVideoEntity> recentlyWatched;
  final List<YoungMuslimVideoEntity> favorites;
  final List<YoungMuslimVideoEntity> watchLater;
  final List<YoungMuslimVideoEntity> suggestions;
  final List<YoungMuslimVideoEntity> searchResults;
  final YoungMuslimRewardsSummaryEntity rewardsSummary;
  final List<YoungMuslimAchievementEntity> achievements;

  @override
  List<Object?> get props => [
        categories,
        series,
        continueWatching,
        recentlyWatched,
        favorites,
        watchLater,
        suggestions,
        searchResults,
        rewardsSummary,
        achievements,
      ];
}

class YoungMuslimCategoryDetailsEntity extends Equatable {
  const YoungMuslimCategoryDetailsEntity({
    required this.category,
    required this.series,
    required this.videos,
  });

  final YoungMuslimCategoryEntity category;
  final List<YoungMuslimSeriesEntity> series;
  final List<YoungMuslimVideoEntity> videos;

  @override
  List<Object?> get props => [category, series, videos];
}

class YoungMuslimVideoDetailsEntity extends Equatable {
  const YoungMuslimVideoDetailsEntity({
    required this.video,
    required this.category,
    required this.series,
    required this.similarVideos,
    required this.nextVideo,
    required this.videoQuiz,
    required this.seriesQuiz,
    required this.rewardsSummary,
    required this.achievements,
  });

  final YoungMuslimVideoEntity video;
  final YoungMuslimCategoryEntity category;
  final YoungMuslimSeriesEntity series;
  final List<YoungMuslimVideoEntity> similarVideos;
  final YoungMuslimVideoEntity? nextVideo;
  final YoungMuslimQuizSetEntity? videoQuiz;
  final YoungMuslimQuizSetEntity? seriesQuiz;
  final YoungMuslimRewardsSummaryEntity rewardsSummary;
  final List<YoungMuslimAchievementEntity> achievements;

  @override
  List<Object?> get props => [
        video,
        category,
        series,
        similarVideos,
        nextVideo,
        videoQuiz,
        seriesQuiz,
        rewardsSummary,
        achievements,
      ];
}

class YoungMuslimPlayerSessionEntity extends Equatable {
  const YoungMuslimPlayerSessionEntity({
    required this.video,
    required this.category,
    required this.series,
    required this.queue,
    required this.nextVideo,
    required this.resumeFromSeconds,
    required this.videoQuiz,
    required this.seriesQuiz,
  });

  final YoungMuslimVideoEntity video;
  final YoungMuslimCategoryEntity category;
  final YoungMuslimSeriesEntity series;
  final List<YoungMuslimVideoEntity> queue;
  final YoungMuslimVideoEntity? nextVideo;
  final int resumeFromSeconds;
  final YoungMuslimQuizSetEntity? videoQuiz;
  final YoungMuslimQuizSetEntity? seriesQuiz;

  @override
  List<Object?> get props => [
        video,
        category,
        series,
        queue,
        nextVideo,
        resumeFromSeconds,
        videoQuiz,
        seriesQuiz,
      ];
}

class YoungMuslimQuizAnswerReviewEntity extends Equatable {
  const YoungMuslimQuizAnswerReviewEntity({
    required this.question,
    required this.submittedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  final YoungMuslimQuizQuestionEntity question;
  final String submittedAnswer;
  final String correctAnswer;
  final bool isCorrect;

  @override
  List<Object?> get props => [
        question,
        submittedAnswer,
        correctAnswer,
        isCorrect,
      ];
}

class YoungMuslimQuizResultEntity extends Equatable {
  const YoungMuslimQuizResultEntity({
    required this.quizSet,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.awardedXp,
    required this.passed,
    required this.answerReviews,
    required this.newlyUnlockedAchievements,
    required this.rewardsSummary,
  });

  final YoungMuslimQuizSetEntity quizSet;
  final int correctAnswers;
  final int totalQuestions;
  final int awardedXp;
  final bool passed;
  final List<YoungMuslimQuizAnswerReviewEntity> answerReviews;
  final List<YoungMuslimAchievementEntity> newlyUnlockedAchievements;
  final YoungMuslimRewardsSummaryEntity rewardsSummary;

  double get scorePercent {
    if (totalQuestions == 0) {
      return 0;
    }
    return correctAnswers / totalQuestions;
  }

  @override
  List<Object?> get props => [
        quizSet,
        correctAnswers,
        totalQuestions,
        awardedXp,
        passed,
        answerReviews,
        newlyUnlockedAchievements,
        rewardsSummary,
      ];
}
