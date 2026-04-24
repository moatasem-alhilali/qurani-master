import 'package:quran_app/features/floating_adhkar/data/database/floating_adhkar_database_service.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_built_in_override.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_counts.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_custom_preference.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_built_in_source.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_selector.dart';
import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';

class FloatingAdhkarRepository {
  FloatingAdhkarRepository({
    required this.databaseService,
    required this.builtInSource,
    required this.selector,
  });

  final FloatingAdhkarDatabaseService databaseService;
  final FloatingAdhkarBuiltInSource builtInSource;
  final FloatingAdhkarSelector selector;

  Future<FloatingAdhkarSettings> loadSettings() async {
    final stored = await databaseService.getSettings();
    if (stored != null) {
      return stored;
    }

    final defaults = FloatingAdhkarSettings.defaults();
    await databaseService.upsertSettings(defaults);
    return defaults;
  }

  Future<void> updateSettings(FloatingAdhkarSettings settings) async {
    await databaseService.upsertSettings(settings);
  }

  Future<List<FloatingAdhkarItem>> loadBuiltInItems({
    bool includeDeleted = false,
  }) async {
    final baseItems = await builtInSource.loadItems();
    final overrideMap = await databaseService.getBuiltInOverrideMap();

    final merged = baseItems
        .map((item) {
          final override = overrideMap[item.id];
          if (override == null) {
            return item;
          }

          return item.copyWith(
            title: override.hasCustomTitle
                ? override.customTitle!.trim()
                : item.title,
            text: override.hasCustomText
                ? override.customText!.trim()
                : item.text,
            originalTitle: item.originalTitle ?? item.title,
            originalText: item.originalText ?? item.text,
            isDeleted: override.isDeleted,
          );
        })
        .where((item) => includeDeleted || !item.isDeleted)
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));

    return merged;
  }

  Future<List<FloatingAdhkarItem>> loadCustomItems({
    bool enabledOnly = false,
  }) async {
    final items = await DatabaseSabihService.getAllSubihItems();
    final selectionMap = await databaseService.getCustomSelectionMap();

    return items.where((item) => item.isCustom).where((item) {
      if (!enabledOnly) {
        return true;
      }
      final id = item.id;
      if (id == null) {
        return false;
      }
      return selectionMap[id] ?? true;
    }).map((item) {
      return FloatingAdhkarItem(
        id: 'custom:${item.id}',
        title: item.title,
        text: item.content.trim().isEmpty ? item.title : item.content.trim(),
        sourceType: FloatingAdhkarSourceType.custom,
        sourceLabel: 'أذكاري الخاصة',
        customAdhkarId: item.id,
      );
    }).toList();
  }

  Future<Map<int, bool>> loadCustomSelectionMap() {
    return databaseService.getCustomSelectionMap();
  }

  Future<void> updateBuiltInItem({
    required String itemId,
    required String title,
    required String text,
  }) async {
    final builtInItem = await _loadRawBuiltInItem(itemId);
    if (builtInItem == null) {
      return;
    }

    final normalizedTitle = title.trim();
    final normalizedText = text.trim();
    final baseTitle = builtInItem.originalTitle ?? builtInItem.title;
    final baseText = builtInItem.originalText ?? builtInItem.text;
    final overrideMap = await databaseService.getBuiltInOverrideMap();
    final existing = overrideMap[itemId];

    final nextOverride = FloatingAdhkarBuiltInOverride(
      itemId: itemId,
      customTitle: normalizedTitle == baseTitle ? null : normalizedTitle,
      customText: normalizedText == baseText ? null : normalizedText,
      isDeleted: existing?.isDeleted ?? false,
      updatedAt: DateTime.now(),
    );

    if (!nextOverride.hasAnyOverride) {
      await databaseService.deleteBuiltInOverride(itemId);
      return;
    }

    await databaseService.upsertBuiltInOverride(nextOverride);
  }

  Future<void> setBuiltInItemEnabled({
    required String itemId,
    required bool enabled,
  }) async {
    if (enabled) {
      await restoreBuiltInItem(itemId);
      return;
    }

    await deleteBuiltInItem(itemId);
  }

  Future<void> deleteBuiltInItem(String itemId) async {
    final overrideMap = await databaseService.getBuiltInOverrideMap();
    final existing = overrideMap[itemId];

    await databaseService.upsertBuiltInOverride(
      FloatingAdhkarBuiltInOverride(
        itemId: itemId,
        customTitle: existing?.customTitle,
        customText: existing?.customText,
        isDeleted: true,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> restoreBuiltInItem(String itemId) async {
    final overrideMap = await databaseService.getBuiltInOverrideMap();
    final existing = overrideMap[itemId];
    if (existing == null) {
      return;
    }

    final restored = existing.copyWith(
      isDeleted: false,
      updatedAt: DateTime.now(),
    );

    if (!restored.hasAnyOverride) {
      await databaseService.deleteBuiltInOverride(itemId);
      return;
    }

    await databaseService.upsertBuiltInOverride(restored);
  }

  Future<void> resetBuiltInItem(String itemId) async {
    final overrideMap = await databaseService.getBuiltInOverrideMap();
    final existing = overrideMap[itemId];
    if (existing == null) {
      return;
    }

    if (existing.isDeleted) {
      final updated = existing.copyWith(
        clearCustomTitle: true,
        clearCustomText: true,
        updatedAt: DateTime.now(),
      );
      await databaseService.upsertBuiltInOverride(updated);
      return;
    }

    await databaseService.deleteBuiltInOverride(itemId);
  }

  Future<void> setCustomItemEnabled(int subihId, bool enabled) async {
    await databaseService.upsertCustomPreference(
      FloatingAdhkarCustomPreference(
        subihId: subihId,
        isEnabled: enabled,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<FloatingAdhkarCounts> loadCounts() async {
    final builtIns = await loadBuiltInItems();
    final customs = await loadCustomItems();
    final selectionMap = await loadCustomSelectionMap();

    final enabledCustomCount = customs.where((item) {
      final customId = item.customAdhkarId;
      if (customId == null) {
        return false;
      }
      return selectionMap[customId] ?? true;
    }).length;

    return FloatingAdhkarCounts(
      builtInCount: builtIns.length,
      customTotalCount: customs.length,
      customEnabledCount: enabledCustomCount,
    );
  }

  Future<List<FloatingAdhkarItem>> loadSelectableItems(
    FloatingAdhkarSettings settings,
  ) async {
    final items = <FloatingAdhkarItem>[];

    if (settings.includeBuiltIn) {
      items.addAll(await loadBuiltInItems());
    }

    if (settings.includeCustom) {
      items.addAll(await loadCustomItems(enabledOnly: true));
    }

    return items;
  }

  Future<FloatingAdhkarItem?> loadPreviewItem({
    FloatingAdhkarSettings? settings,
  }) async {
    final effectiveSettings = settings ?? await loadSettings();
    final selectable = await loadSelectableItems(effectiveSettings);

    if (selectable.isEmpty) {
      return null;
    }

    selectable.sort((a, b) => a.title.compareTo(b.title));
    return selectable.first;
  }

  Future<FloatingAdhkarItem?> pickNextItem({
    FloatingAdhkarSettings? settings,
  }) async {
    final effectiveSettings = settings ?? await loadSettings();

    final builtInItems = effectiveSettings.includeBuiltIn
        ? await loadBuiltInItems()
        : const <FloatingAdhkarItem>[];
    final customItems = effectiveSettings.includeCustom
        ? await loadCustomItems(enabledOnly: true)
        : const <FloatingAdhkarItem>[];

    if (builtInItems.isEmpty && customItems.isEmpty) {
      return null;
    }

    return selector.pickNext(
      settings: effectiveSettings,
      builtInItems: builtInItems,
      customItems: customItems,
    );
  }

  Future<void> recordShownItem(FloatingAdhkarItem item) async {
    final settings = await loadSettings();
    await updateSettings(
      settings.copyWith(
        lastItemId: item.id,
        lastSourceType: item.sourceType,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<FloatingAdhkarItem?> _loadRawBuiltInItem(String itemId) async {
    final items = await builtInSource.loadItems();
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (_) {
      return null;
    }
  }
}
