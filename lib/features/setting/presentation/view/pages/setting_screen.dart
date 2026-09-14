import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/theme/theme_manager.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/download/presentation/view/pages/download_screen.dart';
import 'package:quran_app/features/setting/data/services/social_links_service.dart';
import 'package:quran_app/features/setting/presentation/view/pages/app_information_pages.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/features/setting_notification/presentation/view/pages/setting_notification_screen.dart';
import 'package:quran_app/src/core/review/app_review_service.dart';
import 'package:quran_app/src/core/update/app_update_cubit.dart';
import 'package:quran_app/src/core/update/app_update_service.dart';
import 'package:quran_app/src/core/update/update_prompts.dart';

/// شاشة الإعدادات: قائمة واحدة مقسّمة إلى مجموعات معنونة، بلا بطاقات.
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  static const String _developerName = 'معتصم الهلالي';
  static const String _developerSite = 'https://moatasem.dev';
  static const String _developerPhone = '+966537502257';

  late final Future<SocialLinks> _socialLinksFuture;

  @override
  void initState() {
    super.initState();
    _socialLinksFuture = SocialLinksService().getLinks();
  }

  /// فحص يدوي للتحديثات: أندرويد يسلّم لواجهة Google Play، وiOS يعرض الحوار.
  Future<void> _checkForUpdates(BuildContext context) async {
    final cubit = context.read<AppUpdateCubit>();
    final result = await cubit.checkNow();
    if (!context.mounted) return;

    switch (result.outcome) {
      case ManualUpdateOutcome.updateAvailableIos:
        await showIosUpdateDialog(
          context,
          storeVersion: result.storeVersion ?? '',
          storeUrl: result.storeUrl,
          releaseNotes: result.releaseNotes,
        );
      case ManualUpdateOutcome.updateStartedAndroid:
        AdaptiveSnackBar.show(context, message: 'جارٍ بدء تحديث التطبيق...');
      case ManualUpdateOutcome.upToDate:
        AdaptiveSnackBar.show(
          context,
          message: 'أنت تستخدم أحدث إصدار من التطبيق.',
          type: AdaptiveSnackBarType.success,
        );
      case ManualUpdateOutcome.error:
        AdaptiveSnackBar.show(
          context,
          message: 'تعذّر التحقق من التحديثات، حاول لاحقاً.',
          type: AdaptiveSnackBarType.error,
        );
    }
  }

  void _toggleDarkMode(BuildContext context, {required bool isDark}) {
    context.read<ThemeBloc>().add(
          ChangeThemeModeEvent(
            mode: isDark ? ThemeModeManager.dark : ThemeModeManager.light,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'الإعدادات',
      children: [
        SettingsGroup(
          title: 'التفضيلات',
          children: [
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                final isDark = state.currentThemeMode == ThemeMode.dark;
                return SettingsRow(
                  icon: isDark ? AppIcons.moon : AppIcons.sun,
                  title: 'النمط الداكن',
                  subtitle: isDark ? 'مفعل' : 'معطل',
                  trailing: SettingsSwitch(
                    value: isDark,
                    onChanged: (value) =>
                        _toggleDarkMode(context, isDark: value),
                  ),
                  onTap: () => _toggleDarkMode(context, isDark: !isDark),
                );
              },
            ),
            SettingsRow(
              icon: AppIcons.notifications,
              title: 'إعدادات الإشعارات',
              subtitle: 'تحكّم بكل تنبيه يصلك من التطبيق',
              onTap: () => context.push(const SettingNotificationScreen()),
            ),
            SettingsRow(
              icon: AppIcons.download,
              title: 'إعدادات التنزيل',
              subtitle: 'إدارة الملفات المحمّلة والمساحة',
              isLast: true,
              onTap: () => context.push(const DownloadScreen()),
            ),
          ],
        ),
        SettingsGroup(
          title: 'التطبيق',
          children: [
            SettingsRow(
              icon: AppIcons.update,
              title: 'التحقق من التحديثات',
              subtitle: 'تأكد من أنك تستخدم أحدث إصدار',
              onTap: () => _checkForUpdates(context),
            ),
            SettingsRow(
              icon: AppIcons.quran,
              title: 'من نحن',
              subtitle: 'تعرف على تطبيق طمأنينة ورسالته',
              onTap: () => context.push(const AboutAppScreen()),
            ),
            SettingsRow(
              icon: AppIcons.star,
              title: 'قيّم التطبيق',
              subtitle: 'ساهم في نشر الخير بتقييمك على المتجر',
              isLast: true,
              onTap: () => AppReviewService().openStoreListing(),
            ),
          ],
        ),
        SettingsGroup(
          title: 'الخصوصية والأمان',
          children: [
            SettingsRow(
              icon: AppIcons.shield,
              title: 'سياسة الخصوصية',
              subtitle: 'كيف يتعامل التطبيق مع بياناتك وصلاحياتك',
              onTap: () => context.push(const PrivacyPolicyScreen()),
            ),
            SettingsRow(
              icon: AppIcons.security,
              title: 'أمان البيانات',
              subtitle: 'ملخص البيانات والصلاحيات وطريقة استخدامها',
              isLast: true,
              onTap: () => context.push(const DataSafetyScreen()),
            ),
          ],
        ),
        SettingsGroup(
          title: 'المطوّر',
          children: [
            SettingsRow(
              icon: AppIcons.user,
              title: 'حول المطور',
              subtitle: 'معلومات وروابط التواصل الخاصة بالمطور',
              onTap: () => context.push(const DeveloperAboutScreen()),
            ),
            SettingsRow(
              icon: AppIcons.source,
              title: _developerName,
              subtitle: 'تواصل مباشر عبر الموقع أو واتس اب',
              isLast: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingsIconButton(
                    icon: AppIcons.globe,
                    tooltip: 'الموقع الشخصي',
                    onTap: () => UrlLauncherUtils.launchWebUrl(_developerSite),
                  ),
                  SizedBox(width: 2.w),
                  SettingsIconButton(
                    icon: AppIcons.whatsapp,
                    tooltip: 'واتس اب',
                    onTap: () => UrlLauncherUtils.launchWhatsAppUrl(
                      _developerPhone,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SettingsGroup(
          title: 'تابع آخر الأخبار',
          children: [
            FutureBuilder<SocialLinks>(
              future: _socialLinksFuture,
              builder: (context, snapshot) {
                final links = snapshot.data ?? SocialLinks.defaults();
                return _SocialTiles(links: links);
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// روابط التواصل: مربّعات صغيرة بدل بطاقة، والرابط الفارغ يظهر خافتًا.
class _SocialTiles extends StatelessWidget {
  const _SocialTiles({required this.links});

  final SocialLinks links;

  @override
  Widget build(BuildContext context) {
    final items = <_SocialItem>[
      _SocialItem('تليجرام', links.telegram, AppIcons.telegram),
      _SocialItem('واتس اب', links.whatsapp, AppIcons.whatsapp),
      _SocialItem('فيسبوك', links.facebook, AppIcons.facebook),
      _SocialItem('انستجرام', links.instagram, AppIcons.instagram),
      _SocialItem('تويتر', links.twitter, AppIcons.twitter),
    ];

    return SettingsTileRow(
      tiles: [
        for (final item in items)
          SettingsTile(
            icon: item.icon,
            label: item.title,
            onTap: item.url.trim().isEmpty
                ? null
                : () => UrlLauncherUtils.launchWebUrl(item.url.trim()),
          ),
      ],
    );
  }
}

class _SocialItem {
  const _SocialItem(this.title, this.url, this.icon);

  final String title;
  final String url;
  final HugeIconData icon;
}
