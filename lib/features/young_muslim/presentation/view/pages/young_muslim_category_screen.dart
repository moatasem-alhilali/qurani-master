import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/presentation/bloc/young_muslim_bloc.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_video_details_screen.dart';
import 'package:quran_app/features/young_muslim/presentation/view/young_muslim_provider.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';

class YoungMuslimCategoryScreen extends StatefulWidget {
  const YoungMuslimCategoryScreen({
    required this.categoryId,
    super.key,
  });

  final String categoryId;

  @override
  State<YoungMuslimCategoryScreen> createState() =>
      _YoungMuslimCategoryScreenState();
}

class _YoungMuslimCategoryScreenState extends State<YoungMuslimCategoryScreen> {
  String? _selectedSeriesId;

  @override
  void initState() {
    super.initState();
    context
        .read<YoungMuslimBloc>()
        .add(YoungMuslimCategoryRequested(widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoungMuslimBloc, YoungMuslimState>(
      builder: (context, state) {
        final details = state.categoryDetails;
        if (details == null || details.category.id != widget.categoryId) {
          return const AppScaffoldWidget(
            title: 'المسلم الصغير',
            body: SizedBox(
              height: 420,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        _selectedSeriesId ??=
            details.series.isNotEmpty ? details.series.first.id : null;
        final filteredVideos = details.videos
            .where(
              (video) =>
                  _selectedSeriesId == null ||
                  video.seriesId == _selectedSeriesId,
            )
            .toList();

        final bannerColors = youngMuslimGradientColors(
          context,
          startHex: details.category.accentStart,
          endHex: details.category.accentEnd,
        );

        return AppScaffoldWidget(
          title: details.category.titleAr,
          body: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 260.h,
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
                          details.category.bannerImage,
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
                              context.scrim.withValues(alpha: 0.1),
                              context.scrim.withValues(alpha: 0.62),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 22.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            YoungMuslimMetricChip(
                              label: details.category.audience == 'kids'
                                  ? 'واجهة آمنة للأطفال'
                                  : 'مشاهدة عامة',
                              icon: Icons.child_care_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              details.category.titleAr,
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
                              details.category.description,
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
                SizedBox(height: 22.h),
                const YoungMuslimSectionHeader(
                  title: 'اختر السلسلة',
                  subtitle:
                      'يمكنك التنقّل بين السلاسل أو اللغات داخل هذا القسم',
                ),
                SizedBox(height: 14.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    for (final series in details.series)
                      ChoiceChip(
                        label: Text(series.titleAr),
                        selected: _selectedSeriesId == series.id,
                        onSelected: (_) {
                          setState(() => _selectedSeriesId = series.id);
                        },
                        selectedColor: youngMuslimAccentColor(
                          context,
                          series.accentStart,
                        ).withValues(alpha: 0.18),
                        labelStyle:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: _selectedSeriesId == series.id
                                      ? youngMuslimAccentColor(
                                          context,
                                          series.accentStart,
                                        )
                                      : context.gray1,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                  ],
                ),
                SizedBox(height: 22.h),
                YoungMuslimSectionHeader(
                  title: 'الحلقات',
                  subtitle:
                      '${filteredVideos.length} عنصر داخل السلسلة المختارة',
                ),
                SizedBox(height: 14.h),
                if (filteredVideos.isEmpty)
                  const YoungMuslimEmptyState(
                    title: 'لا توجد حلقات الآن',
                    subtitle:
                        'غيّر السلسلة المختارة أو عد لاحقًا بعد تحديث الفلاتر.',
                    icon: Icons.video_collection_outlined,
                  )
                else
                  GridView.builder(
                    itemCount: filteredVideos.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final video = filteredVideos[index];
                      return YoungMuslimVideoCard(
                        video: video,
                        seriesTitle: _seriesTitle(details, video.seriesId),
                        compact: true,
                        onTap: () => _openVideo(context, video.id),
                        onFavoriteToggle: () => context
                            .read<YoungMuslimBloc>()
                            .add(YoungMuslimFavoriteToggled(video.id)),
                        onWatchLaterToggle: () => context
                            .read<YoungMuslimBloc>()
                            .add(YoungMuslimWatchLaterToggled(video.id)),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _seriesTitle(YoungMuslimCategoryDetailsEntity details, String id) {
    for (final item in details.series) {
      if (item.id == id) {
        return item.titleAr;
      }
    }
    return '';
  }

  void _openVideo(BuildContext context, String videoId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => YoungMuslimRouteScope.inherit(
          context: context,
          child: YoungMuslimVideoDetailsScreen(videoId: videoId),
        ),
      ),
    );
  }
}
