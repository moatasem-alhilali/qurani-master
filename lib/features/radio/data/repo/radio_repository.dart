import 'package:quran_app/features/radio/data/data_source/radio_local_data_source.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/data/service/radio_audio_service.dart';
import 'package:quran_app/features/radio/data/service/radio_favourites_store.dart';
import 'package:quran_app/features/radio/data/service/radio_sleep_timer.dart';

class RadioRepository {
  RadioRepository({
    required RadioLocalDataSource localDataSource,
    required RadioAudioService audioService,
    required RadioFavouritesStore favourites,
    required RadioSleepTimer sleepTimer,
  })  : _localDataSource = localDataSource,
        _audioService = audioService,
        _favourites = favourites,
        _sleepTimer = sleepTimer {
    // المؤقّت يعرف متى ينتهي، ولا يعرف ما الذي يوقفه. الربط هنا لا داخله،
    // فتبقى الخدمة قابلة للاختبار وحدها.
    _sleepTimer.onElapsed = stop;
  }

  final RadioLocalDataSource _localDataSource;
  final RadioAudioService _audioService;
  final RadioFavouritesStore _favourites;
  final RadioSleepTimer _sleepTimer;

  RadioAudioService get audioService => _audioService;
  RadioFavouritesStore get favourites => _favourites;
  RadioSleepTimer get sleepTimer => _sleepTimer;

  Future<List<RadioStationModel>> loadStations() {
    _favourites.hydrate();
    return _localDataSource.loadStations();
  }

  int? getLastStationId() => _localDataSource.getLastStationId();

  Future<void> playStation(RadioStationModel station) async {
    await _audioService.playStation(station);
    await _localDataSource.saveLastStationId(station.id);
  }

  Future<void> togglePlayPause() => _audioService.togglePlayPause();

  Future<void> stop() async {
    _sleepTimer.cancel();
    await _audioService.stop();
  }
}
