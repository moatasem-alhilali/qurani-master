import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/app_localizations/AppLocalizations.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/dark_theme.dart';
import 'package:quran_app/core/util/exit_alert.dialog.dart';
import 'package:quran_app/core/util/light_theme.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/home/presentation/bloc/random_ayah_bloc.dart';
import 'package:quran_app/features/home/presentation/view/widgets/bottom_navigation_bar_widget.dart';
import 'package:quran_app/features/manage_version/data/datasources/version_cache_datasource.dart';
import 'package:quran_app/features/manage_version/data/datasources/version_remote_datasource.dart';
import 'package:quran_app/features/manage_version/data/repositories/version_repository_impl.dart';
import 'package:quran_app/features/manage_version/presentation/bloc/version_bloc.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/old_read_quran/old_read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/features/search/data/database/quran_search_datasource.dart';
import 'package:quran_app/features/search/presentation/bloc/search_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ///prayer time
        BlocProvider(
          create: (context) => PrayerTimeCubit(
            prayerTimeService: AdhanPrayerTimeService(),
            coordinatesService: DatabaseCoordinatesService(),
          )..initPrayerTime(),
        ),

        ///connectivity
        BlocProvider(
          create: (context) =>
              sl<ConnectivityBloc>()..add(const ConnectivityStarted()),
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

        ///quran audio
        BlocProvider(
          create: (context) =>
              sl<QuranAudioBloc>()..add(InitQuranPlayerDataEvent()),
          lazy: false,
        ),

        ///base
        BlocProvider(create: (context) => BaseBloc()),

        ///bookmark
        BlocProvider(
          create: (context) => sl<BookmarkBloc>()
            ..add(GetBookmarksAyahEvent())
            ..add(GetBookmarksPageEvent()),
          lazy: false,
        ),

        ///read quran
        BlocProvider(
          lazy: false,
          create: (context) => OldReadQuranBloc()..add(OldLoadQuranEvent()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => ReadQuranBloc()..add(LoadQuranEvent()),
        ),

        ///notification
        BlocProvider(
          create: (context) =>
              NotificationBloc()..add(InitializeNotificationEvent()),
          lazy: false,
        ),

        ///search
        BlocProvider(
          create: (context) => SearchBloc(
            repositoryImpl: sl<QuranSearchDataSource>(),
          ),
          // lazy: false,
        ),

        ///home
        BlocProvider(
          create: (context) => sl<RandomAyahBloc>()..add(GetRandomAyahEvent()),
          lazy: false,
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocConsumer<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) {
              // TODO: implement listener
            },
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
  const _App({
    super.key,
  });

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
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
            // titleWidget: const SizedBox(),
            // back: false,
            // title: 'طمأنينة',
            // showBackground: currentPage == 0 ? false : true,
            // isScroll: currentPage == 2 ? false : true,
            bottomNavigationBar: const IntrinsicHeight(
              child: ColoredBox(
                color: Colors.transparent,
                child: SafeArea(
                  top: false,
                  child: CustomBottomNavigationBarWidget(),
                ),
              ),
            ),
            body: SafeArea(child: screens[currentPage]),
          );
        },
      ),
    );
  }
}
