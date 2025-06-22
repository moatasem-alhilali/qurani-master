import 'package:flutter/material.dart';
import 'package:quran_app/core/components/timeline_list_item.dart';

/// Example usage of TimelineListItem component
/// This recreates the exact UI shown in the image with prayer times
class TimelineListItemExample extends StatefulWidget {
  const TimelineListItemExample({super.key});

  @override
  State<TimelineListItemExample> createState() =>
      _TimelineListItemExampleState();
}

class _TimelineListItemExampleState extends State<TimelineListItemExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Prayer Times Timeline - Exactly like the image
            TimelineList(
              items: [
                TimelineItemVariants.prayer(
                  title: 'الفجر',
                  subtitle: 'صلاة الفجر',
                  icon: Icons.wb_twilight,
                  time: '04:30',
                  status: TimelineItemStatus.completed,
                  iconColor: Colors.blue,
                ),
                TimelineItemVariants.prayer(
                  title: 'الشروق',
                  subtitle: 'شروق الشمس',
                  icon: Icons.wb_sunny,
                  time: '06:15',
                  status: TimelineItemStatus.completed,
                  iconColor: Colors.orange,
                ),
                TimelineItemVariants.prayer(
                  title: 'الظهر',
                  subtitle: 'صلاة الظهر',
                  icon: Icons.wb_sunny_outlined,
                  time: '12:30',
                  status: TimelineItemStatus.active,
                  iconColor: Colors.amber,
                ),
                TimelineItemVariants.prayer(
                  title: 'العصر',
                  subtitle: 'صلاة العصر',
                  icon: Icons.wb_cloudy,
                  time: '15:45',
                  status: TimelineItemStatus.upcoming,
                  iconColor: Colors.orange,
                ),
                TimelineItemVariants.prayer(
                  title: 'المغرب',
                  subtitle: 'صلاة المغرب',
                  icon: Icons.wb_incandescent,
                  time: '18:20',
                  status: TimelineItemStatus.upcoming,
                  iconColor: Colors.red,
                ),
                TimelineItemVariants.prayer(
                  title: 'العشاء',
                  subtitle: 'صلاة العشاء',
                  icon: Icons.nights_stay,
                  time: '19:45',
                  status: TimelineItemStatus.upcoming,
                  iconColor: Colors.indigo,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Daily Schedule Timeline
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الجدول اليومي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TimelineList(
                    items: [
                      TimelineItemVariants.event(
                        title: 'قراءة القرآن',
                        subtitle: 'سورة البقرة',
                        icon: Icons.book,
                        time: '07:00',
                        status: TimelineItemStatus.completed,
                        iconColor: Colors.green,
                      ),
                      TimelineItemVariants.event(
                        title: 'الأذكار',
                        subtitle: 'أذكار الصباح',
                        icon: Icons.favorite,
                        time: '08:00',
                        status: TimelineItemStatus.active,
                        iconColor: Colors.pink,
                      ),
                      TimelineItemVariants.event(
                        title: 'الدعاء',
                        subtitle: 'دعاء الرزق',
                        icon: Icons.pan_tool,
                        time: '14:00',
                        status: TimelineItemStatus.upcoming,
                        iconColor: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Individual Timeline Items Examples
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'أمثلة فردية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Active item
                  TimelineListItem(
                    title: 'النشاط الحالي',
                    subtitle: 'جاري الآن',
                    icon: Icons.play_circle,
                    time: 'الآن',
                    status: TimelineItemStatus.active,
                    iconColor: Colors.blue,
                    isFirst: true,
                    onTap: () {
                      // Handle tap
                    },
                  ),

                  // Completed item
                  TimelineListItem(
                    title: 'تم الإنجاز',
                    subtitle: 'مكتمل',
                    icon: Icons.check_circle,
                    time: '10:00',
                    status: TimelineItemStatus.completed,
                    iconColor: Colors.green,
                    onTap: () {
                      // Handle tap
                    },
                  ),

                  // Upcoming item
                  TimelineListItem(
                    title: 'قادم',
                    subtitle: 'في الانتظار',
                    icon: Icons.schedule,
                    time: '16:00',
                    iconColor: Colors.orange,
                    onTap: () {
                      // Handle tap
                    },
                  ),

                  // Inactive item
                  TimelineListItem(
                    title: 'غير نشط',
                    subtitle: 'معطل',
                    icon: Icons.cancel,
                    time: '--:--',
                    status: TimelineItemStatus.inactive,
                    iconColor: Colors.grey,
                    isLast: true,
                    onTap: () {
                      // Handle tap
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// Quick usage examples for common scenarios
class PrayerTimesExample {
  // Prayer times for a typical day
  static List<TimelineListItem> getPrayerTimes() {
    return [
      TimelineItemVariants.prayer(
        title: 'الفجر',
        subtitle: 'صلاة الفجر',
        icon: Icons.wb_twilight,
        time: '04:30',
        status: TimelineItemStatus.completed,
        iconColor: Colors.blue,
      ),
      TimelineItemVariants.prayer(
        title: 'الشروق',
        subtitle: 'شروق الشمس',
        icon: Icons.wb_sunny,
        time: '06:15',
        status: TimelineItemStatus.completed,
        iconColor: Colors.orange,
      ),
      TimelineItemVariants.prayer(
        title: 'الظهر',
        subtitle: 'صلاة الظهر',
        icon: Icons.wb_sunny_outlined,
        time: '12:30',
        status: TimelineItemStatus.active,
        iconColor: Colors.amber,
      ),
      TimelineItemVariants.prayer(
        title: 'العصر',
        subtitle: 'صلاة العصر',
        icon: Icons.wb_cloudy,
        time: '15:45',
        status: TimelineItemStatus.upcoming,
        iconColor: Colors.orange,
      ),
      TimelineItemVariants.prayer(
        title: 'المغرب',
        subtitle: 'صلاة المغرب',
        icon: Icons.wb_incandescent,
        time: '18:20',
        status: TimelineItemStatus.upcoming,
        iconColor: Colors.red,
      ),
      TimelineItemVariants.prayer(
        title: 'العشاء',
        subtitle: 'صلاة العشاء',
        icon: Icons.nights_stay,
        time: '19:45',
        status: TimelineItemStatus.upcoming,
        iconColor: Colors.indigo,
      ),
    ];
  }

  // Simple usage in any widget
  static Widget buildPrayerTimeline() {
    return TimelineList(items: getPrayerTimes());
  }
}

/// Ramadan Schedule Example
class RamadanScheduleExample {
  static List<TimelineListItem> getRamadanSchedule() {
    return [
      TimelineItemVariants.event(
        title: 'السحور',
        subtitle: 'وجبة السحور',
        icon: Icons.restaurant,
        time: '03:30',
        status: TimelineItemStatus.completed,
        iconColor: Colors.brown,
      ),
      TimelineItemVariants.prayer(
        title: 'الفجر',
        subtitle: 'صلاة الفجر',
        icon: Icons.wb_twilight,
        time: '04:00',
        status: TimelineItemStatus.completed,
        iconColor: Colors.blue,
      ),
      TimelineItemVariants.event(
        title: 'قراءة القرآن',
        subtitle: '5 صفحات',
        icon: Icons.book,
        time: '09:00',
        status: TimelineItemStatus.active,
        iconColor: Colors.green,
      ),
      TimelineItemVariants.prayer(
        title: 'المغرب',
        subtitle: 'الإفطار',
        icon: Icons.wb_incandescent,
        time: '18:20',
        status: TimelineItemStatus.upcoming,
        iconColor: Colors.red,
      ),
      TimelineItemVariants.prayer(
        title: 'التراويح',
        subtitle: 'صلاة التراويح',
        icon: Icons.nights_stay,
        time: '20:30',
        status: TimelineItemStatus.upcoming,
        iconColor: Colors.purple,
      ),
    ];
  }
}
