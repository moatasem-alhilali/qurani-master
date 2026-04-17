import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/theme_mode_widget.dart';
import 'package:quran_app/features/download/presentation/view/pages/download_screen.dart';
import 'package:quran_app/features/manage_version/presentation/view/pages/version_management_screen.dart';
import 'package:quran_app/features/setting_notification/presentation/view/pages/setting_notification_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'الإعدادات',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            _SettingTile(
              title: 'اعدادات الاشعارات',
              subtitle: 'قم بتعديل اعدادات الاشعارات',
              icon: CupertinoIcons.bell_fill,
              onTap: () {
                context.push(const SettingNotificationScreen());
              },
            ),
            _SettingTile(
              title: 'اعدادات التنزيل',
              subtitle: 'قم بتعديل اعدادات التنزيل والمساحة',
              icon: CupertinoIcons.arrow_down_to_line,
              onTap: () {
                context.push(const DownloadScreen());
              },
            ),
            _SettingTile(
              title: 'إدارة الإصدارات',
              subtitle: 'تحقق من التحديثات وإدارة إصدارات التطبيق',
              icon: CupertinoIcons.arrow_up_circle_fill,
              onTap: () {
                context.push(const VersionManagementScreen());
              },
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'المظهر والخلفية',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: context.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            const ThemeModeWidget(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.r);
    final accent = context.primaryColor;
    final cardBackground = context.surfaceColor;
    final cardBackgroundSoft = context.surfaceVariant.withValues(alpha: 0.42);
    final cardBorder = context.outline.withValues(alpha: 0.85);
    final shadow = context.shadow.withValues(alpha: 0.06);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
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
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                Positioned(
                  top: -20.h,
                  left: -20.w,
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(
                          icon,
                          color: accent,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: context.onSurfaceColor,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: context.onSurfaceVariant.withValues(alpha: 0.8),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: context.onSurfaceVariant.withValues(alpha: 0.3),
                        size: 16.sp,
                      ),
                    ],
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
