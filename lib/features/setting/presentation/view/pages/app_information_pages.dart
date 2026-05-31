import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/setting/data/services/social_links_service.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InfoPage(
      title: 'سياسة الخصوصية',
      icon: AppIcons.shield,
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
              'التطبيق، ويمكنك إدارة صلاحيات النظام من إعدادات جهازك في أي وقت.',
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
      sections: [
        _InfoSectionData(
          title: 'البيانات الحساسة',
          body:
              'لا يطلب التطبيق بيانات حساسة إلا عند الحاجة لميزة واضحة يختارها '
              'المستخدم. بعض البيانات مثل أوقات التنبيه، التفضيلات، وخطط القراءة '
              'تُحفظ محليًا على الجهاز.',
        ),
        _InfoSectionData(
          title: 'الموقع',
          body: 'يُستخدم الموقع لحساب مواقيت الصلاة، اتجاه القبلة، والخدمات '
              'المعتمدة على المكان. يمكن للمستخدم إيقاف صلاحية الموقع من إعدادات '
              'النظام.',
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
              'أي مشاركة تتم تكون ضمن خدمات تشغيل ضرورية أو إجراء يبدأه المستخدم.',
        ),
      ],
    );
  }
}

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'من نحن',
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            const _HeroInfoCard(
              icon: AppIcons.quran,
              title: 'طمأنينة',
              subtitle:
                  'تطبيق قرآني وعبادي يساعدك على الصلاة، الذكر، تلاوة القرآن، '
                  'والاستمرار على ورد يومي بهدوء وبأسلوب قريب من المستخدم.',
            ),
            const _InfoSection(
              title: 'رسالتنا',
              body:
                  'أن يكون التطبيق رفيقًا خفيفًا يعين المستخدم على الطاعة دون '
                  'إزعاج، ويجمع الأدوات اليومية المهمة مثل المصحف، الأذكار، '
                  'مواقيت الصلاة، التنبيهات، والميزات المساعدة للأسرة.',
            ),
            const _InfoSection(
              title: 'ما نقدمه',
              body: 'مصحف، أذكار، مواقيت صلاة، قبلة، ورد يومي، تطبيقات مصغرة، '
                  'صحبة الفجر، المسلم الصغير، خدمات للمسافر، وتنبيهات قابلة '
                  'للتخصيص حسب حاجة المستخدم.',
            ),
            SizedBox(height: 18.h),
            const _AppSocialLinksSection(),
          ],
        ),
      ),
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
    return AppScaffoldWidget(
      title: 'حول المطور',
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            const _HeroInfoCard(
              icon: AppIcons.user,
              title: 'معتصم الهلالي',
              subtitle:
                  'مهندس برمجيات Full Stack وMobile بخبرة تتجاوز 7 سنوات، '
                  'متخصص في Flutter وLaravel وNext.js وبناء تطبيقات إنتاجية '
                  'للويب والجوال.',
            ),
            const _InfoSection(
              title: 'نبذة مختصرة',
              body: 'يعمل معتصم الهلالي على بناء تطبيقات ومنصات رقمية تخدم '
                  'مستخدمين حقيقيين، مع اهتمام خاص بتطبيقات الجوال، الأنظمة '
                  'الخلفية، واجهات الاستخدام، ومنصات Fintech وSaaS.',
            ),
            const _InfoSection(
              title: 'مجالات العمل',
              body:
                  'Flutter، Laravel، Next.js، React، API Development، تطبيقات '
                  'الجوال، تطبيقات الويب، حلول Fintech، ومنصات SaaS.',
            ),
            SizedBox(height: 18.h),
            const _ContactActions(
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
        ),
      ),
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

        return _ContactActions(
          title: 'روابط التطبيق',
          actions: items,
        );
      },
    );
  }
}

class _InfoPage extends StatelessWidget {
  const _InfoPage({
    required this.title,
    required this.icon,
    required this.sections,
  });

  final String title;
  final HugeIconData icon;
  final List<_InfoSectionData> sections;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: title,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            _HeroInfoCard(
              icon: icon,
              title: title,
              subtitle: 'معلومات واضحة ومختصرة حول طريقة تعامل التطبيق معها.',
            ),
            for (final section in sections)
              _InfoSection(title: section.title, body: section.body),
          ],
        ),
      ),
    );
  }
}

class _HeroInfoCard extends StatelessWidget {
  const _HeroInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final HugeIconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            padding: EdgeInsets.all(9.w),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: AppIcon(
              icon,
              color: context.primaryColor,
              size: 26.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: context.onSurfaceColor,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    height: 1.55,
                    color: context.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w800,
              color: context.primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            style: TextStyle(
              fontSize: 11.5.sp,
              height: 1.7,
              color: context.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactActions extends StatelessWidget {
  const _ContactActions({
    required this.actions,
    this.title = 'طرق التواصل',
  });

  final String title;
  final List<_ContactAction> actions;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w800,
              color: context.primaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final action in actions) _ContactChip(action: action),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.action});

  final _ContactAction action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launch(action.url),
      borderRadius: BorderRadius.circular(999.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: context.primaryColor.withValues(alpha: 0.16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              action.icon,
              size: 15.sp,
              color: context.primaryColor,
            ),
            SizedBox(width: 6.w),
            Text(
              action.title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: context.primaryColor,
              ),
            ),
          ],
        ),
      ),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
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
