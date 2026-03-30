import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/young_muslim/presentation/bloc/young_muslim_bloc.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_player_screen.dart';
import 'package:quran_app/features/young_muslim/presentation/view/young_muslim_provider.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_quiz_sheet.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';

class YoungMuslimVideoDetailsScreen extends StatefulWidget {
  const YoungMuslimVideoDetailsScreen({
    required this.videoId,
    super.key,
  });

  final String videoId;

  @override
  State<YoungMuslimVideoDetailsScreen> createState() =>
      _YoungMuslimVideoDetailsScreenState();
}

class _YoungMuslimVideoDetailsScreenState
    extends State<YoungMuslimVideoDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<YoungMuslimBloc>()
        .add(YoungMuslimVideoRequested(widget.videoId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoungMuslimBloc, YoungMuslimState>(
      builder: (context, state) {
        final details = state.videoDetails;
        if (details == null || details.video.id != widget.videoId) {
          return const AppScaffoldWidget(
            title: 'المسلم الصغير',
            body: SizedBox(
              height: 420,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final bannerColors = youngMuslimGradientColors(
          context,
          startHex: details.series.accentStart,
          endHex: details.series.accentEnd,
        );

        return AppScaffoldWidget(
          title: details.video.topicTitle,
          body: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 320.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: bannerColors,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: bannerColors.first.withValues(alpha: 0.16),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: Image.network(
                          details.video.thumbnailUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              context.scrim.withValues(alpha: 0.06),
                              context.scrim.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: [
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
                            SizedBox(height: 14.h),
                            Text(
                              details.video.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              details.video.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.92),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openPlayer(context, details.video.id),
                        icon: const Icon(Icons.play_circle_fill_rounded),
                        label: Text(
                          details.video.hasProgress
                              ? 'متابعة المشاهدة'
                              : 'تشغيل الآن',
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
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    YoungMuslimMetricChip(
                      label: details.video.isCompleted
                          ? 'تمت المشاهدة كاملة'
                          : details.video.hasProgress
                              ? 'تقدّم ${(details.video.progressPercent * 100).round()}%'
                              : 'لم تبدأ بعد',
                      icon: Icons.insights_rounded,
                      color: details.video.isCompleted
                          ? youngMuslimCompletionColor(context)
                          : context.primaryColor,
                    ),
                    YoungMuslimMetricChip(
                      label: youngMuslimRelative(details.video.lastWatchedAt),
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
                SizedBox(height: 22.h),
                Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: youngMuslimPanelDecoration(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YoungMuslimSectionHeader(
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
                  YoungMuslimVideoCard(
                    video: details.nextVideo!,
                    seriesTitle: details.series.titleAr,
                    onTap: () => _openVideo(context, details.nextVideo!.id),
                    onFavoriteToggle: () => context.read<YoungMuslimBloc>().add(
                          YoungMuslimFavoriteToggled(details.nextVideo!.id),
                        ),
                    onWatchLaterToggle: () => context
                        .read<YoungMuslimBloc>()
                        .add(
                          YoungMuslimWatchLaterToggled(details.nextVideo!.id),
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
                  SizedBox(
                    height: 305.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final video = details.similarVideos[index];
                        return YoungMuslimVideoCard(
                          video: video,
                          seriesTitle: video.seriesId == details.series.id
                              ? details.series.titleAr
                              : details.category.titleAr,
                          onTap: () => _openVideo(context, video.id),
                          onFavoriteToggle: () => context
                              .read<YoungMuslimBloc>()
                              .add(YoungMuslimFavoriteToggled(video.id)),
                          onWatchLaterToggle: () => context
                              .read<YoungMuslimBloc>()
                              .add(YoungMuslimWatchLaterToggled(video.id)),
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemCount: details.similarVideos.length,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPlayer(BuildContext context, String videoId) {
    Navigator.of(context)
        .push(
      MaterialPageRoute<void>(
        builder: (_) => YoungMuslimRouteScope.inherit(
          context: context,
          child: YoungMuslimPlayerScreen(videoId: videoId),
        ),
      ),
    )
        .then((_) {
      context.read<YoungMuslimBloc>().add(YoungMuslimVideoRequested(videoId));
      context.read<YoungMuslimBloc>().add(const YoungMuslimRefreshed());
    });
  }

  void _openVideo(BuildContext context, String videoId) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => YoungMuslimRouteScope.inherit(
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
