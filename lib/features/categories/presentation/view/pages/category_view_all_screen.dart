import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/data/model/section_type_model.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_data_screen.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_detail_screen.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/category_skin_widgets.dart';

/// أبواب قسم واحد من المكتبة — صفوف نحيلة بلا بطاقات.
class CategoryViewAllScreen extends StatelessWidget {
  const CategoryViewAllScreen({
    required this.data,
    required this.title,
    super.key,
  });

  final List<SectionTypeModel> data;
  final String title;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        title: title,
        body: ColoredBox(
          color: skin.ground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (data.isEmpty)
                const CategoryNotice(message: 'لا توجد أبواب في هذا القسم.')
              else
                for (var i = 0; i < data.length; i++)
                  CategoryRow(
                    title: data[i].title ?? '',
                    icon: AppIcons.bookOpen,
                    isLast: i == data.length - 1,
                    onTap: () => _open(context, data[i]),
                  ),
              SizedBox(height: 22.h),
            ],
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, SectionTypeModel section) {
    if (section.apiUrl.contains('get-item')) {
      context.showBottomSheet(
        child: CategoryDetailScreen(
          category: CategoryDetailModel(
            apiUrl: section.apiUrl,
            title: section.title,
          ),
        ),
      );
      return;
    }

    context.push(
      CategoryDataScreen(
        id: section.id ?? 0,
        title: section.title ?? title,
        url: section.apiUrl,
      ),
    );
  }
}
