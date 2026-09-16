import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/pages/analytics_screen.dart';

/// مدخل ملخّص الذكر: صفّ نحيل يحمل مجموع تسبيح اليوم، لا بطاقة.
class TasbeehAnalyticsHeader extends StatelessWidget {
  const TasbeehAnalyticsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<SabihBloc, SabihState>(
      buildWhen: (previous, current) => previous.countsMap != current.countsMap,
      builder: (context, state) {
        final total = (state.countsMap ?? const <int, int>{})
            .values
            .fold<int>(0, (sum, value) => sum + value);

        return InkWell(
          onTap: () {
            context.push(
              BlocProvider.value(
                value: context.read<SabihBloc>(),
                child: const AnalyticsScreen(),
              ),
              screenName: 'TasbeehAnalyticsScreen',
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: skin.iconChip,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: AppIcon(
                      AppIcons.layers,
                      color: skin.accent,
                      size: 15.sp,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ملخّص الذكر',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        total == 0
                            ? 'لم تبدأ ذكر اليوم بعد'
                            : 'ذكرت اليوم $total مرّة',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.inkSoft.withValues(alpha: 0.78),
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
              ],
            ),
          ),
        );
      },
    );
  }
}
