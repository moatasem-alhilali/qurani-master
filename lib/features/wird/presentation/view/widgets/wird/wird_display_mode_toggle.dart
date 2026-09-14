import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';

/// تبديل طريقة العرض بين القائمة والبطاقة الواحدة.
class WirdDisplayModeToggle extends StatelessWidget {
  const WirdDisplayModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<WirdBloc, WirdState>(
      buildWhen: (p, c) => p.displayMode != c.displayMode,
      builder: (context, state) {
        final isListMode = state.displayMode == WirdDisplayMode.listView;

        return Tooltip(
          message: isListMode ? 'عرض ذكرًا واحدًا' : 'عرض الأذكار قائمةً',
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              context.read<WirdBloc>().add(ChangeDisplayModeEvent());
            },
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: AppIcon(
                  isListMode ? AppIcons.layers : AppIcons.list,
                  color: skin.accent,
                  size: 15.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
