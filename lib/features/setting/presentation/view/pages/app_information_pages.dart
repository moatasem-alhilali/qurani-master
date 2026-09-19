import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/setting/data/services/social_links_service.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/l10n/l10n.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _InfoPage(
      title: context.l10n.settingsPrivacyPolicyTitle,
      icon: AppIcons.shield,
      intro: context.l10n.settingsPrivacyIntro,
      sections: [
        _InfoSectionData(
          title: context.l10n.settingsPrivacyMattersTitle,
          body: context.l10n.settingsPrivacyMattersBody,
        ),
        _InfoSectionData(
          title: context.l10n.settingsPrivacyDataUsedTitle,
          body: context.l10n.settingsPrivacyDataUsedBody,
        ),
        _InfoSectionData(
          title: context.l10n.settingsPrivacyControlTitle,
          body: context.l10n.settingsPrivacyControlBody,
        ),
        _InfoSectionData(
          title: context.l10n.settingsPrivacyThirdPartyTitle,
          body: context.l10n.settingsPrivacyThirdPartyBody,
        ),
      ],
    );
  }
}

class DataSafetyScreen extends StatelessWidget {
  const DataSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _InfoPage(
      title: context.l10n.settingsDataSafetyTitle,
      icon: AppIcons.security,
      intro: context.l10n.settingsDataSafetyIntro,
      sections: [
        _InfoSectionData(
          title: context.l10n.settingsDataSafetySensitiveTitle,
          body: context.l10n.settingsDataSafetySensitiveBody,
        ),
        _InfoSectionData(
          title: context.l10n.settingsDataSafetyLocationTitle,
          body: context.l10n.settingsDataSafetyLocationBody,
        ),
        _InfoSectionData(
          title: context.l10n.settingsDataSafetyNotificationsTitle,
          body: context.l10n.settingsDataSafetyNotificationsBody,
        ),
        _InfoSectionData(
          title: context.l10n.settingsDataSafetyStorageTitle,
          body: context.l10n.settingsDataSafetyStorageBody,
        ),
        _InfoSectionData(
          title: context.l10n.settingsDataSafetySharingTitle,
          body: context.l10n.settingsDataSafetySharingBody,
        ),
      ],
    );
  }
}

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: context.l10n.settingsAboutUsTitle,
      children: [
        _InfoHero(
          icon: AppIcons.quran,
          title: context.l10n.appName,
          body: context.l10n.settingsAboutAppBody,
        ),
        SettingsGroup(
          title: context.l10n.settingsAboutMissionTitle,
          children: [
            SettingsParagraph(
              context.l10n.settingsAboutMissionBody,
            ),
          ],
        ),
        SettingsGroup(
          title: context.l10n.settingsAboutOfferTitle,
          children: [
            SettingsParagraph(
              context.l10n.settingsAboutOfferBody,
            ),
          ],
        ),
        const _AppSocialLinksSection(),
      ],
    );
  }
}

class DeveloperAboutScreen extends StatelessWidget {
  const DeveloperAboutScreen({super.key});

  static const String _website = 'https://moatasem.dev';
  static const String _email = 'm.alhilalee@gmail.com';
  static const String _whatsapp = '+966537502257';
  static const String _github = 'https://github.com/moatasem-alhilali';
  static const String _linkedin =
      'https://www.linkedin.com/in/moatasem-alhilali';
  static const String _twitter = 'https://x.com/moatasem_alhilali';

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: context.l10n.settingsAboutDeveloperTitle,
      children: [
        _InfoHero(
          icon: AppIcons.user,
          title: context.l10n.settingsDeveloperName,
          body: context.l10n.settingsDeveloperHeroBody,
        ),
        SettingsGroup(
          title: context.l10n.settingsDeveloperBioTitle,
          children: [
            SettingsParagraph(
              context.l10n.settingsDeveloperBioBody,
            ),
          ],
        ),
        SettingsGroup(
          title: context.l10n.settingsDeveloperFieldsTitle,
          children: [
            SettingsParagraph(
              context.l10n.settingsDeveloperFieldsBody,
            ),
          ],
        ),
        _ContactActions(
          title: context.l10n.settingsDeveloperContactTitle,
          actions: [
            _ContactAction(
              context.l10n.settingsContactWebsite,
              AppIcons.globe,
              _website,
            ),
            _ContactAction(
              context.l10n.settingsContactEmail,
              AppIcons.link,
              'mailto:$_email',
            ),
            _ContactAction(
              context.l10n.settingsSocialWhatsapp,
              AppIcons.whatsapp,
              'wa:$_whatsapp',
            ),
            const _ContactAction('GitHub', AppIcons.source, _github),
            const _ContactAction('LinkedIn', AppIcons.user, _linkedin),
            const _ContactAction('X', AppIcons.twitter, _twitter),
          ],
        ),
      ],
    );
  }
}

class _AppSocialLinksSection extends StatefulWidget {
  const _AppSocialLinksSection();

  @override
  State<_AppSocialLinksSection> createState() => _AppSocialLinksSectionState();
}

class _AppSocialLinksSectionState extends State<_AppSocialLinksSection> {
  late final Future<SocialLinks> _linksFuture;

  @override
  void initState() {
    super.initState();
    _linksFuture = SocialLinksService().getLinks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SocialLinks>(
      future: _linksFuture,
      builder: (context, snapshot) {
        final links = snapshot.data ?? SocialLinks.defaults();
        final items = [
          _ContactAction(
            context.l10n.settingsSocialTelegram,
            AppIcons.telegram,
            links.telegram,
          ),
          _ContactAction(
            context.l10n.settingsSocialWhatsapp,
            AppIcons.whatsapp,
            links.whatsapp,
          ),
          _ContactAction(
            context.l10n.settingsSocialFacebook,
            AppIcons.facebook,
            links.facebook,
          ),
          _ContactAction(
            context.l10n.settingsSocialInstagram,
            AppIcons.instagram,
            links.instagram,
          ),
          _ContactAction(
            context.l10n.settingsSocialTwitter,
            AppIcons.twitter,
            links.twitter,
          ),
        ].where((item) => item.url.trim().isNotEmpty).toList();

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return _ContactActions(
          title: context.l10n.settingsAppLinksTitle,
          actions: items,
        );
      },
    );
  }
}

/// صفحة معلومات: مقدّمة مرتفعة واحدة ثم مجموعات نصّية بعناوين صغيرة.
class _InfoPage extends StatelessWidget {
  const _InfoPage({
    required this.title,
    required this.icon,
    required this.intro,
    required this.sections,
  });

  final String title;
  final HugeIconData icon;
  final String intro;
  final List<_InfoSectionData> sections;

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: title,
      children: [
        _InfoHero(icon: icon, title: title, body: intro),
        for (final section in sections)
          SettingsGroup(
            title: section.title,
            children: [SettingsParagraph(section.body)],
          ),
      ],
    );
  }
}

/// العنصر المرتفع الوحيد في صفحات المعلومات: هوية الصفحة وملخّصها.
class _InfoHero extends StatelessWidget {
  const _InfoHero({
    required this.icon,
    required this.title,
    required this.body,
  });

  final HugeIconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SettingsRaisedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SettingsIconChip(icon: icon),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Text(
            body,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.86),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

/// روابط التواصل كمربّعات صغيرة بدل بطاقة شرائح.
class _ContactActions extends StatelessWidget {
  const _ContactActions({
    required this.title,
    required this.actions,
  });

  final String title;
  final List<_ContactAction> actions;

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      title: title,
      children: [
        SettingsTileRow(
          columns: 4,
          tiles: [
            for (final action in actions)
              SettingsTile(
                icon: action.icon,
                label: action.title,
                onTap: () => _launch(action.url),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _launch(String url) async {
    if (url.startsWith('wa:')) {
      await UrlLauncherUtils.launchWhatsAppUrl(url.replaceFirst('wa:', ''));
      return;
    }
    await UrlLauncherUtils.launchWebUrl(url);
  }
}

class _InfoSectionData {
  const _InfoSectionData({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

class _ContactAction {
  const _ContactAction(this.title, this.icon, this.url);

  final String title;
  final HugeIconData icon;
  final String url;
}
