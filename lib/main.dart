import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/Home/state.dart';
import 'package:quran_app/features/offline_audio/cubit/offline_cubit.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';

import 'package:quran_app/core/BlocObserver/BlocObserver.dart';
import 'package:quran_app/core/Home/cubit.dart';
import 'package:quran_app/core/local/db.dart';
import 'package:quran_app/features/sabih/cubit/subih_cubit.dart';
import 'package:quran_app/features/search_ayah/cubit/serch_ayah_cubit.dart';
import 'features/my_adia/core/adia_cubit_cubit.dart';
import 'features/my_adia/core/db/db_helper_note.dart';
import 'features/quran/controller/db_helper.dart';
import 'main_view.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }
  //
  Bloc.observer = MyBlocObserver();
  await DBHelperDou.initDb();
  await DBHelperAudio.initDb();
  await DBHelperQuran.initDb();

  await CashHelper.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AudioCubit()..initAudioPlayer(),
        ),

        //Home Cubit
        BlocProvider(create: (context) => HomeCubit()..checkConnection()),
        //Adia Cubit
        BlocProvider(create: (context) => AdiaCubitCubit()..getDoa()),
        //Quran Cubit
        BlocProvider(create: (context) => QuranCubit()..getBookMark()),
        //Subih Cubit
        BlocProvider(create: (context) => SubihCubit()),
        //Search Ayah Cubit
        BlocProvider(create: (context) => SearchAyahCubit()),
        //Offline Cubit
        BlocProvider(create: (context) => OfflineCubit()..getAudioPath()),
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
