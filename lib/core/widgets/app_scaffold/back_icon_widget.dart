import 'package:flutter/material.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/l10n/l10n.dart';

/// زرّ رجوع مستقلّ للشاشات التي تبني ترويستها بنفسها.
///
/// هندسته مطابقة لزرّ الرجوع داخل شريط التطبيق: [IconButton] بإعداداته
/// الافتراضية وأيقونة [kAppBarIconSize]. كان قبلها بقيود ‎40.w‎ وحشو خاصّ
/// وأيقونة ‎size: 50‎ فيخرج مربّعًا أكبر من بقية أزرار الشريط.
class BackIconWidget extends StatelessWidget {
  const BackIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return IconButton(
      onPressed: () => context.pop(),
      tooltip: context.l10n.commonBack,
      icon: AppIcon(
        AppIcons.backFor(context),
        color: skin.accent,
        size: kAppBarIconSize,
      ),
    );
  }
}
