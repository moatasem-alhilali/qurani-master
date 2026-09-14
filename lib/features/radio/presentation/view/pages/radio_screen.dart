import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/data/service/radio_favourites_store.dart';
import 'package:quran_app/features/radio/data/service/radio_sleep_timer.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/radio_stations_loading_view.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_favourites_strip.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_search_field.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_sleep_chip.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_tile.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/tuner/radio_tuner.dart';

/// صفحة الإذاعة.
///
/// القائمة والقرص **أداةٌ واحدة**: النقر على أي صفّ يُدير القرص إليه، فيبقى
/// للمستخدم إحساسٌ واحد بالمكان بدل واجهتين منفصلتين. وهذا ما يجعل التصفّح
/// السريع (القرص) والوصول المباشر (البحث والقائمة) يعيشان معًا بلا تعارض.
class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  /// أقلّ من نصف العرض: تظهر المحطتان المجاورتان على الجانبين، فيُفهم أن
  /// القرص يمتدّ خارج الشاشة ويُدعى المستخدم للسحب.
  static const _viewport = 0.44;

  final PageController _dial = PageController(viewportFraction: _viewport);
  final ValueNotifier<String> _query = ValueNotifier('');

  final RadioFavouritesStore _favourites = sl<RadioFavouritesStore>();
  final RadioSleepTimer _sleepTimer = sl<RadioSleepTimer>();

  /// القرص يُضبط على المحطة المحفوظة مرّة واحدة بعد أوّل تحميل.
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _favourites.hydrate();
  }

  @override
  void dispose() {
    _dial.dispose();
    _query.dispose();
    super.dispose();
  }

  void _seedDial(int index) {
    if (_seeded || index <= 0) return;
    _seeded = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_dial.hasClients) return;
      _dial.jumpToPage(index);
    });
  }

  /// نقرة على صفّ أو على مفضّلة: يُشغَّل فورًا ويلحق القرص.
  ///
  /// لو تُرك الأمر لاستقرار القرص وحده لتأخّر الصوت قرابة ثانية بين زمن
  /// الحركة ومهلة الاستقرار.
  void _selectStation(List<RadioStationModel> stations, int index) {
    if (index < 0 || index >= stations.length) return;
    HapticFeedback.selectionClick();

    context.read<RadioBloc>().add(RadioStationPlayRequested(stations[index]));
    if (!_dial.hasClients) return;

    // القفزة البعيدة تُقطع: تحريك عشرين صفحة بحركة واحدة يمرّ بكل الأغلفة
    // بينهما فيبدو ارتجافًا.
    final from = tunerPosition(_dial, index).round();
    if ((from - index).abs() > 4) {
      _dial.jumpToPage(index);
      return;
    }
    _dial.animateToPage(
      index,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        title: 'الإذاعة',
        initialOffset: 0,
        body: ColoredBox(
          color: skin.ground,
          child: BlocConsumer<RadioBloc, RadioState>(
            // المقارنة على العدّاد لا على النصّ: الخطأ نفسه مرّتين يجب أن
            // يظهر مرّتين.
            listenWhen: (previous, current) =>
                previous.errorTick != current.errorTick &&
                current.errorMessage != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
            },
            builder: (context, state) {
              if (state.loadState == RequestState.loading &&
                  state.stations.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: const RadioStationsLoadingView(),
                );
              }

              final stations = state.stations;
              if (stations.isEmpty) return SizedBox(height: 200.h);

              _seedDial(state.currentIndex);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 4.h),
                  RadioTuner(
                    controller: _dial,
                    stations: stations,
                    currentIndex: state.currentIndex,
                    isPowered: state.isPowered,
                    isPlaying: state.isPlaying,
                    isLoading: state.isLoadingPlayback,
                    leading: RadioSleepChip(timer: _sleepTimer),
                    trailing: RadioFavouriteButton(
                      favourites: _favourites,
                      station: state.currentStation,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  skin.divider(),
                  RadioFavouritesStrip(
                    favourites: _favourites,
                    stations: stations,
                    currentId: state.currentStation?.id,
                    onSelect: (station) => _selectStation(
                      stations,
                      stations.indexWhere((s) => s.id == station.id),
                    ),
                  ),
                  RadioSearchField(query: _query),
                  ValueListenableBuilder<String>(
                    valueListenable: _query,
                    builder: (context, query, _) => _StationSections(
                      state: state,
                      query: query,
                      favourites: _favourites,
                      onSelect: (station) => _selectStation(
                        stations,
                        stations.indexWhere((s) => s.id == station.id),
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// القائمة مقسومة على نوعها، ومصفّاة بالبحث.
class _StationSections extends StatelessWidget {
  const _StationSections({
    required this.state,
    required this.query,
    required this.favourites,
    required this.onSelect,
  });

  final RadioState state;
  final String query;
  final RadioFavouritesStore favourites;
  final ValueChanged<RadioStationModel> onSelect;

  List<RadioStationModel> _filter(List<RadioStationModel> source) {
    final needle = query.trim();
    if (needle.isEmpty) return source;
    // البحث على الاسم الكامل والمختصر معًا: من يكتب «إذاعة» يجد، ومن يكتب
    // اسم القارئ وحده يجد.
    return source
        .where(
          (station) =>
              station.name.contains(needle) ||
              station.shortName.contains(needle),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final reciters = _filter(state.reciters);
    final programs = _filter(state.programs);

    if (reciters.isEmpty && programs.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 26.h),
        child: Text(
          'لا توجد محطة بهذا الاسم.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.78),
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _group(RadioStationKind.reciter.label, reciters),
        _group(RadioStationKind.program.label, programs),
      ],
    );
  }

  Widget _group(String title, List<RadioStationModel> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        HomeSectionHeader(title: title),
        for (var i = 0; i < items.length; i++)
          RadioStationTile(
            station: items[i],
            isCurrent: state.currentStation?.id == items[i].id,
            isPlayingCurrent:
                state.currentStation?.id == items[i].id && state.isPlaying,
            favourites: favourites,
            showDivider: i != items.length - 1,
            onTap: () => onSelect(items[i]),
          ),
      ],
    );
  }
}
