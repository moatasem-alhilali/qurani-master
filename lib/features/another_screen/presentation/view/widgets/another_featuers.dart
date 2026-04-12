import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_icon_widget.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_text_widget.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/allh_name/presentation/view/pages/allh_name_screen.dart';
import 'package:quran_app/features/another_screen/presentation/view/pages/husin_almuslim_screen.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/surah_and_detail_screen.dart';
import 'package:quran_app/features/hadith_40/presentation/view/pages/hadith_40_screen.dart';
import 'package:quran_app/features/my_adia/presentation/view/my_doa_provider.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';
import 'package:quran_app/features/qiblah/qiblah_main_screen.dart';
import 'package:quran_app/features/quran_plan/presentation/view/pages/quran_plan_list_screen.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_app/features/sabih/presentation/view/tasbeeh_provider.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_schedules_screen.dart';
import 'package:quran_app/features/thikr/presentation/view/pages/main_thikr_screen.dart';

class AnotherFeatures extends StatelessWidget {
  const AnotherFeatures({super.key});

  List<_FeatureShortcut> _items(BuildContext context) {
    return [
      _FeatureShortcut(
        label: 'المصحف الشريف',
        icon: FlutterIslamicIcons.quran2,
        onTap: () => context.push(const ReadQuranScreen()),
      ),
      _FeatureShortcut(
        label: 'مواقيت الصلاة',
        icon: FlutterIslamicIcons.prayingPerson,
        onTap: () => context.push(const PrayerTimeScreen()),
      ),
      _FeatureShortcut(
        label: 'خطط الختمة',
        icon: FlutterIslamicIcons.solidQuran2,
        onTap: () => context.push(const QuranPlanListScreen()),
      ),
      _FeatureShortcut(
        label: 'التنبيه الذكي',
        icon: Icons.phone_in_talk_rounded,
        onTap: () => context.push(const SmartOutreachSchedulesScreen()),
      ),
      _FeatureShortcut(
        label: 'اتجاه القبلة',
        icon: FlutterIslamicIcons.qibla,
        onTap: () => context.push(const QiblahMainScreen()),
      ),
      _FeatureShortcut(
        label: 'المسبحة',
        icon: FlutterIslamicIcons.tasbih2,
        onTap: () => context.push(const TasbeehProvider()),
      ),
      _FeatureShortcut(
        label: 'أسماء الله الحسنى',
        icon: FlutterIslamicIcons.allah,
        onTap: () => context.push(const AllhNameScreen()),
      ),
      _FeatureShortcut(
        label: 'مكتبة الأذكار',
        icon: FlutterIslamicIcons.quran,
        onTap: () => context.push(const MainThikrScreen()),
      ),
      _FeatureShortcut(
        label: 'حصن المسلم',
        icon: FlutterIslamicIcons.quran,
        onTap: () => context.push(const HisnMuslimScreen()),
      ),
      _FeatureShortcut(
        label: 'الأربعون النووية',
        icon: FlutterIslamicIcons.quran,
        onTap: () => context.push(const Hadith40Screen()),
      ),
      _FeatureShortcut(
        label: 'موسوعة السور',
        icon: FlutterIslamicIcons.quran,
        onTap: () => context.push(const SurahWithAllDetailScreen()),
      ),
      _FeatureShortcut(
        label: 'أدعيتي الخاصة',
        icon: FlutterIslamicIcons.muslim2,
        onTap: () => context.push(const MuDoaProvider()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final features = _items(context);

    return GridView.builder(
      itemCount: features.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1 / 1.4,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        final item = features[index];
        final shape = CardShapeType.values[index % CardShapeType.values.length];

        return _FeatureItem(
          onPressed: item.onTap,
          text: item.label,
          icon: item.icon,
          shapeType: shape,
        );
      },
    );
  }
}

class _FeatureShortcut {
  const _FeatureShortcut({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.shapeType,
  });

  final String text;
  final IconData icon;
  final CardShapeType shapeType;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FeatureCardIconWidget(
            onTap: onPressed,
            icon: Icon(icon, size: 40.sp),
            shapeType: shapeType,
          ),
        ),
        SizedBox(height: 5.h),
        text.autoSize(
          context,
          maxLines: 1,
          minFontSize: 10,
          fontSize: 11.sp,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
