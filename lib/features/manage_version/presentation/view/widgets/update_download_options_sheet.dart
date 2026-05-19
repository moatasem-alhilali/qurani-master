import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/manage_version/data/models/app_version_model.dart';

const String kTamaneenaTelegramUrl = 'https://t.me/tamaneenaquran';
const String kTamaneenaAppStoreUrl =
    'https://apps.apple.com/us/app/%D8%B7%D9%85%D8%A3%D9%86%D9%8A%D9%86%D8%A9-%D9%82%D8%B1%D8%A2%D9%86-%D9%88%D8%A3%D8%B0%D9%83%D8%A7%D8%B1/id6761408570';

Future<void> showUpdateDownloadOptionsSheet(
  BuildContext context,
  AppVersionModel versionInfo,
) {
  final options = _buildDownloadOptions(versionInfo);

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: sheetContext.surfaceColor,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: sheetContext.outline.withValues(alpha: 0.75),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 22.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: sheetContext.onSurfaceVariant
                            .withValues(alpha: 0.24),
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'تحميل التحديث',
                    style: titleMedium(sheetContext).copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'اختر منصة التحميل المناسبة لك',
                    style: titleMedium(sheetContext).copyWith(
                      fontSize: 12.sp,
                      color:
                          sheetContext.onSurfaceVariant.withValues(alpha: 0.75),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  for (final option in options) ...[
                    _DownloadOptionTile(option: option),
                    SizedBox(height: 8.h),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

List<_DownloadOption> _buildDownloadOptions(AppVersionModel versionInfo) {
  if (Platform.isIOS) {
    return const [
      _DownloadOption(
        title: 'App Store',
        subtitle: 'تحميل الإصدار من متجر أبل',
        url: kTamaneenaAppStoreUrl,
        icon: AppIcons.download,
      ),
    ];
  }

  final options = <_DownloadOption>[
    const _DownloadOption(
      title: 'تليجرام',
      subtitle: 'قناة طمأنينة الرسمية',
      url: kTamaneenaTelegramUrl,
      icon: AppIcons.telegram,
    ),
  ];

  final mediaFireUrl = versionInfo.downloadUrl.trim();
  if (mediaFireUrl.isNotEmpty) {
    options.add(
      _DownloadOption(
        title: 'MediaFire',
        subtitle: 'رابط التحميل المباشر',
        url: mediaFireUrl,
        icon: AppIcons.download,
      ),
    );
  }

  final googlePlayUrl = versionInfo.googlePlayUrl.trim();
  if (googlePlayUrl.isNotEmpty) {
    options.add(
      _DownloadOption(
        title: 'Google Play',
        subtitle: 'تحميل الإصدار من المتجر',
        url: googlePlayUrl,
        icon: AppIcons.globe,
      ),
    );
  }

  return options;
}

class _DownloadOptionTile extends StatelessWidget {
  const _DownloadOptionTile({required this.option});

  final _DownloadOption option;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: () async {
        Navigator.of(context).pop();
        await UrlLauncherUtils.launchWebUrl(option.url);
      },
      child: Ink(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: context.primaryColor.withValues(alpha: 0.13),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: AppIcon(
                option.icon,
                color: context.primaryColor,
                size: 21.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: titleMedium(context).copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    option.subtitle,
                    style: titleMedium(context).copyWith(
                      fontSize: 11.sp,
                      color: context.onSurfaceVariant.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            AppIcon(
              AppIcons.forward,
              color: context.primaryColor.withValues(alpha: 0.78),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadOption {
  const _DownloadOption({
    required this.title,
    required this.subtitle,
    required this.url,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String url;
  final HugeIconData icon;
}
