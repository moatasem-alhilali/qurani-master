import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/radio/data/service/radio_sleep_timer.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_sleep_timer_sheet.dart';
import 'package:quran_app/l10n/l10n.dart';

/// شارة مؤقّت النوم: هلال حين لا مؤقّت، وعدّاد تنازلي حين يعمل.
///
/// العدّاد داخل [ValueListenableBuilder] وحده، فلا تُبنى الصفحة ستّين مرّة
/// في الدقيقة من أجل رقمين.
class RadioSleepChip extends StatelessWidget {
  const RadioSleepChip({required this.timer, super.key});

  final RadioSleepTimer timer;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return ValueListenableBuilder<Duration?>(
      valueListenable: timer.remaining,
      builder: (context, remaining, _) {
        final isRunning = remaining != null;

        return Semantics(
          button: true,
          label: context.l10n.radioSleepTimer,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              showRadioSleepTimerSheet(context, timer: timer);
            },
            borderRadius: BorderRadius.circular(999.r),
            child: Ink(
              padding: EdgeInsets.symmetric(
                horizontal: isRunning ? 11.w : 9.w,
                vertical: 7.h,
              ),
              decoration: BoxDecoration(
                color: isRunning
                    ? skin.accent.withValues(alpha: 0.14)
                    : skin.iconChip,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(
                    AppIcons.moon,
                    color: isRunning
                        ? skin.accent
                        : skin.inkSoft.withValues(alpha: 0.6),
                    size: 15.sp,
                  ),
                  if (isRunning) ...[
                    SizedBox(width: 6.w),
                    Text(
                      RadioSleepTimer.format(remaining),
                      style: TextStyle(
                        color: skin.accent,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
