import 'package:quran_app/core/local_database/database_service.dart';
import 'package:quran_app/features/young_muslim/data/data_sources/young_muslim_asset_data_source.dart';
import 'package:quran_app/features/young_muslim/data/models/young_muslim_models.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:sqflite/sqflite.dart';

DateTime? _localParseDate(dynamic value) {
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

String _normalizeQuizAnswer(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F\u06D6-\u06ED]'), '')
      .replaceAll(RegExp(r'[^a-z0-9\u0600-\u06FF\s]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

bool _matchesDirectAnswer(String answer, String correctAnswer) {
  final normalizedAnswer = _normalizeQuizAnswer(answer);
  final normalizedCorrect = _normalizeQuizAnswer(correctAnswer);

  if (normalizedAnswer.isEmpty || normalizedCorrect.isEmpty) {
    return false;
  }

  return normalizedAnswer == normalizedCorrect ||
      normalizedAnswer.contains(normalizedCorrect) ||
      normalizedCorrect.contains(normalizedAnswer);
}

class YoungMuslimTables {
  static const seedState = 'ym_seed_state';
  static const categories = 'ym_categories';
  static const series = 'ym_series';
  static const videos = 'ym_videos';
  static const videoProgress = 'ym_video_progress';
  static const recentViews = 'ym_recent_views';
  static const favorites = 'ym_favorites';
  static const watchLater = 'ym_watch_later';
  static const quizSets = 'ym_quiz_sets';
  static const quizQuestions = 'ym_quiz_questions';
  static const quizAttempts = 'ym_quiz_attempts';
  static const rewards = 'ym_rewards';
  static const achievements = 'ym_achievements';
  static const unlockedAchievements = 'ym_unlocked_achievements';
  static const relatedVideos = 'ym_related_videos';
  static const rewardRules = 'ym_reward_rules';
}

class YoungMuslimLocalDataSource {
  YoungMuslimLocalDataSource({
    DatabaseService? databaseService,
  }) : _databaseService = databaseService ?? DatabaseService();

  final DatabaseService _databaseService;

  Future<Database> get _db async => _databaseService.database;

  Future<void> ensureInitialized(YoungMuslimSeedBundle bundle) async {
    await _ensureSchema();
    final database = await _db;
    final currentVersion = await _getSeedVersion(database);
    final hasCategories = Sqflite.firstIntValue(
          await database.rawQuery(
            'SELECT COUNT(*) FROM ${YoungMuslimTables.categories}',
          ),
        ) !=
        0;

    if (currentVersion == bundle.version && hasCategories) {
      await _ensureRewardsSummaryRow();
      await _rebuildRewardsSummary();
      return;
    }

    await database.transaction((txn) async {
      await txn.delete(YoungMuslimTables.relatedVideos);
      await txn.delete(YoungMuslimTables.quizQuestions);
      await txn.delete(YoungMuslimTables.quizSets);
      await txn.delete(YoungMuslimTables.videos);
      await txn.delete(YoungMuslimTables.series);
      await txn.delete(YoungMuslimTables.categories);
      await txn.delete(YoungMuslimTables.achievements);
      await txn.delete(YoungMuslimTables.rewardRules);

      for (final category in bundle.categories) {
        await txn.insert(
          YoungMuslimTables.categories,
          category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      for (final series in bundle.series) {
        await txn.insert(
          YoungMuslimTables.series,
          series.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      for (final video in bundle.videos) {
        await txn.insert(
          YoungMuslimTables.videos,
          video.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      for (final quizSet in bundle.quizSets) {
        await txn.insert(
          YoungMuslimTables.quizSets,
          quizSet.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        for (final question in quizSet.questions) {
          await txn.insert(
            YoungMuslimTables.quizQuestions,
            (question as YoungMuslimQuizQuestionModel).toMap(quizSet.id),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }

      for (final achievement in bundle.achievements) {
        await txn.insert(
          YoungMuslimTables.achievements,
          achievement.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      for (final rule in bundle.rewardRules) {
        await txn.insert(
          YoungMuslimTables.rewardRules,
          rule.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await txn.insert(
        YoungMuslimTables.seedState,
        {
          'seed_key': 'catalog_version',
          'seed_value': bundle.version.toString(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await _rebuildRelatedVideos();
    await _ensureRewardsSummaryRow();
    await _rebuildRewardsSummary();
  }

  Future<YoungMuslimDashboardEntity> getDashboard({
    String query = '',
    YoungMuslimFilters filters = YoungMuslimFilters.empty,
  }) async {
    final library = await _loadLibrary();
    final categories = library.categories.values.toList()
      ..sort((first, second) => first.order.compareTo(second.order));
    final series = library.series.values.toList()
      ..sort((first, second) => first.order.compareTo(second.order));
    final filtered = _applyFilters(
      library.videos,
      query,
      filters,
      library.categories,
      library.series,
    );

    final continueWatching = library.videos
        .where((video) => video.hasProgress)
        .toList()
      ..sort(
        (first, second) => (second.lastWatchedAt ?? DateTime(1970)).compareTo(
          first.lastWatchedAt ?? DateTime(1970),
        ),
      );

    final recentlyWatched = library.videos
        .where((video) => video.lastWatchedAt != null)
        .toList()
      ..sort(
        (first, second) => (second.lastWatchedAt ?? DateTime(1970)).compareTo(
          first.lastWatchedAt ?? DateTime(1970),
        ),
      );

    final favorites = library.videos.where((video) => video.isFavorite).toList()
      ..sort((first, second) => second.viewCount.compareTo(first.viewCount));

    final watchLater = library.videos
        .where((video) => video.isWatchLater)
        .toList()
      ..sort((first, second) => second.viewCount.compareTo(first.viewCount));

    final suggestions = _buildSuggestions(library.videos, recentlyWatched);

    return YoungMuslimDashboardEntity(
      categories: categories,
      series: series,
      continueWatching: continueWatching.take(12).toList(),
      recentlyWatched: recentlyWatched.take(12).toList(),
      favorites: favorites.take(12).toList(),
      watchLater: watchLater.take(12).toList(),
      suggestions: suggestions.take(18).toList(),
      searchResults: filtered.take(40).toList(),
      rewardsSummary: library.rewardsSummary,
      achievements: library.achievements,
    );
  }

  Future<YoungMuslimCategoryDetailsEntity> getCategoryDetails(
    String categoryId, {
    String query = '',
    YoungMuslimFilters filters = YoungMuslimFilters.empty,
  }) async {
    final library = await _loadLibrary();
    final category = library.categories[categoryId]!;
    final categorySeries = library.series.values
        .where((item) => item.categoryId == categoryId)
        .toList()
      ..sort((first, second) => first.order.compareTo(second.order));
    final categoryVideos = _applyFilters(
      library.videos.where((video) => video.categoryId == categoryId).toList(),
      query,
      filters.copyWith(categoryId: categoryId),
      library.categories,
      library.series,
    )..sort((first, second) {
        if (first.seriesId == second.seriesId) {
          return first.orderIndex.compareTo(second.orderIndex);
        }
        final firstSeries = library.series[first.seriesId]!;
        final secondSeries = library.series[second.seriesId]!;
        return firstSeries.order.compareTo(secondSeries.order);
      });

    return YoungMuslimCategoryDetailsEntity(
      category: category,
      series: categorySeries,
      videos: categoryVideos,
    );
  }

  Future<YoungMuslimVideoDetailsEntity> getVideoDetails(String videoId) async {
    final library = await _loadLibrary();
    final video = library.videoById(videoId)!;
    final category = library.categories[video.categoryId]!;
    final series = library.series[video.seriesId]!;
    final relatedIds = library.relatedVideoIds[videoId] ?? const [];
    final similarVideos = relatedIds
        .map(library.videoById)
        .whereType<YoungMuslimVideoModel>()
        .toList();
    final seriesVideos = library.videos
        .where((item) => item.seriesId == video.seriesId)
        .toList()
      ..sort((first, second) => first.orderIndex.compareTo(second.orderIndex));
    YoungMuslimVideoModel? nextVideo;
    for (final candidate in seriesVideos) {
      if (candidate.orderIndex > video.orderIndex) {
        nextVideo = candidate;
        break;
      }
    }

    return YoungMuslimVideoDetailsEntity(
      video: video,
      category: category,
      series: series,
      similarVideos: similarVideos.take(12).toList(),
      nextVideo: nextVideo,
      videoQuiz: await getVideoQuiz(videoId),
      seriesQuiz: await getSeriesQuiz(video.seriesId),
      rewardsSummary: library.rewardsSummary,
      achievements: library.achievements,
    );
  }

  Future<YoungMuslimPlayerSessionEntity> getPlayerSession(
      String videoId) async {
    final library = await _loadLibrary();
    final video = library.videoById(videoId)!;
    final category = library.categories[video.categoryId]!;
    final series = library.series[video.seriesId]!;
    final queue = library.videos
        .where((item) => item.seriesId == video.seriesId)
        .toList()
      ..sort((first, second) => first.orderIndex.compareTo(second.orderIndex));
    YoungMuslimVideoModel? nextVideo;
    for (final candidate in queue) {
      if (candidate.orderIndex > video.orderIndex) {
        nextVideo = candidate;
        break;
      }
    }

    return YoungMuslimPlayerSessionEntity(
      video: video,
      category: category,
      series: series,
      queue: queue,
      nextVideo: nextVideo,
      resumeFromSeconds: video.isCompleted ? 0 : video.positionSeconds,
      videoQuiz: await getVideoQuiz(videoId),
      seriesQuiz: await getSeriesQuiz(video.seriesId),
    );
  }

  Future<void> markVideoOpened(String videoId) async {
    final database = await _db;
    final existing = await _getProgressRow(videoId);
    final now = DateTime.now().toIso8601String();

    await database.insert(
      YoungMuslimTables.videoProgress,
      {
        'video_id': videoId,
        'position_seconds': existing?['position_seconds'] ?? 0,
        'progress_percent': existing?['progress_percent'] ?? 0,
        'is_completed': existing?['is_completed'] ?? 0,
        'completed_at': existing?['completed_at'],
        'last_watched_at': now,
        'watch_count': ((existing?['watch_count'] as num?)?.toInt() ?? 0) + 1,
        'total_watched_seconds':
            (existing?['total_watched_seconds'] as num?)?.toInt() ?? 0,
        'reminder_scheduled_at': existing?['reminder_scheduled_at'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await database.insert(
      YoungMuslimTables.recentViews,
      {
        'video_id': videoId,
        'viewed_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveVideoProgress({
    required String videoId,
    required int positionSeconds,
    required int durationSeconds,
  }) async {
    final database = await _db;
    final existing = await _getProgressRow(videoId);
    final safeDuration = durationSeconds <= 0 ? 1 : durationSeconds;
    final progressPercent = (positionSeconds / safeDuration).clamp(0, 1);
    final completed = progressPercent >= 0.92;
    final now = DateTime.now().toIso8601String();
    final previousPosition =
        (existing?['position_seconds'] as num?)?.toInt() ?? 0;
    final additionalWatched = positionSeconds > previousPosition
        ? positionSeconds - previousPosition
        : 0;

    await database.insert(
      YoungMuslimTables.videoProgress,
      {
        'video_id': videoId,
        'position_seconds': positionSeconds,
        'progress_percent': progressPercent,
        'is_completed':
            completed ? 1 : ((existing?['is_completed'] == 1) ? 1 : 0),
        'completed_at':
            completed ? now : (existing?['completed_at'] as String?),
        'last_watched_at': now,
        'watch_count': (existing?['watch_count'] as num?)?.toInt() ?? 0,
        'total_watched_seconds':
            ((existing?['total_watched_seconds'] as num?)?.toInt() ?? 0) +
                additionalWatched,
        'reminder_scheduled_at': existing?['reminder_scheduled_at'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await database.insert(
      YoungMuslimTables.recentViews,
      {
        'video_id': videoId,
        'viewed_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (completed) {
      await markVideoCompleted(videoId);
    }
  }

  Future<void> markVideoCompleted(String videoId) async {
    final database = await _db;
    final videoRow = await database.query(
      YoungMuslimTables.videos,
      where: 'id = ?',
      whereArgs: [videoId],
      limit: 1,
    );
    if (videoRow.isEmpty) {
      return;
    }

    final video = YoungMuslimVideoModel.fromDb(videoRow.first);
    final existing = await _getProgressRow(videoId);
    final now = DateTime.now().toIso8601String();

    await database.insert(
      YoungMuslimTables.videoProgress,
      {
        'video_id': videoId,
        'position_seconds': video.durationSeconds,
        'progress_percent': 1.0,
        'is_completed': 1,
        'completed_at': now,
        'last_watched_at': now,
        'watch_count': ((existing?['watch_count'] as num?)?.toInt() ?? 0),
        'total_watched_seconds':
            (existing?['total_watched_seconds'] as num?)?.toInt() ??
                video.durationSeconds,
        'reminder_scheduled_at': null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await _rebuildRewardsSummary();
  }

  Future<void> toggleFavorite(String videoId) async {
    final database = await _db;
    final existing = await database.query(
      YoungMuslimTables.favorites,
      where: 'video_id = ?',
      whereArgs: [videoId],
      limit: 1,
    );

    if (existing.isEmpty) {
      await database.insert(
        YoungMuslimTables.favorites,
        {
          'video_id': videoId,
          'added_at': DateTime.now().toIso8601String(),
        },
      );
    } else {
      await database.delete(
        YoungMuslimTables.favorites,
        where: 'video_id = ?',
        whereArgs: [videoId],
      );
    }
  }

  Future<void> toggleWatchLater(String videoId) async {
    final database = await _db;
    final existing = await database.query(
      YoungMuslimTables.watchLater,
      where: 'video_id = ?',
      whereArgs: [videoId],
      limit: 1,
    );

    if (existing.isEmpty) {
      await database.insert(
        YoungMuslimTables.watchLater,
        {
          'video_id': videoId,
          'added_at': DateTime.now().toIso8601String(),
        },
      );
    } else {
      await database.delete(
        YoungMuslimTables.watchLater,
        where: 'video_id = ?',
        whereArgs: [videoId],
      );
    }

    await _rebuildRewardsSummary();
  }

  Future<YoungMuslimQuizSetEntity?> getVideoQuiz(String videoId) async {
    final database = await _db;
    final rows = await database.query(
      YoungMuslimTables.quizSets,
      where: 'video_id = ?',
      whereArgs: [videoId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return _buildQuizSet(rows.first);
  }

  Future<YoungMuslimQuizSetEntity?> getSeriesQuiz(String seriesId) async {
    final database = await _db;
    final rows = await database.query(
      YoungMuslimTables.quizSets,
      where: 'series_id = ? AND level = ?',
      whereArgs: [seriesId, 'series'],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return _buildQuizSet(rows.first);
  }

  Future<YoungMuslimQuizResultEntity> submitQuiz({
    required String quizId,
    required Map<String, String> answers,
  }) async {
    final database = await _db;
    final quizRows = await database.query(
      YoungMuslimTables.quizSets,
      where: 'id = ?',
      whereArgs: [quizId],
      limit: 1,
    );
    final quizSet = await _buildQuizSet(quizRows.first);

    var correctAnswers = 0;
    for (final question in quizSet.questions) {
      final answer = answers[question.id];
      if (answer == null) {
        continue;
      }
      if ((question.correctOptionId?.isNotEmpty ?? false)) {
        if (answer == question.correctOptionId) {
          correctAnswers++;
        }
      } else if (_matchesDirectAnswer(answer, question.correctAnswerText)) {
        correctAnswers++;
      }
    }

    final passed = correctAnswers >= quizSet.passingScore;
    final previousAttempts = Sqflite.firstIntValue(
          await database.rawQuery(
            '''
            SELECT COUNT(*) FROM ${YoungMuslimTables.quizAttempts}
            WHERE quiz_id = ? AND score >= ?
            ''',
            [quizId, quizSet.passingScore],
          ),
        ) ??
        0;

    var awardedXp = 0;
    if (passed && previousAttempts == 0) {
      awardedXp = quizSet.xpReward;
      if (correctAnswers == quizSet.questions.length) {
        awardedXp += await _rewardRuleValue('perfect_quiz_bonus');
      }
    }

    await database.insert(
      YoungMuslimTables.quizAttempts,
      {
        'quiz_id': quizId,
        'video_id': quizSet.videoId,
        'score': correctAnswers,
        'total_questions': quizSet.questions.length,
        'correct_answers': correctAnswers,
        'awarded_xp': awardedXp,
        'completed_at': DateTime.now().toIso8601String(),
      },
    );

    final newlyUnlocked = await _rebuildRewardsSummary();
    final rewardsSummary = await getRewardsSummary();

    return YoungMuslimQuizResultEntity(
      quizSet: quizSet,
      correctAnswers: correctAnswers,
      totalQuestions: quizSet.questions.length,
      awardedXp: awardedXp,
      passed: passed,
      newlyUnlockedAchievements: newlyUnlocked,
      rewardsSummary: rewardsSummary,
    );
  }

  Future<YoungMuslimRewardsSummaryEntity> getRewardsSummary() async {
    final database = await _db;
    final rows = await database.query(
      YoungMuslimTables.rewards,
      where: 'summary_id = 1',
      limit: 1,
    );
    if (rows.isEmpty) {
      return YoungMuslimRewardsSummaryModel.initial();
    }
    return YoungMuslimRewardsSummaryModel.fromDb(rows.first);
  }

  Future<List<YoungMuslimAchievementEntity>> getAchievements() async {
    final database = await _db;
    final achievements = await database.rawQuery(
      '''
      SELECT a.*, u.achievement_id IS NOT NULL AS is_unlocked, u.unlocked_at
      FROM ${YoungMuslimTables.achievements} a
      LEFT JOIN ${YoungMuslimTables.unlockedAchievements} u
      ON u.achievement_id = a.id
      ORDER BY a.threshold ASC
      ''',
    );

    return achievements
        .map(YoungMuslimAchievementModel.fromDb)
        .toList(growable: false);
  }

  Future<void> updateReminderScheduledAt(
    String videoId,
    DateTime? scheduledAt,
  ) async {
    final database = await _db;
    final existing = await _getProgressRow(videoId);
    if (existing == null) {
      await database.insert(
        YoungMuslimTables.videoProgress,
        {
          'video_id': videoId,
          'position_seconds': 0,
          'progress_percent': 0,
          'is_completed': 0,
          'completed_at': null,
          'last_watched_at': null,
          'watch_count': 0,
          'total_watched_seconds': 0,
          'reminder_scheduled_at': scheduledAt?.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return;
    }

    await database.update(
      YoungMuslimTables.videoProgress,
      {
        'reminder_scheduled_at': scheduledAt?.toIso8601String(),
      },
      where: 'video_id = ?',
      whereArgs: [videoId],
    );
  }

  Future<DateTime?> getReminderScheduledAt(String videoId) async {
    final row = await _getProgressRow(videoId);
    return _localParseDate(row?['reminder_scheduled_at']);
  }

  Future<void> _ensureSchema() async {
    final database = await _db;
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.seedState} (
        seed_key TEXT PRIMARY KEY,
        seed_value TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.categories} (
        id TEXT PRIMARY KEY,
        title_ar TEXT NOT NULL,
        title_en TEXT NOT NULL,
        description TEXT NOT NULL,
        banner_image TEXT NOT NULL,
        thumbnail TEXT NOT NULL,
        source_key TEXT NOT NULL,
        tags_json TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        audience TEXT NOT NULL,
        language TEXT NOT NULL,
        content_type TEXT NOT NULL,
        series_ids_json TEXT NOT NULL,
        accent_start TEXT NOT NULL,
        accent_end TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.series} (
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL,
        title_ar TEXT NOT NULL,
        title_en TEXT NOT NULL,
        description TEXT NOT NULL,
        banner_image TEXT NOT NULL,
        thumbnail TEXT NOT NULL,
        file_name TEXT NOT NULL,
        source_key TEXT NOT NULL,
        tags_json TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        audience TEXT NOT NULL,
        language TEXT NOT NULL,
        content_type TEXT NOT NULL,
        accent_start TEXT NOT NULL,
        accent_end TEXT NOT NULL,
        playlist_id TEXT NOT NULL,
        playlist_url TEXT NOT NULL,
        total_videos INTEGER NOT NULL,
        total_duration_seconds INTEGER NOT NULL,
        is_featured INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.videos} (
        id TEXT PRIMARY KEY,
        youtube_video_id TEXT NOT NULL,
        category_id TEXT NOT NULL,
        series_id TEXT NOT NULL,
        title TEXT NOT NULL,
        normalized_title TEXT NOT NULL,
        title_slug TEXT NOT NULL,
        topic_title TEXT NOT NULL,
        topic_slug TEXT NOT NULL,
        description TEXT NOT NULL,
        thumbnail TEXT NOT NULL,
        youtube_url TEXT NOT NULL,
        duration_seconds INTEGER NOT NULL,
        duration_human TEXT NOT NULL,
        episode_number INTEGER,
        part_number INTEGER,
        view_count INTEGER NOT NULL DEFAULT 0,
        language TEXT NOT NULL,
        content_type TEXT NOT NULL,
        is_intro INTEGER NOT NULL DEFAULT 0,
        is_outro INTEGER NOT NULL DEFAULT 0,
        is_bts INTEGER NOT NULL DEFAULT 0,
        order_index INTEGER NOT NULL,
        searchable_text TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.videoProgress} (
        video_id TEXT PRIMARY KEY,
        position_seconds INTEGER NOT NULL DEFAULT 0,
        progress_percent REAL NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        completed_at TEXT,
        last_watched_at TEXT,
        watch_count INTEGER NOT NULL DEFAULT 0,
        total_watched_seconds INTEGER NOT NULL DEFAULT 0,
        reminder_scheduled_at TEXT
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.recentViews} (
        video_id TEXT PRIMARY KEY,
        viewed_at TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.favorites} (
        video_id TEXT PRIMARY KEY,
        added_at TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.watchLater} (
        video_id TEXT PRIMARY KEY,
        added_at TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.quizSets} (
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL,
        series_id TEXT NOT NULL,
        video_id TEXT,
        level TEXT NOT NULL,
        title TEXT NOT NULL,
        xp_reward INTEGER NOT NULL,
        passing_score INTEGER NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.quizQuestions} (
        id TEXT PRIMARY KEY,
        quiz_id TEXT NOT NULL,
        type TEXT NOT NULL,
        prompt TEXT NOT NULL,
        options_json TEXT NOT NULL,
        correct_option_id TEXT,
        correct_answer_text TEXT NOT NULL,
        explanation TEXT NOT NULL,
        order_index INTEGER NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.quizAttempts} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quiz_id TEXT NOT NULL,
        video_id TEXT,
        score INTEGER NOT NULL,
        total_questions INTEGER NOT NULL,
        correct_answers INTEGER NOT NULL,
        awarded_xp INTEGER NOT NULL,
        completed_at TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.rewards} (
        summary_id INTEGER PRIMARY KEY CHECK(summary_id = 1),
        xp INTEGER NOT NULL DEFAULT 0,
        level INTEGER NOT NULL DEFAULT 1,
        completed_videos INTEGER NOT NULL DEFAULT 0,
        completed_series INTEGER NOT NULL DEFAULT 0,
        correct_answers INTEGER NOT NULL DEFAULT 0,
        watch_later_items INTEGER NOT NULL DEFAULT 0,
        perfect_quizzes INTEGER NOT NULL DEFAULT 0,
        unlocked_achievements INTEGER NOT NULL DEFAULT 0,
        last_updated_at TEXT
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.achievements} (
        id TEXT PRIMARY KEY,
        title_ar TEXT NOT NULL,
        title_en TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        threshold INTEGER NOT NULL,
        xp_reward INTEGER NOT NULL,
        icon TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.unlockedAchievements} (
        achievement_id TEXT PRIMARY KEY,
        unlocked_at TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.relatedVideos} (
        video_id TEXT NOT NULL,
        related_video_id TEXT NOT NULL,
        relation_type TEXT NOT NULL,
        score REAL NOT NULL,
        PRIMARY KEY (video_id, related_video_id)
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${YoungMuslimTables.rewardRules} (
        rule_key TEXT PRIMARY KEY,
        value INTEGER NOT NULL
      )
    ''');
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_ym_videos_category ON ${YoungMuslimTables.videos}(category_id)',
    );
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_ym_videos_series ON ${YoungMuslimTables.videos}(series_id)',
    );
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_ym_progress_last_watched ON ${YoungMuslimTables.videoProgress}(last_watched_at)',
    );
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_ym_quiz_questions_quiz ON ${YoungMuslimTables.quizQuestions}(quiz_id)',
    );
  }

  Future<int?> _getSeedVersion(Database database) async {
    final rows = await database.query(
      YoungMuslimTables.seedState,
      where: 'seed_key = ?',
      whereArgs: ['catalog_version'],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return int.tryParse(rows.first['seed_value'] as String);
  }

  Future<void> _ensureRewardsSummaryRow() async {
    final database = await _db;
    final rows = await database.query(
      YoungMuslimTables.rewards,
      where: 'summary_id = 1',
      limit: 1,
    );
    if (rows.isNotEmpty) {
      return;
    }
    await database.insert(
      YoungMuslimTables.rewards,
      YoungMuslimRewardsSummaryModel.initial().toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> _getProgressRow(String videoId) async {
    final database = await _db;
    final rows = await database.query(
      YoungMuslimTables.videoProgress,
      where: 'video_id = ?',
      whereArgs: [videoId],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<YoungMuslimQuizSetModel> _buildQuizSet(
      Map<String, dynamic> row) async {
    final database = await _db;
    final questionRows = await database.query(
      YoungMuslimTables.quizQuestions,
      where: 'quiz_id = ?',
      whereArgs: [row['id']],
      orderBy: 'order_index ASC',
    );
    final questions = questionRows
        .map(YoungMuslimQuizQuestionModel.fromDb)
        .toList(growable: false);
    return YoungMuslimQuizSetModel.fromDb(row, questions);
  }

  Future<_YoungMuslimLibrary> _loadLibrary() async {
    final database = await _db;
    final categoryRows = await database.query(
      YoungMuslimTables.categories,
      orderBy: 'sort_order ASC',
    );
    final seriesRows = await database.query(
      YoungMuslimTables.series,
      orderBy: 'sort_order ASC',
    );
    final videoRows = await database.query(
      YoungMuslimTables.videos,
      orderBy: 'order_index ASC',
    );
    final progressRows = await database.query(YoungMuslimTables.videoProgress);
    final favoriteRows = await database.query(YoungMuslimTables.favorites);
    final watchLaterRows = await database.query(YoungMuslimTables.watchLater);
    final relatedRows = await database.query(
      YoungMuslimTables.relatedVideos,
      orderBy: 'score DESC',
    );

    final categories = {
      for (final item in categoryRows)
        item['id'] as String: YoungMuslimCategoryModel.fromDb(item),
    };
    final series = {
      for (final item in seriesRows)
        item['id'] as String: YoungMuslimSeriesModel.fromDb(item),
    };

    final progressMap = {
      for (final item in progressRows) item['video_id'] as String: item,
    };
    final favoriteIds =
        favoriteRows.map((item) => item['video_id'] as String).toSet();
    final watchLaterIds =
        watchLaterRows.map((item) => item['video_id'] as String).toSet();

    final videos = videoRows.map(YoungMuslimVideoModel.fromDb).map((video) {
      final progress = progressMap[video.id];
      return video.mergeUserState(
        isFavorite: favoriteIds.contains(video.id),
        isWatchLater: watchLaterIds.contains(video.id),
        positionSeconds: (progress?['position_seconds'] as num?)?.toInt() ?? 0,
        progressPercent:
            (progress?['progress_percent'] as num?)?.toDouble() ?? 0,
        isCompleted:
            progress?['is_completed'] == 1 || progress?['is_completed'] == true,
        watchCount: (progress?['watch_count'] as num?)?.toInt() ?? 0,
        lastWatchedAt: _localParseDate(progress?['last_watched_at']),
        completedAt: _localParseDate(progress?['completed_at']),
      );
    }).toList(growable: false);

    final rewardsSummary = await getRewardsSummary();
    final achievements = await getAchievements();
    final relatedVideoIds = <String, List<String>>{};
    for (final row in relatedRows) {
      final videoId = row['video_id'] as String;
      final relatedVideoId = row['related_video_id'] as String;
      relatedVideoIds.putIfAbsent(videoId, () => []).add(relatedVideoId);
    }

    return _YoungMuslimLibrary(
      categories: categories,
      series: series,
      videos: videos,
      rewardsSummary: rewardsSummary,
      achievements: achievements,
      relatedVideoIds: relatedVideoIds,
    );
  }

  List<YoungMuslimVideoModel> _applyFilters(
    List<YoungMuslimVideoModel> source,
    String query,
    YoungMuslimFilters filters,
    Map<String, YoungMuslimCategoryModel> categories,
    Map<String, YoungMuslimSeriesModel> series,
  ) {
    final normalizedQuery = query.trim().toLowerCase();
    return source.where((video) {
      if (filters.categoryId != null &&
          video.categoryId != filters.categoryId) {
        return false;
      }
      if (filters.seriesId != null && video.seriesId != filters.seriesId) {
        return false;
      }
      if (filters.language != null && video.language != filters.language) {
        return false;
      }
      if (filters.contentType != null &&
          video.contentType != filters.contentType) {
        return false;
      }
      switch (filters.status) {
        case YoungMuslimStatusFilter.completed:
          if (!video.isCompleted) {
            return false;
          }
          break;
        case YoungMuslimStatusFilter.inProgress:
          if (!video.hasProgress) {
            return false;
          }
          break;
        case YoungMuslimStatusFilter.favorites:
          if (!video.isFavorite) {
            return false;
          }
          break;
        case YoungMuslimStatusFilter.watchLater:
          if (!video.isWatchLater) {
            return false;
          }
          break;
        case YoungMuslimStatusFilter.all:
          break;
      }

      if (normalizedQuery.isEmpty) {
        return true;
      }

      final category = categories[video.categoryId];
      final seriesItem = series[video.seriesId];
      final searchable = [
        video.title,
        video.normalizedTitle,
        video.topicTitle,
        video.description,
        category?.titleAr,
        category?.titleEn,
        seriesItem?.titleAr,
        seriesItem?.titleEn,
      ].join(' ').toLowerCase();

      return searchable.contains(normalizedQuery);
    }).toList(growable: false);
  }

  List<YoungMuslimVideoModel> _buildSuggestions(
    List<YoungMuslimVideoModel> videos,
    List<YoungMuslimVideoModel> recentlyWatched,
  ) {
    final recentCategories =
        recentlyWatched.take(3).map((video) => video.categoryId).toSet();

    final preferred = videos
        .where(
          (video) =>
              !video.isCompleted &&
              recentCategories.contains(video.categoryId) &&
              !video.isBehindTheScenes,
        )
        .toList()
      ..sort((first, second) => second.viewCount.compareTo(first.viewCount));

    if (preferred.isNotEmpty) {
      return preferred;
    }

    final fallback = videos.where((video) => !video.isBehindTheScenes).toList()
      ..sort((first, second) => second.viewCount.compareTo(first.viewCount));
    return fallback;
  }

  Future<List<YoungMuslimAchievementEntity>> _rebuildRewardsSummary() async {
    final database = await _db;
    final completedVideos = Sqflite.firstIntValue(
          await database.rawQuery(
            'SELECT COUNT(*) FROM ${YoungMuslimTables.videoProgress} WHERE is_completed = 1',
          ),
        ) ??
        0;

    final watchLaterCount = Sqflite.firstIntValue(
          await database.rawQuery(
            'SELECT COUNT(*) FROM ${YoungMuslimTables.watchLater}',
          ),
        ) ??
        0;

    final quizStats = await database.rawQuery(
      '''
      SELECT
        COALESCE(SUM(correct_answers), 0) AS correct_answers,
        COALESCE(SUM(awarded_xp), 0) AS quiz_xp,
        COALESCE(SUM(CASE WHEN correct_answers = total_questions THEN 1 ELSE 0 END), 0) AS perfect_quizzes
      FROM ${YoungMuslimTables.quizAttempts}
      ''',
    );
    final correctAnswers =
        (quizStats.first['correct_answers'] as num?)?.toInt() ?? 0;
    final quizXp = (quizStats.first['quiz_xp'] as num?)?.toInt() ?? 0;
    final perfectQuizzes =
        (quizStats.first['perfect_quizzes'] as num?)?.toInt() ?? 0;

    final seriesRows = await database.query(YoungMuslimTables.series);
    final seriesModels =
        seriesRows.map(YoungMuslimSeriesModel.fromDb).toList(growable: false);
    var completedSeries = 0;
    for (final series in seriesModels) {
      final count = Sqflite.firstIntValue(
            await database.rawQuery(
              '''
              SELECT COUNT(*) FROM ${YoungMuslimTables.videoProgress}
              WHERE is_completed = 1
              AND video_id IN (
                SELECT id FROM ${YoungMuslimTables.videos} WHERE series_id = ?
              )
              ''',
              [series.id],
            ),
          ) ??
          0;
      if (count >= series.totalVideos && series.totalVideos > 0) {
        completedSeries++;
      }
    }

    final newlyUnlocked = await _unlockNewAchievements(
      completedVideos: completedVideos,
      completedSeries: completedSeries,
      correctAnswers: correctAnswers,
      watchLaterItems: watchLaterCount,
    );

    final unlockedRows = Sqflite.firstIntValue(
          await database.rawQuery(
            'SELECT COUNT(*) FROM ${YoungMuslimTables.unlockedAchievements}',
          ),
        ) ??
        0;
    final achievementsXp = Sqflite.firstIntValue(
          await database.rawQuery(
            '''
            SELECT COALESCE(SUM(a.xp_reward), 0)
            FROM ${YoungMuslimTables.achievements} a
            INNER JOIN ${YoungMuslimTables.unlockedAchievements} u
            ON u.achievement_id = a.id
            ''',
          ),
        ) ??
        0;
    final videoCompletedXp = await _rewardRuleValue('video_completed');
    final totalXp =
        (completedVideos * videoCompletedXp) + quizXp + achievementsXp;
    final level = (totalXp ~/ 100) + 1;

    await database.insert(
      YoungMuslimTables.rewards,
      {
        'summary_id': 1,
        'xp': totalXp,
        'level': level,
        'completed_videos': completedVideos,
        'completed_series': completedSeries,
        'correct_answers': correctAnswers,
        'watch_later_items': watchLaterCount,
        'perfect_quizzes': perfectQuizzes,
        'unlocked_achievements': unlockedRows,
        'last_updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return newlyUnlocked;
  }

  Future<List<YoungMuslimAchievementEntity>> _unlockNewAchievements({
    required int completedVideos,
    required int completedSeries,
    required int correctAnswers,
    required int watchLaterItems,
  }) async {
    final database = await _db;
    final achievements = await database.query(YoungMuslimTables.achievements);
    final unlockedIds =
        (await database.query(YoungMuslimTables.unlockedAchievements))
            .map((row) => row['achievement_id'] as String)
            .toSet();

    final newlyUnlocked = <YoungMuslimAchievementEntity>[];
    for (final row in achievements) {
      final achievement = YoungMuslimAchievementModel.fromDb(row);
      if (unlockedIds.contains(achievement.id)) {
        continue;
      }

      int currentValue = 0;
      switch (achievement.type) {
        case 'completed_videos':
          currentValue = completedVideos;
          break;
        case 'completed_series':
          currentValue = completedSeries;
          break;
        case 'correct_answers':
          currentValue = correctAnswers;
          break;
        case 'watch_later_items':
          currentValue = watchLaterItems;
          break;
        default:
          currentValue = 0;
          break;
      }

      if (currentValue >= achievement.threshold) {
        final unlockedAt = DateTime.now();
        await database.insert(
          YoungMuslimTables.unlockedAchievements,
          {
            'achievement_id': achievement.id,
            'unlocked_at': unlockedAt.toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        newlyUnlocked.add(
          achievement.copyWith(isUnlocked: true, unlockedAt: unlockedAt),
        );
      }
    }

    return newlyUnlocked;
  }

  Future<int> _rewardRuleValue(String key) async {
    final database = await _db;
    final rows = await database.query(
      YoungMuslimTables.rewardRules,
      where: 'rule_key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return (rows.isEmpty ? 0 : (rows.first['value'] as num?)?.toInt()) ?? 0;
  }

  Future<void> _rebuildRelatedVideos() async {
    final database = await _db;
    await database.delete(YoungMuslimTables.relatedVideos);
    final videos = (await database.query(
      YoungMuslimTables.videos,
      orderBy: 'order_index ASC',
    ))
        .map(YoungMuslimVideoModel.fromDb)
        .toList();

    for (final video in videos) {
      final sameSeries = videos
          .where(
              (item) => item.seriesId == video.seriesId && item.id != video.id)
          .toList()
        ..sort(
            (first, second) => first.orderIndex.compareTo(second.orderIndex));
      final sameTopic = sameSeries
          .where((item) => item.topicSlug == video.topicSlug)
          .take(2)
          .toList();
      final sameCategory = videos
          .where(
            (item) =>
                item.categoryId == video.categoryId &&
                item.id != video.id &&
                item.seriesId != video.seriesId,
          )
          .toList()
        ..sort((first, second) => second.viewCount.compareTo(first.viewCount));

      final related = <Map<String, dynamic>>[];
      final nextInSeries = sameSeries
          .where((item) => item.orderIndex > video.orderIndex)
          .toList();

      if (nextInSeries.isNotEmpty) {
        related.add({
          'related_video_id': nextInSeries.first.id,
          'relation_type': 'next_in_series',
          'score': 1.0,
        });
      }
      for (final item in sameTopic) {
        related.add({
          'related_video_id': item.id,
          'relation_type': 'same_topic',
          'score': 0.95,
        });
      }
      for (final item in sameCategory.take(3)) {
        related.add({
          'related_video_id': item.id,
          'relation_type': 'same_category',
          'score': 0.8,
        });
      }

      final inserted = <String>{};
      for (final item in related) {
        final relatedId = item['related_video_id'] as String;
        if (inserted.contains(relatedId)) {
          continue;
        }
        inserted.add(relatedId);
        await database.insert(
          YoungMuslimTables.relatedVideos,
          {
            'video_id': video.id,
            'related_video_id': relatedId,
            'relation_type': item['relation_type'],
            'score': item['score'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }
}

class _YoungMuslimLibrary {
  const _YoungMuslimLibrary({
    required this.categories,
    required this.series,
    required this.videos,
    required this.rewardsSummary,
    required this.achievements,
    required this.relatedVideoIds,
  });

  final Map<String, YoungMuslimCategoryModel> categories;
  final Map<String, YoungMuslimSeriesModel> series;
  final List<YoungMuslimVideoModel> videos;
  final YoungMuslimRewardsSummaryEntity rewardsSummary;
  final List<YoungMuslimAchievementEntity> achievements;
  final Map<String, List<String>> relatedVideoIds;

  YoungMuslimVideoModel? videoById(String id) {
    for (final video in videos) {
      if (video.id == id) {
        return video;
      }
    }
    return null;
  }
}
