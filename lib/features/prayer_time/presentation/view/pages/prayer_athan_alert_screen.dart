import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B3D2E),
              Color(0xFF145A45),
              Color(0xFF1B6E55),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.mosque_rounded,
                  size: 90.sp,
                  color: Colors.white,
                ),
                SizedBox(height: 18.h),
                Text(
                  'حان الآن وقت صلاة',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  prayerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                if ((prayerTimeLabel ?? '').trim().isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    prayerTimeLabel!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                Text(
                  'أقم صلاتك بخشوع، فهي نور القلب وسكينة الروح.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0B3D2E),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('تم الاستعداد للصلاة'),
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PrayerTimeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.schedule),
                    label: const Text('فتح صفحة أوقات الصلاة'),
                  ),
                ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
