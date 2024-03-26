import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/jsons/ruqia_text.dart';
import 'package:quran_app/core/services/clip_board_services.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class RuqiaShareiahScreen extends StatelessWidget {
  const RuqiaShareiahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: "الرقية الشرعية",
      body: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ruqiaText.length,
        itemBuilder: (context, index) {
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
                          ruqiaText[index]['category'],
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
                                text: ruqiaText[index]['zekr'],
                                message: "تم النسخ بنجاح",
                              );
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
                    ruqiaText[index]['zekr'],
                    style: const TextStyle(
                        color: Color.fromARGB(255, 210, 209, 209)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "المرجع : ${ruqiaText[index]['reference'] == "" ? "القرأن الكريم" : ruqiaText[index]['reference']}",
                    style: const TextStyle(color: Colors.grey),
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
