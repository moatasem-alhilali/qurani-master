part of 'young_muslim_player_screen.dart';

class _PlayerErrorBody extends StatelessWidget {
  const _PlayerErrorBody({
    required this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: AppIcon(
                AppIcons.warning,
                color: AppColors.error,
                size: 18.sp,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            message ?? context.l10n.youngMuslimPlayerLoadError,
            textAlign: TextAlign.center,
            style: youngMuslimRowTitle(skin, size: 13.sp),
          ),
        ],
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
    final skin = AppSkin.of(context);
    final nextVideo = session.nextVideo;
    final nextVideoLabel = nextVideo == null
        ? null
        : '${nextVideo.episodeNumber ?? nextVideo.orderIndex}';
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RepaintBoundary(child: player),
            SizedBox(height: 14.h),
            Padding(
              padding: AppSkin.gutter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    session.series.titleAr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: youngMuslimRowSubtitle(skin),
                  ),
                ],
              ),
            ),
            skin.divider(),
            HomeSectionHeader(title: context.l10n.youngMuslimWatchOptions),
            _AutoPlayRow(
              enabled: autoPlayEnabled,
              onToggle: onToggleAutoPlay,
              isLast: nextVideo == null,
            ),
            if (nextVideo != null)
              YoungMuslimActionRow(
                icon: AppIcons.forwardFor(context),
                title: context.l10n.youngMuslimPlayNextEpisode,
                subtitle: context.l10n
                    .youngMuslimNextEpisodeFromSeries(nextVideoLabel!),
                isLast: true,
                onTap: () => unawaited(onPlayNext()),
              ),
            skin.divider(),
            HomeSectionHeader(title: context.l10n.youngMuslimSeriesPlaylist),
            RepaintBoundary(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < session.queue.length; i++)
                    YoungMuslimVideoRow(
                      video: session.queue[i],
                      seriesTitle: session.series.titleAr,
                      isCurrent: session.queue[i].id == session.video.id,
                      isLast: i == session.queue.length - 1,
                      onTap: () => unawaited(
                        onPlaySelected(session.queue[i].id),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
          ],
        );
      },
    );
  }
}

/// صفّ التشغيل التلقائي: مفتاح واحد بخلفية مربّع الأيقونة، بلا بطاقة حوله.
class _AutoPlayRow extends StatelessWidget {
  const _AutoPlayRow({
    required this.enabled,
    required this.onToggle,
    required this.isLast,
  });

  final bool enabled;
  final Future<void> Function() onToggle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Row(
        children: [
          YoungMuslimIconChip(icon: AppIcons.play, active: enabled),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.youngMuslimAutoPlayNext,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: youngMuslimRowTitle(skin),
                ),
                Text(
                  context.l10n.youngMuslimAutoPlayNextSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: youngMuslimRowSubtitle(skin),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Switch.adaptive(
            value: enabled,
            activeTrackColor: AppColors.gold,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              unawaited(onToggle());
            },
          ),
        ],
      ),
    );
  }
}
