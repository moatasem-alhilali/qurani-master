import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:quran_app/core/Home/state.dart';
import 'package:quran_app/core/bloc/base_bloc.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/services/permission_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';

import 'package:quran_app/core/BlocObserver/BlocObserver.dart';
import 'package:quran_app/core/Home/cubit.dart';
import 'package:quran_app/features/read_quran/data/data_source/data_client.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'features/my_adia/core/db/db_helper_note.dart';
import 'main_view.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

Logger logger = Logger();
//flutter build appbundle --release --no-sound-null-safety

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  //
  Bloc.observer = MyBlocObserver();
  await DBHelperDou.initDb();
  await DioHelper.init();
  DBHelper.initDb();
  await CashHelper.init();
  lastPageRead = CashHelper.getInt(key: 'lastPageRead') ?? 0;
  currentThemeType = CashHelper.getInt(key: 'currentThemeType') ?? 0;
  setupServiceLocator();
  serviceEnabled = await PermissionService.locationEnabled();

  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }

  await PermissionService.handelNotification();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AudioCubit()..initAudioPlayer(),
        ),

        //Home Cubit
        BlocProvider(create: (context) => HomeCubit()..checkConnection()),

        // BlocProvider(create: (context) => QuranCubit()),

        BlocProvider(create: (context) => BaseBloc()),
        BlocProvider(create: (context) => BookmarkBloc()),
        BlocProvider(
            lazy: false,
            create: (context) => ReadQuranBloc()..add(LoadQuranEvent())),

        //
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return const MyApp();
        },
      ),
    ),
  );
}

Future<Database?> getDatabase() async {
  try {
    return await sl<DataBaseClient>().database;
  } catch (e) {
    logger.e(e);
  }
  return null;
}
//https://raw.githubusercontent.com/islamic-network/cdn/master/info/cdn_surah_audio.json

//https://api.alquran.cloud/v1/edition/format/audio

//ai:https://islam-ai-api.p.rapidapi.com/api/bot?question="اهميه الصلاة"
//ai:https://islam-ai-api.p.rapidapi.com/api/chat?question="اهميه الصلاة"

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
