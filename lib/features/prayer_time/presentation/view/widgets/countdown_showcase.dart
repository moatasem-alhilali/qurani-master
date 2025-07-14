import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/next_prayer_countdown_widget.dart';

class CountdownShowcase extends StatelessWidget {
  const CountdownShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final samplePrayers = [
      TimePrayerModel(
        id: 1,
        title: 'الفجر',
        time: '05:30',
        type: Prayer.fajr,
        image: '',
        content: 'صلاة الفجر خيرٌ من الدنيا وما فيها',
        color: Colors.purple,
      ),
      TimePrayerModel(
        id: 2,
        title: 'الظهر',
        time: '12:15',
        type: Prayer.dhuhr,
        image: '',
        content: 'من صلى الظهر تحرم عليه نفحات يوم القيامة',
        color: Colors.yellow,
      ),
      TimePrayerModel(
        id: 3,
        title: 'العصر',
        time: '15:45',
        type: Prayer.asr,
        image: '',
        content: 'من ترك صلاة العصر حبط عمله',
        color: Colors.orange,
      ),
      TimePrayerModel(
        id: 4,
        title: 'المغرب',
        time: '18:30',
        type: Prayer.maghrib,
        image: '',
        content: 'من يصلي المغرب حاضرًا لن يدخل النار',
        color: Colors.red,
      ),
      TimePrayerModel(
        id: 5,
        title: 'العشاء',
        time: '20:00',
        type: Prayer.isha,
        image: '',
        content: 'العشاء نور في الدنيا ونور في الآخرة',
        color: Colors.indigo,
      ),
    ];

    return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Text(
                'Amazing Prayer Countdown Widgets',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: samplePrayers.length,
              itemBuilder: (context, index) {
                final prayer = samplePrayers[index];
                // Sample remaining time (different for each prayer)
                final remainingTime = Duration(
                  hours: 2 + index,
                  minutes: 30 + (index * 10),
                  seconds: 45 + (index * 5),
                );

                return NextPrayerCountdownWidget(
                  nextPrayer: prayer,
                  remainingTime: remainingTime,
                );
              },
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Each prayer has its own unique animation and visual style that represents the time of day. The countdown timer updates in real-time with beautiful animations.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      );
  }
}
