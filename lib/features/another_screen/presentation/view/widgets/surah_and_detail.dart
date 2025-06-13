import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/jsons/random_surah_detail.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';

class SurahWithAllDetail extends StatelessWidget {
  const SurahWithAllDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: "معلومات حول السور",
      body: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: randomSurahDetail.length,
        itemBuilder: (context, index) {
          var data = randomSurahDetail[index];

          return BaseAnimate(
            index: 0,
            child: InkWell(
              onTap: () {
                context.showBottomSheet(
                  child: _bottomSheet(data: data),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: index % 2 == 0
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "إسم السورة :${data['surah']}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: index % 2 == 0
                          ? FxColors.primary
                          : FxColors.primarySecondary,
                      radius: 18,
                      child: Text("${index + 1}"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _bottomSheet extends StatelessWidget {
  const _bottomSheet({
    required this.data,
  });

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "إسم السورة :${data['surah']}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  " عدد الأيات :${data['ayaatiha']}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 5,
            ),
            //
            Text(
              "معنى الإسم",
              style: titleSmall(context),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              data['maeni_asamuha'],
              style: const TextStyle(color: Colors.grey),
            ),

            //--------------
            const SizedBox(
              height: 5,
            ),
            Text(
              "سبب التسمية",
              style: titleSmall(context),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              data['sabab_tasmiatiha'],
              style: const TextStyle(color: Colors.grey),
            ),
            //--------------
            const SizedBox(
              height: 5,
            ),
            Text(
              "أسماء السورة",
              style: titleSmall(context),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              data['asmawuha'],
              style: const TextStyle(color: Colors.grey),
            ),
            //--------------
            const SizedBox(
              height: 5,
            ),
            Text(
              "المقصد العلمي من السورة",
              style: titleSmall(context),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              data['maqsiduha_aleamu'],
              style: const TextStyle(color: Colors.grey),
            ),
            //--------------
            const SizedBox(
              height: 5,
            ),
            Text(
              "سبب النزول",
              style: titleSmall(context),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              data['sabab_nuzuliha'],
              style: const TextStyle(color: Colors.grey),
            ),
            //--------------
            const SizedBox(
              height: 5,
            ),
            Text(
              "فضلها",
              style: titleSmall(context),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              data['fadluha'][0],
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
