import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/book_mark_page_tab.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/bookmark_aya_tab.dart';

class BookMarkList extends StatelessWidget {
  BookMarkList({super.key});

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const Gap(6),
            Container(
              height: 40,
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: context.quranTheme.colorScheme.primary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: TabBar(
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: TextStyle(
                  color: context.quranTheme.hintColor,
                  fontFamily: 'kufi',
                  fontSize: 11,
                ),
                indicator: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color:
                      context.quranTheme.colorScheme.background.withOpacity(.3),
                ),
                tabs: [
                  Tab(
                    child: Text(
                      'الصفحات',
                      style: TextStyle(
                        color: context.quranTheme.canvasColor,
                        fontSize: 12,
                        fontFamily: 'kufi',
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'الايات',
                      style: TextStyle(
                        color: context.quranTheme.canvasColor,
                        fontSize: 12,
                        fontFamily: 'kufi',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  const BookmarkPageTab(),
                  BookmarkAyahTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
