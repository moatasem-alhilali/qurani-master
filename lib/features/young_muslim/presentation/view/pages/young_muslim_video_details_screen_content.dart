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
                icon: AppIcon(
                  AppIcons.play,
                  size: 15.sp,
                  color: context.onPrimaryColor,
                  strokeWidth: 1.55,
                ),
                label: Text(
                  details.video.hasProgress ? 'متابعة المشاهدة' : 'تشغيل الآن',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: context.onPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            _ActionCircleButton(
              icon: details.video.isFavorite
                  ? AppIcons.heartFilled
                  : AppIcons.heart,
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
                  ? AppIcons.bookmark
                  : AppIcons.bookmarkAdd,
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
            padding: EdgeInsets.all(16.r),
            decoration: youngMuslimPanelDecoration(context),
            child: Wrap(
              spacing: 12.w,
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
          padding: EdgeInsets.all(16.r),
          decoration: youngMuslimPanelDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const YoungMuslimSectionHeader(
                title: 'معلومات الحلقة',
                subtitle: 'تفاصيل بسيطة وواضحة للطفل وولي الأمر',
              ),
              SizedBox(height: 16.h),
              _buildInfoRow(
                context,
                'القصة',
                details.video.topicTitle,
                isBold: true,
              ),
              _buildInfoRow(context, 'القسم', details.category.titleAr),
              _buildInfoRow(context, 'السلسلة', details.series.titleAr),
              if (details.video.episodeNumber != null)
                _buildInfoRow(
                  context,
                  'رقم الحلقة',
                  '${details.video.episodeNumber}',
                ),
              if (details.videoQuiz != null) ...[
                SizedBox(height: 16.h),
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
                    icon: AppIcon(
                      AppIcons.target,
                      size: 14.sp,
                      color: context.primaryColor,
                      strokeWidth: 1.55,
                    ),
                    label: Text(
                      'أسئلة الحلقة',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(
                        color: context.primaryColor.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
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
                  icon: AppIcon(
                    AppIcons.target,
                    size: 14.sp,
                    color: context.primaryColor,
                    strokeWidth: 1.55,
                  ),
                  label: Text(
                    'نقاطي وإنجازاتي',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(
                      color: context.primaryColor.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
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

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13.sp,
              color: context.onSurfaceVariant.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                color: context.onSurfaceColor,
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
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

  final HugeIconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Ink(
        width: 42.w,
        height: 42.w,
        decoration: youngMuslimPanelDecoration(context, radius: 14),
        child: AppIcon(
          icon,
          color: color,
          size: 16.sp,
          strokeWidth: 1.55,
        ),
      ),
    );
  }
}
