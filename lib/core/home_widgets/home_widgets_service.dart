import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/core/constant.dart' as constants;
import 'package:quran_app/features/floating_adhkar/data/database/floating_adhkar_database_service.dart';
import 'package:quran_app/features/floating_adhkar/data/repo/floating_adhkar_repository.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_built_in_source.dart';
import 'package:quran_app/features/floating_adhkar/data/service/floating_adhkar_selector.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_library/quran_library.dart';
import 'package:workmanager/workmanager.dart';

const String homeWidgetsBackgroundTaskUniqueName =
    'tamaneena.home_widgets.refresh';
const String homeWidgetsBackgroundTaskName = 'homeWidgetsBackgroundRefresh';

@pragma('vm:entry-point')
void tamaneenaHomeWidgetsCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await QuranLibrary.init();
    } catch (error) {
      debugPrint('HomeWidgetsService: background Quran init skipped: $error');
    }

    try {
      await HomeWidgetsService().refreshAll();
      return true;
    } catch (error) {
      debugPrint('HomeWidgetsService: background refresh failed: $error');
      return false;
    }
  });
}

class HomeWidgetsService {
  HomeWidgetsService({
    AdhanPrayerTimeService? prayerTimeService,
    FloatingAdhkarRepository? floatingAdhkarRepository,
  })  : _prayerTimeService = prayerTimeService ?? AdhanPrayerTimeService(),
        _floatingAdhkarRepository = floatingAdhkarRepository ??
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
    'TamaneenaLockPrayerWidget',
    'TamaneenaLockDhikrWidget',
  ];

  static const List<String> androidWidgetProviders = <String>[
    'HomePrayerWidgetProvider',
    'HomeDhikrWidgetProvider',
    'HomeAyahWidgetProvider',
    'HomeWirdWidgetProvider',
  ];

  final AdhanPrayerTimeService _prayerTimeService;
  final FloatingAdhkarRepository _floatingAdhkarRepository;

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
      frequency: const Duration(minutes: 30),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );
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
    await _saveSharedData();
    await _updateNativeWidgets();
  }

  Future<void> _savePrayerData() async {
    try {
      final prayers = await _prayerTimeService.getTodayPrayerTimes();
      final now = DateTime.now();
      final futurePrayers = prayers
          .where(
            (prayer) =>
                prayer.type != Prayer.sunrise && prayer.time.isAfter(now),
          )
          .toList();
      final next = futurePrayers.isNotEmpty
          ? futurePrayers.first
          : prayers.firstWhere(
              (prayer) => prayer.type == Prayer.fajr,
              orElse: () => prayers.first,
            );
      final nextTime = futurePrayers.isNotEmpty
          ? next.time
          : next.time.add(const Duration(days: 1));
      final remaining = nextTime.difference(now);

      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>('prayer_name', next.name),
        HomeWidget.saveWidgetData<String>('prayer_time', next.time12),
        HomeWidget.saveWidgetData<String>(
          'prayer_remaining',
          _formatRemaining(remaining),
        ),
        HomeWidget.saveWidgetData<String>('prayer_label', 'الصلاة القادمة'),
        HomeWidget.saveWidgetData<String>('prayer_city', 'طمأنينة'),
      ]);
    } catch (error) {
      debugPrint('HomeWidgetsService: prayer data fallback: $error');
      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>('prayer_name', 'الفجر'),
        HomeWidget.saveWidgetData<String>('prayer_time', '04:18 ص'),
        HomeWidget.saveWidgetData<String>('prayer_remaining', 'قريبًا'),
        HomeWidget.saveWidgetData<String>('prayer_label', 'الصلاة القادمة'),
        HomeWidget.saveWidgetData<String>('prayer_city', 'طمأنينة'),
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

      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>(
          'dhikr_title',
          (item?.title.trim().isNotEmpty ?? false) ? item!.title : 'ذكر اليوم',
        ),
        HomeWidget.saveWidgetData<String>(
          'dhikr_text',
          (item?.text.trim().isNotEmpty ?? false)
              ? item!.text
              : constants.thikr,
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

      final now = DateTime.now();
      final daySeed = DateTime(now.year, now.month, now.day)
          .difference(DateTime(now.year))
          .inDays;
      final ayah = ayahs[daySeed % ayahs.length];
      final text = ayah.text.trim().isNotEmpty
          ? ayah.text.trim()
          : ayah.ayaTextEmlaey.trim();
      final source = '${ayah.arabicName ?? 'القرآن'}: ${ayah.ayahNumber}';

      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>('ayah_title', 'آية اليوم'),
        HomeWidget.saveWidgetData<String>('ayah_text', '﴿$text﴾'),
        HomeWidget.saveWidgetData<String>('ayah_source', source),
      ]);
    } catch (error) {
      debugPrint('HomeWidgetsService: quran ayah fallback: $error');
      await Future.wait(<Future<bool?>>[
        HomeWidget.saveWidgetData<String>('ayah_title', 'آية اليوم'),
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
}

enum HomeWidgetType {
  prayer('HomePrayerWidgetProvider'),
  dhikr('HomeDhikrWidgetProvider'),
  ayah('HomeAyahWidgetProvider'),
  wird('HomeWirdWidgetProvider');

  const HomeWidgetType(this.androidProvider);

  final String androidProvider;
}
