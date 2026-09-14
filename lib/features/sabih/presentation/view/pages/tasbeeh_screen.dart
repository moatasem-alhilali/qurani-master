import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/service/tasbih_preferences.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/sabih_state_views.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbeeh_analytics_header.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbeeh_stage.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbih_settings_sheet.dart';

/// شاشة المسبحة.
///
/// التخطيط: شريط أذكار في الأعلى، ثم الذكر المختار كبيرًا، ثم السبحة،
/// ثم العدّاد. المساحة كلها منطقة لمس — فلا يلاحق الإصبعُ زرًّا صغيرًا.
class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    TasbihPreferences.instance.load();
    // LoadAllSubihEvent يحمّل عدّاد اليوم تلقائيًا مع قائمة الأذكار.
    context.read<SabihBloc>().add(LoadAllSubihEvent());
  }

  SubihModel? _current(List<SubihModel> items) {
    if (items.isEmpty) return null;
    final index = _selected.clamp(0, items.length - 1);
    return items[index];
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    // الصفحة سطح ورقي واحد: نوحّد أرضية الهيكل مع أرضية المحتوى حتى لا
    // ينكسر اللون بين الترويسة والجسد.
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: BlocConsumer<SabihBloc, SabihState>(
        listenWhen: (previous, current) =>
            previous.actionState != current.actionState,
        listener: (context, state) {
          if (state.actionState == RequestState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'حدث خطأ')),
            );
          }
        },
        builder: (context, state) {
          final current = _current(state.subihList);

          return AppScaffoldWidget(
            title: 'المسبحة',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (current != null)
                  IconButton(
                    tooltip: 'إعدادات الذكر',
                    onPressed: () => showTasbihSettingsSheet(
                      context,
                      subih: current,
                      count: state.getCountForSubih(current.id ?? -1),
                    ),
                    icon: AppIcon(
                      AppIcons.sliders,
                      color: skin.accent,
                      size: 18.sp,
                    ),
                  ),
                IconButton(
                  tooltip: 'إضافة ذكر مخصص',
                  onPressed: () => showDhikrSheet(context),
                  icon: AppIcon(AppIcons.add, color: skin.accent, size: 18.sp),
                ),
              ],
            ),
            body: ColoredBox(
              color: skin.ground,
              child: _buildBody(context, state, current),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SabihState state,
    SubihModel? current,
  ) {
    // الحالة الأولى والتحميل سواء: القائمة لم تصل بعد.
    if (state.loadState == RequestState.initial ||
        (state.loadState == RequestState.loading && state.subihList.isEmpty)) {
      return const SabihLoading();
    }

    if (state.loadState == RequestState.error) {
      return SabihNotice(
        message: state.errorMessage ?? 'حدث خطأ',
        actionLabel: 'إعادة المحاولة',
        onAction: () => context.read<SabihBloc>().add(LoadAllSubihEvent()),
      );
    }

    if (current == null) {
      return SabihNotice(
        message: 'لم يتم العثور على عناصر ذكر',
        actionLabel: 'أضف ذكرك الأول',
        onAction: () => showDhikrSheet(context),
      );
    }

    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TasbeehAnalyticsHeader(),
        skin.divider(),
        SizedBox(height: 10.h),
        TasbeehDhikrStrip(
          items: state.subihList,
          selectedIndex: _selected.clamp(0, state.subihList.length - 1),
          onSelected: (index) => setState(() => _selected = index),
        ),
        // بلا Expanded: جسد AppScaffoldWidget يُلفّ في SliverToBoxAdapter
        // فارتفاعه غير محدود، وأي flex داخله يرمي استثناء تخطيط.
        // التمرير يتكفّل به السliver نفسه.
        TasbeehStage(
          // المفتاح يجعل حالة السلسلة تُبنى من جديد عند تبديل الذكر،
          // فلا تنزلق الخرزات انزلاقًا كاذبًا بسبب اختلاف العدّادين.
          key: ValueKey(current.id),
          subih: current,
          count: state.getCountForSubih(current.id ?? -1),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
