import 'dart:convert';

import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/cash/cache_config.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/constant.dart' as constants;
import 'package:quran_app/core/theme/theme_manager.dart';
import 'package:quran_app/features/floating_adhkar/data/database/floating_adhkar_database_service.dart';
import 'package:quran_app/features/floating_adhkar/data/repo/floating_adhkar_repository.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_built_in_source.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_selector.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';
import 'package:quran_library/quran_library.dart';
import 'package:workmanager/workmanager.dart';

const String homeWidgetsBackgroundTaskUniqueName =
    'tamaneena.home_widgets.refresh';
const String homeWidgetsBackgroundTaskName = 'homeWidgetsBackgroundRefresh';
const String homeWidgetsPrayerTaskUniqueName =
    'tamaneena.home_widgets.prayer_refresh';
const String homeWidgetsPrayerTaskName = 'homeWidgetsPrayerBoundaryRefresh';

@pragma('vm:entry-point')
void tamaneenaHomeWidgetsCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await CacheConfig.loadConfig();
    try {
      await QuranLibrary.init();
    } catch (error) {
      debugPrint('HomeWidgetsService: background Quran init skipped: $error');
    }

    try {
      final service = HomeWidgetsService();
      await service.refreshAll();
      await service.startBackgroundUpdates();
      return true;
    } catch (error) {
      debugPrint('HomeWidgetsService: background refresh failed: $error');
      return false;
    }
  });
}

class HomeWidgetsService {
  HomeWidgetsService({
    FloatingAdhkarRepository? floatingAdhkarRepository,
  }) : _floatingAdhkarRepository = floatingAdhkarRepository ??
            FloatingAdhkarRepository(
              databaseService: FloatingAdhkarDatabaseService(),
              builtInSource: FloatingAdhkarBuiltInSource(),
              selector: FloatingAdhkarSelector(),
            );

  static const String appGroupId = 'group.com.tamaneena.tamaneena_app.widgets';
  static const List<String> iosWidgetKinds = <String>[
    'TamaneenaPrayerWidget',
    'TamaneenaDhikrWidget',
    'TamaneenaAyahWidget',
    'TamaneenaWirdWidget',
    'TamaneenaPrayerTimesWidget',
    'TamaneenaLockPrayerWidget',
    'TamaneenaLockDhikrWidget',
    'TamaneenaLockAyahWidget',
  ];

  static const List<String> androidWidgetProviders = <String>[
    'HomePrayerWidgetProvider',
    'HomeDhikrWidgetProvider',
    'HomeAyahWidgetProvider',
    'HomeWirdWidgetProvider',
    'HomePrayerTimesWidgetProvider',
  ];

  final FloatingAdhkarRepository _floatingAdhkarRepository;
  final DatabaseCoordinatesService _coordinatesService =
      DatabaseCoordinatesService();
  Duration? _nextPrayerRefreshDelay;

  Future<void> initializeBackgroundUpdates() async {
    await Workmanager().initialize(
      tamaneenaHomeWidgetsCallbackDispatcher,
    );
  }

  Future<void> startBackgroundUpdates() async {
    await initializeBackgroundUpdates();
    await Workmanager().registerPeriodicTask(
      homeWidgetsBackgroundTaskUniqueName,
      homeWidgetsBackgroundTaskName,
      frequency: const Duration(minutes: 15),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );
    await _scheduleNextPrayerBoundaryRefresh();
  }

  Future<void> stopBackgroundUpdates() {
    return Workmanager()
        .cancelByUniqueName(homeWidgetsBackgroundTaskUniqueName);
  }

  Future<bool> isAndroidPinSupported() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    return await HomeWidget.isRequestPinWidgetSupported() ?? false;
  }

  Future<bool> requestPinWidget(HomeWidgetType type) async {
    if (!await isAndroidPinSupported()) {
      return false;
    }
    await refreshAll();
    final provider = type.androidProvider;
    await HomeWidget.requestPinWidget(
      androidName: provider,
      qualifiedAndroidName: 'com.tamaneena.tamaneena_app.$provider',
    );
    return true;
  }

  Future<void> refreshAll() async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
    } catch (error) {
      debugPrint('HomeWidgetsService: App Group setup skipped: $error');
    }

    await _savePrayerData();
    await _saveDhikrData();
    await _saveAyahData();
    await _saveWirdData();
    await _saveThemeData();
    await _saveSharedData();
    await _updateNativeWidgets();
  }

  Future<void> _savePrayerData() async {
    try {
      final savedLocation = await _coordinatesService.getSavedLocation();
      if (savedLocation == null) {
        throw StateError('No saved prayer location for widgets');
      }

      final schedule = _buildPrayerSchedule(savedLocation);
      if (schedule.isEmpty) {
        throw StateError('Prayer widget schedule is empty');
      }

      final now = _locationNow(savedLocation.utcOffsetMinutes);
      final next = schedule.firstWhere(
        (item) => item.isPrayer && item.time.isAfter(now),
        orElse: () => schedule.firstWhere((item) => item.isPrayer),
      );
      final nextTime = next.time;
      final remaining = nextTime.difference(now);
      _nextPrayerRefreshDelay = remaining + const Duration(minutes: 1);
      final todayItems = schedule.takeWhile((item) {
        final first = schedule.first.time;
        return _isSameDate(item.time, first);
      }).toList();

      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>('prayer_name', next.name),
        HomeWidget.saveWidgetData<String>(
          'prayer_time',
          _formatTime(next.time),
        ),
        HomeWidget.saveWidgetData<String>(
          'prayer_remaining',
          _formatRemaining(remaining),
        ),
        HomeWidget.saveWidgetData<String>('prayer_label', 'الصلاة القادمة'),
        HomeWidget.saveWidgetData<String>(
          'prayer_city',
          savedLocation.label,
        ),
        HomeWidget.saveWidgetData<int>(
          'prayer_next_epoch_millis',
          nextTime.millisecondsSinceEpoch,
        ),
        HomeWidget.saveWidgetData<int>(
          'prayer_location_utc_offset_minutes',
          savedLocation.utcOffsetMinutes,
        ),
        HomeWidget.saveWidgetData<String>(
          'prayer_schedule_json',
          jsonEncode(schedule.map((item) => item.toJson()).toList()),
        ),
        HomeWidget.saveWidgetData<String>(
          'prayer_times_summary',
          _buildPrayerTimesSummary(todayItems),
        ),
        ..._prayerTimeKeyWrites(todayItems),
      ]);
    } catch (error) {
      debugPrint('HomeWidgetsService: prayer data fallback: $error');
      _nextPrayerRefreshDelay = const Duration(minutes: 30);
      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>('prayer_name', 'الفجر'),
        HomeWidget.saveWidgetData<String>('prayer_time', '04:18 ص'),
        HomeWidget.saveWidgetData<String>('prayer_remaining', 'قريبًا'),
        HomeWidget.saveWidgetData<String>('prayer_label', 'الصلاة القادمة'),
        HomeWidget.saveWidgetData<String>('prayer_city', 'طمأنينة'),
        HomeWidget.saveWidgetData<String>('prayer_schedule_json', '[]'),
        HomeWidget.saveWidgetData<String>(
          'prayer_times_summary',
          'الفجر 04:18 | الظهر 12:05 | العصر 03:14 | '
              'المغرب 06:32 | العشاء 07:51',
        ),
      ]);
    }
  }

  Future<void> _saveDhikrData() async {
    try {
      final settings = await _floatingAdhkarRepository.loadSettings();
      final item = await _floatingAdhkarRepository.pickNextItem(
            settings: settings,
          ) ??
          await _floatingAdhkarRepository.loadPreviewItem(settings: settings);

      final title = _cleanDhikrTitle(
        itemTitle: item?.title,
        itemText: item?.text,
      );
      final text = (item?.text.trim().isNotEmpty ?? false)
          ? item!.text.trim()
          : constants.thikr;

      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>(
          'dhikr_title',
          title,
        ),
        HomeWidget.saveWidgetData<String>(
          'dhikr_text',
          text,
        ),
        HomeWidget.saveWidgetData<String>(
          'dhikr_source',
          item?.sourceLabel ?? 'أذكار طمأنينة',
        ),
      ]);
      if (item != null) {
        await _floatingAdhkarRepository.recordShownItem(item);
      }
    } catch (error) {
      debugPrint('HomeWidgetsService: dhikr data fallback: $error');
      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>('dhikr_title', 'ذكر اليوم'),
        HomeWidget.saveWidgetData<String>('dhikr_text', constants.thikr),
        HomeWidget.saveWidgetData<String>('dhikr_source', 'أذكار طمأنينة'),
      ]);
    }
  }

  Future<void> _saveAyahData() async {
    try {
      final quranCtrl = QuranCtrl.instance;
      await quranCtrl.ensureCoreDataLoaded();
      final ayahs = quranCtrl.state.allAyahs.isNotEmpty
          ? quranCtrl.state.allAyahs
          : quranCtrl.ayahs;
      if (ayahs.isEmpty) {
        throw StateError('Quran ayahs are empty');
      }

      final refreshSeed = DateTime.now().millisecondsSinceEpoch ~/
          const Duration(minutes: 30).inMilliseconds;
      final ayah = ayahs[refreshSeed % ayahs.length];
      final text = ayah.text.trim().isNotEmpty
          ? ayah.text.trim()
          : ayah.ayaTextEmlaey.trim();
      final source = '${ayah.arabicName ?? 'القرآن'}: ${ayah.ayahNumber}';

      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>('ayah_title', 'آية عشوائية'),
        HomeWidget.saveWidgetData<String>('ayah_text', '﴿$text﴾'),
        HomeWidget.saveWidgetData<String>('ayah_source', source),
        HomeWidget.saveWidgetData<int>(
          'ayah_last_updated_epoch_millis',
          DateTime.now().millisecondsSinceEpoch,
        ),
      ]);
    } catch (error) {
      debugPrint('HomeWidgetsService: quran ayah fallback: $error');
      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>('ayah_title', 'آية عشوائية'),
        HomeWidget.saveWidgetData<String>('ayah_text', constants.ayah),
        HomeWidget.saveWidgetData<String>('ayah_source', 'القرآن الكريم'),
      ]);
    }
  }

  Future<void> _saveWirdData() async {
    final now = DateTime.now();
    final seed = now.day + now.month;
    final completed = (seed * 13) % 100;
    await Future.wait(<Future<bool?>>[
      HomeWidget.saveWidgetData<String>('wird_title', 'ورد اليوم'),
      HomeWidget.saveWidgetData<String>('wird_progress', '$completed%'),
      HomeWidget.saveWidgetData<String>(
        'wird_summary',
        completed == 0
            ? 'ابدأ وردك الآن'
            : 'أكملت $completed% من وردك، أكمل النور.',
      ),
      HomeWidget.saveWidgetData<int>('wird_progress_value', completed),
    ]);
  }

  Future<void> _saveThemeData() async {
    final themeType = CacheService().getString(ThemeColorsManager.cacheKey) ??
        ThemeColorsManager.blue;
    final accent = switch (themeType) {
      ThemeColorsManager.brown => '#C9A46A',
      ThemeColorsManager.green => '#BFA16A',
      ThemeColorsManager.dark => '#D6B977',
      _ => '#C9A46A',
    };

    await Future.wait(<Future<bool?>>[
      HomeWidget.saveWidgetData<String>('widget_theme_type', themeType),
      HomeWidget.saveWidgetData<String>('widget_accent_hex', accent),
      HomeWidget.saveWidgetData<String>('widget_surface_hex', '#17130D'),
      HomeWidget.saveWidgetData<String>('widget_on_surface_hex', '#FFF7E1'),
      HomeWidget.saveWidgetData<String>('widget_muted_hex', '#D4B873'),
    ]);
  }

  Future<void> _saveSharedData() async {
    final stamp = DateFormat.jm('ar').format(DateTime.now());
    await Future.wait(<Future<bool?>>[
      HomeWidget.saveWidgetData<String>('widget_brand', 'طمأنينة'),
      HomeWidget.saveWidgetData<String>('widget_updated_at', 'تحديث $stamp'),
    ]);
  }

  Future<void> _updateNativeWidgets() async {
    for (final provider in androidWidgetProviders) {
      try {
        await HomeWidget.updateWidget(
          androidName: provider,
          qualifiedAndroidName: 'com.tamaneena.tamaneena_app.$provider',
        );
      } catch (error) {
        debugPrint('HomeWidgetsService: update $provider failed: $error');
      }
    }

    for (final kind in iosWidgetKinds) {
      try {
        await HomeWidget.updateWidget(iOSName: kind);
      } catch (error) {
        debugPrint('HomeWidgetsService: iOS update $kind skipped: $error');
      }
    }
  }

  Future<void> _scheduleNextPrayerBoundaryRefresh() async {
    final delay = _nextPrayerRefreshDelay;
    if (delay == null || delay.isNegative || delay.inMinutes > 24 * 60) {
      return;
    }

    try {
      await Workmanager().registerOneOffTask(
        homeWidgetsPrayerTaskUniqueName,
        homeWidgetsPrayerTaskName,
        initialDelay: delay,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        constraints: Constraints(
          networkType: NetworkType.notRequired,
        ),
      );
    } catch (error) {
      debugPrint('HomeWidgetsService: prayer boundary task skipped: $error');
    }
  }

  String _formatRemaining(Duration duration) {
    if (duration.isNegative) {
      return 'الآن';
    }
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours <= 0) {
      return 'بعد $minutes د';
    }
    return 'بعد $hours س $minutes د';
  }

  List<_PrayerWidgetScheduleItem> _buildPrayerSchedule(
    PrayerLocationSelection selection,
  ) {
    final params = CalculationMethod.muslim_world_league.getParameters()
      ..madhab = Madhab.shafi;
    final coordinates = Coordinates(selection.latitude, selection.longitude);
    final offset = Duration(minutes: selection.utcOffsetMinutes);
    final nowAtLocation = _locationNow(selection.utcOffsetMinutes);
    final baseDate = DateTime(
      nowAtLocation.year,
      nowAtLocation.month,
      nowAtLocation.day,
    );
    final items = <_PrayerWidgetScheduleItem>[];

    for (var day = 0; day < 2; day++) {
      final date = baseDate.add(Duration(days: day));
      final prayerTimes = PrayerTimes.utcOffset(
        coordinates,
        DateComponents.from(date),
        params,
        offset,
      );
      items.addAll(<_PrayerWidgetScheduleItem>[
        _PrayerWidgetScheduleItem(
          key: 'fajr',
          name: 'الفجر',
          time: prayerTimes.fajr,
        ),
        _PrayerWidgetScheduleItem(
          key: 'sunrise',
          name: 'الشروق',
          time: prayerTimes.sunrise,
          isPrayer: false,
        ),
        _PrayerWidgetScheduleItem(
          key: 'dhuhr',
          name: 'الظهر',
          time: prayerTimes.dhuhr,
        ),
        _PrayerWidgetScheduleItem(
          key: 'asr',
          name: 'العصر',
          time: prayerTimes.asr,
        ),
        _PrayerWidgetScheduleItem(
          key: 'maghrib',
          name: 'المغرب',
          time: prayerTimes.maghrib,
        ),
        _PrayerWidgetScheduleItem(
          key: 'isha',
          name: 'العشاء',
          time: prayerTimes.isha,
        ),
      ]);
    }

    items.sort((a, b) => a.time.compareTo(b.time));
    return items;
  }

  List<Future<bool?>> _prayerTimeKeyWrites(
    List<_PrayerWidgetScheduleItem> items,
  ) {
    final byKey = <String, _PrayerWidgetScheduleItem>{
      for (final item in items) item.key: item,
    };
    return <Future<bool?>>[
      for (final key in <String>[
        'fajr',
        'sunrise',
        'dhuhr',
        'asr',
        'maghrib',
        'isha',
      ])
        HomeWidget.saveWidgetData<String>(
          'prayer_${key}_time',
          byKey[key] == null ? '--:--' : _formatTime(byKey[key]!.time),
        ),
    ];
  }

  String _buildPrayerTimesSummary(List<_PrayerWidgetScheduleItem> items) {
    return items
        .where((item) => item.isPrayer)
        .map((item) => '${item.name} ${_formatTime(item.time)}')
        .join(' | ');
  }

  String _formatTime(DateTime time) {
    return DateFormat.jm('ar').format(time);
  }

  DateTime _locationNow(int utcOffsetMinutes) {
    return DateTime.now().toUtc().add(Duration(minutes: utcOffsetMinutes));
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _cleanDhikrTitle({
    required String? itemTitle,
    required String? itemText,
  }) {
    final title = itemTitle?.trim() ?? '';
    final text = itemText?.trim() ?? '';
    if (title.isEmpty || title == text || text.startsWith(title)) {
      return 'ذكر اليوم';
    }
    return title;
  }
}

enum HomeWidgetType {
  prayer('HomePrayerWidgetProvider'),
  dhikr('HomeDhikrWidgetProvider'),
  ayah('HomeAyahWidgetProvider'),
  wird('HomeWirdWidgetProvider'),
  prayerTimes('HomePrayerTimesWidgetProvider');

  const HomeWidgetType(this.androidProvider);

  final String androidProvider;
}

class _PrayerWidgetScheduleItem {
  const _PrayerWidgetScheduleItem({
    required this.key,
    required this.name,
    required this.time,
    this.isPrayer = true,
  });

  final String key;
  final String name;
  final DateTime time;
  final bool isPrayer;

  Map<String, Object> toJson() => <String, Object>{
        'key': key,
        'name': name,
        'time': _timeFormat.format(time),
        'epochMillis': time.millisecondsSinceEpoch,
        'isPrayer': isPrayer,
      };

  static final DateFormat _timeFormat = DateFormat.jm('ar');
}
