import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/core/widgets/app_scaffold/back_icon_widget.dart';
import 'package:quran_app/core/widgets/icon_button_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/download_quran_audio_bloc/download_quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/audio_search_body_widget.dart';
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

  ValueNotifier<bool> isBoxClosed = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    boxController.addListener(() {
      isBoxClosed.value = !boxController.isBoxOpen;
    });
  }

  @override
  void dispose() {
    boxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const appBarParts = 6;
    final appBarHeight = screenHeight / appBarParts;
    final actualAppBarHeight = appBarHeight < 85 ? 85 : appBarHeight;

    const double minHeightBox = 60;
    final maxHeightBox = screenHeight - actualAppBarHeight;

    return BlocProvider(
      create: (context) => DownloadQuranAudioBloc(),
      child: Scaffold(
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
                // margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    ValueListenableBuilder(
                      key: const ValueKey('default'),
                      valueListenable: isBoxClosed,
                      builder: (context, value, child) {
                        return value
                            ? AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: value ? 1 : 0,
                                child: value
                                    ? const BackIconWidget()
                                    : const SizedBox.shrink(),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    Gap(5.w),
                    Text(
                      'القرآن الكريم صوت',
                      textAlign: TextAlign.center,
                      style: context.titleMedium?.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
              searchBox: SearchBox(
                color: context.surfaceColor,
                controller: textEditingController,
                inputDecoration: InputDecoration(
                  hintText: 'ابحث عن سورة',
                  hintStyle: context.bodyMedium?.copyWith(
                    color: context.gray1,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.surfaceColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.surfaceColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.surfaceColor,
                    ),
                  ),
                ),
                style: context.bodyMedium,
                body: Container(
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                  ),
                  child: AudioSearchBodyWidget(
                    boxController: boxController,
                    textEditingController: textEditingController,
                  ),
                ),
              ),
              actions: [
                IconButtonWidget(
                  icon: const Icon(
                    CupertinoIcons.search,
                    // color: context.gray1,
                  ),
                  onPressed: () {
                    textEditingController.text = '';
                    boxController.showSearchBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
