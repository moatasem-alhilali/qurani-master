import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/radio/data/service/radio_sleep_timer.dart';
import 'package:quran_app/l10n/l10n.dart';

/// ورقة مؤقّت النوم.
///
/// أهمّ ما كان ناقصًا في صفحة الإذاعة: من ينام على التلاوة يبقى البثّ يعمل
/// حتى الصباح، فيستنزف البيانات والبطارية. لا حلّ له سابقًا إلا فتح التطبيق
/// والضغط على الإيقاف.
Future<void> showRadioSleepTimerSheet(
  BuildContext context, {
  required RadioSleepTimer timer,
}) {
  final skin = AppSkin.of(context);

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: skin.ground,
    showDragHandle: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
    ),
    builder: (context) => _SleepTimerSheet(timer: timer),
  );
}

class _SleepTimerSheet extends StatelessWidget {
  const _SleepTimerSheet({required this.timer});

  final RadioSleepTimer timer;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 34.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: skin.hairline,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                AppIcon(AppIcons.moon, color: skin.accent, size: 16.sp),
                SizedBox(width: 8.w),
                Text(
                  context.l10n.radioSleepTimer,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              context.l10n.radioSleepTimerDescription,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            SizedBox(height: 14.h),
            ValueListenableBuilder<Duration?>(
              valueListenable: timer.remaining,
              builder: (context, remaining, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        for (final minutes in RadioSleepTimer.presets)
                          _MinuteChip(
                            minutes: minutes,
                            // «مفعّل» يعني أن المتبقّي ما زال داخل هذه المدّة
                            // ولم يتجاوز المدّة الأصغر منها.
                            isActive: remaining != null &&
                                _presetFor(remaining) == minutes,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              timer.start(Duration(minutes: minutes));
                              Navigator.of(context).pop();
                            },
                          ),
                      ],
                    ),
                    if (remaining != null) ...[
                      SizedBox(height: 14.h),
                      skin.divider(),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.l10n.radioStopsIn(
                                RadioSleepTimer.format(remaining),
                              ),
                              style: TextStyle(
                                color: skin.ink,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              timer.cancel();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              context.l10n.radioCancelTimer,
                              style: TextStyle(
                                color: skin.accent,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// أقرب مدّة معروضة تشمل المتبقّي — لتمييز الخيار المفعّل.
  static int _presetFor(Duration remaining) {
    final minutes = remaining.inSeconds / 60;
    for (final preset in RadioSleepTimer.presets) {
      if (minutes <= preset + 0.5) return preset;
    }
    return RadioSleepTimer.presets.last;
  }
}

class _MinuteChip extends StatelessWidget {
  const _MinuteChip({
    required this.minutes,
    required this.isActive,
    required this.onTap,
  });

  final int minutes;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.gold : skin.iconChip,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          context.l10n.radioMinutes(minutes),
          style: TextStyle(
            color: isActive
                ? (skin.isDark ? AppColors.brandNight : AppColors.brandIvory)
                : skin.ink,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
