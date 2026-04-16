import 'package:quran_app/features/radio/data/data_source/radio_local_data_source.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/data/service/radio_audio_service.dart';

class RadioRepository {
  RadioRepository({
    required RadioLocalDataSource localDataSource,
    required RadioAudioService audioService,
  })  : _localDataSource = localDataSource,
        _audioService = audioService;

  final RadioLocalDataSource _localDataSource;
  final RadioAudioService _audioService;

  Future<List<RadioStationModel>> loadStations() {
    return _localDataSource.loadStations();
  }

  int? getLastStationId() {
    return _localDataSource.getLastStationId();
  }

  Future<void> playStation(RadioStationModel station) async {
    await _audioService.playStation(station);
    await _localDataSource.saveLastStationId(station.id);
  }

  Future<void> togglePlayPause() {
    return _audioService.togglePlayPause();
  }

  Future<void> stop() {
    return _audioService.stop();
  }

  RadioAudioService get audioService => _audioService;
}
