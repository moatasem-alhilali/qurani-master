import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/theme_widget.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyleButtonWrap(
          onTap: () {
            context.push(const SettingNotificationScreen());
          },
          child: CardWidget(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.symmetric(
              horizontal: 10.sp,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('اعدادات الاشعارات', style: titleMedium(context)),
                    SizedBox(height: 5.h),
                    Text(
                      'قم بتعديل اعدادات الاشعارات',
                      style: titleMedium(context).copyWith(
                        fontSize: 12.sp,
                        color: context.gray1,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: context.primaryScheme.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: context.primaryScheme),
                    boxShadow: [
                      BoxShadow(
                        color: context.primaryScheme.withOpacity(0.1),
                        blurRadius: 10.r,
                        offset: Offset(0, 10.h),
                      ),
                      BoxShadow(
                        color: context.primaryScheme.withOpacity(0.1),
                        blurRadius: 10.r,
                        offset: Offset(0, -10.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.bell,
                    color: context.primaryScheme,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        StyleButtonWrap(
          onTap: () {
            context.push(const DownloadScreen());
          },
          child: CardWidget(
            margin: EdgeInsets.symmetric(
              horizontal: 10.sp,
            ),
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('اعدادات التنزيل', style: titleMedium(context)),
                    SizedBox(height: 5.h),
                    Text(
                      'قم بتعديل اعدادات التنزيل',
                      style: titleMedium(context).copyWith(
                        fontSize: 12.sp,
                        color: context.gray1,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: context.primaryScheme.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: context.primaryScheme),
                    boxShadow: [
                      BoxShadow(
                        color: context.primaryScheme.withOpacity(0.1),
                        blurRadius: 10.r,
                        offset: Offset(0, 10.h),
                      ),
                      BoxShadow(
                        color: context.primaryScheme.withOpacity(0.1),
                        blurRadius: 10.r,
                        offset: Offset(0, -10.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.arrow_down_to_line,
                    color: context.primaryScheme,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        StyleButtonWrap(
          onTap: () {
            context.push(const VersionManagementScreen());
          },
          child: CardWidget(
            margin: EdgeInsets.symmetric(
              horizontal: 10.sp,
            ),
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('إدارة الإصدارات', style: titleMedium(context)),
                    SizedBox(height: 5.h),
                    Text(
                      'تحقق من التحديثات وإدارة إصدارات التطبيق',
                      style: titleMedium(context).copyWith(
                        fontSize: 12.sp,
                        color: context.gray1,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: context.primaryScheme.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: context.primaryScheme),
                    boxShadow: [
                      BoxShadow(
                        color: context.primaryScheme.withOpacity(0.1),
                        blurRadius: 10.r,
                        offset: Offset(0, 10.h),
                      ),
                      BoxShadow(
                        color: context.primaryScheme.withOpacity(0.1),
                        blurRadius: 10.r,
                        offset: Offset(0, -10.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.arrow_up_circle,
                    color: context.primaryScheme,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'اعدادات الثيم',
            style: titleMedium(context).copyWith(
              fontSize: 16.sp,
            ),
          ),
        ),
        const ThemeWidget(),
      ],
    );
  }
}
