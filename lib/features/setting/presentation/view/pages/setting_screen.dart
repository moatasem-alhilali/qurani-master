import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/dialog/style_dialog_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/pages/notification_schedules_screen.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/sheet/setting_theme_sheet.dart';
import 'package:quran_app/features/setting/data/constant/notification_keys.dart';
import 'package:quran_app/features/setting/data/model/notification_setting_model.dart';
import 'package:quran_app/features/setting/presentation/bloc/setting_notification_bloc.dart';
import 'package:quran_app/features/setting/presentation/view/pages/setting_notification_screen.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/show_edit_schedule_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        StyleButtonWrap(
          onTap: () {
            context.push(const SettingNotificationScreen());
          },
          child: CardWidget(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الاشعارات', style: titleMedium(context)),
                    SizedBox(height: 5.h),
                    Text(
                      'تنبيهات الإشعارات',
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
        SizedBox(height: 16.h),
        CardWidget(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اعدادات الثيم',
                style: titleMedium(context).copyWith(
                  fontSize: 16.sp,
                  // color: context.gray1,
                ),
              ),
              // SizedBox(height: 6.h),
              SettingThemeSheet(
                shouldPop: false,
              ),
            ],
          ),
        ),
      ],
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
            'إعدادات',
            style: titleLarge(context),
          ),
        ],
      ),
    );
  }
}
