import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/offline_audio/cubit/offline_cubit.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit_cubit.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';
import 'package:quran_app/features/quran_audio/ui/pages/audio_home.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/controller_audio_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SurahAudio extends StatelessWidget {
  const SurahAudio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OfflineCubit, OfflineState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = OfflineCubit.get(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Text(
                "الاستماع الى القرأن",
                style: titleMedium(context)
                    .copyWith(color: ColorsManager.customPrimary),
              ),
            ),
            InkWell(
              onTap: () {
                navigateTo(AudioHome(), context);
              },
              child: BlocBuilder<AudioCubit, AudioCubitState>(
                builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    AudioPlayerHelper
                                        .currentAudioData.imageReader!,
                                    fit: BoxFit.cover,
                                    height: SizeConfig.blockSizeVertical! * 8,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AudioPlayerHelper
                                          .currentAudioData.nameReader!,
                                      style: titleSmall(context),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    BlocBuilder<AudioCubit, AudioCubitState>(
                                      builder: (context, state) {
                                        return Text(
                                          surahData[AudioPlayerHelper
                                                  .currentSurah]
                                              .titleAr!,
                                          style: titleSmall(context),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                navigateTo(AudioHome(), context);
                              },
                              icon: const Icon(Icons.more_vert_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //
                        BlocBuilder<QuranCubit, QuranCubitState>(
                          builder: (context, state) {
                            return ISCONNECTED
                                ? ProgressWithController(
                                    countVerse: surahData[
                                            AudioPlayerHelper.currentSurah]
                                        .count
                                        .toString(),
                                  )
                                : Container();
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    ).animate(
      effects: [
        FadeEffect(duration: 1000.ms),
      ],
      autoPlay: true,
    );
  }
}
