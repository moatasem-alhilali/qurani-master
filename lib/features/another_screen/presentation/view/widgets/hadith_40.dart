import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/jsons/hadith_text.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:readmore/readmore.dart';

class Hadith40 extends StatelessWidget {
  const Hadith40({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: 'الأربعين النووية',
      body: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: hadith.length,
        itemBuilder: (context, index) {
          final data = hadith[index];

          return BaseAnimate(
            index: 0,
            child: CardWidget(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ReadMoreText(
                    data['hadith'] as String,
                    trimLines: 5,
                    colorClickableText: Colors.red,
                    trimMode: TrimMode.Line,
                    textDirection: TextDirection.rtl,
                    trimCollapsedText: 'عرض أكثر',
                    trimExpandedText: 'عرض أقل',
                    style: titleMedium(context),
                    moreStyle: const TextStyle(
                      color: Color.fromARGB(255, 162, 55, 47),
                      fontSize: 14,
                    ),
                    lessStyle: const TextStyle(
                      color: Color.fromARGB(255, 162, 55, 47),
                      fontSize: 14,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'شرح الحديث',
                    style: titleMedium(context)
                        .copyWith(color: context.primaryScheme),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ReadMoreText(
                    data['description'] as String,
                    trimLines: 3,
                    colorClickableText: Colors.red,
                    trimMode: TrimMode.Line,
                    textDirection: TextDirection.rtl,
                    trimCollapsedText: 'عرض أكثر',
                    trimExpandedText: 'عرض أقل',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    moreStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    lessStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconShareWidget(
                        text: '${data['hadith']} : ${data['description']}',
                        subject: 'الأربعين النووية',
                      ),
                      CopyIconWidget(
                        text: '${data['hadith']} : ${data['description']}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
