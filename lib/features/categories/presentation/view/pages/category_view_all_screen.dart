import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_text_widget.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/data/model/section_type_model.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_data_screen.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_detail_screen.dart';

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
    return BaseHomeWidget(
      title: title,
      showBackground: false,
      body: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return FeatureCardTextWidget(
                onTap: () {
                  final url = data[index].apiUrl;
                  if (url.contains('get-item')) {
                    context.showBottomSheet(
                      child: CategoryDetailScreen(
                        category: CategoryDetailModel(
                          apiUrl: data[index].apiUrl,
                          title: data[index].title,
                        ),
                      ),
                    );
                    return;
                  } else {
                    context.push(
                      CategoryDataScreen(
                        id: data[index].id!,
                        title: data[index].title!,
                        url: data[index].apiUrl,
                      ),
                    );
                  }
                },
                title: data[index].title ?? '',
              );
            },
          ),
          // List<Map<String,dynamic>>
        ],
      ),
    );
  }
}
