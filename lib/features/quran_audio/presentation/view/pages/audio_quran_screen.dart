import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/backdrop_surah_list_audio_body_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/collapsed_quran_audio_body_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/current_surah_audio_play_widget.dart';

class AudioQuranScreen extends StatefulWidget {
  const AudioQuranScreen({super.key});

  @override
  State<AudioQuranScreen> createState() => _AudioQuranScreenState();
}

class _AudioQuranScreenState extends State<AudioQuranScreen> {
  final BoxController boxController = BoxController();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      boxController.setSearchBody(
        child: Center(
          child: Text(
            textEditingController.text != ''
                ? textEditingController.value.text
                : 'Empty',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    boxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            context.colorScheme.onSurface == ThemeMode.light
                ? Brightness.dark
                : Brightness.light,
        statusBarBrightness: context.colorScheme.onSurface == ThemeMode.light
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarIconBrightness:
            context.colorScheme.onSurface == ThemeMode.light
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarColor:
            context.colorScheme.onSurface == ThemeMode.light
                ? context.colorScheme.onSurface.withAlpha(10)
                : context.colorScheme.surface,
      ),
    );
    //
    final screenHeight = MediaQuery.of(context).size.height;
    const appBarParts = 6;
    final appBarHeight = screenHeight / appBarParts;
    final actualAppBarHeight = appBarHeight < 85 ? 85 : appBarHeight;

    const double minHeightBox = 60;
    final maxHeightBox = screenHeight - actualAppBarHeight;

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SlidingBox(
        controller: boxController,
        minHeight: minHeightBox,
        maxHeight: maxHeightBox,
        color: context.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        body: CollapsedQuranAudioBodyWidget(boxController: boxController),
        draggableIconVisible: false,
        collapsed: true,
        collapsedBody:
            CurrentSurahAudioPlayWidget(boxController: boxController),
        backdrop: Backdrop(
          fading: true,
          color: context.scaffoldBackgroundColor,
          body: BackdropSurahListAudioBodyWidget(
            boxController: boxController,
          ),
          appBar: BackdropAppBar(
            title: Container(
              margin: const EdgeInsets.only(left: 15),
              child: Text(
                'القرآن الكريم',
                textAlign: TextAlign.center,
                style: context.titleMedium?.copyWith(
                  fontSize: 22.sp,
                ),
              ),
            ),
            searchBox: SearchBox(
              controller: textEditingController,
              inputDecoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: context.colorScheme.onSurface,
                  fontSize: 18,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              style: TextStyle(
                color: context.colorScheme.onSurface,
                fontSize: 18,
              ),
              body: Center(
                child: Text(
                  'Search Result',
                  style: TextStyle(
                    color: context.colorScheme.onSurface,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurface.withAlpha(15),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: IconButton(
                  iconSize: 20,
                  icon: const Icon(
                    CupertinoIcons.search,
                    // color: context.primaryScheme,
                  ),
                  onPressed: () {
                    textEditingController.text = '';
                    boxController.showSearchBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
