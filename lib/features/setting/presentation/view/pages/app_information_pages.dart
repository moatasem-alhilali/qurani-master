import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/setting/data/services/social_links_service.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InfoPage(
      title: 'سياسة الخصوصية',
      icon: AppIcons.shield,
      intro: 'معلومات واضحة ومختصرة حول طريقة تعامل التطبيق مع بياناتك.',
      sections: [
        _InfoSectionData(
          title: 'خصوصيتك تهمنا',
          body:
              'نحرص في طمأنينة على أن تكون تجربة استخدام التطبيق واضحة وآمنة. '
              'نستخدم البيانات الضرورية فقط لتشغيل مزايا التطبيق وتحسينها، '
              'ولا نبيع بيانات المستخدمين أو نشاركها لأغراض إعلانية.',
        ),
        _InfoSectionData(
          title: 'البيانات التي قد يستخدمها التطبيق',
          body:
              'قد يستخدم التطبيق الموقع لحساب أوقات الصلاة والقبلة، والإشعارات '
              'لتنبيهات الأذان والأذكار، وبيانات التخزين لحفظ المحتوى المحمل '
              'والإعدادات المحلية، وجهات الاتصال فقط في الميزات التي يفعّلها '
              'المستخدم مثل صحبة الفجر.',
        ),
        _InfoSectionData(
          title: 'التحكم ببياناتك',
          body: 'يمكنك تعطيل الإشعارات أو تعديلها من إعدادات الإشعارات داخل '
              'التطبيق، ويمكنك إدارة صلاحيات النظام من إعدادات جهازك في أي '
              'وقت.',
        ),
        _InfoSectionData(
          title: 'الخدمات الخارجية',
          body: 'قد يستخدم التطبيق خدمات مثل Firebase Remote Config وFirebase '
              'Messaging لتحديث الإعدادات وإرسال التنبيهات العامة. يتم استخدام '
              'هذه الخدمات لتشغيل التطبيق وتحسين التجربة فقط.',
        ),
      ],
    );
  }
}

class DataSafetyScreen extends StatelessWidget {
  const DataSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InfoPage(
      title: 'أمان البيانات',
      icon: AppIcons.security,
      intro: 'ملخص للبيانات التي يستخدمها التطبيق وكيف تُحفظ وتُشارك.',
      sections: [
        _InfoSectionData(
          title: 'البيانات الحساسة',
          body:
              'لا يطلب التطبيق بيانات حساسة إلا عند الحاجة لميزة واضحة يختارها '
              'المستخدم. بعض البيانات مثل أوقات التنبيه، التفضيلات، وخطط '
              'القراءة تُحفظ محليًا على الجهاز.',
        ),
        _InfoSectionData(
          title: 'الموقع',
          body: 'يُستخدم الموقع لحساب مواقيت الصلاة، اتجاه القبلة، والخدمات '
              'المعتمدة على المكان. يمكن للمستخدم إيقاف صلاحية الموقع من '
              'إعدادات النظام.',
        ),
        _InfoSectionData(
          title: 'الإشعارات',
          body:
              'يستخدم التطبيق الإشعارات للأذان، الأذكار، التذكيرات، وبعض رسائل '
              'التطبيق العامة. يمكن التحكم بكل نوع إشعار من صفحة إعدادات '
              'الإشعارات.',
        ),
        _InfoSectionData(
          title: 'التخزين والتحميل',
          body: 'قد يستخدم التطبيق التخزين لحفظ الملفات والمحتوى الذي يختار '
              'المستخدم تحميله، مثل الصوتيات أو المواد المتاحة داخل التطبيق.',
        ),
        _InfoSectionData(
          title: 'المشاركة',
          body:
              'لا تتم مشاركة بياناتك الشخصية مع أطراف خارجية للبيع أو التسويق. '
              'أي مشاركة تتم تكون ضمن خدمات تشغيل ضرورية أو إجراء يبدأه '
              'المستخدم.',
        ),
      ],
    );
  }
}

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScaffold(
      title: 'من نحن',
      children: [
        _InfoHero(
          icon: AppIcons.quran,
          title: 'طمأنينة',
          body: 'تطبيق قرآني وعبادي يساعدك على الصلاة، الذكر، تلاوة القرآن، '
              'والاستمرار على ورد يومي بهدوء وبأسلوب قريب من المستخدم.',
        ),
        SettingsGroup(
          title: 'رسالتنا',
          children: [
            SettingsParagraph(
              'أن يكون التطبيق رفيقًا خفيفًا يعين المستخدم على الطاعة دون '
              'إزعاج، ويجمع الأدوات اليومية المهمة مثل المصحف، الأذكار، '
              'مواقيت الصلاة، التنبيهات، والميزات المساعدة للأسرة.',
            ),
          ],
        ),
        SettingsGroup(
          title: 'ما نقدمه',
          children: [
            SettingsParagraph(
              'مصحف، أذكار، مواقيت صلاة، قبلة، ورد يومي، تطبيقات مصغرة، '
              'صحبة الفجر، المسلم الصغير، خدمات للمسافر، وتنبيهات قابلة '
              'للتخصيص حسب حاجة المستخدم.',
            ),
          ],
        ),
        _AppSocialLinksSection(),
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
    return const SettingsScaffold(
      title: 'حول المطور',
      children: [
        _InfoHero(
          icon: AppIcons.user,
          title: 'معتصم الهلالي',
          body: 'مهندس برمجيات Full Stack وMobile بخبرة تتجاوز 7 سنوات، '
              'متخصص في Flutter وLaravel وNext.js وبناء تطبيقات إنتاجية '
              'للويب والجوال.',
        ),
        SettingsGroup(
          title: 'نبذة مختصرة',
          children: [
            SettingsParagraph(
              'يعمل معتصم الهلالي على بناء تطبيقات ومنصات رقمية تخدم '
              'مستخدمين حقيقيين، مع اهتمام خاص بتطبيقات الجوال، الأنظمة '
              'الخلفية، واجهات الاستخدام، ومنصات Fintech وSaaS.',
            ),
          ],
        ),
        SettingsGroup(
          title: 'مجالات العمل',
          children: [
            SettingsParagraph(
              'Flutter، Laravel، Next.js، React، API Development، تطبيقات '
              'الجوال، تطبيقات الويب، حلول Fintech، ومنصات SaaS.',
            ),
          ],
        ),
        _ContactActions(
          title: 'طرق التواصل',
          actions: [
            _ContactAction('الموقع', AppIcons.globe, _website),
            _ContactAction('البريد', AppIcons.link, 'mailto:$_email'),
            _ContactAction('واتس اب', AppIcons.whatsapp, 'wa:$_whatsapp'),
            _ContactAction('GitHub', AppIcons.source, _github),
            _ContactAction('LinkedIn', AppIcons.user, _linkedin),
            _ContactAction('X', AppIcons.twitter, _twitter),
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
          _ContactAction('تليجرام', AppIcons.telegram, links.telegram),
          _ContactAction('واتس اب', AppIcons.whatsapp, links.whatsapp),
          _ContactAction('فيسبوك', AppIcons.facebook, links.facebook),
          _ContactAction('انستجرام', AppIcons.instagram, links.instagram),
          _ContactAction('تويتر', AppIcons.twitter, links.twitter),
        ].where((item) => item.url.trim().isNotEmpty).toList();

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return _ContactActions(title: 'روابط التطبيق', actions: items);
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
