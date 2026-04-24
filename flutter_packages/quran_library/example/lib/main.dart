// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quran_library/quran_library.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await QuranLibrary.init();
  QuranLibrary.initWordAudio();
  runApp(
    // DevicePreview(
    //   builder: (context) => const MyApp(),
    // ),
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    const TextScaler fixedScaler = TextScaler.linear(1.0);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      locale: const Locale('ar'),
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
        ),
        primaryColor: Colors.teal,
        useMaterial3: false,
      ),
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: fixedScaler),
          child: child!,
        );
      },
      home: const Scaffold(
        // body: SingleAyah(),
        // body: SingleSurah(),
        // body: QuranPages(),
        body: FullQuran(),
      ),
    );
  }
}

class FullQuran extends StatelessWidget {
  const FullQuran({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return QuranLibraryScreen(
      parentContext: context,
      isDark: false,
      isShowTabBar: true,
      isFontsLocal: false,
      useDefaultAppBar: true,
      enableWordSelection: true,
      isShowDisplayModeBar: true,
      showAyahBookmarkedIcon: true,
      appLanguageCode: 'ar',
      // appIconPathForPlayAudioInBackground:
      //     'assets/images/quran_library_logo.png',
      // isAyahBookmarked: (ayah) =>
      //     ayah.ayahUQNumber == 12 && ayah.surahNumber == 2,
      ayahMenuStyle:
          AyahMenuStyle.defaults(isDark: false, context: context).copyWith(
        customMenuItems: [
          const Icon(Icons.share, size: 28, color: Colors.teal),
        ],
      ),
      // ayahIconColor: Colors.teal,
      // backgroundColor: Colors.white,
      // textColor: Colors.black,
      // tafsirStyle:
      //     TafsirStyle.defaults(isDark: false, context: context).copyWith(
      //   widthOfBottomSheet: 500,
      //   heightOfBottomSheet: MediaQuery.sizeOf(context).height * 0.9,
      //   changeTafsirDialogHeight: MediaQuery.sizeOf(context).height * 0.9,
      //   changeTafsirDialogWidth: 400,
      // ),
      // anotherMenuChild:
      //     const Icon(Icons.play_arrow_outlined, size: 28, color: Colors.teal),
      // anotherMenuChildOnTap: (ayah) {
      //   // SurahAudioController.instance.state.currentAyahUnequeNumber =
      //   //     ayah.ayahUQNumber;
      //   AudioCtrl.instance
      //       .playAyah(context, ayah.ayahUQNumber, playSingleAyah: true);
      //   log('Another Menu Child Tapped: ${ayah.ayahUQNumber}');
      // },
      // secondMenuChild:
      //     const Icon(Icons.playlist_play, size: 28, color: Colors.teal),
      // secondMenuChildOnTap: (ayah) {
      //   // SurahAudioController.instance.state.currentAyahUnequeNumber =
      //   //     ayah.ayahUQNumber;
      //   AudioCtrl.instance
      //       .playAyah(context, ayah.ayahUQNumber, playSingleAyah: false);
      //   log('Second Menu Child Tapped: ${ayah.ayahUQNumber}');
      // },
    );
  }
}

class SingleSurah extends StatelessWidget {
  const SingleSurah({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SurahDisplayScreen(
      parentContext: context,
      surahNumber: 2,
      isDark: false,
      appLanguageCode: 'ar',
      useDefaultAppBar: true,
    );
  }
}

class SingleAyah extends StatelessWidget {
  const SingleAyah({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GetSingleAyah(
        surahNumber: 1,
        ayahNumber: 2,
        fontSize: 30,
        isBold: false,
        islocalFont: false,
        isDark: true,
        textHeight: 1.5,
        enabledTajweed: true,
        enableWordSelection: true,
        onWordTap: (ref) {
          print(
              'سورة: ${ref.surahNumber}, آية: ${ref.ayahNumber}, كلمة: ${ref.wordNumber}');
        },
        selectedWordColor: Colors.amber.withValues(alpha: 0.3),
      ),
    );
  }
}

class QuranPages extends StatelessWidget {
  const QuranPages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QuranPagesScreen(
        parentContext: context,
        enableMultiSelect: true,
        // highlightedAyahNumbersBySurah: {
        //   2: [7, 8, 9, 10, 11, 12],
        // },
        // page: 6,
        startPage: 6,
        endPage: 60, // النطاق شامل
        // highlightedAyahNumbersInPages: [
        //   (
        //     start: 3,
        //     end: 5,
        //     ayahs: [7, 8, 9, 10, 11, 12],
        //   )
        // ],
        highlightedRanges: const [
          (startSurah: 2, startAyah: 30, endSurah: 2, endAyah: 35)
        ],
        withPageView: true, // تمكين/تعطيل السحب بين الصفحات
      ),
    );
  }
}
