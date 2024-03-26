import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/components/base_fade_image.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/audios/presentation/view/pages/base_audio_screen.dart';
import 'package:quran_app/features/categories/data/json/quran_json.dart';
import 'package:quran_app/features/categories/data/json/serah_json.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_view_all.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/item.dart';
import 'package:quran_app/features/home/widgets/category_section.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BaseHeder(text: "القرأن الكريم وعلومه"),
        SizedBox(
          height: context.getHight(25),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // for (int i = 0; i < 5;i++)
                _ITem(
                  onTap: () {
                    context.push(BaseAudioScreen(
                      id: "364764",
                      title: "تلاوات مشهوره",
                    ));
                  },
                  title: "تلاوات مشهوره",
                  image:
                      "https://cdn.myportfolio.com/b718dae02f30e9fb7a2b33ef47b6de15/9b3688b5-b76f-4e40-a2c5-f10f25b857cd_rw_3840.jpg?h=1d031cb00142e741d04802f7a44159ee",
                ),
                _ITem(
                  onTap: () {
                    context.push(BaseAudioScreen(
                      id: "364777",
                      title: "تعليم اطفال",
                    ));
                  },
                  title: "تعليم اطفال",
                  image:
                      "https://i0.wp.com/abunawaf.com/wp-content/uploads/2014/07/12345693.jpg?fit=960%2C638&ssl=1",
                ),
                _ITem(
                  onTap: () {
                    context.push(BaseAudioScreen(
                      id: "364774",
                      title: "تلاوات بروايات وقراءات",
                    ));
                  },
                  title: "تلاوات بروايات وقراءات",
                  image:
                      "https://img.freepik.com/premium-photo/religious-bearded-asian-muslim-man-reading-quran-mosque_641698-1048.jpg",
                ),

                _ITem(
                  onTap: () {
                    context.push(BaseAudioScreen(
                      id: "364771",
                      title: "مصاحف الحرمين",
                    ));
                  },
                  title: "مصاحف الحرمين",
                  image:
                      "https://cnn-arabic-images.cnn.io/cloudinary/image/upload/w_1920,c_scale,q_auto/cnnarabic/2020/08/15/images/162561.jpg",
                ),

                _ITem(
                  onTap: () {
                    context.push(BaseAudioScreen(
                      id: "364768",
                      title: "مصاحف مترجمة معانيها",
                    ));
                  },
                  title: "مصاحف مترجمة معانيها",
                  image:
                      "https://www.noor-book.com/publice/covers_cache_webp/1/d/d/5/02f62b4165dd537df60326da06d3724d.jpg.webp",
                ),

                _ITem(
                  onTap: () {
                    context.push(BaseAudioScreen(
                      id: "691",
                      title: "مصاحف مترجمة ",
                    ));
                  },
                  title: "مصاحف مترجمة",
                  image:
                      "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1547257935i/25766113.jpg",
                ),
              ],
            ),
          ),
        ),
        const BaseHeder(text: "تصنيفات "),
        const CategorySection(),
        const BaseHeder(text: "الاقسام "),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2 / 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
          ),
          children: [
            QuranCategory(data: quranJson, title: "القرأن"),
            QuranCategory(data: sonaJson, title: "السنه"),
            QuranCategory(data: serahNabawyJson, title: "السيرة النبوية"),
            QuranCategory(data: aqidaJson, title: "العقيدة"),
            QuranCategory(data: fikhJson, title: "فقه"),
            QuranCategory(data: kotabManbrJson, title: "الخطب المنبرية"),
            QuranCategory(
              data: fdaelJson,
              title: "فضائل الأقوال والأفعال والأخلاق",
            ),
            QuranCategory(data: dawaForAllhJson, title: "الدعوة إلى الله"),
            QuranCategory(data: historyJson, title: "التاريخ"),
            QuranCategory(data: arabicLangJson, title: "اللغة العربية"),
            QuranCategory(data: studyIslamic, title: "دراسات إسلامية"),
            QuranCategory(data: lessonJson, title: "الدروس والمتون العلمية"),
            QuranCategory(data: kabaerJson, title: "الكبائر والمحرمات"),
          ],
        ),
      ],
    );
  }
}

class QuranCategory extends StatelessWidget {
  const QuranCategory({super.key, this.data, this.title});
  final dynamic data;
  final dynamic title;
  @override
  Widget build(BuildContext context) {
    return ItemCategory(
      onTap: () {
        context.push(
          CategoryViewAll(
            data: data,
            title: title,
          ),
        );
      },
      title: title,
    ).animate().fade();
  }
}

class _ITem extends StatelessWidget {
  const _ITem({required this.onTap, this.image, this.title});
  final void Function()? onTap;
  final String? image;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        height: context.getHight(25),
        width: context.getWidth(25),
        child: Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.expand,
          children: [
            const BaseFadeImageAsset(
              image: "assets/image/card-2.jpg",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.black,
                  ],
                  stops: const [
                    0.20,
                    1,
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                child: title!.autoSize(context,
                    maxLines: 2, textAlign: TextAlign.center, minFontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
