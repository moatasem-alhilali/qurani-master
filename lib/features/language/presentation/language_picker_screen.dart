import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/locale/locale_cubit.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/gen/assets.gen.dart';
import 'package:quran_app/l10n/l10n.dart';

/// اختيار لغة الواجهة.
///
/// - [LanguagePickerScreen.onboarding]: أوّل فتح للتطبيق. الضغط على لغة يبدّل
///   الواجهة فورًا للمعاينة (العنوان وزرّ «متابعة» يظهران باللغة المختارة)،
///   ولا يُحفظ شيء حتى «متابعة».
/// - [LanguagePickerScreen.settings]: من الإعدادات؛ الاختيار يُحفظ فورًا.
class LanguagePickerScreen extends StatelessWidget {
  const LanguagePickerScreen.onboarding({super.key}) : isOnboarding = true;

  const LanguagePickerScreen.settings({super.key}) : isOnboarding = false;

  final bool isOnboarding;

  @override
  Widget build(BuildContext context) {
    final list = BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) => _LanguageList(
        selected: state.language,
        onSelected: (language) {
          unawaited(HapticFeedback.selectionClick());
          final cubit = context.read<LocaleCubit>();
          if (isOnboarding) {
            cubit.preview(language);
          } else {
            unawaited(cubit.change(language));
          }
        },
      ),
    );

    if (!isOnboarding) {
      return SettingsScaffold(
        title: context.l10n.languageSettingTitle,
        children: [
          SizedBox(height: 6.h),
          list,
          const _ReligiousTextNote(),
        ],
      );
    }

    final skin = AppSkin.of(context);
    return Scaffold(
      backgroundColor: skin.ground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 28.h, bottom: 12.h),
                children: [
                  const _Header(),
                  SizedBox(height: 18.h),
                  list,
                  const _ReligiousTextNote(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 14.h),
              child: SettingsPrimaryButton(
                label: context.l10n.commonContinue,
                onPressed: () {
                  unawaited(HapticFeedback.mediumImpact());
                  unawaited(context.read<LocaleCubit>().confirm());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final logo =
        skin.isDark ? Assets.logo.splashIconDark : Assets.logo.splashIcon;

    return Column(
      children: [
        logo.image(width: 64.w, height: 64.w),
        SizedBox(height: 14.h),
        Text(
          context.l10n.languageTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: skin.ink,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            context.l10n.languageSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.inkSoft,
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageList extends StatelessWidget {
  const _LanguageList({required this.selected, required this.onSelected});

  final AppLanguage selected;
  final ValueChanged<AppLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          for (final language in AppLanguage.values)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _LanguageRow(
                language: language,
                selected: language == selected,
                onTap: () => onSelected(language),
              ),
            ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Semantics(
      selected: selected,
      button: true,
      label: language.nativeName,
      child: Material(
        color: selected ? skin.iconChip : skin.ground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(
            color: selected ? skin.accent : skin.hairline,
            width: selected ? 1.4 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                Text(language.flag, style: TextStyle(fontSize: 24.sp)),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الاسم بلغته واتّجاهه: «اردو» يُقرأ من اليمين حتى
                      // والواجهة إندونيسية.
                      Text(
                        language.nativeName,
                        textDirection: language.isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        language.englishName,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: skin.inkSoft,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: selected
                      ? AppIcon(
                          AppIcons.check,
                          key: const ValueKey('on'),
                          color: skin.accent,
                          size: 20.sp,
                        )
                      : SizedBox(key: const ValueKey('off'), width: 20.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReligiousTextNote extends StatelessWidget {
  const _ReligiousTextNote();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 8.h),
      child: Text(
        context.l10n.languageReligiousTextNote,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: skin.inkSoft.withValues(alpha: 0.85),
          fontSize: 11.sp,
          height: 1.5,
        ),
      ),
    );
  }
}
