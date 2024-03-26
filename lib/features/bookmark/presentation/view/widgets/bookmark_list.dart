import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/book_mark_page_tab.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/bookmark_aya_tab.dart';

class BookMarkList extends StatelessWidget {
  BookMarkList({super.key});

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const Gap(6),
            Container(
              height: 40,
              padding: const EdgeInsets.all(4.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: currentThemeData.colorScheme.primary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: TabBar(
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: TextStyle(
                  color: currentThemeData.hintColor,
                  fontFamily: 'kufi',
                  fontSize: 11,
                ),
                indicator: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color:
                      currentThemeData.colorScheme.background.withOpacity(.3),
                ),
                tabs: [
                  Tab(
                    child: Text(
                      'الصفحات',
                      style: TextStyle(
                        color: currentThemeData.canvasColor,
                        fontSize: 12,
                        fontFamily: 'kufi',
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'الايات',
                      style: TextStyle(
                        color: currentThemeData.canvasColor,
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
            )
          ],
        ),
      ),
    );
  }
}
