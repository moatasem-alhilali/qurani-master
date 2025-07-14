import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/theme_widget.dart';
import 'package:quran_app/features/download/presentation/view/pages/download_screen.dart';
import 'package:quran_app/features/manage_version/presentation/bloc/version_bloc.dart';
import 'package:quran_app/features/manage_version/presentation/widgets/update_dialog_widget.dart';
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
        // Dialog listener - only triggers when dialog state changes from false to true
        BlocListener<VersionBloc, VersionState>(
          listenWhen: (previous, current) {
            // Only listen when dialog state changes from false to true
            return !previous.isUpdateDialogVisible &&
                current.isUpdateDialogVisible;
          },
          listener: (context, state) {
            if (state.isUpdateDialogVisible && state.hasUpdateAvailable) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => UpdateDialogWidget(
                  versionModel: state.latestVersionInfo!,
                ),
              ).then((_) {
                // Safety check: ensure dialog state is dismissed if closed by other means
                if (context.mounted) {
                  final currentState = context.read<VersionBloc>().state;
                  if (currentState.isUpdateDialogVisible) {
                    context.read<VersionBloc>().add(DismissUpdateDialogEvent());
                  }
                }
              });
            }
          },
          child: const SizedBox.shrink(),
        ),

        // Messages listener - handles success and error messages
        BlocConsumer<VersionBloc, VersionState>(
          listenWhen: (previous, current) {
            // Listen for completion states
            return previous.versionCheckState != current.versionCheckState;
          },
          listener: (context, state) {
            // Handle success message for no updates
            if (state.versionCheckState == RequestState.success &&
                !state.hasUpdateAvailable &&
                !state.isUpdateDialogVisible) {
              final message = state.isConnected
                  ? 'لا توجد تحديثات متاحة، أنت تستخدم أحدث إصدار'
                  : 'لا توجد تحديثات محفوظة متاحة';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: titleMedium(context).copyWith(color: Colors.white),
                  ),
                  backgroundColor:
                      state.isConnected ? Colors.green : Colors.orange,
                  duration: const Duration(seconds: 3),
                ),
              );
            }

            // Handle general errors
            if (state.versionCheckState == RequestState.error &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage!,
                    style: titleMedium(context).copyWith(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return StyleButtonWrap(
              onTap: state.versionCheckState == RequestState.loading
                  ? null
                  : () {
                      // Manual check always forces refresh and ignores skip status
                      context.read<VersionBloc>().add(
                            CheckForUpdatesEvent(
                              forceRefresh: true,
                              isManualCheck: true,
                            ),
                          );
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
                        Row(
                          children: [
                            Text(
                              'تحقق من وجود إصدار جديد',
                              style: titleMedium(context),
                            ),
                            SizedBox(width: 8.w),
                            // Connectivity status indicator
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: state.isConnected
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: state.isConnected
                                      ? Colors.green
                                      : Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                state.isConnected ? 'متصل' : 'غير متصل',
                                style: titleMedium(context).copyWith(
                                  fontSize: 8.sp,
                                  color: state.isConnected
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          _getUpdateButtonSubtitle(state),
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
                      child: state.versionCheckState == RequestState.loading
                          ? SizedBox(
                              width: 24.sp,
                              height: 24.sp,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.primaryScheme,
                                ),
                              ),
                            )
                          : Icon(
                              state.isConnected
                                  ? CupertinoIcons.refresh_bold
                                  : CupertinoIcons.folder,
                              color: context.primaryScheme,
                              size: 24.sp,
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
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

  String _getUpdateButtonSubtitle(VersionState state) {
    if (state.versionCheckState == RequestState.loading) {
      return state.isConnected
          ? 'جاري البحث عن تحديثات عبر الإنترنت...'
          : 'جاري البحث في البيانات المحفوظة...';
    }

    if (state.isConnected) {
      return 'ابحث عن إصدارات جديدة من التطبيق';
    } else {
      return 'ابحث في البيانات المحفوظة محلياً';
    }
  }
}
