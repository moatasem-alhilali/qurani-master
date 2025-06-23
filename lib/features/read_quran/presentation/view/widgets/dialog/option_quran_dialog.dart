import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/drawer_slide/surah_juz_list.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/core/widgets/theme_widget.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/bookmark_list.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/search/presentation/view/widgets/sarch_ayah_widget.dart';

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
    // final theme = context.quranTheme.colorScheme;

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.all(8.sp),
        // width: double.infinity,
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 3,
              spreadRadius: 3,
              color: context.primaryScheme.withOpacity(.15),
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
        final theme = context.quranTheme.colorScheme;

        return CardWidget(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 8.sp,
            vertical: 8.sp,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              _BottomAction(
                icon: bookmark_list,
                label: 'السور',
                widget: SurahJuzList(),
              ),
              _BottomAction(
                icon: bookmark_list,
                label: 'المحفوظ',
                widget: BookMarkList(),
              ),
              const _BottomAction(
                icon: search_icon,
                label: 'البحث',
                widget: SearchAyahWidget(),
              ),
              InkWell(
                onTap: () {
                  context.showBottomSheet(
                    backgroundColor: context.scaffoldBackgroundColor,
                    child: ThemeWidget(
                      onTap: () => context.pop(),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    options(height: 25, width: 25, color: theme.surface),
                    const SizedBox(height: 4),
                    Text(
                      'الثيم',
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
  const _BottomAction({
    required this.icon,
    required this.label,
    required this.widget,
  });
  final Widget Function({double height, double width}) icon;
  final String label;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.showBottomSheet(
        backgroundColor: context.scaffoldBackgroundColor,
        child: SizedBox(
          height: context.getHight(80),
          child: widget,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon(height: 25, width: 25),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: context.quranTheme.colorScheme.surface),
          ),
        ],
      ),
    );
  }
}

class _QuickExitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.quranTheme.colorScheme;

    return InkWell(
      onTap: () {
        CacheConfig.saveLastPageRead();
        context
          ..pop()
          ..pop();
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
