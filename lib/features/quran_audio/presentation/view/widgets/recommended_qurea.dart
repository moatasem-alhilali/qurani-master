import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/jsons/moast_reader_text.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_audio/data/remote/audio_player_repo.dart';
import 'package:quran_app/features/quran_audio/presentation/cubit/audio_cubit.dart';

class RecommendedQureaWidget extends StatefulWidget {
  const RecommendedQureaWidget({
    super.key,
  });

  @override
  State<RecommendedQureaWidget> createState() => _RecommendedQureaWidgetState();
}

class _RecommendedQureaWidgetState extends State<RecommendedQureaWidget> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'قارئ أخر مقترح',
                style: titleMedium(context).copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),

        //list of qurea
        SizedBox(
          height: context.getHight(22),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, indexOfQarea) {
              final data = mostReaderData[indexOfQarea];

              return BlocBuilder<AudioCubit, AudioState>(
                builder: (context, state) {
                  final cubit = AudioCubit.get(context);
                  return InkWell(
                    onTap: () async {
                      //current
                      final currentAudioData = AudioPlayerRepo.currentAudioData;
                      //update
                      final updateCurrent = CurrentAudioModel(
                        countSurahVerse: currentAudioData.countSurahVerse,
                        imageReader: data['image'] as String,
                        nameReader: data['name'] as String,
                        nameSurah: currentAudioData.nameSurah,
                        identifier: data['identifier'] as String,
                        indexSurah: currentAudioData.indexSurah,
                      );
                      //save
                      AudioPlayerRepo.currentAudioData = updateCurrent;
                      AudioPlayerRepo.audioPlayerOnlineListen.stop();

                      AudioCubit.get(context).initAudioPlayer();

                      //change the index
                      cubit.changeIndex(indexOfQarea);
                    },
                    child: CardWidget(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      width: context.getWidth(22),
                      padding: const EdgeInsets.all(4),
                      borderRadius: BorderRadius.circular(20),
                      color: cubit.currentReader == indexOfQarea
                          ? context.primaryScheme
                          : null,
                      // decoration: BoxDecoration(

                      // ),
                      // duration: const Duration(milliseconds: 500),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SvgPicture.asset(
                                data['image'] as String,
                                height: context.getHight(10),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data['name'] as String,
                              textAlign: TextAlign.center,
                              style: titleSmall(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            itemCount: mostReaderData.length,
          ),
        ),
      ],
    );
  }
}
