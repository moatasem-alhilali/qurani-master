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
              AppIcon(
                AppIcons.warning,
                size: 44.sp,
                color: context.errorColor,
                strokeWidth: 1.55,
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
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
              child: Column(
                children: [
                  // SizedBox(height: 16.h),
                  // _PlayerStatsRow(
                  //   controller: controller,
                  //   session: session,
                  // ),
                  SizedBox(height: 18.h),
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: youngMuslimPanelDecoration(
                      context,
                      radius: 16,
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
                          title: Text(
                            'تشغيل الفيديو التالي تلقائيًا',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            'ضمن نفس السلسلة فقط بعد نهاية الحلقة',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: context.onSurfaceVariant.withOpacity(0.7),
                            ),
                          ),
                          onChanged: (_) => onToggleAutoPlay(),
                        ),
                        if (session.nextVideo != null)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: onPlayNext,
                              icon: const AppIcon(AppIcons.forward),
                              label: Text(
                                'تشغيل التالي: $nextVideoLabel',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
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
