import 'package:flutter/material.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/features/read_quran/data/model/surah_model.dart';

class StyleContainerWidget extends StatelessWidget {
  StyleContainerWidget({required this.child, super.key});
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      height: context.getHight(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.primaryScheme,
      ),
      child: child,
    );
  }
}

class ItemDownloaded extends StatelessWidget {
  ItemDownloaded({super.key, this.data, this.indexSurah});
  SurahModel? data;
  int? indexSurah;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$indexSurah',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        Column(
          children: [
            Text(
              data!.titleAr!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              '${data!.count!}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            if (ISCONNECTED) {
            } else {
              ToastServes.showToast(message: 'لست متصلا بالأنترنت');
            }
          },
          icon: const Icon(Icons.download),
        ),
      ],
    );
  }
}
