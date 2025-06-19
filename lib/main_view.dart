import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/app_localizations/AppLocalizations.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/notification/bloc/notification_bloc.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/exit_alert.dialog.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/home/presentation/view/widgets/bottom_navigation_bar_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/next_time_prayer_remain_widget.dart';
import 'package:quran_app/features/prayer_time/data/database/database_coordinates_service.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/prayer_time/presentation/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/setting/presentation/bloc/setting_notification_bloc.dart';

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
        ),

        ///theme
        BlocProvider(
          create: (context) =>
              ThemeBloc()..add(ChangeThemeEvent(theme: currentThemeType)),
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
          create: (context) => ReadQuranBloc()..add(LoadQuranEvent()),
        ),

        ///notification
        BlocProvider(
          create: (context) =>
              NotificationBloc()..add(InitializeNotificationEvent()),
          lazy: false,
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return BlocConsumer<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return ScreenUtilInit(
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (_, child) => MaterialApp(
                  builder: BotToastInit(), //1. call BotToastInit
                  navigatorObservers: [
                    BotToastNavigatorObserver(),
                  ], //2. registered route observer

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
                  // darkTheme: getDarkMode(),
                  darkTheme: context.themeApp,
                  theme: getLightMode(),
                  title: 'طمأنينة',
                  themeMode: ThemeMode.dark,
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

class _App extends StatelessWidget {
  const _App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        showMyAlert(context: context);
      },
      // child: ,
      child: BlocBuilder<BaseBloc, BaseState>(
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                SettingNotificationBloc(sl())..add(LoadNotificationSettings()),
            child: BaseHome(
              titleWidget:
                  currentPage == 0 ? const NextTimePrayerRemainWidget() : null,
              back: false,
              title: 'طمأنينة',
              isScroll: currentPage == 2 ? false : true,
              bottomNavigationBar: const CustomBottomNavigationBarWidget(),
              body: screens[currentPage],
            ),
          );
        },
      ),
    );
  }
}
