import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_header_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_sliver_widget.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/another_featuers.dart';
import 'package:quran_app/features/manage_version/presentation/bloc/version_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/next_prayer_countdown/next_prayer_countdown_widget.dart';
import 'package:quran_app/features/young_muslim/presentation/view/young_muslim_provider.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenNew> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppSliverWidget(
      hasAppBar: false,
      topSpacing: 0,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            const NextPrayerCountdownWidget(),
            const _HomeUpdateTile(),
            const BaseHederWidget(text: 'المميزات'),
            const AnotherFeatures(),
            const BaseHederWidget(text: 'قسم الأطفال'),
            SizedBox(
              height: context.getHight(22),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _YoungMuslimCard(
                      width: context.getWidth(90),
                      height: context.getHight(18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _YoungMuslimCard extends StatelessWidget {
  const _YoungMuslimCard({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cardBackground = context.surfaceColor;
    final cardBackgroundSoft = context.primaryContainer.withValues(alpha: 0.45);
    final cardBorder = context.outline.withValues(alpha: 0.85);
    final shadow = context.shadow.withValues(alpha: 0.10);
    final accent = context.primaryColor;
    final accentSoft = context.primaryContainer.withValues(alpha: 0.80);
    final titleColor = context.onSurfaceColor;
    final bodyColor = context.onSurfaceVariant.withValues(alpha: 0.86);

    return InkWell(
      onTap: () {
        context.push(const YoungMuslimProvider());
      },
      borderRadius: BorderRadius.circular(26.r),
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cardBackground,
              cardBackgroundSoft,
            ],
          ),
          border: Border.all(
            color: cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 20.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -22.h,
              right: -12.w,
              child: Container(
                width: 96.w,
                height: 96.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentSoft.withValues(alpha: 0.22),
                ),
              ),
            ),
            Positioned(
              bottom: -14.h,
              left: 18.w,
              child: Container(
                width: 58.w,
                height: 58.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.10),
                ),
              ),
            ),
            Positioned(
              top: 18.h,
              right: 18.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.18),
                  ),
                ),
                child: Text(
                  'تعلّم ممتع',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 9.4.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المسلم الصغير',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'رحلة خفيفة للطفل بين القصص والآداب والأذكار',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 10.5.sp,
                      height: 1.28,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 7.w,
                    runSpacing: 7.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const _YoungMuslimMiniPill(
                        icon: Icons.auto_stories_rounded,
                        label: 'قصص',
                      ),
                      const _YoungMuslimMiniPill(
                        icon: Icons.favorite_border_rounded,
                        label: 'آداب',
                      ),
                      const _YoungMuslimMiniPill(
                        icon: Icons.star_border_rounded,
                        label: 'أذكار',
                      ),
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accentSoft,
                              accent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: shadow.withValues(alpha: 0.18),
                              blurRadius: 10.r,
                              offset: Offset(0, 5.h),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_lesson_rounded,
                          color: context.onPrimaryColor,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YoungMuslimMiniPill extends StatelessWidget {
  const _YoungMuslimMiniPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final background = context.surfaceColor.withValues(alpha: 0.70);
    final border = context.outline.withValues(alpha: 0.90);
    final foreground = context.onSurfaceColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: foreground,
            size: 13.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 9.4.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeUpdateTile extends StatelessWidget {
  const _HomeUpdateTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VersionBloc, VersionState>(
      builder: (context, state) {
        if (!state.isConnected ||
            !state.hasUpdateAvailable ||
            !state.canDownload ||
            state.latestVersionInfo == null) {
          return const SizedBox.shrink();
        }

        final versionInfo = state.latestVersionInfo!;
        final accentColor = versionInfo.isUpdateRequired
            ? const Color(0xFFCC9D2F)
            : context.primaryColor;

        return Padding(
          padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 12.h),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.22),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              onTap: () {
                context.read<VersionBloc>().add(
                      OpenDownloadLinkEvent(
                        downloadUrl: versionInfo.downloadUrl,
                      ),
                    );
              },
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 4.h,
              ),
              leading: Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.system_update_alt_rounded,
                  color: accentColor,
                  size: 24.sp,
                ),
              ),
              title: Text(
                'يوجد تحديث جديد للتطبيق',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  [
                    'الإصدار ${versionInfo.latestVersion}',
                    if (versionInfo.downloadSize?.isNotEmpty ?? false)
                      versionInfo.downloadSize!,
                  ].join(' • '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.onSurfaceColor.withValues(alpha: 0.72),
                      ),
                ),
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  'تحميل',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
