import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/features/offline_audio/cubit/offline_cubit.dart';
import 'package:quran_app/features/offline_audio/pages/offline_audio_screen.dart';

import 'package:quran_app/features/quran_audio/ui/widgets/all_surah_aduio.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/play_suarh_audio.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/recommended_qurea.dart';

class AudioHome extends StatefulWidget {
  const AudioHome({Key? key}) : super(key: key);

  @override
  State<AudioHome> createState() => _AudioHomeState();
}

class _AudioHomeState extends State<AudioHome> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: BaseHome(
            customAppBar: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Text(
                      "القرأن استماع",
                      style: titleMedium(context),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    OfflineCubit.get(context).getAudioPath();
                    navigateTo(const OfflineAudioScreen(), context);
                  },
                  icon: const Icon(
                    Icons.wifi_off_outlined,
                    size: 30,
                  ),
                ),
              ],
            ),

            //body
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Audio play suarh listen

                PlaySurahAudio(),

                //recommended qura

                RecommendedQurea(),

                //another surah
                const AllSurahAudio(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
