import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/sabih_state_views.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbeeh_analytics_header.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/tasbeeh/tasbeeh_carousel.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  @override
  void initState() {
    super.initState();
    // LoadAllSubihEvent يحمّل عدّاد اليوم تلقائيًا مع قائمة الأذكار.
    context.read<SabihBloc>().add(LoadAllSubihEvent());
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    // الصفحة سطح ورقي واحد: نوحّد أرضية الهيكل مع أرضية المحتوى حتى لا
    // ينكسر اللون بين الترويسة والجسد.
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        title: 'المسبحة',
        trailing: IconButton(
          tooltip: 'إضافة ذكر مخصص',
          onPressed: () => showDhikrSheet(context),
          icon: AppIcon(AppIcons.add, color: skin.accent, size: 18.sp),
        ),
        body: ColoredBox(
          color: skin.ground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TasbeehAnalyticsHeader(),
              skin.divider(),
              const HomeSectionHeader(title: 'ذكرك الآن'),
              BlocConsumer<SabihBloc, SabihState>(
                listenWhen: (previous, current) =>
                    previous.actionState != current.actionState,
                listener: (context, state) {
                  if (state.actionState == RequestState.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage ?? 'حدث خطأ')),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    previous.loadState != current.loadState ||
                    previous.subihList != current.subihList ||
                    previous.countsMap != current.countsMap,
                builder: (context, state) {
                  // الحالة الأولى والتحميل سواء: القائمة لم تصل بعد.
                  if (state.loadState == RequestState.initial ||
                      (state.loadState == RequestState.loading &&
                          state.subihList.isEmpty)) {
                    return const SabihLoading();
                  }

                  if (state.loadState == RequestState.error) {
                    return SabihNotice(
                      message: state.errorMessage ?? 'حدث خطأ',
                      actionLabel: 'إعادة المحاولة',
                      onAction: () {
                        context.read<SabihBloc>().add(LoadAllSubihEvent());
                      },
                    );
                  }

                  if (state.subihList.isEmpty) {
                    return SabihNotice(
                      message: 'لم يتم العثور على عناصر ذكر',
                      actionLabel: 'أضف ذكرك الأول',
                      onAction: () => showDhikrSheet(context),
                    );
                  }

                  return TasbeehCarousel(state: state);
                },
              ),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }
}
