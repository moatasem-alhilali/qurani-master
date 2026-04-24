import 'dart:math';

import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';

class FloatingAdhkarSelector {
  FloatingAdhkarSelector({Random? random}) : _random = random ?? Random();

  final Random _random;

  FloatingAdhkarItem? pickNext({
    required FloatingAdhkarSettings settings,
    required List<FloatingAdhkarItem> builtInItems,
    required List<FloatingAdhkarItem> customItems,
  }) {
    if (settings.mixSources || builtInItems.isEmpty || customItems.isEmpty) {
      return _pickRandom(
        [...builtInItems, ...customItems],
        lastItemId: settings.lastItemId,
      );
    }

    final preferredSource = _resolvePreferredSource(
      lastSourceType: settings.lastSourceType,
      builtInItems: builtInItems,
      customItems: customItems,
    );

    final primaryPool = preferredSource == FloatingAdhkarSourceType.builtIn
        ? builtInItems
        : customItems;
    final secondaryPool = preferredSource == FloatingAdhkarSourceType.builtIn
        ? customItems
        : builtInItems;
    final primaryCandidates = _excludeLastItem(
      primaryPool,
      lastItemId: settings.lastItemId,
    );
    if (primaryCandidates.isNotEmpty) {
      return _pickRandom(
        primaryCandidates,
        lastItemId: null,
      );
    }

    final secondaryCandidates = _excludeLastItem(
      secondaryPool,
      lastItemId: settings.lastItemId,
    );
    if (secondaryCandidates.isNotEmpty) {
      return _pickRandom(
        secondaryCandidates,
        lastItemId: null,
      );
    }

    return _pickRandom(
          primaryPool,
          lastItemId: settings.lastItemId,
        ) ??
        _pickRandom(
          secondaryPool,
          lastItemId: settings.lastItemId,
        );
  }

  FloatingAdhkarSourceType _resolvePreferredSource({
    required FloatingAdhkarSourceType? lastSourceType,
    required List<FloatingAdhkarItem> builtInItems,
    required List<FloatingAdhkarItem> customItems,
  }) {
    if (lastSourceType == FloatingAdhkarSourceType.builtIn &&
        customItems.isNotEmpty) {
      return FloatingAdhkarSourceType.custom;
    }

    if (lastSourceType == FloatingAdhkarSourceType.custom &&
        builtInItems.isNotEmpty) {
      return FloatingAdhkarSourceType.builtIn;
    }

    if (builtInItems.isNotEmpty) {
      return FloatingAdhkarSourceType.builtIn;
    }

    return FloatingAdhkarSourceType.custom;
  }

  List<FloatingAdhkarItem> _excludeLastItem(
    List<FloatingAdhkarItem> pool, {
    required String? lastItemId,
  }) {
    if (lastItemId == null) {
      return pool;
    }

    return pool.where((item) => item.id != lastItemId).toList();
  }

  FloatingAdhkarItem? _pickRandom(
    List<FloatingAdhkarItem> pool, {
    required String? lastItemId,
  }) {
    if (pool.isEmpty) {
      return null;
    }

    final filtered = pool.length > 1 && lastItemId != null
        ? pool.where((item) => item.id != lastItemId).toList()
        : pool;
    final effectivePool = filtered.isEmpty ? pool : filtered;

    return effectivePool[_random.nextInt(effectivePool.length)];
  }
}
