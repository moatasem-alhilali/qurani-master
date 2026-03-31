import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';

abstract class YoungMuslimRepository {
  Future<void> ensureInitialized();

  Future<YoungMuslimDashboardEntity> getDashboard({
    String query = '',
    YoungMuslimFilters filters = YoungMuslimFilters.empty,
  });

  Future<YoungMuslimCategoryDetailsEntity> getCategoryDetails(
    String categoryId, {
    String query = '',
    YoungMuslimFilters filters = YoungMuslimFilters.empty,
  });

  Future<YoungMuslimVideoDetailsEntity> getVideoDetails(String videoId);

  Future<YoungMuslimPlayerSessionEntity> getPlayerSession(String videoId);

  Future<void> markVideoOpened(String videoId);

  Future<void> saveVideoProgress({
    required String videoId,
    required int positionSeconds,
    required int durationSeconds,
  });

  Future<void> markVideoCompleted(String videoId);

  Future<void> toggleFavorite(String videoId);

  Future<void> toggleWatchLater(String videoId);

  Future<YoungMuslimQuizSetEntity?> getVideoQuiz(String videoId);

  Future<YoungMuslimQuizSetEntity?> getSeriesQuiz(String seriesId);

  Future<YoungMuslimQuizResultEntity> submitQuiz({
    required String quizId,
    required Map<String, String> answers,
  });

  Future<YoungMuslimRewardsSummaryEntity> getRewardsSummary();

  Future<List<YoungMuslimAchievementEntity>> getAchievements();

  Future<void> scheduleResumeReminder(String videoId);

  Future<void> cancelResumeReminder(String videoId);
}
