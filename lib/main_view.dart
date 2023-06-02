import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_app/features/home_screen/pages/home_screen.dart';
import 'package:quran_app/core/Home/cubit.dart';
import 'package:quran_app/core/Home/state.dart';

import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';

import 'core/AppLocalizations/AppLocalizations.dart';
import 'core/services/get_cash_data.dart';
import 'core/services/services_notification.dart';
import 'core/util/exit_alert.dialog.dart';
import 'features/prayer_time/cubit/prayer_time_cubit.dart';
import 'features/quran/controller/repository_quran.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    print("==========================");
    print("initNotification");
    print("=======================");
    initNotification();
    FlutterNativeSplash.remove();

    print("done");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTimeCubit()..initPrayerTime(),
      child: MaterialApp(
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
        home: MainView(),
        darkTheme: getDarkMode(),
        theme: getLightMode(),
        title: 'بلغوا عني ',
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  void initNotification() async {
    notifyHelper = NotifyHelper();
    await notifyHelper.initializeNotification(context);
    await notifyHelper.initChannelAndroid();
    print("init Notification ");
  }
}

class MainView extends StatefulWidget {
  MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
    ControllerQuran.loadSurah();
    initCashValue();
    ToastServes.fToast = FToast();
    ToastServes.fToast!.init(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            await showDialog(
              context: context,
              builder: (context) => MyAlertDialog(),
            );
            return false;
          },
          child: const HomeScreen(),
        );
      },
    );
  }
}
