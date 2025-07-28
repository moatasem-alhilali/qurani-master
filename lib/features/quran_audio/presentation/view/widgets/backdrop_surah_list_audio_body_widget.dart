import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/core/widgets/animated_snackbar_widget.dart';
import 'package:quran_app/core/widgets/icon_button_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/icon_play_toggle_audio_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/surah_aduio_list_widget.dart';

class BackdropSurahListAudioBodyWidget extends StatelessWidget {
  const BackdropSurahListAudioBodyWidget({
    required this.boxController,
    super.key,
  });
  final BoxController boxController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 75.h),
      child: Column(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'اونلاين',
                    style: context.titleMedium?.copyWith(
                      fontSize: 22,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.showCustomSnackbar(
                      'قريبا سيتم إضافة هذه الميزة',
                      style: SnackBarType.warning,
                    );
                  },
                  child: Text(
                    'محفوظ',
                    style: context.titleMedium?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.showCustomSnackbar(
                      'قريبا سيتم إضافة هذه الميزة',
                      style: SnackBarType.warning,
                    );
                  },
                  child: Text(
                    'المفضلة',
                    style: context.titleMedium?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.showCustomSnackbar(
                      'قريبا سيتم إضافة هذه الميزة',
                      style: SnackBarType.warning,
                    );
                  },
                  child: Text(
                    'الاكثر تحميلا',
                    style: context.titleMedium?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButtonWidget(
                              tooltip: 'تبديل الترتيب',
                              onPressed: () {
                                context.showCustomSnackbar(
                                  'قريبا سيتم إضافة هذه الميزة',
                                  style: SnackBarType.warning,
                                );
                              },
                              icon: const Icon(
                                CupertinoIcons.sort_down,
                                // size: 23,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.showCustomSnackbar(
                                  'قريبا سيتم إضافة هذه الميزة',
                                  style: SnackBarType.warning,
                                );
                              },
                              child: Text(
                                'تاريخ الاضافة',
                                style: context.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            BlocBuilder<QuranAudioBloc, QuranAudioState>(
                              buildWhen: (p, c) =>
                                  p.isShuffleEnabled != c.isShuffleEnabled,
                              builder: (context, state) {
                                return IconButtonWidget(
                                  tooltip: 'تبديل الترتيب',
                                  onPressed: () => context
                                      .read<QuranAudioBloc>()
                                      .add(ToggleShuffleEvent()),
                                  icon: Icon(
                                    CupertinoIcons.shuffle,
                                    color: state.isShuffleEnabled
                                        ? context.primaryColor
                                        : null,
                                    size: 18.sp,
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<QuranAudioBloc, QuranAudioState>(
                              builder: (context, state) {
                                if (state.loadAudioSourceState ==
                                    RequestState.loading) {
                                  return const SizedBox();
                                }

                                return IconPlayToggleAudioWidget(
                                  audioPlayer:
                                      state.audioPlayerSource ?? AudioPlayer(),
                                  radius: 16,
                                  backgroundColor: Colors.transparent,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SurahAudioListWidget(
                      boxController: boxController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class MaterialListItem extends StatelessWidget {
//   const MaterialListItem({
//     required this.title,
//     required this.description,
//     required this.image,
//     required this.onPressed,
//     required this.onMorePressed,
//     super.key,
//   });
//   final Widget title;
//   final Widget description;
//   final Widget image;
//   final VoidCallback onPressed;
//   final VoidCallback onMorePressed;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//       clipBehavior: Clip.antiAlias,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//       ),
//       child: MaterialButton(
//         padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
//         height: 75,
//         splashColor:  context.onSurfaceColor.withAlpha(50),
//         highlightColor:  context.onSurfaceColor.withAlpha(50),
//         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         onPressed: onPressed,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 45,
//                   height: 45,
//                   clipBehavior: Clip.antiAlias,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: image,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(left: 15),
//                         child: title,
//                       ),
//                       Container(
//                         margin: const EdgeInsets.only(left: 15),
//                         child: description,
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: onMorePressed,
//                   icon: Icon(
//                     Icons.more_vert_rounded,
//                     color:  context.onSurfaceColor.withAlpha(100),
//                     size: 22,
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(65, 10, 15, 0),
//               height: 1,
//               color:  context.onSurfaceColor.withAlpha(30),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
