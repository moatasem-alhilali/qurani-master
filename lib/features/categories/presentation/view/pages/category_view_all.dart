import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_data_screen.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/item.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/quran_sheet.dart';

class CategoryViewAll extends StatelessWidget {
  const CategoryViewAll({super.key, this.data, this.title});
  final dynamic data;
  final dynamic title;
  @override
  Widget build(BuildContext context) {
    return BaseHomeWidget(
      title: title as String,
      body: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: data.length as int,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return ItemCategory(
                onTap: () {
                  final url = data[index]['apiurl'].toString();
                  if (url.contains('get-item')) {
                    context.showBottomSheet(
                      child: QuranBooksDetail(data: data[index]),
                    );
                    return;
                  } else {
                    context.push(
                      CategoryDataScreen(
                        id: data[index]['id'] as int,
                        title: data[index]['title'] as String,
                        url: data[index]['apiurl'] as String,
                      ),
                    );
                  }
                },
                title: data[index]['title'] as String,
              ).animate().fade();
            },
          ),
          // List<Map<String,dynamic>>
        ],
      ),
    );
  }
}
