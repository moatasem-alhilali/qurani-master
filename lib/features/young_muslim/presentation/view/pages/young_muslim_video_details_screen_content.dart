part of 'young_muslim_video_details_screen.dart';

extension _YoungMuslimVideoDetailsScreenContent
    on _YoungMuslimVideoDetailsScreenState {
  Widget _buildVideoDetailsContent(
    BuildContext context,
    YoungMuslimVideoDetailsEntity details,
  ) {
    final progressLabel = details.video.isCompleted
        ? 'تمت المشاهدة كاملة'
        : details.video.hasProgress
            ? 'تقدّم ${(details.video.progressPercent * 100).round()}%'
            : 'لم تبدأ بعد';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(
          child: YoungMuslimMediaBanner(
            title: details.video.title,
            subtitle: details.video.description,
            imageUrl: details.video.thumbnailUrl,
            accentStart: details.series.accentStart,
            accentEnd: details.series.accentEnd,
            height: 260,
            badges: [
              YoungMuslimMetricChip(
                label: details.series.titleAr,
                icon: Icons.video_library_rounded,
                color: Colors.white,
              ),
              YoungMuslimMetricChip(
                label: youngMuslimDuration(
                  details.video.durationSeconds,
                ),
                icon: Icons.schedule_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _openPlayer(details.video.id),
                icon: const Icon(Icons.play_circle_fill_rounded),
                label: Text(
                  details.video.hasProgress ? 'متابعة المشاهدة' : 'تشغيل الآن',
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            _ActionCircleButton(
              icon: details.video.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: details.video.isFavorite
                  ? youngMuslimRewardColor(context)
                  : context.primaryColor,
              onTap: () => context.read<YoungMuslimBloc>().add(
                    YoungMuslimFavoriteToggled(details.video.id),
                  ),
            ),
            SizedBox(width: 10.w),
            _ActionCircleButton(
              icon: details.video.isWatchLater
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: details.video.isWatchLater
                  ? context.secondaryColor
                  : context.primaryColor,
              onTap: () => context.read<YoungMuslimBloc>().add(
                    YoungMuslimWatchLaterToggled(details.video.id),
                  ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        RepaintBoundary(
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: youngMuslimPanelDecoration(context),
            child: Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                YoungMuslimMetricChip(
                  label: progressLabel,
                  icon: Icons.insights_rounded,
                  color: details.video.isCompleted
                      ? youngMuslimCompletionColor(context)
                      : context.primaryColor,
                ),
                YoungMuslimMetricChip(
                  label: youngMuslimRelative(
                    details.video.lastWatchedAt,
                  ),
                  icon: Icons.history_rounded,
                  color: context.secondaryColor,
                ),
                YoungMuslimMetricChip(
                  label: '${details.video.watchCount} مرة مشاهدة',
                  icon: Icons.repeat_rounded,
                  color: youngMuslimRewardColor(context),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 22.h),
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: youngMuslimPanelDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const YoungMuslimSectionHeader(
                title: 'معلومات الحلقة',
                subtitle: 'تفاصيل بسيطة وواضحة للطفل وولي الأمر',
              ),
              SizedBox(height: 16.h),
              Text(
                'القصة: ${details.video.topicTitle}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(height: 10.h),
              Text(
                'القسم: ${details.category.titleAr}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 10.h),
              Text(
                'السلسلة: ${details.series.titleAr}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (details.video.episodeNumber != null) ...[
                SizedBox(height: 10.h),
                Text(
                  'رقم الحلقة: ${details.video.episodeNumber}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (details.videoQuiz != null) ...[
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      YoungMuslimQuizSheet.show(
                        context: context,
                        quizSet: details.videoQuiz!,
                        title: 'سؤال بعد المشاهدة',
                      );
                    },
                    icon: const Icon(Icons.quiz_outlined),
                    label: const Text('أسئلة الحلقة'),
                  ),
                ),
              ],
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    YoungMuslimRewardsSheet.show(
                      context: context,
                      rewardsSummary: details.rewardsSummary,
                      achievements: details.achievements,
                    );
                  },
                  icon: const Icon(Icons.emoji_events_outlined),
                  label: const Text('نقاطي وإنجازاتي'),
                ),
              ),
            ],
          ),
        ),
        if (details.nextVideo != null) ...[
          SizedBox(height: 22.h),
          const YoungMuslimSectionHeader(
            title: 'الفيديو التالي من نفس السلسلة',
            subtitle: 'انتقال مريح بدون الخروج من التجربة',
          ),
          SizedBox(height: 14.h),
          RepaintBoundary(
            child: YoungMuslimVideoCard(
              video: details.nextVideo!,
              seriesTitle: details.series.titleAr,
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
          SizedBox(height: 22.h),
          const YoungMuslimSectionHeader(
            title: 'فيديوهات مشابهة',
            subtitle: 'اقتراحات من نفس النوع أو السياق القصصي',
          ),
          SizedBox(height: 14.h),
          RepaintBoundary(
            child: YoungMuslimVideoCarousel(
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
      ],
    );
  }

  Widget _buildLoadingBody() {
    return const YoungMuslimLoadingPanel();
  }

  Widget _buildErrorBody(BuildContext context, String? message) {
    return YoungMuslimEmptyState(
      title: 'تعذر تحميل تفاصيل الحلقة',
      subtitle: message ?? 'حاول مرة أخرى بعد قليل.',
      icon: Icons.cloud_off_rounded,
    );
  }

  Future<void> _openPlayer(String videoId) async {
    await Navigator.of(context).push(
      youngMuslimPageRoute<void>(
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
        child: YoungMuslimRouteScope.inherit(
          context: context,
          child: YoungMuslimVideoDetailsScreen(videoId: videoId),
        ),
      ),
    );
  }
}

class _ActionCircleButton extends StatelessWidget {
  const _ActionCircleButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Ink(
        width: 52.w,
        height: 52.w,
        decoration: youngMuslimPanelDecoration(context, radius: 18),
        child: Icon(icon, color: color),
      ),
    );
  }
}
