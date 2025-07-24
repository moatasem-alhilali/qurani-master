import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/sheet/animated_bottom_resize_sheet.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/controller_audio_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/new/surah_verse_reader_list_widget.dart';

class CollapsedBodyWidget extends StatelessWidget {
  const CollapsedBodyWidget({
    required this.boxController,
    super.key,
  });
  final BoxController boxController;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const appBarParts = 6;
    final appBarHeight = screenHeight / appBarParts;
    final actualAppBarHeight = appBarHeight < 85 ? 85 : appBarHeight;
    final maxHeightBox = screenHeight - actualAppBarHeight;
    return Container(
      height: maxHeightBox,
      decoration: BoxDecoration(
        // color: context.primaryScheme,
        // gradient: LinearGradient(
        //   stops: const [0, 0.58],
        //   begin: Alignment.bottomCenter,
        //   end: Alignment.topCenter,
        //   colors: [
        //     context.colorScheme.onSurface,
        //     context.scaffoldBackgroundColor,
        //   ],
        // ),
        gradient: LinearGradient(
          stops: const [
            0.40,
            1,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            context.secondary,
            context.primaryScheme,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    if (boxController.isAttached) boxController.closeBox();
                  },
                  color: Theme.of(context).colorScheme.onSurface,
                  iconSize: 24,
                  icon: const Icon(CupertinoIcons.chevron_down),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      color: Theme.of(context).colorScheme.onSurface,
                      iconSize: 21,
                      icon: const Icon(Icons.share_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      color: Theme.of(context).colorScheme.onSurface,
                      iconSize: 22,
                      icon: const Icon(CupertinoIcons.volume_up),
                    ),
                    IconButton(
                      onPressed: () {},
                      color: Theme.of(context).colorScheme.onSurface,
                      iconSize: 22,
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<QuranAudioBloc, QuranAudioState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                        maxHeight: 500,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            spreadRadius: 7,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        state.currentAudioData?.nameReader?.substring(0, 1) ??
                            '',
                        style: TextStyle(
                          fontSize: 22,
                          color: context.primaryScheme,
                        ),
                      ),
                    ),
                    StyleButtonWrap(
                      onTap: () {
                        context.showAnimatedBottomResizeSheet(
                          builder: (scrollController) =>
                              SurahVerseReaderListWidget(
                            scrollController: scrollController,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Text(
                              state.currentAudioData?.nameSurah ?? '',
                              textAlign: TextAlign.center,
                              style: context.titleMedium.copyWith(
                                  // color: Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              state.currentAudioData?.nameReader ?? '',
                              textAlign: TextAlign.center,
                              style: context.titleMedium.copyWith(
                                fontSize: 14,
                                // color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            // height: maxHeightBox * 0.3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.music_note_list,
                        // color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.heart,
                        // color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.plus,
                        // color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                const ProgressWithControllerWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
