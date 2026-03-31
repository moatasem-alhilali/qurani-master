import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran_app/features/young_muslim/data/models/young_muslim_models.dart';

class YoungMuslimSeedBundle {
  const YoungMuslimSeedBundle({
    required this.version,
    required this.categories,
    required this.series,
    required this.videos,
    required this.quizSets,
    required this.achievements,
    required this.rewardRules,
  });

  final int version;
  final List<YoungMuslimCategoryModel> categories;
  final List<YoungMuslimSeriesModel> series;
  final List<YoungMuslimVideoModel> videos;
  final List<YoungMuslimQuizSetModel> quizSets;
  final List<YoungMuslimAchievementModel> achievements;
  final List<YoungMuslimRewardRuleModel> rewardRules;
}

class YoungMuslimAssetDataSource {
  static const _catalogPath = 'assets/json/young_muslim/catalog.json';
  static const _quizzesPath = 'assets/json/young_muslim/quizzes.json';
  static const _rewardsPath = 'assets/json/young_muslim/rewards.json';

  Future<YoungMuslimSeedBundle> loadSeedBundle() async {
    final catalogJson = jsonDecode(await rootBundle.loadString(_catalogPath))
        as Map<String, dynamic>;
    final quizzesJson = jsonDecode(await rootBundle.loadString(_quizzesPath))
        as Map<String, dynamic>;
    final rewardsJson = jsonDecode(await rootBundle.loadString(_rewardsPath))
        as Map<String, dynamic>;

    final categories = (catalogJson['categories'] as List<dynamic>? ?? const [])
        .map(
          (item) =>
              YoungMuslimCategoryModel.fromJson(item as Map<String, dynamic>),
        )
        .toList()
      ..sort((first, second) => first.order.compareTo(second.order));

    final series = (catalogJson['series'] as List<dynamic>? ?? const [])
        .map(
          (item) =>
              YoungMuslimSeriesModel.fromJson(item as Map<String, dynamic>),
        )
        .toList()
      ..sort((first, second) => first.order.compareTo(second.order));

    final videos = <YoungMuslimVideoModel>[];
    for (final seriesModel in series) {
      final playlistJson = jsonDecode(
        await rootBundle.loadString(seriesModel.fileName),
      ) as Map<String, dynamic>;
      final playlistVideos =
          (playlistJson['videos'] as List<dynamic>? ?? const [])
              .map(
                (item) => YoungMuslimVideoModel.fromAssetJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
      videos.addAll(playlistVideos);
    }

    final quizSets = (quizzesJson['quiz_sets'] as List<dynamic>? ?? const [])
        .map(
          (item) =>
              YoungMuslimQuizSetModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    final achievements =
        (rewardsJson['achievements'] as List<dynamic>? ?? const [])
            .map(
              (item) => YoungMuslimAchievementModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();

    final rewardRulesMap = Map<String, dynamic>.from(
      (rewardsJson['xp_rules'] as Map?) ?? const <String, dynamic>{},
    );
    final rewardRules = rewardRulesMap.entries
        .map(YoungMuslimRewardRuleModel.fromJson)
        .toList();

    return YoungMuslimSeedBundle(
      version: (catalogJson['version'] as num?)?.toInt() ?? 1,
      categories: categories,
      series: series,
      videos: videos,
      quizSets: quizSets,
      achievements: achievements,
      rewardRules: rewardRules,
    );
  }
}
