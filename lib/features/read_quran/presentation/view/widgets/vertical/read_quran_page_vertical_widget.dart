// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
// import 'package:quran_app/core/extensions/theme_context_extension.dart';
// import 'package:quran_app/core/models_public/surahs_model.dart';
// import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
// import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
// import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
// import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';
// import 'package:quran_app/features/read_quran/presentation/bloc/old_read_quran/old_read_quran_bloc.dart';
// import 'package:quran_app/gen/fonts.gen.dart';

// class ReadQuranPageVerticalWidget extends StatefulWidget {
//   const ReadQuranPageVerticalWidget({required this.pageIndex, super.key});
//   final int pageIndex;

//   @override
//   State<ReadQuranPageVerticalWidget> createState() =>
//       _ReadQuranPageVerticalWidgetState();
// }

// class _ReadQuranPageVerticalWidgetState
//     extends State<ReadQuranPageVerticalWidget> {
//   int? selectedAyahUQNumber;

//   // Cache expensive calculations
//   double? _cachedFontSize;
//   double? _cachedWidth;

//   List<List<AyahQuranModel>>? _cachedAyahsData;
//   int? _cachedDataVersion;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BookmarkBloc, BookmarkState>(
//       builder: (context, state) {
//         return BlocBuilder<OldReadQuranBloc, OldReadQuranState>(
//           builder: (context, state) {
//             final quranCtrl = context.read<OldReadQuranBloc>().quranRH;

//             return LayoutBuilder(
//               builder: (context, constraints) {
//                 // Cache font size calculation
//                 final fontSize = _getCachedFontSize(constraints.maxWidth);

//                 return BlocBuilder<ThemeBloc, ThemeState>(
//                   builder: (context, state) {
//                     // Cache ayahs data
//                     final currentPageAyahsSeparatedForBasmalah =
//                         _getCachedAyahsData(quranCtrl);

//                     return RepaintBoundary(
//                       child: quranCtrl.pages.isEmpty
//                           ? const Center(
//                               child: CircularProgressIndicator.adaptive(),
//                             )
//                           : SingleChildScrollView(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: List.generate(
//                                   currentPageAyahsSeparatedForBasmalah.length,
//                                   (i) {
//                                     final ayahs =
//                                         currentPageAyahsSeparatedForBasmalah[i];
//                                     return _AyahGroupWidget(
//                                       key: ValueKey('${widget.pageIndex}_$i'),
//                                       pageIndex: widget.pageIndex,
//                                       groupIndex: i,
//                                       ayahs: ayahs,
//                                       fontSize: fontSize,
//                                       selectedAyahUQNumber:
//                                           selectedAyahUQNumber,
//                                       onAyahSelect: (uq) => setState(
//                                         () => selectedAyahUQNumber = uq,
//                                       ),
//                                       onAyahUnselect: () => setState(
//                                         () => selectedAyahUQNumber = null,
//                                       ),
//                                       quranCtrl: quranCtrl,
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   double _getCachedFontSize(double width) {
//     if (_cachedFontSize == null || _cachedWidth != width) {
//       _cachedWidth = width;
//       _cachedFontSize = _calculateFontSize(width);
//     }
//     return _cachedFontSize!;
//   }

//   List<List<AyahQuranModel>> _getCachedAyahsData(QuranReadHelper quranCtrl) {
//     // Simple cache invalidation based on data version
//     final currentDataVersion = quranCtrl.pages.length;
//     if (_cachedAyahsData == null || _cachedDataVersion != currentDataVersion) {
//       _cachedDataVersion = currentDataVersion;
//       _cachedAyahsData =
//           quranCtrl.getCurrentPageAyahsSeparatedForBasmalah(widget.pageIndex);
//     }
//     return _cachedAyahsData!;
//   }

//   double _calculateFontSize(double width) {
//     if (width <= 480) return 18;
//     if (width > 480 && width <= 600) return 30;
//     if (width > 600 && width <= 900) return 32;
//     return 36;
//   }
// }

// // Extract ayah group to separate widget to reduce rebuild scope
// class _AyahGroupWidget extends StatelessWidget {
//   const _AyahGroupWidget({
//     required this.pageIndex,
//     required this.groupIndex,
//     required this.ayahs,
//     required this.fontSize,
//     required this.selectedAyahUQNumber,
//     required this.onAyahSelect,
//     required this.onAyahUnselect,
//     required this.quranCtrl,
//     super.key,
//   });

//   final int pageIndex;
//   final int groupIndex;
//   final List<AyahQuranModel> ayahs;
//   final double fontSize;
//   final int? selectedAyahUQNumber;
//   final void Function(int) onAyahSelect;
//   final VoidCallback onAyahUnselect;
//   final QuranReadHelper quranCtrl;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         context.surahBannerFirstPlace(pageIndex, groupIndex, context),
//         _buildBasmalahIfNeeded(quranCtrl, ayahs, context),
//         RepaintBoundary(
//           child: _AyahTextWidget(
//             pageIndex: pageIndex,
//             ayahs: ayahs,
//             fontSize: fontSize,
//             selectedAyahUQNumber: selectedAyahUQNumber,
//             onAyahSelect: onAyahSelect,
//             onAyahUnselect: onAyahUnselect,
//             quranCtrl: quranCtrl,
//           ),
//         ),
//         context.surahBannerLastPlace(pageIndex, groupIndex, context),
//       ],
//     );
//   }

//   Widget _buildBasmalahIfNeeded(
//     QuranReadHelper quranCtrl,
//     List<AyahQuranModel> ayahs,
//     BuildContext context,
//   ) {
//     final surahNumber = quranCtrl.getSurahNumberByAyah(ayahs.first);
//     final isFirstAyah = ayahs.first.ayahNumber == 1;
//     final isExcludedSurah = surahNumber == 9 || surahNumber == 1;

//     if (isExcludedSurah || !isFirstAyah) {
//       return const SizedBox.shrink();
//     }

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: (surahNumber == 95 || surahNumber == 97)
//           ? besmAllah2(context)
//           : besmAllah(context),
//     );
//   }
// }

// // Extract ayah text to separate widget for better performance
// class _AyahTextWidget extends StatelessWidget {
//   const _AyahTextWidget({
//     required this.pageIndex,
//     required this.ayahs,
//     required this.fontSize,
//     required this.selectedAyahUQNumber,
//     required this.onAyahSelect,
//     required this.onAyahUnselect,
//     required this.quranCtrl,
//     super.key,
//   });

//   final int pageIndex;
//   final List<AyahQuranModel> ayahs;
//   final double fontSize;
//   final int? selectedAyahUQNumber;
//   final void Function(int) onAyahSelect;
//   final VoidCallback onAyahUnselect;
//   final QuranReadHelper quranCtrl;

//   @override
//   Widget build(BuildContext context) {
//     final pageText =
//         ayahs.map((ayah) => '${ayah.text} ﴿${ayah.ayahNumber}﴾').join(' ');

//     final fontSize = calculateAutoFontSize(
//       context: context,
//       pageText: pageText,
//     );

//     final spans = <TextSpan>[];
//     for (final ayah in ayahs) {
//       spans
//         ..add(
//           TextSpan(
//             text: ayah.text,
//             style: TextStyle(
//               fontFamily: FontFamily.scheherazade,
//               fontSize: fontSize,
//               height: 1.6,
//               color: context.primaryColor,
//             ),
//           ),
//         )
//         ..add(
//           TextSpan(
//             text: '﴿${ayah.ayahNumber}﴾',
//             style: TextStyle(
//               fontFamily: FontFamily.scheherazade,
//               fontSize: fontSize * 0.4,
//               color: context.primaryColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         );
//     }

//     return RichText(
//       text: TextSpan(children: spans),
//       textAlign: TextAlign.center,
//       textDirection: TextDirection.rtl,
//     );
//   }

//   double calculateAutoFontSize({
//     required BuildContext context,
//     required String pageText,
//     double minFontSize = 14,
//     double maxFontSize = 38,
//   }) {
//     final media = MediaQuery.of(context);
//     final width = media.size.width;
//     final height = media.size.height;

//     // تقدير عدد السطور المطلوب: كل 60 حرف سطر تقريبا (يمكن تعديله حسب الخط)
//     final approxLines = (pageText.length / 50).ceil();

//     // المساحة المتاحة للكتابة (طرح الترويسة والتذييل وبعض الهوامش)
//     final availableHeight = height - 220; // عدل القيمة حسب الحاجة

//     // حجم الخط المبدئي
//     var fontSize = availableHeight / (approxLines * 1.3);

//     // ضبط النطاق
//     if (fontSize < minFontSize) fontSize = minFontSize;
//     if (fontSize > maxFontSize) fontSize = maxFontSize;

//     return fontSize;
//   }
// }
