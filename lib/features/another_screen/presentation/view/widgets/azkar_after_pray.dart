import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/copy_icon_widget.dart';
import 'package:quran_app/core/components/icon_share_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/jsons/post_prayer_azkar.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class AzkarAfterPray extends StatelessWidget {
  const AzkarAfterPray({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: 'أذكار بعد الصلاة',
      body: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: azkarAfterPray.length,
        itemBuilder: (context, index) {
          final data = azkarAfterPray[index];

          return BaseAnimate(
            index: 0,
            child: CardWidget(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    data['zekr'] as String,
                    style: titleMedium(context),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (data['bless'] == '')
                          Container()
                        else
                          Expanded(
                            child: Text(
                              "العدد: ${data['bless']}",
                              style: titleSmall(context).copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (data['repeat'] == '')
                          Container()
                        else
                          Text(
                            "التكرار :  ${data['repeat']}",
                            style: titleSmall(context)
                                .copyWith(color: Colors.grey, fontSize: 12),
                          ),
                      ],
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
                        text: data['zekr'] as String,
                        subject: 'أذكار بعد الصلاة',
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
