import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'controller_audio_widget.dart';

class PlaySurahAudio extends StatefulWidget {
  const PlaySurahAudio({
    super.key,
  });

  @override
  State<PlaySurahAudio> createState() => _PlaySuarhAudioState();
}

class _PlaySuarhAudioState extends State<PlaySurahAudio> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioCubitState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SvgPicture.asset(
                AudioPlayerHelper.currentAudioData.imageReader!,
                height: SizeConfig.blockSizeVertical! * 20,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //
            Text(
              AudioPlayerHelper.currentAudioData.nameReader!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),

            //
            BlocBuilder<AudioCubit, AudioCubitState>(
              builder: (context, state) {
                return Text(
                  surahData[AudioPlayerHelper.currentSurah].titleAr!,
                  style: titleSmall(context),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),

            //progress
            ProgressWithController(
              countVerse:
                  surahData[AudioPlayerHelper.currentAudioData.indexSurah!].count.toString(),
            ),
          ],
        ).animate().fade(duration: const Duration(seconds: 1));
      },
    );
  }
}
