import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/quran_widgets/animated_prayer_time_widget.dart';
import 'package:quran_app/core/components/quran_widgets/animated_progress_ring_widget.dart';
import 'package:quran_app/core/components/quran_widgets/animated_tasbih_widget.dart';
import 'package:quran_app/core/components/quran_widgets/breathing_animation_widget.dart';
import 'package:quran_app/core/components/quran_widgets/expanding_fab_widget.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_icon_widget.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_text_widget.dart';
import 'package:quran_app/core/components/quran_widgets/flip_card_3d_widget.dart';
import 'package:quran_app/core/components/quran_widgets/verse_of_day_widget.dart';

class FantasticWidgetsShowcase extends StatefulWidget {
  const FantasticWidgetsShowcase({super.key});

  @override
  State<FantasticWidgetsShowcase> createState() =>
      _FantasticWidgetsShowcaseState();
}

class _FantasticWidgetsShowcaseState extends State<FantasticWidgetsShowcase> {
  double progressValue = 0.7;
  int dhikrCount = 67;
  int currentPage = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مجموعة الأدوات الرائعة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Feature Cards with Geometric Shapes
            _buildSectionTitle('1. بطاقات الميزات مع الأشكال الهندسية'),
            SizedBox(height: 16.h),
            FeatureCardIconWidget(
              title: 'القرآن الكريم',
              icon: const Icon(Icons.menu_book),
              primaryColor: FeatureCardColors.teal,
              onTap: () => _showSnackBar('تم النقر على القرآن الكريم'),
            ),
            FeatureCardIconWidget(
              title: 'الأذكار',
              icon: const Icon(Icons.favorite),
              primaryColor: FeatureCardColors.blue,
              shapeType: CardShapeType.waves,
              onTap: () => _showSnackBar('تم النقر على الأذكار'),
            ),
            FeatureCardIconWidget(
              title: 'مواقيت الصلاة',
              icon: const Icon(Icons.access_time),
              primaryColor: FeatureCardColors.purple,
              shapeType: CardShapeType.stars,
              onTap: () => _showSnackBar('تم النقر على مواقيت الصلاة'),
            ),
            FeatureCardIconWidget(
              title: 'التسبيح',
              icon: const Icon(Icons.radio_button_checked),
              primaryColor: FeatureCardColors.orange,
              shapeType: CardShapeType.hexagons,
              onTap: () => _showSnackBar('تم النقر على التسبيح'),
            ),
            SizedBox(height: 40.h),

            // Section 2: 3D Flip Cards
            _buildSectionTitle('2. بطاقات الآيات القرآنية المتحركة'),
            SizedBox(height: 16.h),
            const Center(
              child: QuranVerseCard(
                verseArabic:
                    'وَإِذَا قُرِئَ الْقُرْآنُ فَاسْتَمِعُوا لَهُ وَأَنصِتُوا لَعَلَّكُمْ تُرْحَمُونَ',
                verseTranslation:
                    'And when the Quran is recited, then listen to it and be silent that you may receive mercy.',
                surahName: 'سورة الأعراف',
                verseNumber: 204,
                primaryColor: FeatureCardColors.green,
              ),
            ),

            SizedBox(height: 40.h),

            // Section 3: Prayer Time Widget
            _buildSectionTitle('3. عداد مواقيت الصلاة الدائري'),
            SizedBox(height: 16.h),
            Center(
              child: AnimatedPrayerTimeWidget(
                size: 220.w,
                prayerTimes: [
                  PrayerTime(
                    name: 'الفجر',
                    time: const TimeOfDay(hour: 5, minute: 30),
                    arabicName: 'الفجر',
                  ),
                  PrayerTime(
                    name: 'الظهر',
                    time: const TimeOfDay(hour: 12, minute: 15),
                    arabicName: 'الظهر',
                  ),
                  PrayerTime(
                    name: 'العصر',
                    time: const TimeOfDay(hour: 15, minute: 45),
                    arabicName: 'العصر',
                  ),
                  PrayerTime(
                    name: 'المغرب',
                    time: const TimeOfDay(hour: 18, minute: 20),
                    arabicName: 'المغرب',
                  ),
                  PrayerTime(
                    name: 'العشاء',
                    time: const TimeOfDay(hour: 19, minute: 50),
                    arabicName: 'العشاء',
                  ),
                ],
                primaryColor: FeatureCardColors.indigo,
                activeColor: FeatureCardColors.amber,
              ),
            ),

            SizedBox(height: 40.h),

            // Section 4: Progress Rings
            _buildSectionTitle('4. حلقات التقدم المتحركة'),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    QuranReadingProgressRing(
                      currentPage: currentPage,
                      totalPages: 604,
                      size: 120.w,
                    ),
                    SizedBox(height: 8.h),
                    const Text('تقدم القراءة'),
                  ],
                ),
                Column(
                  children: [
                    DhikrCounterRing(
                      currentCount: dhikrCount,
                      targetCount: 100,
                      size: 120.w,
                      title: 'سبحان الله',
                    ),
                    SizedBox(height: 8.h),
                    const Text('عداد التسبيح'),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Progress Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage = (currentPage + 10).clamp(0, 604);
                    });
                  },
                  child: const Text('+10 صفحات'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dhikrCount = (dhikrCount + 10).clamp(0, 100);
                    });
                  },
                  child: const Text('+10 تسبيح'),
                ),
              ],
            ),

            SizedBox(height: 40.h),

            // Section 5: Custom Progress Ring
            _buildSectionTitle('5. حلقة تقدم مخصصة'),
            SizedBox(height: 16.h),
            Center(
              child: Column(
                children: [
                  AnimatedProgressRingWidget(
                    progress: progressValue,
                    size: 150.w,
                    progressColors: const [
                      FeatureCardColors.pink,
                      FeatureCardColors.purple,
                    ],
                    glowEffect: true,
                    particleEffect: true,
                  ),
                  SizedBox(height: 20.h),
                  Slider(
                    value: progressValue,
                    onChanged: (value) {
                      setState(() {
                        progressValue = value;
                      });
                    },
                    label: '${(progressValue * 100).round()}%',
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // Section 6: Digital Tasbih Counter
            _buildSectionTitle('6. مسبحة رقمية متحركة'),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SubhanAllahTasbih(size: 120.w),
                    SizedBox(height: 8.h),
                    const Text('سبحان الله'),
                  ],
                ),
                Column(
                  children: [
                    AlhamdulillahTasbih(size: 120.w),
                    SizedBox(height: 8.h),
                    const Text('الحمد لله'),
                  ],
                ),
                Column(
                  children: [
                    AllahuAkbarTasbih(size: 120.w),
                    SizedBox(height: 8.h),
                    const Text('الله أكبر'),
                  ],
                ),
              ],
            ),

            SizedBox(height: 40.h),

            // Section 7: Breathing Animation
            _buildSectionTitle('7. تمارين التنفس والتأمل'),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    DhikrBreathingWidget(
                      size: 140.w,
                      dhikrText: 'لا إله إلا الله',
                    ),
                    SizedBox(height: 8.h),
                    const Text('تنفس الذكر'),
                  ],
                ),
                Column(
                  children: [
                    RelaxationBreathingWidget(size: 140.w),
                    SizedBox(height: 8.h),
                    const Text('تنفس الاسترخاء'),
                  ],
                ),
              ],
            ),

            SizedBox(height: 40.h),

            // Section 8: Qibla Compass
            _buildSectionTitle('8. بوصلة القبلة'),
            SizedBox(height: 16.h),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Column(
            //       children: [
            //         SimpleQiblaCompass(
            //           size: 150.w,
            //           qiblaDirection: 45,
            //           currentDirection: progressValue * 360,
            //         ),
            //         SizedBox(height: 8.h),
            //         const Text('بوصلة بسيطة'),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         DetailedQiblaCompass(
            //           size: 150.w,
            //           qiblaDirection: 45,
            //           currentDirection: progressValue * 360,
            //           distance: 1500,
            //           cityName: 'القاهرة',
            //         ),
            //         SizedBox(height: 8.h),
            //         const Text('بوصلة مفصلة'),
            //       ],
            //     ),
            //   ],
            // ),

            SizedBox(height: 40.h),

            // Section 9: Verse of the Day
            _buildSectionTitle('9. آية اليوم'),
            SizedBox(height: 16.h),
            CardWidget(
              color: Colors.black,
              child: Column(
                children: [
                  WisdomVerseWidget(
                    width: 350.w,
                    height: 220.h,
                  ),
                  SizedBox(height: 16.h),
                  HopeVerseWidget(
                    width: 350.w,
                    height: 220.h,
                  ),
                ],
              ),
            ),

            SizedBox(height: 100.h), // Space for FAB
          ],
        ),
      ),

      // Section 10: Expanding FAB
      floatingActionButton: ExpandingFabWidget(
        children: QuranAppFabActions.defaultActions
            .map(
              (action) => FabAction(
                icon: action.icon,
                onPressed: () =>
                    _showSnackBar('تم النقر على ${action.tooltip}'),
                backgroundColor: _getRandomColor(),
              ),
            )
            .toList(),
        primaryColor: FeatureCardColors.green,
        closedIcon: Icons.apps,
        openIcon: Icons.close,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Color _getRandomColor() {
    final colors = [
      FeatureCardColors.red,
      FeatureCardColors.blue,
      FeatureCardColors.green,
      FeatureCardColors.orange,
      FeatureCardColors.purple,
      FeatureCardColors.teal,
    ];
    return colors[(DateTime.now().millisecondsSinceEpoch % colors.length)];
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}

// Example of how to use these widgets in your app
class ExampleUsageWidget extends StatelessWidget {
  const ExampleUsageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استخدام الأدوات')),
      body: Column(
        children: [
          // Simple feature card
          FeatureCardIconWidget(
            title: 'مثال بسيط',
            icon: const Icon(Icons.star),
            primaryColor: FeatureCardColors.amber,
            shapeType: CardShapeType.stars,
            onTap: () {
              // Your action here
            },
          ),

          SizedBox(height: 20.h),

          // Simple progress ring
          AnimatedProgressRingWidget(
            progress: 0.75,
            size: 100.w,
            progressColors: const [Colors.green, Colors.lightGreen],
          ),
        ],
      ),

      // Simple expanding FAB
      floatingActionButton: ExpandingFabWidget(
        children: [
          FabAction(
            icon: Icons.home,
            onPressed: () {
              // Navigate to home
            },
          ),
          FabAction(
            icon: Icons.search,
            onPressed: () {
              // Open search
            },
          ),
        ],
      ),
    );
  }
}

// Predefined color schemes for different cards
class FeatureCardColors {
  static const Color teal = Color(0xFF14B8A6);
  static const Color blue = Color(0xFF3B82F6);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color orange = Color(0xFFF59E0B);
  static const Color red = Color(0xFFEF4444);
  static const Color green = Color(0xFF10B981);
  static const Color pink = Color(0xFFEC4899);
  static const Color indigo = Color(0xFF6366F1);
  static const Color amber = Color(0xFFFBBF24);
  static const Color emerald = Color(0xFF10B981);
}
