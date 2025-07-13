import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_header_widget.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_icon_widget.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_text_widget.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/audios/presentation/view/pages/base_audio_screen.dart';
import 'package:quran_app/features/categories/data/json/quran_json.dart';
import 'package:quran_app/features/categories/data/json/serah_json.dart';
import 'package:quran_app/features/categories/data/model/category_section_model.dart';
import 'package:quran_app/features/categories/data/model/section_type_model.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_detail_option_screen.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_view_all_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BaseHederWidget(text: 'القرأن الكريم وعلومه'),
        SizedBox(
          height: context.getHight(20),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FeatureCardIconWidget(
                  title: 'تلاوات مشهوره',
                  icon: const Icon(Icons.volume_up_rounded),
                  onTap: () {
                    context.push(
                      BaseAudioScreen(
                        id: '364764',
                        title: 'تلاوات مشهوره',
                      ),
                    );
                  },
                  maxLines: 1,
                  width: context.getWidth(30),
                  height: context.getHight(18),
                ),
                FeatureCardIconWidget(
                  title: 'تعليم اطفال',
                  icon: const Icon(Icons.child_care_rounded),
                  onTap: () {
                    context.push(
                      BaseAudioScreen(
                        id: '364777',
                        title: 'تعليم اطفال',
                      ),
                    );
                  },
                  maxLines: 1,
                  shapeType: CardShapeType.stars,
                  width: context.getWidth(35),
                  height: context.getHight(18),
                ),
                FeatureCardIconWidget(
                  title: 'تلاوات بروايات',
                  icon: const Icon(Icons.library_books_rounded),
                  onTap: () {
                    context.push(
                      BaseAudioScreen(
                        id: '364774',
                        title: 'تلاوات بروايات وقراءات',
                      ),
                    );
                  },
                  maxLines: 1,
                  shapeType: CardShapeType.diamonds,
                  width: context.getWidth(35),
                  height: context.getHight(18),
                ),
                FeatureCardIconWidget(
                  title: 'مصاحف الحرمين',
                  icon: const Icon(Icons.mosque_rounded),
                  onTap: () {
                    context.push(
                      BaseAudioScreen(
                        id: '364771',
                        title: 'مصاحف الحرمين',
                      ),
                    );
                  },
                  maxLines: 1,
                  shapeType: CardShapeType.hexagons,
                  width: context.getWidth(35),
                  height: context.getHight(18),
                ),
                FeatureCardIconWidget(
                  title: 'مصاحف مترجمة معانيها',
                  icon: const Icon(Icons.translate_rounded),
                  onTap: () {
                    context.push(
                      BaseAudioScreen(
                        id: '364768',
                        title: 'مصاحف مترجمة معانيها',
                      ),
                    );
                  },
                  shapeType: CardShapeType.triangles,
                  maxLines: 1,
                  width: context.getWidth(35),
                  height: context.getHight(18),
                ),
                FeatureCardIconWidget(
                  title: 'مصاحف مترجمة',
                  icon: const Icon(Icons.g_translate_rounded),
                  maxLines: 1,
                  onTap: () {
                    context.push(
                      BaseAudioScreen(
                        id: '691',
                        title: 'مصاحف مترجمة ',
                      ),
                    );
                  },
                  shapeType: CardShapeType.waves,
                  width: context.getWidth(35),
                  height: context.getHight(18),
                ),
              ],
            ),
          ),
        ),
        const BaseHederWidget(text: 'تصنيفات '),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1 / 1.3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
          ),
          children: [
            CategorySectionItem(
              title: 'فيديوهات',
              icon: const Icon(Icons.video_library_rounded),
              data: _getCategorySectionData()[0],
            ),
            CategorySectionItem(
              title: 'كتب',
              icon: const Icon(Icons.menu_book_rounded),
              data: _getCategorySectionData()[1],
              shapeType: CardShapeType.stars,
            ),
            CategorySectionItem(
              title: 'قصص',
              icon: const Icon(Icons.auto_stories_rounded),
              data: _getCategorySectionData()[2],
              shapeType: CardShapeType.diamonds,
            ),
            CategorySectionItem(
              title: 'اصوات',
              icon: const Icon(Icons.audiotrack_rounded),
              data: _getCategorySectionData()[3],
              shapeType: CardShapeType.hexagons,
            ),
            CategorySectionItem(
              title: 'فتاوي',
              icon: const Icon(Icons.balance_rounded),
              data: _getCategorySectionData()[4],
              shapeType: CardShapeType.triangles,
            ),
            CategorySectionItem(
              title: 'قرأن',
              icon: const Icon(Icons.import_contacts_rounded),
              data: _getCategorySectionData()[5],
              shapeType: CardShapeType.waves,
            ),
            CategorySectionItem(
              title: 'عروض تقديميه',
              icon: const Icon(Icons.slideshow_rounded),
              data: _getCategorySectionData()[6],
            ),
            CategorySectionItem(
              title: 'اخبار',
              icon: const Icon(Icons.newspaper_rounded),
              data: _getCategorySectionData()[7],
              shapeType: CardShapeType.stars,
            ),
            CategorySectionItem(
              title: 'مقالات',
              icon: const Icon(Icons.article_rounded),
              data: _getCategorySectionData()[8],
              shapeType: CardShapeType.diamonds,
            ),
            CategorySectionItem(
              title: 'تطبيقات',
              icon: const Icon(Icons.apps_rounded),
              data: _getCategorySectionData()[9],
              shapeType: CardShapeType.hexagons,
            ),
            CategorySectionItem(
              title: 'خطب',
              icon: const Icon(Icons.record_voice_over_rounded),
              data: _getCategorySectionData()[10],
              shapeType: CardShapeType.triangles,
            ),
          ],
        ),
        const BaseHederWidget(text: 'الاقسام '),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1 / 1.3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
          ),
          children: [
            QuranCategory(
              data: quranJson,
              title: 'القرأن',
              icon: const Icon(Icons.menu_book_rounded),
            ),
            QuranCategory(
              data: sonaJson,
              title: 'السنه',
              icon: const Icon(Icons.star_rounded),
              shapeType: CardShapeType.stars,
            ),
            QuranCategory(
              data: serahNabawyJson,
              title: 'السيرة النبوية',
              icon: const Icon(Icons.person_rounded),
              shapeType: CardShapeType.diamonds,
            ),
            QuranCategory(
              data: aqidaJson,
              title: 'العقيدة',
              icon: const Icon(Icons.psychology_rounded),
              shapeType: CardShapeType.hexagons,
            ),
            QuranCategory(
              data: fikhJson,
              title: 'فقه',
              icon: const Icon(Icons.gavel_rounded),
              shapeType: CardShapeType.triangles,
            ),
            QuranCategory(
              data: kotabManbrJson,
              title: 'الخطب المنبرية',
              icon: const Icon(Icons.campaign_rounded),
              shapeType: CardShapeType.waves,
            ),
            QuranCategory(
              data: fdaelJson,
              title: 'فضائل الأقوال',
              icon: const Icon(Icons.favorite_rounded),
            ),
            QuranCategory(
              data: dawaForAllhJson,
              title: 'الدعوة إلى الله',
              icon: const Icon(Icons.volunteer_activism_rounded),
              shapeType: CardShapeType.stars,
            ),
            QuranCategory(
              data: historyJson,
              title: 'التاريخ',
              icon: const Icon(Icons.history_edu_rounded),
              shapeType: CardShapeType.diamonds,
            ),
            QuranCategory(
              data: arabicLangJson,
              title: 'اللغة العربية',
              icon: const Icon(Icons.language_rounded),
              shapeType: CardShapeType.hexagons,
            ),
            QuranCategory(
              data: studyIslamic,
              title: 'دراسات إسلامية',
              icon: const Icon(Icons.school_rounded),
              shapeType: CardShapeType.triangles,
            ),
            QuranCategory(
              data: lessonJson,
              title: 'الدروس العلمية',
              icon: const Icon(Icons.class_rounded),
              shapeType: CardShapeType.waves,
            ),
            QuranCategory(
              data: kabaerJson,
              title: 'الكبائر والمحرمات',
              icon: const Icon(Icons.warning_rounded),
            ),
          ],
        ),
      ],
    );
  }
}

class CategorySectionItem extends StatelessWidget {
  const CategorySectionItem({
    required this.title,
    required this.icon,
    required this.data,
    super.key,
    this.shapeType = CardShapeType.circles,
  });

  final String title;
  final Widget icon;
  final CategorySectionModel data;
  final CardShapeType shapeType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FeatureCardIconWidget(
            icon: icon,
            onTap: () {
              context.push(
                CategoryDetailOptionScreen(
                  category: data,
                ),
              );
            },
            shapeType: shapeType,
          ),
        ),
        SizedBox(height: 5.h),
        title.autoSize(
          context,
          maxLines: 3,
          minFontSize: 10,
          fontSize: 11.sp,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class QuranCategory extends StatelessWidget {
  const QuranCategory({
    required this.title,
    required this.data,
    super.key,
    this.icon,
    this.shapeType = CardShapeType.circles,
  });
  final List<Map<String, dynamic>> data;
  final String title;
  final Widget? icon;
  final CardShapeType shapeType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FeatureCardIconWidget(
            icon: icon ??
                const Icon(
                  Icons.category_rounded,
                  color: Colors.red,
                ),
            onTap: () {
              context.push(
                CategoryViewAllScreen(
                  data: data.map(SectionTypeModel.fromJson).toList(),
                  title: title,
                ),
              );
            },
            shapeType: shapeType,
          ),
        ),
        SizedBox(height: 5.h),
        title.autoSize(
          context,
          maxLines: 3,
          minFontSize: 10,
          fontSize: 11.sp,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

List<CategorySectionModel> _getCategorySectionData() {
  return [
    CategorySectionModel(
      title: 'فيديوهات',
      type: 'section',
      itemsCount: 1010,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/videos/ar/ar/1/25/json',
    ),
    CategorySectionModel(
      title: 'كتب',
      type: 'section',
      itemsCount: 4984,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/books/ar/ar/1/25/json',
    ),
    CategorySectionModel(
      title: 'قصص',
      type: 'section',
      itemsCount: 1703,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/articles/ar/ar/1/25/json',
    ),
    CategorySectionModel(
      title: 'اصوات',
      type: 'section',
      itemsCount: 4057,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/audios/ar/ar/1/25/json',
    ),
    CategorySectionModel(
      title: 'فتاوي',
      type: 'section',
      itemsCount: 527,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/fatwa/ar/ar/1/25/json',
    ),
    CategorySectionModel(
      title: 'قرأن',
      type: 'section',
      itemsCount: 164,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/quran/ar/ar/1/25/json',
    ),
    CategorySectionModel(
      title: 'عروض تقديميه',
      type: 'section',
      itemsCount: 5,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/cards/ar/ar/1/25/json',
    ),
    CategorySectionModel(
      title: 'اخبار',
      type: 'section',
      itemsCount: 1,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/news/ar/ar/1/25/json',
    ),
    CategorySectionModel(
      title: 'مقالات',
      type: 'section',
      itemsCount: 275,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/poster/ar/ar/1/25/json',
    ),
    CategorySectionModel(
      title: 'تطبيقات',
      type: 'section',
      itemsCount: 55,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/apps/ar/ar/1/25/json',
    ),
    CategorySectionModel(
      title: 'خطب',
      type: 'section',
      itemsCount: 288,
      apiUrl:
          'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/khotab/ar/ar/1/25/json',
    ),
  ];
}
