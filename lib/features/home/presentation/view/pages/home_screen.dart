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
    final accentSoft = context.primaryContainer.withValues(alpha: 0.80);
    final titleColor = context.onSurfaceColor;
    final bodyColor = context.onSurfaceVariant.withValues(alpha: 0.86);
    final panelBackground = context.surfaceVariant.withValues(alpha: 0.58);

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
              blurRadius: 14.r,
              offset: Offset(0, 7.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -14.h,
              left: -8.w,
              child: Container(
                width: 68.w,
                height: 68.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentSoft.withValues(alpha: 0.22),
                ),
              ),
            ),
            Positioned(
              bottom: -10.h,
              right: 20.w,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.10),
                ),
              ),
            ),
            Positioned(
              top: 12.h,
              left: 14.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
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
                          SizedBox(height: 3.h),
                          Text(
                            'رحلة خفيفة للطفل بين القصص والآداب والأذكار',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: 8.8.sp,
                              height: 1.20,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              _YoungMuslimDot(color: accent),
                              SizedBox(width: 6.w),
                              Text(
                                'قصص',
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 8.2.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              _YoungMuslimDot(
                                color: context.secondaryColor,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'آداب',
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 8.2.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              _YoungMuslimDot(
                                color: context.primaryContainer,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'أذكار',
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 8.2.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 74.w,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      color: panelBackground,
                      border: Border.all(
                        color: context.outline.withValues(alpha: 0.65),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
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
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _YoungMuslimPanelLine(
                            width: 32.w,
                            color: context.outline.withValues(alpha: 0.55),
                          ),
                          SizedBox(height: 4.h),
                          _YoungMuslimPanelLine(
                            width: 22.w,
                            color: context.outline.withValues(alpha: 0.42),
                          ),
                        ],
                      ),
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

class _YoungMuslimPanelLine extends StatelessWidget {
  const _YoungMuslimPanelLine({
    required this.width,
    required this.color,
  });

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999.r),
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
