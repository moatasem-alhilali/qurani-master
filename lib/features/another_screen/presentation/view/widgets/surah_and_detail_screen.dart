import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/components/unified_library_widgets.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/another_screen/data/models/surah_info_model.dart';
import 'package:quran_app/features/another_screen/presentation/bloc/surah_info/surah_info_bloc.dart';
import 'package:quran_app/l10n/l10n.dart';

/// موسوعة السور.
///
/// كانت مئة وأربع عشرة بطاقة متتالية، لكلٍّ إطارها وظلّها وشارتها — فلا شيء
/// يبرز لأن كل شيء بارز. صارت صفوفًا نحيلة متساوية تفصلها شعرة، ورقم السورة
/// في مربّع الأيقونة، وعدد آياتها رقمًا هادئًا على الطرف.
class SurahWithAllDetailScreen extends StatefulWidget {
  const SurahWithAllDetailScreen({super.key});

  @override
  State<SurahWithAllDetailScreen> createState() =>
      _SurahWithAllDetailScreenState();
}

class _SurahWithAllDetailScreenState extends State<SurahWithAllDetailScreen> {
  String _query = '';

  String _asBullets(List<String> lines) {
    if (lines.isEmpty) {
      return '';
    }
    return lines.map((line) => '• ${line.trim()}').join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (context) => SurahInfoBloc()..add(LoadSurahInfoEvent()),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: AppScaffoldWidget(
          title: context.l10n.anotherScreenSurahEncyclopedia,
          trailing: BlocBuilder<SurahInfoBloc, SurahInfoState>(
            builder: (context, state) {
              return GenericSearchAnchorAsync<SurahInfoModel>(
                asyncSuggestions: (query) async {
                  final normalized = query.trim();
                  if (normalized.isEmpty) {
                    return state.data;
                  }
                  return state.data.where((item) {
                    return item.surah.contains(normalized) ||
                        item.id.toString().contains(normalized) ||
                        item.ayaatiha.contains(normalized);
                  }).toList();
                },
                onSelected: (item) {
                  setState(() => _query = item.surah);
                  _showSurahDetails(context, item, state.data.indexOf(item));
                },
                hintText: context.l10n.anotherScreenSurahSearchHint,
                suggestionBuilder: (context, item) =>
                    UnifiedLibrarySearchSuggestion(
                  title: item.surah,
                  subtitle: item.maqsiduhaAleamu,
                  trailing: '#${item.id}',
                ),
              );
            },
          ),
          slivers: [
            BlocBuilder<SurahInfoBloc, SurahInfoState>(
              builder: (context, state) {
                return state.state.whenSliver<SurahInfoModel>(
                  context: context,
                  sliverList: state.data,
                  onSuccess: () {
                    final normalized = _query.trim();
                    final dataList = normalized.isEmpty
                        ? state.data
                        : state.data.where((item) {
                            return item.surah.contains(normalized) ||
                                item.id.toString().contains(normalized);
                          }).toList();

                    if (dataList.isEmpty) {
                      return SliverToBoxAdapter(
                        child: _NoResultsNote(
                          onShowAll: () => setState(() => _query = ''),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      sliver: SliverList.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final data = dataList[index];
                          return _SurahRow(
                            data: data,
                            isLast: index == dataList.length - 1,
                            onTap: () =>
                                _showSurahDetails(context, data, index),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSurahDetails(BuildContext context, SurahInfoModel data, int index) {
    final l10n = context.l10n;
    String heading(String label) => l10n.anotherScreenLabelHeading(label);
    final shareContent = [
      l10n.anotherScreenSurahTitle(data.surah),
      '',
      l10n.anotherScreenLabelValue(l10n.anotherScreenSurahNumber, '${data.id}'),
      l10n.anotherScreenLabelValue(l10n.anotherScreenAyahCount, data.ayaatiha),
      '',
      heading(l10n.anotherScreenSurahNameMeaning),
      data.maeniAsamuha,
      '',
      heading(l10n.anotherScreenSurahNamingReason),
      data.sababTasmiatiha,
      '',
      heading(l10n.anotherScreenSurahOtherNamesShort),
      data.asmawuha,
      '',
      heading(l10n.anotherScreenSurahPurpose),
      data.maqsiduhaAleamu,
      '',
      heading(l10n.anotherScreenSurahRevelationReason),
      data.sababNuzuliha,
      '',
      heading(l10n.anotherScreenSurahVirtues),
      _asBullets(data.fadluha),
      '',
      heading(l10n.anotherScreenSurahRelations),
      _asBullets(data.munasabatiha),
    ].join('\n');

    context.showBottomSheet(
      child: UnifiedLibraryDetailSheet(
        title: data.surah,
        subtitle: l10n.anotherScreenSurahEncyclopedia,
        shareText: shareContent,
        copyText: shareContent,
        shareSubject: l10n.anotherScreenSurahEncyclopedia,
        badges: [
          UnifiedLibraryMeta(
            label: l10n.anotherScreenSurahOrder,
            value: '${index + 1}',
            isPrimary: true,
          ),
          UnifiedLibraryMeta(
            label: l10n.anotherScreenSurahNumber,
            value: '${data.id}',
          ),
          UnifiedLibraryMeta(
            label: l10n.anotherScreenAyahCount,
            value: data.ayaatiha,
          ),
        ],
        sections: [
          UnifiedLibrarySection(
            title: l10n.anotherScreenSurahNameMeaning,
            content: data.maeniAsamuha,
          ),
          UnifiedLibrarySection(
            title: l10n.anotherScreenSurahNamingReason,
            content: data.sababTasmiatiha,
          ),
          UnifiedLibrarySection(
            title: l10n.anotherScreenSurahOtherNames,
            content: data.asmawuha,
          ),
          UnifiedLibrarySection(
            title: l10n.anotherScreenSurahPurpose,
            content: data.maqsiduhaAleamu,
          ),
          UnifiedLibrarySection(
            title: l10n.anotherScreenSurahRevelationReason,
            content: data.sababNuzuliha,
          ),
          UnifiedLibrarySection(
            title: l10n.anotherScreenSurahVirtues,
            content: _asBullets(data.fadluha),
          ),
          UnifiedLibrarySection(
            title: l10n.anotherScreenSurahRelations,
            content: _asBullets(data.munasabatiha),
          ),
        ],
      ),
    );
  }
}

/// صفّ سورة: رقمها في مربّع الأيقونة، اسمها ومقصدها، ثم عدد آياتها.
class _SurahRow extends StatelessWidget {
  const _SurahRow({
    required this.data,
    required this.onTap,
    required this.isLast,
  });

  final SurahInfoModel data;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BaseAnimate(
      index: data.id,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: isLast
              ? null
              : BoxDecoration(
                  border: Border(bottom: BorderSide(color: skin.hairline)),
                ),
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
                  child: Text(
                    '${data.id}',
                    style: TextStyle(
                      color: skin.accent,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [ui.FontFeature.tabularFigures()],
                    ),
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
                      data.surah,
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
                      data.maqsiduhaAleamu,
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
              SizedBox(width: 8.w),
              Text(
                context.l10n.anotherScreenAyahsLabel(data.ayaatiha),
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.62),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
              SizedBox(width: 6.w),
              AppIcon(
                Directionality.of(context) == TextDirection.rtl
                    ? AppIcons.chevronLeft
                    : AppIcons.chevronRight,
                color: skin.accent,
                size: 15.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// سطر «لا نتائج» مع رابط لعرض الكلّ — بلا أيقونة عملاقة.
class _NoResultsNote extends StatelessWidget {
  const _NoResultsNote({required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
      child: Row(
        children: [
          AppIcon(AppIcons.searchOff, color: skin.accent, size: 15.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              context.l10n.anotherScreenNoMatchingResults,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: onShowAll,
            borderRadius: BorderRadius.circular(999.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Text(
                context.l10n.anotherScreenShowAllSurahs,
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
