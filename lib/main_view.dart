import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/core/theme/dark_theme.dart';

import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/home/widgets/custom_bottom_navigation_bar2.dart';
import 'package:quran_app/features/home/widgets/next_player.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

import 'core/AppLocalizations/AppLocalizations.dart';
import 'core/util/exit_alert.dialog.dart';
import 'features/prayer_time/cubit/prayer_time_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PrayerTimeCubit()..initPrayerTime(),
        ),
        BlocProvider(create: (context) => AudioCubit()..initAudioPlayer()),
        //
        BlocProvider(
            create: (context) =>
                ThemeBloc()..add(ChangeThemeEvent(theme: currentThemeType))),
        BlocProvider(create: (context) => BaseBloc()),
        BlocProvider(create: (context) => BookmarkBloc()),
        BlocProvider(
          lazy: false,
          create: (context) => ReadQuranBloc()..add(LoadQuranEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) => MaterialApp(
              builder: BotToastInit(), //1. call BotToastInit
              navigatorObservers: [
                BotToastNavigatorObserver()
              ], //2. registered route observer

              locale: const Locale('ar'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
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
              darkTheme: getDarkTheme(),
              theme: getLightMode(),
              title: 'طمأنينة',
              themeMode: ThemeMode.dark,
              navigatorKey: NavigationService.navigatorKey,
              debugShowCheckedModeBanner: false,
              home: const _App(),
            ),
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
          return BaseHome(
            titleWidget: currentPage == 0 ? const NextTimePrayerRemain() : null,
            back: false,
            title: "",
            isScroll: currentPage == 2 ? false : true,
            bottomNavigationBar: const CustomBottomNavigationBar(),
            body: screens[currentPage],
          );
        },
      ),
    );
  }
}
