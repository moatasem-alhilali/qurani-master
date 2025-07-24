import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/new/backdrop_music_body_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/new/collapsed._body_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/new/current_surah_audio_play_widget.dart';

class SlidingBoxExamplePage extends StatefulWidget {
  const SlidingBoxExamplePage({super.key});

  @override
  State<SlidingBoxExamplePage> createState() => _SlidingBoxExamplePageState();
}

class _SlidingBoxExamplePageState extends State<SlidingBoxExamplePage> {
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
        body: CollapsedBodyWidget(boxController: boxController),
        draggableIconVisible: false,
        collapsed: true,
        collapsedBody:
            CurrentSurahAudioPlayWidget(boxController: boxController),
        backdrop: Backdrop(
          fading: true,
          color: context.scaffoldBackgroundColor,
          body: const BackdropMusicBodyWidget(),
          appBar: BackdropAppBar(
            title: Container(
              margin: const EdgeInsets.only(left: 15),
              child: Text(
                'Music Player',
                style: TextStyle(
                  fontSize: 22,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
            searchBox: SearchBox(
              controller: textEditingController,
              color: context.colorScheme.surface,
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
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(25),
                  child: IconButton(
                    iconSize: 27,
                    icon: Icon(
                      Icons.search_rounded,
                      color: context.colorScheme.primary,
                    ),
                    onPressed: () {
                      textEditingController.text = '';
                      boxController.showSearchBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
