import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/jsons/hadith_text.dart';
import 'package:quran_app/core/services/clip_board_services.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:readmore/readmore.dart';

class Hadith40 extends StatelessWidget {
  const Hadith40({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: "الأربعين النووية",
      body: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: hadith.length,
        itemBuilder: (context, index) {
          var data = hadith[index];

          return BaseAnimate(
            index: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ReadMoreText(
                    data['hadith'],
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
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "شرح الحديث",
                    style:
                        titleMedium(context).copyWith(color: FxColors.primary),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ReadMoreText(
                    data['description'],
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
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share_sharp),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ClipBoardServices.copyText(
                            text: "$data['hadith'] : $data['description']",
                            message: "تم النسخ بنجاح",
                          );
                        },
                        icon: const Icon(Icons.copy_outlined),
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
