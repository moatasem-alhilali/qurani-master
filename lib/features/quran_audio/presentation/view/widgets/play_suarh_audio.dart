import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_audio/data/remote/audio_player_repo.dart';
import 'package:quran_app/features/quran_audio/presentation/cubit/audio_cubit.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/controller_audio_widget.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class PlaySurahAudioWidget extends StatefulWidget {
  const PlaySurahAudioWidget({
    super.key,
  });

  @override
  State<PlaySurahAudioWidget> createState() => _PlaySurahAudioWidgetState();
}

class _PlaySurahAudioWidgetState extends State<PlaySurahAudioWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        final quranRH = context.read<ReadQuranBloc>().quranRH;
        return Column(
          children: [
            //
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SvgPicture.asset(
                AudioPlayerRepo.currentAudioData.imageReader!,
                height: context.getHight(20),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //
            Text(
              AudioPlayerRepo.currentAudioData.nameReader!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),

            //
            BlocBuilder<BaseBloc, BaseState>(
              builder: (context, state) {
                return BlocBuilder<AudioCubit, AudioState>(
                  builder: (context, state) {
                    return Text(
                      quranRH.surahs[AudioPlayerRepo.currentSurah].arabicName,
                      style: titleSmall(context),
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),

            //progress
            ProgressWithController(
              countVerse: quranRH
                  .surahs[AudioPlayerRepo.currentAudioData.indexSurah!]
                  .ayahs
                  .length
                  .toString(),
            ),
          ],
        ).animate().fade(duration: const Duration(seconds: 1));
      },
    );
  }
}
