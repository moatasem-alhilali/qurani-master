import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/travel_dhikr_model.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/travel_road_station.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// أذكار السفر — مرسومة طريقًا لا مسرودة قائمة.
///
/// البيانات ستّة أذكار فقط، لكلٍّ منها لحظته من الرحلة موسومةً في `trigger`.
/// وكانت الصفحة تحمل لأجلها شريطًا دوّارًا وبحثًا ومبدّل عرض وعدّاد صفحات
/// وبطاقة ملخّص — آلةَ تصفّحٍ لقائمة طويلة، والقائمة ستّة.
///
/// صارت الرحلة نفسها: خطٌّ رأسي ومحطّات بترتيب وقوعها، يمتلئ ذهبًا إلى حيث
/// وصلت. والمحطّة المفتوحة عند الدخول هي أوّل ما لم يُتمّ، فيفتح المسافر
/// الصفحة وهو في موضعه من الطريق.
class TravelAthkarScreen extends StatelessWidget {
  const TravelAthkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TravelAthkarBloc(),
      child: const _TravelAthkarView(),
    );
  }
}

class _TravelAthkarView extends StatefulWidget {
  const _TravelAthkarView();

  @override
  State<_TravelAthkarView> createState() => _TravelAthkarViewState();
}

class _TravelAthkarViewState extends State<_TravelAthkarView> {
  /// ترتيب محطّات رحلتك أنت. ما ليس منها يذهب إلى قسم المودِّع.
  static const _roadOrder = <String>[
    'on_start_travel',
    'on_elevation_change',
    'on_stop',
    'on_return',
  ];

  /// مفتاح المحطّة المفتوحة. حالة عرض خالصة، فلا مكان لها في الـ bloc.
  String? _openKey;

  /// هل لمس المستخدم محطّة بنفسه؟
  ///
  /// قبل ذلك نفتح له أوّل ما لم يُتمّ تلقائيًّا، وبعده نحترم اختياره ولا
  /// نقفز تحت إصبعه كلّما تغيّر العدّاد.
  bool _touched = false;

  List<TravelDhikrModel> _road(List<TravelDhikrModel> items) {
    final ordered = <TravelDhikrModel>[];
    for (final trigger in _roadOrder) {
      for (final item in items) {
        if (item.trigger == trigger) ordered.add(item);
      }
    }
    return ordered;
  }

  List<TravelDhikrModel> _farewell(List<TravelDhikrModel> items) =>
      items.where((item) => !_roadOrder.contains(item.trigger)).toList();

  bool _isDone(TravelDhikrModel item, int count) =>
      item.isDynamicRepeat ? count > 0 : count >= (item.repeatCount ?? 1);

  String? _resolveOpenKey(
    List<TravelDhikrModel> road,
    Map<String, int> counts,
  ) {
    if (_touched) return _openKey;
    for (final item in road) {
      if (!_isDone(item, counts[item.key] ?? 0)) return item.key;
    }
    return road.isEmpty ? null : road.first.key;
  }

  void _toggle(String key) {
    setState(() {
      _touched = true;
      _openKey = _openKey == key ? null : key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TravelerScaffold(
      title: 'أذكار السفر',
      child: BlocBuilder<TravelAthkarBloc, TravelAthkarState>(
        builder: (context, state) {
          if (state.status == TravelAthkarStatus.loading ||
              state.status == TravelAthkarStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TravelAthkarStatus.failure) {
            return TravelerNotice(
              icon: AppIcons.error,
              message: state.errorMessage ?? 'تعذّر تحميل أذكار السفر.',
              isError: true,
              actionLabel: 'إعادة المحاولة',
              onAction: () =>
                  context.read<TravelAthkarBloc>().add(LoadAthkarEvent()),
            );
          }

          final road = _road(state.allItems);
          final farewell = _farewell(state.allItems);
          final openKey = _resolveOpenKey(road, state.repeatCounts);

          return ListView(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
            children: [
              _RoadHeader(road: road, counts: state.repeatCounts),
              SizedBox(height: 16.h),
              for (var i = 0; i < road.length; i++)
                TravelRoadStation(
                  item: road[i],
                  count: state.repeatCounts[road[i].key] ?? 0,
                  isExpanded: openKey == road[i].key,
                  isFirst: i == 0,
                  isLast: i == road.length - 1,
                  onTap: () => _toggle(road[i].key),
                ),
              if (farewell.isNotEmpty) ...[
                SizedBox(height: 18.h),
                const _SectionLabel(
                  title: 'لمن يودّع مسافرًا',
                  caption: 'ليست من طريقك — بل ممّن بقي خلفك',
                ),
                SizedBox(height: 10.h),
                for (var i = 0; i < farewell.length; i++)
                  TravelRoadStation(
                    item: farewell[i],
                    count: state.repeatCounts[farewell[i].key] ?? 0,
                    isExpanded: openKey == farewell[i].key,
                    isFirst: i == 0,
                    isLast: i == farewell.length - 1,
                    onTap: () => _toggle(farewell[i].key),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// سطر واحد يقول أين أنت من الطريق.
class _RoadHeader extends StatelessWidget {
  const _RoadHeader({required this.road, required this.counts});

  final List<TravelDhikrModel> road;
  final Map<String, int> counts;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final done = road.where((item) {
      final count = counts[item.key] ?? 0;
      return item.isDynamicRepeat
          ? count > 0
          : count >= (item.repeatCount ?? 1);
    }).length;

    final isComplete = road.isNotEmpty && done == road.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isComplete ? 'أتممت أذكار طريقك' : 'محطّات الطريق',
          style: TextStyle(
            color: isComplete ? skin.accent : skin.ink,
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          isComplete
              ? 'صحبتك السلامة.'
              : 'كل ذكر في موضعه من الرحلة — افتح المحطّة التي أنت فيها.',
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.75),
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.caption});

  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 18.h, thickness: 1, color: skin.hairline),
        Text(
          title,
          style: TextStyle(
            color: skin.ink,
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          caption,
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.7),
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
