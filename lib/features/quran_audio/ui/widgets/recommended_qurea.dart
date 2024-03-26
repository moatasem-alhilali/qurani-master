import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/jsons/moast_reader_text.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/features/quran_audio/controller/repository/audio_player_helper.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';

class RecommendedQurea extends StatefulWidget {
  const RecommendedQurea({
    super.key,
  });

  @override
  State<RecommendedQurea> createState() => _RecommendedQureaState();
}

class _RecommendedQureaState extends State<RecommendedQurea> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "قارئ أخر مقترح",
                style: titleSmall(context),
              ),
            ],
          ),
        ),

        //list of qurea
        SizedBox(
          height: SizeConfig.blockSizeVertical! * 22,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, indexOfQarea) {
              var data = mostReaderData[indexOfQarea];

              return BlocBuilder<AudioCubit, AudioState>(
                  builder: (context, state) {
                var cubit = AudioCubit.get(context);
                return InkWell(
                  onTap: () async {
                    //current
                    var currentAudioData = AudioPlayerHelper.currentAudioData;
                    //update
                    CurrentAudioModel updateCurrent = CurrentAudioModel(
                      countSurahVerse: currentAudioData.countSurahVerse,
                      imageReader: data['image'],
                      nameReader: data['name'],
                      nameSurah: currentAudioData.nameSurah,
                      identifier: data['identifier'],
                      indexSurah: currentAudioData.indexSurah,
                    );
                    //save
                    AudioPlayerHelper.currentAudioData = updateCurrent;
                    AudioPlayerHelper.audioPlayerOnlineListen.stop();

                    AudioCubit.get(context).initAudioPlayer();

                    //change the index
                    cubit.changeIndex(indexOfQarea);
                  },
                  child: AnimatedContainer(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: SizeConfig.blockSizeHorizontal! * 22,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: cubit.currentReader == indexOfQarea
                          ? FxColors.primarySecondary
                          : Theme.of(context).primaryColor,
                    ),
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SvgPicture.asset(
                              data['image'],
                              height: SizeConfig.blockSizeVertical! * 10,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            data['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
            itemCount: mostReaderData.length,
          ),
        )
      ],
    );
  }
}
