import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';

class PrayerAthanAlertScreen extends StatelessWidget {
  const PrayerAthanAlertScreen({
    required this.prayerName,
    this.prayerTimeLabel,
    super.key,
  });

  final String prayerName;
  final String? prayerTimeLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.primaryColor.withValues(alpha: 0.10),
              context.scaffoldBackgroundColor,
              context.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(
                      Icons.close,
                      color: context.onSurfaceColor,
                    ),
                  ),
                ),
                const Spacer(),
                CardWidget(
                  border: Border.all(
                    color: context.outlineVariant.withValues(alpha: 0.4),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          color: context.primaryColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mosque_rounded,
                          size: 38.sp,
                          color: context.primaryColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'حان الآن وقت الصلاة',
                        style: context.titleMedium?.copyWith(
                          color: context.onSurfaceColor.withValues(alpha: 0.82),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        prayerName,
                        style: context.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if ((prayerTimeLabel ?? '').trim().isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          prayerTimeLabel!,
                          style: context.bodyMedium?.copyWith(
                            color:
                                context.onSurfaceColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                      SizedBox(height: 12.h),
                      Text(
                        'أقم صلاتك بخشوع، فهي نور القلب وسكينة الروح.',
                        style: context.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('تم الاستعداد للصلاة'),
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PrayerTimeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.schedule_rounded),
                    label: const Text('فتح صفحة أوقات الصلاة'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
