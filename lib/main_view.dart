import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/app_localizations/AppLocalizations.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:quran_app/core/bloc/device_sync/device_sync_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/device_sync/data/device_sync_repository.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/dark_theme.dart';
import 'package:quran_app/core/util/exit_alert.dialog.dart';
import 'package:quran_app/core/util/light_theme.dart';
import 'package:quran_app/features/daily_wird/data/repo/daily_wird_repository.dart';
import 'package:quran_app/features/home/presentation/bloc/random_ayah_bloc.dart';
import 'package:quran_app/features/home/presentation/view/pages/home_screen.dart';
import 'package:quran_app/features/manage_version/data/datasources/version_cache_datasource.dart';
import 'package:quran_app/features/manage_version/data/datasources/version_remote_datasource.dart';
import 'package:quran_app/features/manage_version/data/repositories/version_repository_impl.dart';
import 'package:quran_app/features/manage_version/presentation/bloc/version_bloc.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_alarm_notification_router_service.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ///prayer time
        BlocProvider(
          create: (context) => PrayerTimeBloc(
            prayerTimeService: AdhanPrayerTimeService(),
            coordinatesService: DatabaseCoordinatesService(),
          ),
        ),

        ///connectivity
        BlocProvider(
          create: (context) =>
              sl<ConnectivityBloc>()..add(const ConnectivityStarted()),
          lazy: false,
        ),

        BlocProvider(
          create: (context) => DeviceSyncBloc(
            repository: sl<DeviceSyncRepository>(),
            connectivityBloc: context.read<ConnectivityBloc>(),
          )..add(const DeviceSyncStarted()),
          lazy: false,
        ),

        ///version management
        BlocProvider(
          create: (context) => VersionBloc(
            versionRepository: VersionRepositoryImpl(
              remoteDataSource: VersionRemoteDataSourceImpl(),
              cacheDataSource: VersionCacheDataSourceImpl(),
            ),
            connectivityBloc: context.read<ConnectivityBloc>(),
          )..add(InitializeVersionManagementEvent()),
          lazy: false,
        ),

        ///theme
        BlocProvider(
          create: (context) => ThemeBloc()..add(InitThemeEvent()),
        ),

        // ///quran audio
        // BlocProvider(
        //   create: (context) =>
        //       sl<QuranAudioBloc>()..add(InitQuranPlayerDataEvent()),
        //   lazy: false,
        // ),

        ///base
        BlocProvider(create: (context) => BaseBloc()),

        // ///bookmark
        // BlocProvider(
        //   create: (context) => sl<BookmarkBloc>()
        //     ..add(GetBookmarksAyahEvent())
        //     ..add(GetBookmarksPageEvent()),
        //   lazy: false,
        // ),

        // BlocProvider(
        //   lazy: false,
        //   create: (context) => ReadQuranBloc()
        //     ..add(LoadQuranEvent())
        //     ..add(GetLastPageReadEvent()),
        // ),

        ///notification
        BlocProvider(
          create: (context) =>
              NotificationBloc()..add(InitializeNotificationEvent()),
          lazy: false,
        ),

        ///home
        BlocProvider(
          create: (context) => sl<RandomAyahBloc>()..add(GetRandomAyahEvent()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => sl<RadioBloc>()..add(const RadioInitialized()),
          lazy: false,
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, state) {
              return ScreenUtilInit(
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (_, child) => MaterialApp(
                  locale: const Locale('ar'),
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    for (final locale in supportedLocales) {
                      if (deviceLocale != null &&
                          deviceLocale.languageCode == locale.languageCode) {
                        return deviceLocale;
                      }
                    }
                    return supportedLocales.first;
                  },
                  supportedLocales: const [Locale('ar'), Locale('en')],
                  onGenerateRoute: RouterGenerator.getRoute,
                  initialRoute: RoutesManager.main,
                  // // darkTheme: getDarkMode(),
                  // darkTheme: context.themeApp,
                  // theme: getLightMode(),
                  darkTheme: darkTheme,
                  theme: lightTheme,
                  themeMode: themeState.currentThemeMode,
                  title: 'طمأنينة',
                  themeAnimationCurve: Curves.decelerate,
                  themeAnimationDuration: const Duration(milliseconds: 300),
                  themeAnimationStyle: const AnimationStyle(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                    reverseCurve: Curves.decelerate,
                    reverseDuration: Duration(milliseconds: 300),
                  ),
                  navigatorKey: NavigationService.navigatorKey,
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    return DevicePreview.appBuilder(
                      context,
                      child ?? const SizedBox.shrink(),
                    );
                  },

                  home: const _App(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _App extends StatefulWidget {
  const _App();

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    sl<AthanAlarmNotificationRouterService>().initialize();
    unawaited(sl<DailyWirdRepository>().syncReminderSchedules());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !mounted) {
      return;
    }

    context.read<PrayerTimeBloc>().add(
          const PrayerTimeRefreshOnAppResumeRequested(),
        );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, res) async {
        showMyAlert(context: context);
      },
      // child: ,
      child: BlocBuilder<BaseBloc, BaseState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.scaffoldBackgroundColor,
            body: const HomeScreenNew(),
          );
        },
      ),
    );
  }
}
