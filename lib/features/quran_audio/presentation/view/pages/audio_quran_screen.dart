import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/all_surah_aduio.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/play_suarh_audio.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/recommended_qurea.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class AudioQuranScreen extends StatefulWidget {
  const AudioQuranScreen({super.key});

  @override
  State<AudioQuranScreen> createState() => _AudioQuranScreenState();
}

class _AudioQuranScreenState extends State<AudioQuranScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseHome(
      titleWidget: 'واذا قرئ القران فاستمعوا له وانصتوا'.autoSize(
        context,
        fontSize: 12,
        minFontSize: 8,
        maxLines: 3,
        color: Colors.grey,
        textAlign: TextAlign.center,
      ),
      body: Column(
        children: [
          const PlaySurahAudioWidget(),

          const RecommendedQureaWidget(),

          //another surah
          BlocBuilder<ReadQuranBloc, ReadQuranState>(
            builder: (context, state) {
              switch (state.loadQuranState) {
                case RequestState.initial:
                  return const SizedBox();

                case RequestState.loading:
                  return const SizedBox();

                case RequestState.error:
                  return const SizedBox();
                case RequestState.success:
                  return const AllSurahAudioWidget();
              }
            },
          ),
        ],
      ),
    );
  }
}
