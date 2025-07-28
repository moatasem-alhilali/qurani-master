import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/drawer_slide/quran_surah_list.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class QuranJuz extends StatelessWidget {
  QuranJuz({super.key});
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, readQuranState) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 30,
          shrinkWrap: true,
          controller: controller,
          // controller: sl<GeneralController>().surahListController,
          itemBuilder: (_, index) {
            final surah = readQuranState.surahs[index];
            final juz = readQuranState.allAyahs.firstWhere(
              (a) => a.juz == index + 1,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${'الجزء'} ${convertNumbers((index + 1).toString())}',
                    style: context.titleMedium?.copyWith(
                      color: context.primaryColor,
                      fontFamily: 'kufi',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 2,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: (index % 2 == 0
                          ? context.primaryColor
                              .withOpacity(.15)
                          : Colors.transparent),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [Colors.transparent, Colors.black],
                              stops: [0.0, 0.2],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: SvgPicture.asset(
                                          'assets/svg/sora_num.svg',
                                          color: context.primaryColor,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: const Offset(0, 1),
                                        child: Text(
                                          convertNumbers(
                                            (index + 1).toString(),
                                          ),
                                          style: context.titleMedium?.copyWith(
                                            color: context.primaryColor,
                                            fontFamily: 'kufi',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            height: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      juz.text,
                                      style: context.titleMedium?.copyWith(
                                        color: context.primaryColor,
                                        // fontFamily: 'uthmanic2',
                                        fontSize: 14.sp,
                                        height: 2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow
                                          .clip, // Change overflow to clip
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        '${surah.nameAr} ${convertNumbers(surah.surahNumber.toString())} - ${'الصفحه'} ${convertNumbers(juz.page.toString())}',
                                        style: context.titleMedium?.copyWith(
                                          // fontFamily: 'naskh',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                          color: context.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    context.read<ReadQuranBloc>().pageController.jumpToPage(
                          juz.page! - 1,
                        );
                    context.pop();
                    context.pop();
                    // quranCtrl.changeSurahListOnTap(juz.page);
                  },
                ),
                hDivider(
                  color: context.primaryColor.withOpacity(0.2),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
