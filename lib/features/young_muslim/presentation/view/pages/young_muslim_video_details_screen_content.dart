part of 'young_muslim_video_details_screen.dart';

extension _YoungMuslimVideoDetailsScreenContent
    on _YoungMuslimVideoDetailsScreenState {
  Widget _buildVideoDetailsContent(
    BuildContext context,
    YoungMuslimVideoDetailsEntity details,
  ) {
    final skin = AppSkin.of(context);
    final video = details.video;
    final percent =
        video.isCompleted ? 100 : (video.progressPercent * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RepaintBoundary(
          child: YoungMuslimCover(
            imageUrl: video.thumbnailUrl,
            title: video.title,
            description: video.description,
            height: 168.h,
            chips: [
              YoungMuslimMetricChip(
                label: details.series.titleAr,
                icon: AppIcons.layers,
              ),
              YoungMuslimMetricChip(
                label: youngMuslimDuration(video.durationSeconds),
                icon: AppIcons.clock,
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Padding(
          padding: AppSkin.gutter,
          child: Row(
            children: [
              Expanded(
                child: YoungMuslimPrimaryButton(
                  label: video.hasProgress ? 'متابعة المشاهدة' : 'تشغيل الآن',
                  icon: AppIcons.play,
                  onTap: () => _openPlayer(video.id),
                ),
              ),
              SizedBox(width: 8.w),
              YoungMuslimToggleButton(
                icon: video.isFavorite ? AppIcons.heartFilled : AppIcons.heart,
                active: video.isFavorite,
                semanticLabel: 'المفضلة',
                size: 38.w,
                onTap: () => context.read<YoungMuslimBloc>().add(
                      YoungMuslimFavoriteToggled(video.id),
                    ),
              ),
              SizedBox(width: 6.w),
              YoungMuslimToggleButton(
                icon: video.isWatchLater
                    ? AppIcons.bookmark
                    : AppIcons.bookmarkAdd,
                active: video.isWatchLater,
                semanticLabel: 'سأشاهد لاحقًا',
                size: 38.w,
                onTap: () => context.read<YoungMuslimBloc>().add(
                      YoungMuslimWatchLaterToggled(video.id),
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: AppSkin.gutter,
          child: YoungMuslimProgressBar(
            value: video.isCompleted ? 1 : video.progressPercent,
          ),
        ),
        SizedBox(height: 12.h),
        YoungMuslimStatStrip(
          cells: [
            YoungMuslimStatCell(
              value: '$percent٪',
              label: 'التقدّم',
              icon: AppIcons.target,
            ),
            YoungMuslimStatCell(
              value: '${video.watchCount}',
              label: 'مرات المشاهدة',
              icon: AppIcons.replay,
            ),
            YoungMuslimStatCell(
              value: youngMuslimDuration(video.durationSeconds),
              label: 'مدّة الحلقة',
              icon: AppIcons.clock,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: AppSkin.gutter,
          child: Text(
            'آخر مشاهدة: ${youngMuslimRelative(video.lastWatchedAt)}',
            textAlign: TextAlign.center,
            style: youngMuslimRowSubtitle(skin),
          ),
        ),
        skin.divider(),
        const HomeSectionHeader(title: 'معلومات الحلقة'),
        YoungMuslimInfoRow(label: 'القصة', value: video.topicTitle),
        YoungMuslimInfoRow(label: 'القسم', value: details.category.titleAr),
        YoungMuslimInfoRow(
          label: 'السلسلة',
          value: details.series.titleAr,
          isLast: video.episodeNumber == null,
        ),
        if (video.episodeNumber != null)
          YoungMuslimInfoRow(
            label: 'رقم الحلقة',
            value: '${video.episodeNumber}',
            isLast: true,
          ),
        skin.divider(),
        const HomeSectionHeader(title: 'أدوات الحلقة'),
        if (details.videoQuiz != null)
          YoungMuslimActionRow(
            icon: AppIcons.target,
            title: 'أسئلة الحلقة',
            subtitle: 'أسئلة قصيرة تثبّت ما شاهده الطفل',
            onTap: () {
              YoungMuslimQuizSheet.show(
                context: context,
                quizSet: details.videoQuiz!,
                title: 'سؤال بعد المشاهدة',
              );
            },
          ),
        YoungMuslimActionRow(
          icon: AppIcons.star,
          title: 'نقاطي وإنجازاتي',
          subtitle: 'المستوى ${details.rewardsSummary.level}'
              ' · ${details.rewardsSummary.xp} نقطة',
          isLast: true,
          onTap: () {
            YoungMuslimRewardsSheet.show(
              context: context,
              rewardsSummary: details.rewardsSummary,
              achievements: details.achievements,
            );
          },
        ),
        if (details.nextVideo != null) ...[
          skin.divider(),
          const HomeSectionHeader(title: 'الحلقة التالية'),
          RepaintBoundary(
            child: YoungMuslimVideoRow(
              video: details.nextVideo!,
              seriesTitle: details.series.titleAr,
              isLast: true,
              onTap: () => _openVideo(context, details.nextVideo!.id),
              onFavoriteToggle: () => context
                  .read<YoungMuslimBloc>()
                  .add(YoungMuslimFavoriteToggled(details.nextVideo!.id)),
              onWatchLaterToggle: () => context
                  .read<YoungMuslimBloc>()
                  .add(YoungMuslimWatchLaterToggled(details.nextVideo!.id)),
            ),
          ),
        ],
        if (details.similarVideos.isNotEmpty) ...[
          skin.divider(),
          const HomeSectionHeader(title: 'حلقات مشابهة'),
          RepaintBoundary(
            child: YoungMuslimVideoRail(
              videos: details.similarVideos,
              seriesTitleBuilder: (video) => video.seriesId == details.series.id
                  ? details.series.titleAr
                  : details.category.titleAr,
              onTap: (videoId) => _openVideo(context, videoId),
              onFavoriteToggle: (videoId) => context
                  .read<YoungMuslimBloc>()
                  .add(YoungMuslimFavoriteToggled(videoId)),
              onWatchLaterToggle: (videoId) => context
                  .read<YoungMuslimBloc>()
                  .add(YoungMuslimWatchLaterToggled(videoId)),
            ),
          ),
        ],
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildErrorBody(BuildContext context, String? message) {
    return YoungMuslimEmptyState(
      title: 'تعذّر تحميل تفاصيل الحلقة',
      subtitle: message ?? 'حاول مرة أخرى بعد قليل.',
      icon: AppIcons.warning,
    );
  }

  Future<void> _openPlayer(String videoId) async {
    await Navigator.of(context).push(
      youngMuslimPageRoute<void>(
        screenName: 'YoungMuslimPlayerScreen',
        child: YoungMuslimRouteScope.inherit(
          context: context,
          child: YoungMuslimPlayerScreen(videoId: videoId),
        ),
      ),
    );
    if (!mounted) {
      return;
    }
    context.read<YoungMuslimBloc>().add(YoungMuslimVideoRequested(videoId));
    context.read<YoungMuslimBloc>().add(const YoungMuslimRefreshed());
  }

  void _openVideo(BuildContext context, String videoId) {
    Navigator.of(context).pushReplacement(
      youngMuslimPageRoute<void>(
        screenName: 'YoungMuslimVideoDetailsScreen',
        child: YoungMuslimRouteScope.inherit(
          context: context,
          child: YoungMuslimVideoDetailsScreen(videoId: videoId),
        ),
      ),
    );
  }
}
