import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_time_animations.dart';

class PrayerAnimationsShowcase extends StatelessWidget {
  const PrayerAnimationsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final prayers = [
      {'type': Prayer.fajr, 'name': 'Fajr'},
      {'type': Prayer.sunrise, 'name': 'Sunrise'},
      {'type': Prayer.dhuhr, 'name': 'Dhuhr'},
      {'type': Prayer.asr, 'name': 'Asr'},
      {'type': Prayer.maghrib, 'name': 'Maghrib'},
      {'type': Prayer.isha, 'name': 'Isha'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Time Animations'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16.sp,
            mainAxisSpacing: 16.sp,
          ),
          itemCount: prayers.length,
          itemBuilder: (context, index) {
            final prayer = prayers[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrayerTimeAnimationWidget(
                      prayerType: prayer['type']! as Prayer,
                      size: 80,
                      isActive: true,
                    ),
                    SizedBox(height: 12.sp),
                    Text(
                      prayer['name']! as String,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
