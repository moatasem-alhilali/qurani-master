import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_app/core/components/base_home.dart';

import 'package:quran_app/core/shared/export/export-shared.dart';

import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';
import 'package:quran_app/features/quran/presentation/page/quran_pdf/widgets/actions.dart';
import 'package:quran_app/features/quran/presentation/page/quran_pdf/widgets/item_surah.dart';
import 'package:quran_app/features/quran/presentation/page/read/page/quran_read.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BaseHome(
      customAppBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "القرأن الكريم",
              style: titleMedium(context),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    QuranCubit.get(context).playbackEventStream();
                    navigateTo(QuranRead(), context);
                  },
                  icon: const Icon(Icons.menu_book_rounded),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical! * 30,
            alignment: Alignment.topCenter,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 66, 74, 167),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Lottie.asset(
                  'assets/readQuran.json',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  height: SizeConfig.blockSizeVertical! * 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.grey.withOpacity(0.0),
                        Colors.black,
                      ],
                      stops: [0.0, 1.0],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'اخر سورة قمت بقرائتها : $lasSurahRead',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'الوقت: $lastTimeCash',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'التاريخ: $lastDateCash',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ActionsIcon(),
              ),
              const SizedBox(height: 5),
              ItemSurah(),
            ],
          ),
        ],
      ),
    );
  }
}
