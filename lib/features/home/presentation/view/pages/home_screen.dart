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
              height: context.getHight(18),
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
    final titleColor = context.onSurfaceColor;
    final bodyColor = context.onSurfaceVariant.withValues(alpha: 0.86);
    final chipBackground = accent.withValues(alpha: 0.10);
    final chipBorder = accent.withValues(alpha: 0.16);

    return InkWell(
      onTap: () {
        context.push(const YoungMuslimProvider());
      },
      borderRadius: BorderRadius.circular(22.r),
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
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
              blurRadius: 14.r,
              offset: Offset(0, 7.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 4.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      accent,
                      accent.withValues(alpha: 0.14),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -12.h,
              right: -12.w,
              child: Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              top: 12.h,
              left: 14.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: chipBackground,
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: chipBorder,
                  ),
                ),
                child: Text(
                  'تعلّم ممتع',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Row(
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      color: chipBackground,
                      border: Border.all(
                        color: chipBorder,
                      ),
                    ),
                    child: Icon(
                      Icons.play_lesson_rounded,
                      color: accent,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'المسلم الصغير',
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 16.sp,
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
                            fontSize: 8.8.sp,
                            height: 1.22,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            _YoungMuslimDot(color: accent),
                            SizedBox(width: 5.w),
                            Text(
                              'قصص',
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            _YoungMuslimDot(color: context.secondaryColor),
                            SizedBox(width: 5.w),
                            Text(
                              'آداب',
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            _YoungMuslimDot(color: context.primaryContainer),
                            SizedBox(width: 5.w),
                            Text(
                              'أذكار',
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w700,
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
          ],
        ),
      ),
    );
  }
}

class _YoungMuslimDot extends StatelessWidget {
  const _YoungMuslimDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
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
