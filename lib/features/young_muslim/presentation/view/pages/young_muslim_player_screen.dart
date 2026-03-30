import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';
import 'package:quran_app/features/young_muslim/presentation/cubit/young_muslim_player_cubit.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_quiz_sheet.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoungMuslimPlayerScreen extends StatefulWidget {
  const YoungMuslimPlayerScreen({
    required this.videoId,
    super.key,
  });

  final String videoId;

  @override
  State<YoungMuslimPlayerScreen> createState() =>
      _YoungMuslimPlayerScreenState();
}

class _YoungMuslimPlayerScreenState extends State<YoungMuslimPlayerScreen> {
  late final YoungMuslimPlayerCubit _cubit;
  int _lastCompletionTrigger = 0;

  @override
  void initState() {
    super.initState();
    _cubit = YoungMuslimPlayerCubit(
      repository: context.read<YoungMuslimRepository>(),
    )..initialize(widget.videoId);
  }

  @override
  void dispose() {
    unawaited(_cubit.persistOnExit());
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<YoungMuslimPlayerCubit, YoungMuslimPlayerState>(
        listener: (context, state) async {
          if (state.completionTrigger == 0 ||
              state.completionTrigger == _lastCompletionTrigger) {
            return;
          }
          _lastCompletionTrigger = state.completionTrigger;
          await _handleCompletionFlow(context, state.session);
        },
        builder: (context, state) {
          if (state.loadState == RequestState.error) {
            return AppScaffoldWidget(
              title: 'المسلم الصغير',
              showLargeHeader: false,
              body: SizedBox(
                height: 420,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 44.sp,
                          color: context.errorColor,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          state.errorMessage ?? 'تعذر تحميل المشغل الآن.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          if (state.loadState == RequestState.loading ||
              _cubit.controller == null ||
              state.session == null) {
            return const AppScaffoldWidget(
              title: 'المسلم الصغير',
              showLargeHeader: false,
              body: SizedBox(
                height: 420,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          final session = state.session!;
          final player = YoutubePlayer(
            controller: _cubit.controller!,
            showVideoProgressIndicator: false,
            bottomActions: const [
              CurrentPosition(),
              SizedBox(width: 8),
              ProgressBar(isExpanded: true),
              SizedBox(width: 8),
              RemainingDuration(),
              FullScreenButton(),
            ],
          );

          return YoutubePlayerBuilder(
            player: player,
            builder: (context, player) {
              return AppScaffoldWidget(
                title: 'تشغيل آمن للأطفال',
                showLargeHeader: false,
                body: Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: youngMuslimPanelDecoration(context),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28.r),
                          child: player,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      LinearProgressIndicator(
                        value: state.progress.clamp(0, 1),
                        minHeight: 8.h,
                        color: context.primaryColor,
                        backgroundColor:
                            context.outline.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.currentVideo?.title ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          YoungMuslimMetricChip(
                            label:
                                '${state.currentPosition.inMinutes}:${(state.currentPosition.inSeconds % 60).toString().padLeft(2, '0')} / ${youngMuslimDuration(state.duration.inSeconds)}',
                            icon: Icons.timer_outlined,
                            color: context.primaryColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '${session.series.titleAr} • ${session.category.titleAr}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.gray1,
                            ),
                      ),
                      SizedBox(height: 18.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: youngMuslimPanelDecoration(
                          context,
                          radius: 26,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const YoungMuslimSectionHeader(
                              title: 'خيارات المشاهدة',
                              subtitle: 'تجربة مبسطة بدون تشتيت أو خروج خارجي',
                            ),
                            SizedBox(height: 14.h),
                            SwitchListTile.adaptive(
                              value: state.autoPlayEnabled,
                              contentPadding: EdgeInsets.zero,
                              title:
                                  const Text('تشغيل الفيديو التالي تلقائيًا'),
                              subtitle: const Text(
                                'ضمن نفس السلسلة فقط بعد نهاية الحلقة',
                              ),
                              onChanged: (_) => _cubit.toggleAutoPlay(),
                            ),
                            if (session.nextVideo != null)
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _cubit.playNextVideo,
                                  icon: const Icon(Icons.skip_next_rounded),
                                  label: Text(
                                    'تشغيل التالي: ${session.nextVideo!.episodeNumber ?? session.nextVideo!.orderIndex}',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 22.h),
                      const YoungMuslimSectionHeader(
                        title: 'قائمة السلسلة',
                        subtitle: 'انتقل بين الحلقات بدون مغادرة المشغل',
                      ),
                      SizedBox(height: 14.h),
                      SizedBox(
                        height: 288.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final video = session.queue[index];
                            return YoungMuslimVideoCard(
                              video: video,
                              seriesTitle: session.series.titleAr,
                              onTap: () => _cubit.playSelectedVideo(video.id),
                              compact: true,
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(width: 12.w),
                          itemCount: session.queue.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleCompletionFlow(
    BuildContext context,
    YoungMuslimPlayerSessionEntity? session,
  ) async {
    if (session == null) {
      return;
    }

    YoungMuslimQuizResultEntity? videoResult;
    if (session.videoQuiz != null) {
      videoResult = await YoungMuslimQuizSheet.show(
        context: context,
        quizSet: session.videoQuiz!,
        title: 'سؤال الحلقة بعد المشاهدة',
      );
    }

    YoungMuslimQuizResultEntity? seriesResult;
    if (session.nextVideo == null && session.seriesQuiz != null) {
      seriesResult = await YoungMuslimQuizSheet.show(
        context: context,
        quizSet: session.seriesQuiz!,
        title: 'تحدي السلسلة',
      );
    }

    if (mounted && (videoResult != null || seriesResult != null)) {
      final result = seriesResult ?? videoResult!;
      final achievementsText = result.newlyUnlockedAchievements.isEmpty
          ? 'لا توجد إنجازات جديدة هذه المرة.'
          : result.newlyUnlockedAchievements
              .map((achievement) => achievement.titleAr)
              .join('، ');

      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('أحسنت'),
            content: Text(
              'أجبت ${result.correctAnswers}/${result.totalQuestions} بشكل صحيح وربحت ${result.awardedXp} XP.\n$achievementsText',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('متابعة'),
              ),
            ],
          );
        },
      );
    }

    await _cubit.handlePostQuizAutoPlay();
  }
}
