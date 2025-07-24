import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/download_quran_audio_bloc/download_quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/view/widgets/new/surah_aduio_list_widget.dart';

class BackdropMusicBodyWidget extends StatelessWidget {
  const BackdropMusicBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DownloadQuranAudioBloc(),
      child: Container(
        margin: const EdgeInsets.only(top: 70),
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
                      'Tracks',
                      style: context.titleMedium.copyWith(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Playlists',
                      style: context.titleMedium.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Favorites',
                      style: context.titleMedium.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Folders',
                      style: context.titleMedium.copyWith(
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
                  color: context.secondary.withOpacity(0.8),
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
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.sort_down,
                                  size: 23,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Date added',
                                  style: context.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.onSurface
                                      .withAlpha(15),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  highlightColor: context.colorScheme.onSurface
                                      .withAlpha(50),
                                  icon: const Icon(
                                    CupertinoIcons.shuffle,
                                    size: 16,
                                    // color:
                                    //     Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.onSurface
                                      .withAlpha(15),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  highlightColor: context.colorScheme.onSurface
                                      .withAlpha(50),
                                  icon: const Icon(
                                    CupertinoIcons.play_arrow_solid,
                                    size: 16,
                                    // color:
                                    //     Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: SurahAudioListWidget()),
                  ],
                ),
              ),
            ),
          ],
        ),
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
//         splashColor: context.colorScheme.onSurface.withAlpha(50),
//         highlightColor: context.colorScheme.onSurface.withAlpha(50),
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
//                     color: context.colorScheme.onSurface.withAlpha(100),
//                     size: 22,
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(65, 10, 15, 0),
//               height: 1,
//               color: context.colorScheme.onSurface.withAlpha(30),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
