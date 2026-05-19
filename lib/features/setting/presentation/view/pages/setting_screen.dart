import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/theme_mode_widget.dart';
import 'package:quran_app/features/download/presentation/view/pages/download_screen.dart';
import 'package:quran_app/features/manage_version/presentation/view/pages/version_management_screen.dart';
import 'package:quran_app/features/setting/data/services/social_links_service.dart';
import 'package:quran_app/features/setting_notification/presentation/view/pages/setting_notification_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late final Future<SocialLinks> _socialLinksFuture;

  @override
  void initState() {
    super.initState();
    _socialLinksFuture = SocialLinksService().getLinks();
  }

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
              icon: AppIcons.notifications,
              onTap: () {
                context.push(const SettingNotificationScreen());
              },
            ),
            _SettingTile(
              title: 'اعدادات التنزيل',
              subtitle: 'قم بتعديل اعدادات التنزيل والمساحة',
              icon: AppIcons.download,
              onTap: () {
                context.push(const DownloadScreen());
              },
            ),
            _SettingTile(
              title: 'إدارة الإصدارات',
              subtitle: 'تحقق من التحديثات وإدارة إصدارات التطبيق',
              icon: AppIcons.update,
              onTap: () {
                context.push(const VersionManagementScreen());
              },
            ),
            SizedBox(height: 24.h),
            const _SettingsSectionTitle(title: 'تابع آخر الأخبار'),
            SizedBox(height: 12.h),
            FutureBuilder<SocialLinks>(
              future: _socialLinksFuture,
              builder: (context, snapshot) {
                return _SocialLinksCard(
                  links: snapshot.data ?? SocialLinks.defaults(),
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                );
              },
            ),
            SizedBox(height: 18.h),
            const _DeveloperInfoCard(),
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

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
          color: context.primaryColor,
        ),
      ),
    );
  }
}

class _SocialLinksCard extends StatelessWidget {
  const _SocialLinksCard({
    required this.links,
    required this.isLoading,
  });

  final SocialLinks links;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final items = [
      _SocialItem('تليجرام', links.telegram, AppIcons.telegram),
      _SocialItem('واتس اب', links.whatsapp, AppIcons.whatsapp),
      _SocialItem('فيسبوك', links.facebook, AppIcons.facebook),
      _SocialItem('انستجرام', links.instagram, AppIcons.instagram),
      _SocialItem('تويتر', links.twitter, AppIcons.twitter),
    ];

    return _SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(
                AppIcons.news,
                color: context.primaryColor,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'تابع آخر الأخبار حول التطبيق',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: context.onSurfaceColor,
                  ),
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    color: context.primaryColor,
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final item in items) _SocialChip(item: item),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialChip extends StatelessWidget {
  const _SocialChip({required this.item});

  final _SocialItem item;

  @override
  Widget build(BuildContext context) {
    final isEnabled = item.url.trim().isNotEmpty;
    final color = isEnabled ? context.primaryColor : context.onSurfaceVariant;

    return InkWell(
      onTap: isEnabled
          ? () => UrlLauncherUtils.launchWebUrl(item.url.trim())
          : null,
      borderRadius: BorderRadius.circular(999.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isEnabled ? 0.10 : 0.07),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: color.withValues(alpha: isEnabled ? 0.18 : 0.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              item.icon,
              size: 15.sp,
              color: color.withValues(alpha: isEnabled ? 1 : 0.46),
            ),
            SizedBox(width: 6.w),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: color.withValues(alpha: isEnabled ? 1 : 0.50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeveloperInfoCard extends StatelessWidget {
  const _DeveloperInfoCard();

  static const String _website = 'https://moatasem.dev';
  static const String _phone = '+966537502257';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SettingsSectionTitle(title: 'حول المطور'),
        SizedBox(height: 12.h),
        _SettingsCard(
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AppIcon(
                  AppIcons.user,
                  color: context.primaryColor,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معتصم الهلالي',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: context.onSurfaceColor,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        _DeveloperIconButton(
                          tooltip: 'الموقع الشخصي',
                          icon: AppIcons.globe,
                          onTap: () => UrlLauncherUtils.launchWebUrl(_website),
                        ),
                        SizedBox(width: 8.w),
                        _DeveloperIconButton(
                          tooltip: 'واتس اب',
                          icon: AppIcons.whatsapp,
                          onTap: () => UrlLauncherUtils.launchWhatsAppUrl(
                            _phone,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeveloperIconButton extends StatelessWidget {
  const _DeveloperIconButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final HugeIconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11.r),
        child: Ink(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(11.r),
            border: Border.all(
              color: context.primaryColor.withValues(alpha: 0.14),
            ),
          ),
          child: AppIcon(
            icon,
            color: context.primaryColor,
            size: 17.sp,
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: context.outline.withValues(alpha: 0.82),
          ),
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: 0.05),
              blurRadius: 12.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: child,
        ),
      ),
    );
  }
}

class _SocialItem {
  const _SocialItem(this.title, this.url, this.icon);

  final String title;
  final String url;
  final HugeIconData icon;
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
  final HugeIconData icon;
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
                        child: AppIcon(
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
                                color: context.onSurfaceVariant
                                    .withValues(alpha: 0.8),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppIcon(
                        AppIcons.forward,
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
