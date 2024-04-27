import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

import 'package:quran_app/features/quran_audio/ui/widgets/all_surah_aduio.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/play_suarh_audio.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/recommended_qurea.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class AudioHome extends StatefulWidget {
  const AudioHome({Key? key}) : super(key: key);

  @override
  State<AudioHome> createState() => _AudioHomeState();
}

class _AudioHomeState extends State<AudioHome> {
  @override
  Widget build(BuildContext context) {
    return BaseHome(
      titleWidget: "واذا قرئ القران فاستمعوا له وانصتوا".autoSize(
        context,
        fontSize: 12,
        minFontSize: 8,
        maxLines: 3,
        color: Colors.grey,
        textAlign: TextAlign.center,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const PlaySurahAudio(),

          const RecommendedQurea(),

          //another surah
          BlocBuilder<ReadQuranBloc, ReadQuranState>(
            builder: (context, state) {
              switch (state.loadQuranState) {
                case RequestState.defaults:
                  return const SizedBox();

                case RequestState.loading:
                  return const SizedBox();

                case RequestState.error:
                  return const SizedBox();
                case RequestState.success:
                  return const AllSurahAudio();
              }
            },
          ),
        ],
      ),
    );
  }
}
