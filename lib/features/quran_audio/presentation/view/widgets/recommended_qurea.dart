import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';

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
          child: BlocBuilder<QuranAudioBloc, QuranAudioState>(
            builder: (context, state) {
              switch (state.loadState) {
                case RequestState.initial:
                  return const SizedBox.shrink();
                case RequestState.loading:
                  return const SizedBox.shrink();
                case RequestState.success:
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, indexOfQarea) {
                      final data = state.mostReaderData[indexOfQarea];

                      return BlocBuilder<QuranAudioBloc, QuranAudioState>(
                        builder: (context, state) {
                          final bloc = context.read<QuranAudioBloc>();
                          return InkWell(
                            onTap: () async {
                              //update
                              final updateCurrent = CurrentQuranAudioModel(
                                countSurahVerse:
                                    state.currentAudioData!.countSurahVerse,
                                imageReader: data.image,
                                nameReader: data.name,
                                nameSurah: state.currentAudioData!.nameSurah,
                                identifier: data.identifier,
                                indexSurah: state.currentAudioData!.indexSurah,
                              );

                              //change the index
                              bloc.add(
                                ChangeCurrentAudioDataEvent(
                                  currentAudioData: updateCurrent,
                                  reInitialize: true,
                                ),
                              );
                            },
                            child: CardWidget(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              width: context.getWidth(22),
                              padding: const EdgeInsets.all(4),
                              borderRadius: BorderRadius.circular(20),
                              color: state.currentAudioData!.identifier ==
                                      data.identifier
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
                                        data.image ?? '',
                                        height: context.getHight(10),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      data.name ?? '',
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
                    itemCount: state.mostReaderData.length,
                  );
                case RequestState.error:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
