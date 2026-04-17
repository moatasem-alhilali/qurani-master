import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting_notification/data/constant/notification_data_const.dart';
import 'package:quran_app/features/setting_notification/presentation/bloc/setting_notification_bloc.dart';
import 'package:quran_app/features/setting_notification/presentation/view/pages/system_notification_screen.dart';
import 'package:quran_app/features/setting_notification/presentation/view/widgets/notification_setting_item_widget.dart';

class SettingNotificationScreen extends StatefulWidget {
  const SettingNotificationScreen({super.key});

  @override
  State<SettingNotificationScreen> createState() =>
      _SettingNotificationScreenState();
}

class _SettingNotificationScreenState extends State<SettingNotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late List<AnimationController> _itemControllers;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create individual controllers for each section
    _itemControllers = List.generate(
      4, // Number of sections
      (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      ),
    );

    _itemAnimations = _itemControllers
        .map(
          (controller) => Tween<double>(
            begin: 0,
            end: 1,
          ).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeOutCubic,
            ),
          ),
        )
        .toList();
  }

  void _startAnimations() {
    _fadeController.forward();

    // Stagger the item animations
    for (var i = 0; i < _itemControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) {
          _itemControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SettingNotificationBloc(sl())..add(LoadNotificationSettings()),
      lazy: false,
      child: AppScaffoldWidget(
        title: 'اعدادات الاشعارات',

        // titleWidget: const NextTimePrayerRemainWidget(),
        body: BlocBuilder<SettingNotificationBloc, SettingNotificationState>(
          builder: (context, state) {
            return state.loading.handle<NotificationSettingModel>(
              list: state.settings.values.toList(),
              context: context,
              onSuccess: () {
                final s = state.settings;

                return FadeTransition(
                  opacity: _fadeController,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            context.push(const SystemNotificationScreen());
                          },
                          borderRadius: BorderRadius.circular(20.r),
                          child: Ink(
                            padding: EdgeInsets.symmetric(
                              vertical: 20.h,
                              horizontal: 20.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  context.primaryColor,
                                  context.primaryColor.withValues(alpha: 0.8),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: context.primaryColor.withValues(alpha: 0.2),
                                  blurRadius: 12.r,
                                  offset: Offset(0, 6.h),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.bell_solid,
                                      size: 24.sp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'رؤية اشعارات النظام',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _buildSection(
                          0,
                          'الأذان',
                          s,
                          [
                            _NotifItem(
                              NotificationKeys.isNotificationAllAthan,
                              'كل الصلوات',
                              CupertinoIcons.bell_fill,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationAthanFagr,
                              'أذان الفجر',
                              CupertinoIcons.sunrise_fill,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationAthanDuhr,
                              'أذان الظهر',
                              CupertinoIcons.sun_max_fill,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationAthanAsr,
                              'أذان العصر',
                              CupertinoIcons.sun_haze_fill,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationAthanMagrib,
                              'أذان المغرب',
                              CupertinoIcons.sunset_fill,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationAthanIsha,
                              'أذان العشاء',
                              CupertinoIcons.moon_stars_fill,
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        _buildSection(
                          1,
                          'الورد اليومي',
                          s,
                          [
                            _NotifItem(
                              NotificationKeys.isNotificationThikrMorning,
                              'أذكار الصباح',
                              CupertinoIcons.sunrise,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationThikrNight,
                              'أذكار المساء',
                              CupertinoIcons.moon,
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        _buildSection(
                          2,
                          'العشوائي',
                          s,
                          [
                            _NotifItem(
                              NotificationKeys.isNotificationMohammed,
                              'الصلاة على محمد',
                              CupertinoIcons.heart_fill,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationRandomThikr,
                              'الأذكار الصوتية العشوائية',
                              CupertinoIcons.speaker_2_fill,
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        _buildSection(
                          3,
                          'أخرى',
                          s,
                          [
                            _NotifItem(
                              NotificationKeys.isNotificationWridGetup,
                              'أذكار الاستيقاظ',
                              CupertinoIcons.moon_zzz_fill,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationWridSleep,
                              'أذكار النوم',
                              CupertinoIcons.bed_double_fill,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationReadSurahMulk,
                              'قراءة سورة الملك',
                              CupertinoIcons.book_fill,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationReadQuran,
                              'الورد القرآني',
                              CupertinoIcons.textformat,
                            ),
                            _NotifItem(
                              NotificationKeys.isNotificationMiddleNight,
                              'قيام الليل',
                              CupertinoIcons.moon_stars,
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(
    int index,
    String title,
    Map<String, NotificationSettingModel> settings,
    List<_NotifItem> items,
  ) {
    final borderRadius = BorderRadius.circular(20.r);
    final cardBackground = context.surfaceColor;
    final cardBackgroundSoft = context.surfaceVariant.withValues(alpha: 0.42);
    final cardBorder = context.outline.withValues(alpha: 0.85);
    final shadow = context.shadow.withValues(alpha: 0.06);

    return FadeTransition(
      opacity: _itemAnimations[index],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.h,
            ),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: context.primaryColor,
              ),
            ),
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
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
                  blurRadius: 12.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final itemIndex = entry.key;
                final item = entry.value;
                final isLast = itemIndex == items.length - 1;

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 200 + (itemIndex * 100)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: NotificationSettingItemWidget(
                        setting: settings[item.key],
                        title: item.title,
                        iconData: item.iconData,
                        isLast: isLast,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifItem {
  _NotifItem(this.key, this.title, this.iconData);
  final String key;
  final String title;
  final IconData iconData;
}
