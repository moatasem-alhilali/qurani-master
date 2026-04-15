import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/features/daily_wird/data/database/daily_wird_database_service.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_content_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_customization_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_overview_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_preset_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_item_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_settings_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_stats_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_template_item_model.dart';
import 'package:quran_app/features/daily_wird/data/service/daily_wird_reminder_service.dart';

class DailyWirdRepository {
  DailyWirdRepository({
    required this.databaseService,
    required this.reminderService,
  });

  final DailyWirdDatabaseService databaseService;
  final DailyWirdReminderService reminderService;

  _DailyWirdConfig? _config;

  Future<DailyWirdOverview> loadOverview() async {
    final config = await _loadConfig();
    final settings = await _loadOrCreateSettings(config);
    final program = await _ensureTodayProgram(
      settings: settings,
      forceRegenerate: false,
    );
    final stats = await _buildStats(program);

    return DailyWirdOverview(
      presets: config.presets,
      settings: settings,
      stats: stats,
      program: program,
    );
  }

  Future<void> syncReminderSchedules() async {
    final config = await _loadConfig();
    final settings = await _loadOrCreateSettings(config);
    await reminderService.reschedule(settings);
  }

  Future<DailyWirdOverview> selectPreset(String presetId) async {
    final config = await _loadConfig();
    final currentSettings = await _loadOrCreateSettings(config);
    final updatedSettings = currentSettings.copyWith(
      selectedPresetId: presetId,
      onboardingCompleted: true,
      updatedAt: DateTime.now(),
    );

    await databaseService.upsertSettings(updatedSettings);
    await reminderService.reschedule(updatedSettings);

    final program = await _ensureTodayProgram(
      settings: updatedSettings,
      forceRegenerate: true,
    );

    return DailyWirdOverview(
      presets: config.presets,
      settings: updatedSettings,
      stats: await _buildStats(program),
      program: program,
    );
  }

  Future<DailyWirdOverview> incrementItem(String itemId) async {
    final program = await _requireTodayProgram();
    final updatedItems = program.items.map((item) {
      if (item.id != itemId || !item.hasCounter || item.countRequired == null) {
        return item;
      }

      final nextCount = (item.countCompleted + 1).clamp(0, item.countRequired!);
      return item.copyWith(countCompleted: nextCount);
    }).toList();

    return _saveProgramAndBuildOverview(program.copyWith(items: updatedItems));
  }

  Future<DailyWirdOverview> resetItem(String itemId) async {
    final program = await _requireTodayProgram();
    final updatedItems = program.items.map((item) {
      if (item.id != itemId) {
        return item;
      }
      return item.copyWith(countCompleted: 0);
    }).toList();

    return _saveProgramAndBuildOverview(program.copyWith(items: updatedItems));
  }

  Future<DailyWirdOverview> toggleCompleted(String itemId) async {
    final program = await _requireTodayProgram();
    final updatedItems = program.items.map((item) {
      if (item.id != itemId) {
        return item;
      }

      if (item.hasCounter) {
        final required = item.countRequired ?? 0;
        final nextValue = item.isCompleted ? 0 : required;
        return item.copyWith(countCompleted: nextValue);
      }

      final nextValue = item.isCompleted ? 0 : 1;
      return item.copyWith(countCompleted: nextValue);
    }).toList();

    return _saveProgramAndBuildOverview(program.copyWith(items: updatedItems));
  }

  Future<DailyWirdOverview> hideItem(String itemId) async {
    final customization = await _upsertCustomization(
      itemId,
      (current) => current.copyWith(
        isHidden: true,
        updatedAt: DateTime.now(),
      ),
    );

    return _reloadWithCustomization(itemId, customization);
  }

  Future<DailyWirdOverview> restoreItem(String itemId) async {
    final customization = await _upsertCustomization(
      itemId,
      (current) => current.copyWith(
        isHidden: false,
        updatedAt: DateTime.now(),
      ),
    );

    return _reloadWithCustomization(itemId, customization);
  }

  Future<DailyWirdOverview> updateItemCount(
      String itemId, int countRequired) async {
    final normalized = countRequired <= 0 ? 1 : countRequired;
    final customization = await _upsertCustomization(
      itemId,
      (current) => current.copyWith(
        customCountRequired: normalized,
        updatedAt: DateTime.now(),
      ),
    );

    return _reloadWithCustomization(itemId, customization);
  }

  Future<DailyWirdOverview> moveItem(String itemId, int direction) async {
    final program = await _requireTodayProgram();
    final items = [...program.items]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final index = items.indexWhere((item) => item.id == itemId);
    if (index == -1) {
      return loadOverview();
    }

    final targetIndex = index + direction;
    if (targetIndex < 0 || targetIndex >= items.length) {
      return loadOverview();
    }

    final current = items[index];
    final target = items[targetIndex];
    items[index] = target.copyWith(orderIndex: current.orderIndex);
    items[targetIndex] = current.copyWith(orderIndex: target.orderIndex);

    await _upsertCustomization(
      items[index].id,
      (existing) => existing.copyWith(
        orderIndex: items[index].orderIndex,
        updatedAt: DateTime.now(),
      ),
    );
    await _upsertCustomization(
      items[targetIndex].id,
      (existing) => existing.copyWith(
        orderIndex: items[targetIndex].orderIndex,
        updatedAt: DateTime.now(),
      ),
    );

    return _saveProgramAndBuildOverview(program.copyWith(items: items));
  }

  Future<DailyWirdOverview> updateReminderSettings(
      DailyWirdSettings settings) async {
    final updated = settings.copyWith(updatedAt: DateTime.now());
    await databaseService.upsertSettings(updated);
    await reminderService.reschedule(updated);
    final program = await _ensureTodayProgram(
      settings: updated,
      forceRegenerate: false,
    );

    return DailyWirdOverview(
      presets: (await _loadConfig()).presets,
      settings: updated,
      stats: await _buildStats(program),
      program: program,
    );
  }

  Future<DailyWirdProgram?> _ensureTodayProgram({
    required DailyWirdSettings settings,
    required bool forceRegenerate,
  }) async {
    if (settings.selectedPresetId == null ||
        settings.selectedPresetId!.isEmpty) {
      return null;
    }

    if (!forceRegenerate) {
      final stored = await databaseService.getProgram(DateTime.now());
      if (stored != null && stored.presetId == settings.selectedPresetId) {
        return stored;
      }
    }

    final config = await _loadConfig();
    final preset = config.presets.firstWhere(
      (item) => item.id == settings.selectedPresetId,
      orElse: () => config.presets.first,
    );
    final customizations = await databaseService.getCustomizations();
    final customizationMap = {
      for (final customization in customizations)
        customization.itemId: customization,
    };

    final generatedItems = <DailyWirdItem>[];
    for (final itemId in preset.itemIds) {
      final template = config.itemById[itemId];
      if (template == null || !template.isActive) {
        continue;
      }

      final customization = customizationMap[itemId];
      if (customization?.isHidden == true) {
        continue;
      }

      if (!_isActiveToday(template.activeDays, DateTime.now())) {
        continue;
      }

      final contentEntries = _resolveContentEntries(config, template);
      final contentText =
          contentEntries.map((entry) => entry.text).join('\n\n');
      final primaryEntry =
          contentEntries.isNotEmpty ? contentEntries.first : null;
      final countRequired = template.hasCounter
          ? customization?.customCountRequired ?? template.countRequired
          : null;

      generatedItems.add(
        DailyWirdItem(
          id: template.id,
          title: template.title,
          type: template.type,
          contentText: contentText,
          countRequired: countRequired,
          countCompleted: 0,
          hasCounter: template.hasCounter,
          hasAudio: template.hasAudio,
          audioUrl: template.audioUrl,
          timeCategory: template.timeCategory,
          isActive: true,
          orderIndex: customization?.orderIndex ?? template.orderIndex,
          createdAt: DateTime.now(),
          contentEntries: contentEntries,
          fadhl: primaryEntry?.fadhl,
          source: primaryEntry?.source,
          countUnit: template.countUnit,
        ),
      );
    }

    generatedItems.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    final program = DailyWirdProgram(
      date: DateTime.now(),
      items: generatedItems,
      completionPercentage: _calculateCompletionPercentage(generatedItems),
      presetId: preset.id,
      createdAt: DateTime.now(),
    );

    await databaseService.saveProgram(program);
    return program;
  }

  Future<DailyWirdProgram> _requireTodayProgram() async {
    final overview = await loadOverview();
    final program = overview.program;
    if (program == null) {
      throw StateError('Daily Wird preset is not selected yet.');
    }
    return program;
  }

  Future<DailyWirdCustomization> _upsertCustomization(
    String itemId,
    DailyWirdCustomization Function(DailyWirdCustomization current) transform,
  ) async {
    final existing = (await databaseService.getCustomizations()).firstWhere(
      (item) => item.itemId == itemId,
      orElse: () => DailyWirdCustomization(
        itemId: itemId,
        isHidden: false,
        updatedAt: DateTime.now(),
      ),
    );

    final updated = transform(existing);
    await databaseService.upsertCustomization(updated);
    return updated;
  }

  Future<DailyWirdOverview> _reloadWithCustomization(
    String itemId,
    DailyWirdCustomization customization,
  ) async {
    final program = await _requireTodayProgram();
    final updatedItems = <DailyWirdItem>[];

    for (final item in program.items) {
      if (item.id == itemId) {
        if (customization.isHidden) {
          continue;
        }

        final nextCount =
            customization.customCountRequired ?? item.countRequired;
        updatedItems.add(
          item.copyWith(
            countRequired: nextCount,
            orderIndex: customization.orderIndex ?? item.orderIndex,
            countCompleted: nextCount != null && item.countCompleted > nextCount
                ? nextCount
                : item.countCompleted,
          ),
        );
        continue;
      }

      updatedItems.add(item);
    }

    updatedItems.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return _saveProgramAndBuildOverview(program.copyWith(items: updatedItems));
  }

  Future<DailyWirdOverview> _saveProgramAndBuildOverview(
    DailyWirdProgram program,
  ) async {
    final normalizedProgram = program.copyWith(
      completionPercentage: _calculateCompletionPercentage(program.items),
    );
    await databaseService.saveProgram(normalizedProgram);

    final config = await _loadConfig();
    final settings = await _loadOrCreateSettings(config);

    return DailyWirdOverview(
      presets: config.presets,
      settings: settings,
      stats: await _buildStats(normalizedProgram),
      program: normalizedProgram,
    );
  }

  Future<DailyWirdStats> _buildStats(DailyWirdProgram? todayProgram) async {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 6));
    final history =
        await databaseService.getProgramsBetween(start: start, end: end);

    var streak = 0;
    final sorted = [...history]..sort((a, b) => b.date.compareTo(a.date));
    var cursor = DateTime(end.year, end.month, end.day);

    for (final program in sorted) {
      final programDate =
          DateTime(program.date.year, program.date.month, program.date.day);
      if (programDate != cursor) {
        if (programDate.isBefore(cursor)) {
          break;
        }
        continue;
      }
      if (!program.isCompleted) {
        break;
      }
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    final weeklyAverage = history.isEmpty
        ? 0.0
        : history
                .map((program) => program.completionPercentage)
                .fold<double>(0, (sum, value) => sum + value) /
            history.length;

    return DailyWirdStats(
      streakDays: streak,
      weeklyAdherence: weeklyAverage,
      todayCompletionPercentage: todayProgram?.completionPercentage ?? 0,
      completedToday: todayProgram?.isCompleted ?? false,
    );
  }

  Future<DailyWirdSettings> _loadOrCreateSettings(
    _DailyWirdConfig config,
  ) async {
    final stored = await databaseService.getSettings();
    if (stored != null) {
      return stored;
    }

    final defaults = DailyWirdSettings(
      selectedPresetId: null,
      onboardingCompleted: false,
      morningReminderEnabled:
          config.notificationDefaults['morning_reminder_enabled'] == true,
      morningReminderTime:
          config.notificationDefaults['morning_reminder_time'] as String? ??
              '07:00',
      eveningReminderEnabled:
          config.notificationDefaults['evening_reminder_enabled'] == true,
      eveningReminderTime:
          config.notificationDefaults['evening_reminder_time'] as String? ??
              '17:30',
      nightReminderEnabled:
          config.notificationDefaults['night_reminder_enabled'] == true,
      nightReminderTime:
          config.notificationDefaults['night_reminder_time'] as String? ??
              '21:00',
      endOfDaySummaryEnabled:
          config.notificationDefaults['end_of_day_summary_enabled'] == true,
      endOfDaySummaryTime:
          config.notificationDefaults['end_of_day_summary_time'] as String? ??
              '22:30',
      updatedAt: DateTime.now(),
    );

    await databaseService.upsertSettings(defaults);
    return defaults;
  }

  Future<_DailyWirdConfig> _loadConfig() async {
    if (_config != null) {
      return _config!;
    }

    final raw = await JsonLoaderService.loadJsonObject(
      JsonLoaderService.dailyWirdProgramPath,
    );

    final presets = (raw['presets'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(DailyWirdPreset.fromJson)
        .toList();

    final items = (raw['items'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(DailyWirdTemplateItem.fromJson)
        .toList();

    final contentLibraryRaw =
        (raw['content_library'] as Map<String, dynamic>? ?? const {});
    final contentLibrary = <String, DailyWirdContentEntry>{};
    for (final entry in contentLibraryRaw.entries) {
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        contentLibrary[entry.key] =
            DailyWirdContentEntry.fromJson(entry.key, value);
      } else if (value is Map) {
        contentLibrary[entry.key] = DailyWirdContentEntry.fromJson(
          entry.key,
          Map<String, dynamic>.from(value),
        );
      }
    }

    _config = _DailyWirdConfig(
      presets: presets,
      items: items,
      itemById: {for (final item in items) item.id: item},
      contentLibrary: contentLibrary,
      notificationDefaults:
          Map<String, dynamic>.from(raw['notification_defaults'] as Map? ?? {}),
    );
    return _config!;
  }

  List<DailyWirdContentEntry> _resolveContentEntries(
    _DailyWirdConfig config,
    DailyWirdTemplateItem template,
  ) {
    final keys = <String>[
      if (template.referenceKey != null && template.referenceKey!.isNotEmpty)
        template.referenceKey!,
      ...template.referenceKeys,
    ];

    return keys
        .map((key) => config.contentLibrary[key])
        .whereType<DailyWirdContentEntry>()
        .toList();
  }

  bool _isActiveToday(List<String> activeDays, DateTime date) {
    if (activeDays.isEmpty) {
      return true;
    }
    return activeDays.contains(_weekdayName(date.weekday));
  }

  String _weekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
      default:
        return '';
    }
  }

  double _calculateCompletionPercentage(List<DailyWirdItem> items) {
    if (items.isEmpty) {
      return 0;
    }
    final completedCount = items.where((item) => item.isCompleted).length;
    return (completedCount / items.length) * 100;
  }
}

class _DailyWirdConfig {
  const _DailyWirdConfig({
    required this.presets,
    required this.items,
    required this.itemById,
    required this.contentLibrary,
    required this.notificationDefaults,
  });

  final List<DailyWirdPreset> presets;
  final List<DailyWirdTemplateItem> items;
  final Map<String, DailyWirdTemplateItem> itemById;
  final Map<String, DailyWirdContentEntry> contentLibrary;
  final Map<String, dynamic> notificationDefaults;
}
