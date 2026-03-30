import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    unawaited(_restorePortraitMode());
    _cubit = YoungMuslimPlayerCubit(
      repository: context.read<YoungMuslimRepository>(),
    )..initialize(widget.videoId);
  }

  @override
  void dispose() {
    unawaited(_restorePortraitMode());
    unawaited(_cubit.persistOnExit());
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<YoungMuslimPlayerCubit, YoungMuslimPlayerState>(
        listenWhen: (previous, current) =>
            previous.completionTrigger != current.completionTrigger,
        listener: (context, state) async {
          if (state.completionTrigger == 0 ||
              state.completionTrigger == _lastCompletionTrigger) {
            return;
          }
          _lastCompletionTrigger = state.completionTrigger;
          await _handleCompletionFlow(state.session);
        },
        child: AppScaffoldWidget(
          title: 'تشغيل آمن للأطفال',
          showLargeHeader: false,
          initialOffset: null,
          body: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 28.h),
            child: BlocBuilder<YoungMuslimPlayerCubit, YoungMuslimPlayerState>(
              buildWhen: (previous, current) {
                return previous.loadState != current.loadState ||
                    previous.session != current.session ||
                    previous.autoPlayEnabled != current.autoPlayEnabled ||
                    previous.errorMessage != current.errorMessage;
              },
              builder: (context, state) {
                final session = state.session;
                final controller = _cubit.controller;

                Widget child;
                if (session == null && state.loadState == RequestState.error) {
                  child = _PlayerErrorBody(message: state.errorMessage);
                } else if (session == null || controller == null) {
                  child = const YoungMuslimLoadingPanel();
                } else {
                  child = _PlayerContent(
                    session: session,
                    controller: controller,
                    autoPlayEnabled: state.autoPlayEnabled,
                    onToggleAutoPlay: _cubit.toggleAutoPlay,
                    onPlayNext: _cubit.playNextVideo,
                    onPlaySelected: _cubit.playSelectedVideo,
                    onEnterFullScreen: _enterFullScreenMode,
                    onExitFullScreen: _restorePortraitMode,
                  );
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: KeyedSubtree(
                    key: ValueKey(
                      state.session?.video.id ??
                          '${widget.videoId}_${state.loadState.name}',
                    ),
                    child: child,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleCompletionFlow(
    YoungMuslimPlayerSessionEntity? session,
  ) async {
    if (session == null) {
      return;
    }

    if (session.videoQuiz != null) {
      await YoungMuslimQuizSheet.show(
        context: context,
        quizSet: session.videoQuiz!,
        title: 'سؤال الحلقة بعد المشاهدة',
      );
      if (!mounted) {
        return;
      }
    }

    if (session.nextVideo == null && session.seriesQuiz != null) {
      await YoungMuslimQuizSheet.show(
        context: context,
        quizSet: session.seriesQuiz!,
        title: 'تحدي السلسلة',
      );
      if (!mounted) {
        return;
      }
    }

    await _cubit.handlePostQuizAutoPlay();
  }

  Future<void> _enterFullScreenMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _restorePortraitMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}

class _PlayerErrorBody extends StatelessWidget {
  const _PlayerErrorBody({
    required this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                message ?? 'تعذر تحميل المشغل الآن.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerContent extends StatelessWidget {
  const _PlayerContent({
    required this.session,
    required this.controller,
    required this.autoPlayEnabled,
    required this.onToggleAutoPlay,
    required this.onPlayNext,
    required this.onPlaySelected,
    required this.onEnterFullScreen,
    required this.onExitFullScreen,
  });

  final YoungMuslimPlayerSessionEntity session;
  final YoutubePlayerController controller;
  final bool autoPlayEnabled;
  final Future<void> Function() onToggleAutoPlay;
  final Future<void> Function() onPlayNext;
  final Future<void> Function(String videoId) onPlaySelected;
  final Future<void> Function() onEnterFullScreen;
  final Future<void> Function() onExitFullScreen;

  @override
  Widget build(BuildContext context) {
    final player = YoutubePlayer(
      controller: controller,
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
      onEnterFullScreen: () {
        unawaited(onEnterFullScreen());
      },
      onExitFullScreen: () {
        unawaited(onExitFullScreen());
      },
      player: player,
      builder: (context, player) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28.r),
                child: player,
              ),
            ),
            SizedBox(height: 16.h),
            _PlayerStatsRow(
              controller: controller,
              session: session,
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
                    value: autoPlayEnabled,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('تشغيل الفيديو التالي تلقائيًا'),
                    subtitle: const Text(
                      'ضمن نفس السلسلة فقط بعد نهاية الحلقة',
                    ),
                    onChanged: (_) => onToggleAutoPlay(),
                  ),
                  if (session.nextVideo != null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onPlayNext,
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
            RepaintBoundary(
              child: YoungMuslimVideoCarousel(
                videos: session.queue,
                compact: true,
                seriesTitleBuilder: (_) => session.series.titleAr,
                onTap: onPlaySelected,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlayerStatsRow extends StatelessWidget {
  const _PlayerStatsRow({
    required this.controller,
    required this.session,
  });

  final YoutubePlayerController controller;
  final YoungMuslimPlayerSessionEntity session;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<YoutubePlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final duration = value.metaData.duration.inSeconds > 0
            ? value.metaData.duration
            : Duration(seconds: session.video.durationSeconds);
        final position = value.position;
        final progress = duration.inSeconds <= 0
            ? 0.0
            : position.inSeconds / duration.inSeconds;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 8.h,
              color: context.primaryColor,
              backgroundColor: context.outline.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20.r),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.video.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                YoungMuslimMetricChip(
                  label:
                      '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / ${youngMuslimDuration(duration.inSeconds)}',
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
          ],
        );
      },
    );
  }
}
