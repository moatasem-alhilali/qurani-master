import 'package:flutter/material.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_type_all.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/item.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
      ),
      itemCount: _dataJson.length,
      itemBuilder: (context, index) => ItemCategory(
        onTap: () {
          context.push(
            CategoryTypeDetail(
              data: _dataJson[index],
            ),
          );
        },
        title: _dataJson[index]['title'],
      ),
    );
  }
}

List<Map<String, dynamic>> _dataJson = [
  {
    "title": "فيديوهات",
    "type": "section",
    "items_count": 1010,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/videos/ar/ar/1/25/json"
  },
  {
    "title": "كتب",
    "type": "section",
    "items_count": 4984,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/books/ar/ar/1/25/json"
  },
  {
    "title": "قصص",
    "type": "section",
    "items_count": 1703,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/articles/ar/ar/1/25/json"
  },
  {
    "title": "اصوات",
    "type": "section",
    "items_count": 4057,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/audios/ar/ar/1/25/json"
  },
  {
    "title": "فتاوي",
    "type": "section",
    "items_count": 527,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/fatwa/ar/ar/1/25/json"
  },
  // {
  //   "title": "المفضلة",
  //   "type": "section",
  //   "items_count": 15,
  //   "api_url":
  //       "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/favorites/ar/ar/1/25/json"
  // },
  {
    "title": "قرأن",
    "type": "section",
    "items_count": 164,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/quran/ar/ar/1/25/json"
  },
  {
    "title": "عروض تقديميه",
    "type": "section",
    "items_count": 5,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/cards/ar/ar/1/25/json"
  },
  {
    "title": "اخبار",
    "type": "section",
    "items_count": 1,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/news/ar/ar/1/25/json"
  },
  {
    "title": "مقالات",
    "type": "section",
    "items_count": 275,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/poster/ar/ar/1/25/json"
  },
  {
    "title": "تطبيقات",
    "type": "section",
    "items_count": 55,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/apps/ar/ar/1/25/json"
  },
  {
    "title": "خطب",
    "type": "section",
    "items_count": 288,
    "api_url":
        "https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/khotab/ar/ar/1/25/json"
  }
];
