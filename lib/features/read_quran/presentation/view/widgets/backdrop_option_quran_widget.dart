import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_text_widget.dart';
import 'package:quran_app/core/components/sheet/animated_bottom_sheet.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/drawer_slide/juz_page.dart';
import 'package:quran_app/core/widgets/drawer_slide/quran_surah_list.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/book_mark_page_tab.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/bookmark_aya_tab.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/features/search/presentation/bloc/search_bloc.dart';

class BackdropOptionQuranWidget extends StatelessWidget {
  const BackdropOptionQuranWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: Text(
            'ابحث عن الايه',
            style: TextStyle(
              color: context.primaryColor.withValues(alpha: 0.6),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        MyTextFormFieldWidget(
          controller: context.read<SearchBloc>().textEditingController,
          readOnly: true,
          hintText: 'ادخل اسم الايه',
          hintStyle: TextStyle(
            color: context.primaryColor,
            fontSize: 14,
          ),
          style: TextStyle(
            color: context.quranTheme.cardColor,
          ),
          onTap: () {
            context.read<SearchBloc>().textEditingController.clear();
            context.read<ReadQuranBloc>().boxController.showSearchBox();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: Text(
            'الصفحات',
            style: TextStyle(
              color: context.primaryColor.withValues(alpha: 0.6),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: FeatureCardTextWidget(
                shapeType: CardShapeType.hexagons,
                title: 'السور',
                onTap: () {
                  context.showAnimatedBottomSheet(
                    backgroundColor: context.scaffoldBackgroundColor,
                    child: const QuranSurahList(),
                  );
                },
                height: 80.h,
              ),
            ),
            Expanded(
              child: FeatureCardTextWidget(
                shapeType: CardShapeType.hexagons,
                title: 'الاجزاء',
                onTap: () {
                  context.showAnimatedBottomSheet(
                    backgroundColor: context.scaffoldBackgroundColor,
                    child: QuranJuz(),
                  );
                },
                height: 80.h,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: Text(
            'المحفوظات',
            style: TextStyle(
              color: context.primaryColor.withValues(alpha: 0.6),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: FeatureCardTextWidget(
                shapeType: CardShapeType.hexagons,
                title: 'المحفوظات من السور',
                onTap: () {
                  context.showAnimatedBottomSheet(
                    // isExpanded: false,
                    child: const BookmarkPageTab(),
                    // isScrollable: false,
                  );
                },
                height: 80.h,
              ),
            ),
            Expanded(
              child: FeatureCardTextWidget(
                shapeType: CardShapeType.stars,
                title: 'المحفوظات من الايات',
                height: 80.h,
                onTap: () {
                  context.showAnimatedBottomSheet(
                    child: const BookmarkAyahTab(),
                  );
                },
              ),
            ),
          ],
        ),
        // _TopSettingsBar(),

        // _CloseDialogArea(),
      ],
    );
  }
}
