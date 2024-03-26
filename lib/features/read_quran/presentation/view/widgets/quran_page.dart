import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

import 'package:quran_app/features/read_quran/presentation/view/widgets/pages_widget.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/top_title_widget.dart';
import 'package:quran_app/main.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({Key? key}) : super(key: key);

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  @override
  void initState() {
    if (lastPageRead != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ReadQuranBloc>().pageController.jumpToPage(lastPageRead);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final quranCtrl = context.read<ReadQuranBloc>().quranRH;
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, state) {
        return Container(
          padding: context.customOrientation(
              const EdgeInsets.symmetric(vertical: 8.0),
              const EdgeInsets.symmetric(vertical: 0.0)),
          height: context.getScreenHeight(),
          child: quranCtrl.pages.isEmpty
              ? const Center(child: CircularProgressIndicator.adaptive())
              : PageView.builder(
                  itemCount: 604,
                  controller: context.read<ReadQuranBloc>().pageController,
                  padEnds: false,
                  onPageChanged: (val) async {
                    lastPageRead = val;

                    if (context.mounted) {
                      BlocProvider.of<BookmarkBloc>(context)
                          .add(SetStateBookmarkEvent());
                    }
                  },
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (_, index) {
                    return Center(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: TopTitleWidget(
                              index: index,
                              isRight: true,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final width = constraints.maxWidth;
                                var horizontal = 30.0;
                                if (width <= 400) {
                                  horizontal = 30.0;
                                }

                                if (width > 400) {
                                  horizontal = 25.0;
                                }
                                logger.d(width.round());

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontal,
                                  ),
                                  child: PagesWidget(pageIndex: index),
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              convertNumbers('${index + 1}'),
                              style: TextStyle(
                                fontSize: context.customOrientation(18.0, 22.0),
                                fontFamily: 'naskh',
                                color: const Color(0xff77554B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
