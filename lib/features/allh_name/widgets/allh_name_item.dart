import 'package:flutter/material.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/jsons/allh_name_text.dart';
import 'package:quran_app/core/services/clip_board_services.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class ItemAllhName extends StatelessWidget {
  const ItemAllhName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allhName.length,
      itemBuilder: (context, index) {
        var data = allhName[index];
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data['name']!,
                        style: titleMedium(context),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_sharp),
                        ),
                        IconButton(
                          onPressed: () async {
                            await ClipBoardServices.copyText(
                                text: "${data['name']} : ${data['text']}",
                                message: "تم النسخ بنجاح");
                          },
                          icon: const Icon(Icons.copy_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                //
                Text(
                  data['text']!,
                  style: titleSmall(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
