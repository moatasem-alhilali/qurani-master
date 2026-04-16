import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';

class RadioLocalDataSource {
  RadioLocalDataSource(this._cacheService);

  static const _stationsAssetPath = 'assets/json/radio_stations.json';
  static const _lastStationIdKey = 'radio_last_station_id';

  final CacheService _cacheService;

  Future<List<RadioStationModel>> loadStations() async {
    final raw = await rootBundle.loadString(_stationsAssetPath);
    final decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .map(
          (item) => RadioStationModel.fromMap(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<void> saveLastStationId(int id) async {
    await _cacheService.setInt(_lastStationIdKey, id);
  }

  int? getLastStationId() {
    return _cacheService.getInt(_lastStationIdKey);
  }
}
