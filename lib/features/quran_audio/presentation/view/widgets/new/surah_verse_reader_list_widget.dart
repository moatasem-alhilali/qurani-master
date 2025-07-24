import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/generic/query/query_bloc.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_query_extension.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/quran_audio/data/di/injection_container.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';

class SurahVerseReaderListWidget extends StatelessWidget {
  const SurahVerseReaderListWidget({required this.scrollController, super.key});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<SurahVerseReaderBloc>()..add(FetchRequested(null)),
      child: BlocBuilder<SurahVerseReaderBloc,
          QueryState<List<SurahVerseReaderModel>>>(
        builder: (context, state) {
          return state.buildQueryWidget<List<SurahVerseReaderModel>>(
            onSuccess: (data) => ListView.separated(
              controller: scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
              ),
              itemBuilder: (context, index) {
                final reader = data[index];
                return BlocBuilder<QuranAudioBloc, QuranAudioState>(
                  builder: (context, state) {
                    return BaseOnTap(
                      onTap: () {
                        final bloc = context.read<QuranAudioBloc>();

                        final updateCurrent = CurrentQuranAudioModel(
                          countSurahVerse:
                              state.currentAudioData?.countSurahVerse ?? '0',
                          // imageReader: reader.image,
                          nameReader: reader.name,
                          nameSurah: state.currentAudioData?.nameSurah ?? '',
                          identifier: reader.identifier,
                          indexSurah: state.currentAudioData?.indexSurah ?? 1,
                        );

                        //change the index
                        bloc.add(
                          ChangeCurrentAudioDataEvent(
                            currentAudioData: updateCurrent,
                            reInitialize: true,
                          ),
                        );
                        context.pop();
                      },
                      child: CardWidget(
                        // margin:
                        //     EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 22.r,
                              backgroundColor:
                                  context.colorScheme.primary.withOpacity(0.1),
                              child: Text(
                                reader.name.substring(0, 1),
                                style: context.titleMedium.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reader.name,
                                    style: context.titleMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      _InfoChip(
                                        icon: Icons.language,
                                        label: reader.language,
                                      ),
                                      SizedBox(width: 8.w),
                                      _InfoChip(
                                        icon: Icons.audiotrack,
                                        label: reader.format,
                                      ),
                                      if (reader.bitrate != null &&
                                          reader.bitrate!.isNotEmpty) ...[
                                        SizedBox(width: 8.w),
                                        _InfoChip(
                                          icon: Icons.speed,
                                          label: reader.bitrate!,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 12.h,
              ),
              itemCount: data.length,
            ),
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: context.colorScheme.primary),
          SizedBox(width: 4.w),
          Text(
            label,
            style: context.bodyMedium.copyWith(
              color: context.colorScheme.primary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
