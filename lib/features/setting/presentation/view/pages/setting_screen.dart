import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/dialog/style_dialog_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/pages/notification_schedules_screen.dart';
import 'package:quran_app/features/setting/data/constant/notification_keys.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting/presentation/bloc/setting_notification_bloc.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/show_edit_schedule_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
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
    return BlocBuilder<SettingNotificationBloc, SettingNotificationState>(
      builder: (context, state) {
        if (state.loading == LoadState.loading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(
                  radius: 20.r,
                  color: context.primaryScheme,
                ),
                SizedBox(height: 16.h),
                Text(
                  'جاري تحميل الإعدادات...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          );
        }

        final s = state.settings;

        return FadeTransition(
          opacity: _fadeController,
          child: CupertinoScrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildHeader(),
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
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: context.primaryScheme.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              CupertinoIcons.settings,
              color: context.primaryScheme,
              size: 40.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'إعدادات التنبيهات',
            style: titleLarge(context),
          ),
          // SizedBox(height: 8.h),
          // Text(
          //   'تخصيص مواعيد وأنواع الإشعارات الإسلامية',
          //   style: titleMedium(context),
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }

  Widget _buildSection(
    int index,
    String title,
    Map<String, NotificationSettingModel> settings,
    List<_NotifItem> items,
  ) {
    return FadeTransition(
      opacity: _itemAnimations[index],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.secondaryLabel,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: context.secondary,
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
                      child: _buildNotifItem(
                        context,
                        settings[item.key],
                        item.title,
                        item.iconData,
                        isLast,
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

  Widget _buildNotifItem(
    BuildContext context,
    NotificationSettingModel? setting,
    String title,
    IconData iconData,
    bool isLast,
  ) {
    if (setting == null) return const SizedBox();

    return BlocBuilder<SettingNotificationBloc, SettingNotificationState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: isLast
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  )
                : null,
          ),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.read<SettingNotificationBloc>().add(
                          ToggleNotification(setting.key, !setting.enabled),
                        );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: setting.enabled
                                    ? context.primaryScheme
                                    : CupertinoColors.systemGrey4,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                iconData,
                                color: setting.enabled
                                    ? CupertinoColors.white
                                    : CupertinoColors.systemGrey,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: setting.enabled
                                      ? CupertinoColors.label
                                      : CupertinoColors.secondaryLabel,
                                ),
                              ),
                            ),
                            if (setting.enabled) ...[
                              GestureDetector(
                                onTap: () => _showActionMenu(context, setting),
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  child: Icon(
                                    CupertinoIcons.ellipsis_circle,
                                    color: context.primaryScheme,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ],
                            CupertinoSwitch(
                              value: setting.enabled,
                              activeColor: context.primaryScheme,
                              onChanged: (val) {
                                context.read<SettingNotificationBloc>().add(
                                      ToggleNotification(setting.key, val),
                                    );
                              },
                            ),
                          ],
                        ),
                        if (setting.enabled) ...[
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: context.primaryScheme.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              _subtitleFromSchedule(setting),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: context.primaryScheme,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  margin: EdgeInsets.only(left: 60.w),
                  height: 0.5.h,
                  color: CupertinoColors.separator,
                ),
            ],
          ),
        );
      },
    );
  }

  void _showActionMenu(BuildContext context, NotificationSettingModel setting) {
    showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'إدارة الإشعار',
          style: titleMedium(context).copyWith(
            fontSize: 20.sp,
          ),
        ),
        // message: Text(
        //   'اختر الإجراء المطلوب',
        //   style: titleSmall(context),
        // ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              context.push(
                NotificationSchedulesScreen(
                  notifKey: setting.key,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.time,
                  color: context.primaryScheme,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'إدارة أوقات التنبيه',
                  style: titleMedium(context).copyWith(
                    color: context.primaryScheme,
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              context.showImprovedScheduleDialog(
                child: ShowEditScheduleDialog(
                  model: setting,
                  onSave: (updated) {
                    context.read<SettingNotificationBloc>().add(
                          EditNotificationSchedule(
                            setting.key,
                            updated,
                          ),
                        );
                  },
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.calendar_badge_plus,
                  color: context.primaryScheme,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'تعديل جدولة الإشعار',
                  style: titleMedium(context).copyWith(
                    color: context.primaryScheme,
                  ),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'إلغاء',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _subtitleFromSchedule(NotificationSettingModel s) {
    switch (s.scheduleType) {
      case ScheduleType.daily:
        return 'يومياً الساعة ${_formatTime(s.hour, s.minute)}';
      case ScheduleType.hourly:
        return 'كل ساعة عند الدقيقة ${s.minute ?? 0}';
      case ScheduleType.everyNMinutes:
        return 'كل ${s.intervalMinutes ?? 1} دقيقة';
      case ScheduleType.weekly:
        final days = (s.weekdays ?? []).map(_arabicDayOfWeek).join('، ');
        return 'أسبوعياً (${days.isEmpty ? "بدون أيام محددة" : days}) الساعة ${_formatTime(s.hour, s.minute)}';
      case ScheduleType.customDates:
        return 'جدولة مخصصة (${s.customDates?.length ?? 0} توقيت)';
    }
  }

  String _formatTime(int? h, int? m) =>
      '${h?.toString().padLeft(2, '0') ?? '--'}:${m?.toString().padLeft(2, '0') ?? '--'}';

  String _arabicDayOfWeek(int d) {
    switch (d) {
      case 1:
        return 'الاثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
      default:
        return '؟';
    }
  }
}

class _NotifItem {
  _NotifItem(this.key, this.title, this.iconData);
  final String key;
  final String title;
  final IconData iconData;
}
