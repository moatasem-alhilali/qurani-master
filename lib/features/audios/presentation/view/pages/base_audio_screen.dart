import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/audios/data/remote/base_audio_repository_imp.dart';
import 'package:quran_app/features/audios/presentation/bloc/base_audio_bloc.dart';
import 'package:quran_app/features/audios/presentation/view/pages/base_audio_deatil.dart';
import 'package:quran_app/features/audios/presentation/view/widgets/audio_row.dart';
import 'package:quran_app/features/audios/presentation/view/widgets/audio_search_field.dart';
import 'package:quran_app/l10n/l10n.dart';

/// قائمة القرّاء أو السلاسل الصوتية.
///
/// كانت كل سلسلة بطاقة بارتفاع ١٠٠ وشكل عشوائي يتغيّر مع كل إعادة بناء —
/// فتقفز الأشكال أمام العين. صارت صفوفًا نحيلة متساوية تفصلها شعرة.
class BaseAudioScreen extends StatefulWidget {
  const BaseAudioScreen({required this.id, required this.title, super.key});

  final String id;
  final String title;

  @override
  State<BaseAudioScreen> createState() => _BaseAudioScreenState();
}

class _BaseAudioScreenState extends State<BaseAudioScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<dynamic> _filtered(List<dynamic> data) {
    if (_query.isEmpty) {
      return data;
    }
    final needle = _query.toLowerCase();
    return data.where((item) {
      return audioFieldOf(item, 'title').toLowerCase().contains(needle);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (context) => BaseAudioBloc(
        repositoryImpl: sl.get<BaseAudioRepositoryImpl>(),
      )..add(GetBaseAudioEvent(widget.id)),
      // أرضية «طمأنينة» تغطّي الرأس والمحتوى معًا.
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: BlocBuilder<BaseAudioBloc, BaseAudioState>(
          builder: (context, state) {
            final items = _filtered(state.baseAudio);

            return AppScaffoldWidget(
              title: widget.title,
              slivers: [
                SliverToBoxAdapter(
                  child: AudioSearchField(
                    controller: _search,
                    hintText: context.l10n.audiosSearchSeriesHint,
                    onChanged: (text) => setState(() => _query = text),
                  ),
                ),
                state.famousBaseAudioState.whenSliver<dynamic>(
                  sliverList: items,
                  onEmptyList: _EmptyNote(query: _query),
                  onSuccess: () => SliverList.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return AudioRow(
                        title: audioFieldOf(item, 'title'),
                        subtitle: context.l10n.audiosSeriesSubtitle,
                        icon: AppIcons.sound,
                        isLast: index == items.length - 1,
                        onTap: () => context.push(BaseAudioDetail(data: item)),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 18.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// سطر واحد عند خلوّ النتيجة — لا رسم كبير ولا بطاقة.
class _EmptyNote extends StatelessWidget {
  const _EmptyNote({required this.query});

  final String query;

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
              query.isEmpty
                  ? context.l10n.audiosNoSeries
                  : context.l10n.audiosNoResults,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
