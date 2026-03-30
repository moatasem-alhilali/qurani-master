import 'package:quran_app/features/young_muslim/data/data_sources/young_muslim_asset_data_source.dart';
import 'package:quran_app/features/young_muslim/data/data_sources/young_muslim_local_data_source.dart';
import 'package:quran_app/features/young_muslim/data/services/young_muslim_reminder_service.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';

class YoungMuslimRepositoryImpl implements YoungMuslimRepository {
  YoungMuslimRepositoryImpl({
    required YoungMuslimAssetDataSource assetDataSource,
    required YoungMuslimLocalDataSource localDataSource,
    required YoungMuslimReminderService reminderService,
  })  : _assetDataSource = assetDataSource,
        _localDataSource = localDataSource,
        _reminderService = reminderService;

  final YoungMuslimAssetDataSource _assetDataSource;
  final YoungMuslimLocalDataSource _localDataSource;
  final YoungMuslimReminderService _reminderService;

  bool _initialized = false;

  @override
  Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }
    final bundle = await _assetDataSource.loadSeedBundle();
    await _localDataSource.ensureInitialized(bundle);
    _initialized = true;
  }

  @override
  Future<YoungMuslimDashboardEntity> getDashboard({
    String query = '',
    YoungMuslimFilters filters = YoungMuslimFilters.empty,
  }) async {
    await ensureInitialized();
    return _localDataSource.getDashboard(query: query, filters: filters);
  }

  @override
  Future<YoungMuslimCategoryDetailsEntity> getCategoryDetails(
    String categoryId, {
    String query = '',
    YoungMuslimFilters filters = YoungMuslimFilters.empty,
  }) async {
    await ensureInitialized();
    return _localDataSource.getCategoryDetails(
      categoryId,
      query: query,
      filters: filters,
    );
  }

  @override
  Future<YoungMuslimVideoDetailsEntity> getVideoDetails(String videoId) async {
    await ensureInitialized();
    return _localDataSource.getVideoDetails(videoId);
  }

  @override
  Future<YoungMuslimPlayerSessionEntity> getPlayerSession(
      String videoId) async {
    await ensureInitialized();
    return _localDataSource.getPlayerSession(videoId);
  }

  @override
  Future<void> markVideoOpened(String videoId) async {
    await ensureInitialized();
    await _localDataSource.markVideoOpened(videoId);
  }

  @override
  Future<void> saveVideoProgress({
    required String videoId,
    required int positionSeconds,
    required int durationSeconds,
  }) async {
    await ensureInitialized();
    await _localDataSource.saveVideoProgress(
      videoId: videoId,
      positionSeconds: positionSeconds,
      durationSeconds: durationSeconds,
    );
  }

  @override
  Future<void> markVideoCompleted(String videoId) async {
    await ensureInitialized();
    await _localDataSource.markVideoCompleted(videoId);
  }

  @override
  Future<void> toggleFavorite(String videoId) async {
    await ensureInitialized();
    await _localDataSource.toggleFavorite(videoId);
  }

  @override
  Future<void> toggleWatchLater(String videoId) async {
    await ensureInitialized();
    await _localDataSource.toggleWatchLater(videoId);
  }

  @override
  Future<YoungMuslimQuizSetEntity?> getVideoQuiz(String videoId) async {
    await ensureInitialized();
    return _localDataSource.getVideoQuiz(videoId);
  }

  @override
  Future<YoungMuslimQuizSetEntity?> getSeriesQuiz(String seriesId) async {
    await ensureInitialized();
    return _localDataSource.getSeriesQuiz(seriesId);
  }

  @override
  Future<YoungMuslimQuizResultEntity> submitQuiz({
    required String quizId,
    required Map<String, String> answers,
  }) async {
    await ensureInitialized();
    return _localDataSource.submitQuiz(quizId: quizId, answers: answers);
  }

  @override
  Future<YoungMuslimRewardsSummaryEntity> getRewardsSummary() async {
    await ensureInitialized();
    return _localDataSource.getRewardsSummary();
  }

  @override
  Future<List<YoungMuslimAchievementEntity>> getAchievements() async {
    await ensureInitialized();
    return _localDataSource.getAchievements();
  }

  @override
  Future<void> scheduleResumeReminder(String videoId) async {
    await ensureInitialized();
    final details = await _localDataSource.getVideoDetails(videoId);
    await _reminderService.scheduleResumeReminder(
      videoId: videoId,
      title: 'كمل المشاهدة في المسلم الصغير',
      body: 'ارجع إلى "${details.video.topicTitle}" وأكمل رحلتك بهدوء.',
    );
  }

  @override
  Future<void> cancelResumeReminder(String videoId) async {
    await ensureInitialized();
    await _reminderService.cancelResumeReminder(videoId);
  }
}
