part of 'young_muslim_player_screen.dart';

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
    final nextVideo = session.nextVideo;
    final nextVideoLabel = session.nextVideo == null
        ? null
        : '${nextVideo!.episodeNumber ?? nextVideo.orderIndex}';
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
              child: player,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 28.h),
              child: Column(
                children: [
                  // SizedBox(height: 16.h),
                  // _PlayerStatsRow(
                  //   controller: controller,
                  //   session: session,
                  // ),
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
                                'تشغيل التالي: $nextVideoLabel',
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
