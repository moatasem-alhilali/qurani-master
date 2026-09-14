import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/home/data/surah_label.dart';
import 'package:quran_app/features/home/presentation/bloc/random_ayah_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/pages/read_quran_screen.dart';
import 'package:quran_app/gen/fonts.gen.dart';
import 'package:quran_library/quran_library.dart';

/// آية عشوائية بخطّ المصحف، على الأرضية مباشرة بلا بطاقة — الخطّ نفسه
/// هو ما يميّز القسم، فلا يحتاج إطارًا حوله.
class HomeDailyAyah extends StatelessWidget {
  const HomeDailyAyah({super.key});

  /// اسم السورة من رقمها. عند تعذّر قراءة بيانات المكتبة نكتفي برقم الآية.
  String? _surahName(int surahId) {
    try {
      final surahs = QuranLibrary.getAllSurahs();
      if (surahId < 1 || surahId > surahs.length) return null;
      return surahs[surahId - 1];
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomAyahBloc, RandomAyahState>(
      builder: (context, state) {
        final skin = AppSkin.of(context);
        final ayah = state.randomAyah;
        final isLoading =
            ayah == null && state.loadState == RequestState.loading;
        final surahName = ayah == null ? null : _surahName(ayah.surahId);
        final page = ayah?.page;

        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 0),
          child: Column(
            children: [
              if (isLoading)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.gold,
                      ),
                    ),
                  ),
                )
              else
                Text(
                  ayah?.text ?? 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.scheherazade,
                    color: skin.ink,
                    fontSize: 17.sp,
                    height: 1.85,
                  ),
                ),
              if (ayah != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    surahName != null
                        ? '${surahLabel(surahName)} · الآية ${ayah.ayahNumber}'
                        : 'الآية ${ayah.ayahNumber}',
                    style: TextStyle(
                      color: skin.accent,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: _AyahAction(
                      icon: AppIcons.refresh,
                      label: 'آية أخرى',
                      onTap: () => context
                          .read<RandomAyahBloc>()
                          .add(RefreshRandomAyahEvent()),
                    ),
                  ),
                  Container(width: 1, height: 16.h, color: skin.hairline),
                  Expanded(
                    child: _AyahAction(
                      icon: AppIcons.quran,
                      label: 'اقرأها في المصحف',
                      onTap: page == null
                          ? null
                          : () => context.push(ReadQuranScreen(page: page - 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AyahAction extends StatelessWidget {
  const _AyahAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final HugeIconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final color =
        onTap == null ? skin.inkSoft.withValues(alpha: 0.4) : skin.accent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 4.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(icon, color: color, size: 13.sp),
            SizedBox(width: 5.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
