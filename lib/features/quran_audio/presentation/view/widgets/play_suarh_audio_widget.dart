import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/controller_audio_widget.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

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
    return BlocBuilder<QuranAudioBloc, QuranAudioState>(
      builder: (context, state) {
        return Column(
          children: [
            //
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SvgPicture.asset(
                state.currentAudioData!.imageReader!,
                height: context.getHight(20),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //
            Text(
              state.currentAudioData!.nameReader!,
              style: titleMedium(context),
            ),
            const SizedBox(height: 10),

            //
            BlocBuilder<ReadQuranBloc, ReadQuranState>(
              builder: (context, readQuranState) {
                return Text(
                  readQuranState.surahs[state.currentAudioData!.indexSurah!].nameAr,
                  style: titleSmall(context),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),

            //progress
            const ProgressWithControllerWidget(),
          ],
        ).animate().fade(duration: const Duration(seconds: 1));
      },
    );
  }
}
