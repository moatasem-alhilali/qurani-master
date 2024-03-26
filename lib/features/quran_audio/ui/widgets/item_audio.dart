import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/features/read_quran/data/model/surah_model.dart';

class StyleContainer extends StatelessWidget {
  StyleContainer({super.key, required this.child});
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      height: SizeConfig.blockSizeVertical! * 10,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
      ),
      child: child,
    );
  }
}

class ItemDownloaded extends StatelessWidget {
  ItemDownloaded({Key? key, this.data, this.indexSurah}) : super(key: key);
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
              "${data!.count!}",
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
