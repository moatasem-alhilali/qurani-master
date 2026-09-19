import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/services/permission/location_permission_service.dart';
import 'package:quran_app/core/services/permission/notification_permission_service.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_sliver_widget.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/another_featuers.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_continue_reading.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_daily_ayah.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_prayer_tracker.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/prayer_time/data/service/athan_mute_store.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/next_prayer_countdown/next_prayer_countdown_widget.dart';
import 'package:quran_app/features/young_muslim/presentation/view/young_muslim_provider.dart';
import 'package:quran_app/l10n/l10n.dart';
import 'package:quran_app/src/core/update/app_update_cubit.dart';
import 'package:quran_app/src/core/update/app_update_service.dart';
import 'package:quran_app/src/core/update/update_prompts.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenNew> {
  bool _didStartPrayerBootstrap = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_startPrayerTimeBootstrap());
      unawaited(AthanMuteStore.instance.hydrate());
    });
  }

  Future<void> _startPrayerTimeBootstrap() async {
    if (_didStartPrayerBootstrap || !mounted) {
      return;
    }
    _didStartPrayerBootstrap = true;

    try {
      await LocationPermissionService.init();
    } catch (_) {
      // PrayerTimeBloc will resolve the final UI state and show the notice.
    } finally {
      if (mounted) {
        context.read<PrayerTimeBloc>().add(const PrayerTimeInitRequested());
      }
    }

    unawaited(
      NotificationPermissionService.handelNotification().catchError((_) {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    // الصفحة كلها سطح ورقي واحد يمتدّ من أسفل المشهد: لا بطاقات عائمة على
    // أرضية داكنة، بل محتوى متّصل تفصله خطوط شعرة.
    return AppSliverWidget(
      hasAppBar: false,
      topSpacing: 0,
      child: ColoredBox(
        color: skin.ground,
        child: Column(
          children: [
            // المشهد + مواقيت اليوم + المداخل السريعة.
            const NextPrayerCountdownWidget(),
            const _HomeUpdateTile(),

            skin.divider(),
            HomeSectionHeader(title: context.l10n.homeSectionYourDay),
            const HomePrayerTracker(),
            SizedBox(height: 4.h),
            const HomeContinueReading(),

            skin.divider(),
            HomeSectionHeader(title: context.l10n.homeSectionAyah),
            const HomeDailyAyah(),

            skin.divider(),
            HomeSectionHeader(title: context.l10n.homeSectionFeatures),
            Padding(
              padding: AppSkin.gutter,
              child: const AnotherFeatures(),
            ),

            skin.divider(),
            HomeSectionHeader(title: context.l10n.homeSectionKids),
            const _YoungMuslimRow(),

            SizedBox(height: 18.h),
          ],
        ),
      ),
    );
  }
}

/// «المسلم الصغير» — صفّ بنفس لغة بقية الأقسام.
class _YoungMuslimRow extends StatelessWidget {
  const _YoungMuslimRow();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    return InkWell(
      onTap: () => context.push(const YoungMuslimProvider()),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
        child: Row(
          children: [
            AppIcon(AppIcons.bookOpen, color: skin.accent, size: 17.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.homeYoungMuslimTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    context.l10n.homeYoungMuslimSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            AppIcon(
              AppIcons.forwardFor(context),
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeUpdateTile extends StatelessWidget {
  const _HomeUpdateTile();

  @override
  Widget build(BuildContext context) {
    // Reminder tile is iOS-only: on Android, Google Play In-App Updates shows
    // its own native UI, so no in-app tile is needed there.
    return BlocBuilder<AppUpdateCubit, AppUpdateStatus>(
      builder: (context, state) {
        if (state is! AppUpdateIosAvailable) {
          return const SizedBox.shrink();
        }

        final skin = AppSkin.of(context);

        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
          child: InkWell(
            // Same dialog used on launch and in Settings — one consistent
            // iOS update experience. No `onLater` here: the tile is a
            // persistent reminder the user can reopen anytime.
            onTap: () => showIosUpdateDialog(
              context,
              storeVersion: state.storeVersion,
              storeUrl: state.storeUrl,
              releaseNotes: state.releaseNotes,
            ),
            borderRadius: BorderRadius.circular(12.r),
            child: Ink(
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 9.h),
              child: Row(
                children: [
                  AppIcon(
                    AppIcons.update,
                    color: skin.accent,
                    size: 16.sp,
                  ),
                  SizedBox(width: 9.w),
                  Expanded(
                    child: Text(
                      context.l10n.homeUpdateAvailable(state.storeVersion),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      context.l10n.homeUpdateAction,
                      style: TextStyle(
                        color: AppColors.brandIvory,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
