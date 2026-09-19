import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/locale/locale_cubit.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/theme/theme_manager.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/download/presentation/view/pages/download_screen.dart';
import 'package:quran_app/features/language/presentation/language_picker_screen.dart';
import 'package:quran_app/features/setting/data/services/social_links_service.dart';
import 'package:quran_app/features/setting/presentation/view/pages/app_information_pages.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/features/setting_notification/presentation/view/pages/setting_notification_screen.dart';
import 'package:quran_app/l10n/l10n.dart';
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
        AdaptiveSnackBar.show(
          context,
          message: context.l10n.settingsUpdateStarting,
        );
      case ManualUpdateOutcome.upToDate:
        AdaptiveSnackBar.show(
          context,
          message: context.l10n.settingsUpdateUpToDate,
          type: AdaptiveSnackBarType.success,
        );
      case ManualUpdateOutcome.error:
        AdaptiveSnackBar.show(
          context,
          message: context.l10n.settingsUpdateCheckFailed,
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
      title: context.l10n.commonSettings,
      children: [
        SettingsGroup(
          title: context.l10n.settingsGroupPreferences,
          children: [
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                final isDark = state.currentThemeMode == ThemeMode.dark;
                return SettingsRow(
                  icon: isDark ? AppIcons.moon : AppIcons.sun,
                  title: context.l10n.settingsDarkModeTitle,
                  subtitle: isDark
                      ? context.l10n.settingsStatusOn
                      : context.l10n.settingsStatusOff,
                  trailing: SettingsSwitch(
                    value: isDark,
                    onChanged: (value) =>
                        _toggleDarkMode(context, isDark: value),
                  ),
                  onTap: () => _toggleDarkMode(context, isDark: !isDark),
                );
              },
            ),
            BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, state) => SettingsRow(
                icon: AppIcons.language,
                title: context.l10n.languageSettingTitle,
                subtitle:
                    '${state.language.flag}  ${state.language.nativeName}',
                onTap: () =>
                    context.push(const LanguagePickerScreen.settings()),
              ),
            ),
            SettingsRow(
              icon: AppIcons.notifications,
              title: context.l10n.settingsNotificationsTitle,
              subtitle: context.l10n.settingsNotificationsSubtitle,
              onTap: () => context.push(const SettingNotificationScreen()),
            ),
            SettingsRow(
              icon: AppIcons.download,
              title: context.l10n.settingsDownloadsTitle,
              subtitle: context.l10n.settingsDownloadsSubtitle,
              isLast: true,
              onTap: () => context.push(const DownloadScreen()),
            ),
          ],
        ),
        SettingsGroup(
          title: context.l10n.settingsGroupApp,
          children: [
            SettingsRow(
              icon: AppIcons.update,
              title: context.l10n.settingsCheckUpdatesTitle,
              subtitle: context.l10n.settingsCheckUpdatesSubtitle,
              onTap: () => _checkForUpdates(context),
            ),
            SettingsRow(
              icon: AppIcons.quran,
              title: context.l10n.settingsAboutUsTitle,
              subtitle: context.l10n.settingsAboutUsSubtitle,
              onTap: () => context.push(const AboutAppScreen()),
            ),
            SettingsRow(
              icon: AppIcons.star,
              title: context.l10n.settingsRateAppTitle,
              subtitle: context.l10n.settingsRateAppSubtitle,
              isLast: true,
              onTap: () => AppReviewService().openStoreListing(),
            ),
          ],
        ),
        SettingsGroup(
          title: context.l10n.settingsGroupPrivacy,
          children: [
            SettingsRow(
              icon: AppIcons.shield,
              title: context.l10n.settingsPrivacyPolicyTitle,
              subtitle: context.l10n.settingsPrivacyPolicySubtitle,
              onTap: () => context.push(const PrivacyPolicyScreen()),
            ),
            SettingsRow(
              icon: AppIcons.security,
              title: context.l10n.settingsDataSafetyTitle,
              subtitle: context.l10n.settingsDataSafetySubtitle,
              isLast: true,
              onTap: () => context.push(const DataSafetyScreen()),
            ),
          ],
        ),
        SettingsGroup(
          title: context.l10n.settingsGroupDeveloper,
          children: [
            SettingsRow(
              icon: AppIcons.user,
              title: context.l10n.settingsAboutDeveloperTitle,
              subtitle: context.l10n.settingsAboutDeveloperSubtitle,
              onTap: () => context.push(const DeveloperAboutScreen()),
            ),
            SettingsRow(
              icon: AppIcons.source,
              title: context.l10n.settingsDeveloperName,
              subtitle: context.l10n.settingsDeveloperContactSubtitle,
              isLast: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingsIconButton(
                    icon: AppIcons.globe,
                    tooltip: context.l10n.settingsPersonalWebsite,
                    onTap: () => UrlLauncherUtils.launchWebUrl(_developerSite),
                  ),
                  SizedBox(width: 2.w),
                  SettingsIconButton(
                    icon: AppIcons.whatsapp,
                    tooltip: context.l10n.settingsSocialWhatsapp,
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
          title: context.l10n.settingsGroupFollowNews,
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
    final l10n = context.l10n;
    final items = <_SocialItem>[
      _SocialItem(
        l10n.settingsSocialTelegram,
        links.telegram,
        AppIcons.telegram,
      ),
      _SocialItem(
        l10n.settingsSocialWhatsapp,
        links.whatsapp,
        AppIcons.whatsapp,
      ),
      _SocialItem(
        l10n.settingsSocialFacebook,
        links.facebook,
        AppIcons.facebook,
      ),
      _SocialItem(
        l10n.settingsSocialInstagram,
        links.instagram,
        AppIcons.instagram,
      ),
      _SocialItem(l10n.settingsSocialTwitter, links.twitter, AppIcons.twitter),
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
