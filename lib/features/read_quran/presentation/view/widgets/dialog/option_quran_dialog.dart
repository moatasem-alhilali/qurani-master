import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/sheet/setting_theme_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/widgets/drawer_slide/surah_juz_list.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/bookmark_list.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/search/presentation/view/widgets/sarch_ayah.dart';

class OptionQuranDialog extends StatelessWidget {
  const OptionQuranDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _TopSettingsBar(),
          const Align(
            alignment: Alignment.bottomCenter,
            child: _BottomOption(),
          ),
          _CloseDialogArea(),
        ],
      ),
    );
  }
}

class _TopSettingsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.currentThemeData.colorScheme;

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.all(8.sp),
        // width: double.infinity,
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 3,
              spreadRadius: 3,
              color: theme.primary.withOpacity(.15),
            ),
          ],
        ),
        child: _QuickExitButton(),
      ),
    );
  }
}

class _CloseDialogArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: context.getHight(70),
        width: double.infinity,
        child: InkWell(
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => context.pop(),
          child: const CircleAvatar(
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class _BottomOption extends StatelessWidget {
  const _BottomOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, state) {
        final theme = context.currentThemeData.colorScheme;

        return Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 8.sp,
            vertical: 8.sp,
          ),
          decoration: BoxDecoration(
            color: theme.background,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 3,
                spreadRadius: 3,
                color: theme.primary.withOpacity(.15),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              _BottomAction(
                icon: bookmark_list,
                label: "السور",
                widget: SurahJuzList(),
              ),
              _BottomAction(
                icon: bookmark_list,
                label: "المحفوظ",
                widget: BookMarkList(),
              ),
              _BottomAction(
                icon: search_icon,
                label: "البحث",
                widget: SearchAyah(),
              ),
              InkWell(
                onTap: () {
                  context.showBottomSheet(
                    backgroundColor: theme.background,
                    child: SettingThemeSheet(),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    options(height: 25, width: 25, color: theme.surface),
                    const SizedBox(height: 4),
                    Text(
                      "الثيم",
                      style: TextStyle(color: theme.surface),
                    ),
                  ],
                ),
              ),
              const SizedBox(),
            ],
          ).animate().fade(),
        );
      },
    );
  }
}

class _BottomAction extends StatelessWidget {
  final Widget Function({double height, double width}) icon;
  final String label;
  final Widget widget;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.showBottomSheet(
        backgroundColor: context.currentThemeData.colorScheme.background,
        child: SizedBox(
          height: context.getHight(80),
          child: widget,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon(height: 25.0, width: 25.0),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: context.currentThemeData.colorScheme.surface)),
        ],
      ),
    );
  }
}

class _QuickExitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.currentThemeData.colorScheme;

    return InkWell(
      onTap: () {
        CashConfig.setLastRead();
        context.pop();
        context.pop();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.arrow_uturn_left, color: theme.surface, size: 25),
          // const SizedBox(height: 4),
          // Text("خروج", style: TextStyle(color: theme.surface)),
        ],
      ),
    );
  }
}
