import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/audios/presentation/view/pages/base_audio_screen.dart';
import 'package:quran_app/features/categories/data/json/quran_json.dart';
import 'package:quran_app/features/categories/data/json/serah_json.dart';
import 'package:quran_app/features/categories/data/model/category_section_model.dart';
import 'package:quran_app/features/categories/data/model/section_type_model.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_detail_option_screen.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_view_all_screen.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/category_skin_widgets.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';

/// المكتبة: ثلاث مجموعات، كل مجموعة عنوان نحيل وشبكة مربّعات أيقونات.
///
/// كانت الشاشة بطاقات كبيرة بأشكال زخرفية تتنافس على النظر؛ صارت أيقونات
/// صغيرة تحت عناوينها، والأرضية واحدة تفصلها خطوط شعرة.
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        title: 'المكتبة',
        body: ColoredBox(
          color: skin.ground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeSectionHeader(title: 'القرآن الكريم وعلومه'),
              CategoryTileGrid(tiles: _recitationTiles(context)),
              SizedBox(height: 6.h),
              skin.divider(),
              const HomeSectionHeader(title: 'تصنيفات'),
              CategoryTileGrid(tiles: _sectionTiles(context)),
              SizedBox(height: 6.h),
              skin.divider(),
              const HomeSectionHeader(title: 'الأقسام'),
              CategoryTileGrid(tiles: _libraryTiles(context)),
              SizedBox(height: 22.h),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _recitationTiles(BuildContext context) {
    const entries = <({String id, String title, String label})>[
      (id: '364764', title: 'تلاوات مشهورة', label: 'تلاوات مشهورة'),
      (id: '364777', title: 'تعليم أطفال', label: 'تعليم أطفال'),
      (
        id: '364774',
        title: 'تلاوات بروايات وقراءات',
        label: 'تلاوات بروايات',
      ),
      (id: '364771', title: 'مصاحف الحرمين', label: 'مصاحف الحرمين'),
      // أقسام صوتية أخرى متاحة في الواجهة الخلفية ومعطّلة حاليًا:
      // (id: '364768', title: 'مصاحف مترجمة معانيها', ...),
      // (id: '691', title: 'مصاحف مترجمة', ...),
    ];

    return [
      for (final entry in entries)
        CategoryTile(
          label: entry.label,
          icon: AppIcons.sound,
          onTap: () => context.push(
            BaseAudioScreen(id: entry.id, title: entry.title),
          ),
        ),
    ];
  }

  List<Widget> _sectionTiles(BuildContext context) {
    final data = _getCategorySectionData();

    const picks = <({int index, String label, HugeIconData icon})>[
      // (index: 0, label: 'فيديوهات', icon: AppIcons.news),
      (index: 1, label: 'كتب', icon: AppIcons.menuBook),
      (index: 2, label: 'قصص', icon: AppIcons.bookOpen),
      (index: 3, label: 'أصوات', icon: AppIcons.sound),
      // (index: 4, label: 'فتاوى', icon: AppIcons.list),
      (index: 5, label: 'قرآن', icon: AppIcons.quran),
      // (index: 6, label: 'عروض تقديمية', icon: AppIcons.layers),
      // (index: 7, label: 'أخبار', icon: AppIcons.news),
      // (index: 8, label: 'مقالات', icon: AppIcons.noteEdit),
      // (index: 9, label: 'تطبيقات', icon: AppIcons.widgets),
      // (index: 10, label: 'خطب', icon: AppIcons.sound),
    ];

    return [
      for (final pick in picks)
        CategoryTile(
          label: pick.label,
          icon: pick.icon,
          onTap: () => context.push(
            CategoryDetailOptionScreen(category: data[pick.index]),
          ),
        ),
    ];
  }

  List<Widget> _libraryTiles(BuildContext context) {
    final sections = <({
      String title,
      HugeIconData icon,
      List<Map<String, dynamic>> data,
    })>[
      (title: 'القرآن', icon: AppIcons.quran, data: quranJson),
      (title: 'السنة', icon: AppIcons.star, data: sonaJson),
      (title: 'السيرة النبوية', icon: AppIcons.user, data: serahNabawyJson),
      (title: 'العقيدة', icon: AppIcons.allah, data: aqidaJson),
      (title: 'فقه', icon: AppIcons.book, data: fikhJson),
      // (title: 'الخطب المنبرية', icon: AppIcons.sound, data: kotabManbrJson),
      // (title: 'فضائل الأقوال', icon: AppIcons.heart, data: fdaelJson),
      // (title: 'الدعوة إلى الله', icon: AppIcons.globe, data: dawaForAllhJson),
      (title: 'التاريخ', icon: AppIcons.calendar, data: historyJson),
      (title: 'اللغة العربية', icon: AppIcons.globe, data: arabicLangJson),
      (title: 'دراسات إسلامية', icon: AppIcons.bookOpen, data: studyIslamic),
      (title: 'الدروس العلمية', icon: AppIcons.menuBook, data: lessonJson),
      (title: 'الكبائر والمحرمات', icon: AppIcons.warning, data: kabaerJson),
    ];

    return [
      for (final section in sections)
        CategoryTile(
          label: section.title,
          icon: section.icon,
          onTap: () => context.push(
            CategoryViewAllScreen(
              data: section.data.map(SectionTypeModel.fromJson).toList(),
              title: section.title,
            ),
          ),
        ),
    ];
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
