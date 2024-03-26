import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/jsons/post_prayer_azkar.dart';
import 'package:quran_app/core/services/clip_board_services.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class AzkarAfterPray extends StatelessWidget {
  const AzkarAfterPray({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: "أذكار بعد الصلاة",
      body: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: azkarAfterPray.length,
        itemBuilder: (context, index) {
          var data = azkarAfterPray[index];

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
                  Text(
                    data['zekr'],
                    style: titleMedium(context),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        data['bless'] == ""
                            ? Container()
                            : Expanded(
                                child: Text(
                                  "العدد: ${data['bless']}",
                                  style: titleSmall(context).copyWith(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                        data['repeat'] == ""
                            ? Container()
                            : Text(
                                "التكرار :  ${data['repeat']}",
                                style: titleSmall(context)
                                    .copyWith(color: Colors.grey, fontSize: 12),
                              ),
                      ],
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
