import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/components/quran_widgets/enhanced_spiritual_loading_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/my_adia/presentation/view/widget/my_dhikr_card_widget.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';

class MuDoaScreen extends StatefulWidget {
  const MuDoaScreen({
    super.key,
  });

  @override
  State<MuDoaScreen> createState() => _MuDoaScreenState();
}

class _MuDoaScreenState extends State<MuDoaScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SabihBloc>().add(LoadAllSubihEvent());
    _loadTodayCounts();
  }

  void _loadTodayCounts() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    context.read<SabihBloc>().add(
          GetCountsForPeriodEvent(
            from: today,
            to: now,
            periodType: PeriodType.today,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BaseHomeWidget(
      title: 'أدعيتي',
      isScroll: false,
      body: BlocConsumer<SabihBloc, SabihState>(
        listenWhen: (previous, current) =>
            previous.actionState != current.actionState,
        listener: (context, state) {
          if (state.actionState == RequestState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'حدث خطأ'),
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.loadState != current.loadState,
        builder: (context, state) {
          if (state.loadState == LoadState.initial) {
            return Column(
              children: [
                const EnhancedSpiritualLoadingWidget(
                  showText: false,
                  size: 250,
                  // showParticles: false,
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    'ابدأ رحلة ذكرك',
                    style: context.titleMedium.copyWith(
                      color: context.gray1,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            );
          }

          if (state.loadState == LoadState.loading && state.subihList.isEmpty) {
            return Column(
              children: [
                const EnhancedSpiritualLoadingWidget(
                  showText: false,
                  size: 250,
                  // showParticles: false,
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    'جاري تحميل ...',
                    style: context.titleMedium.copyWith(
                      color: context.gray1,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            );
          }

          if (state.loadState == LoadState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EnhancedSpiritualLoadingWidget(
                    showText: false,
                    size: 250,
                    // showParticles: false,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SabihBloc>().add(LoadAllSubihEvent());
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          final subihList = state.subihList.where((e) => e.isCustom).toList();
          // log('subihList: ${subihList.length}');

          if (subihList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EnhancedSpiritualLoadingWidget(
                    showText: false,
                    size: 250,
                    // showParticles: false,
                  ),
                  Center(
                    child: Text(
                      'لا يوجد أدعية مخصصة',
                      style: context.titleMedium.copyWith(
                        color: context.gray1,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: subihList.length,
            // shrinkWrap: true,
            itemBuilder: (context, index) {
              final subih = subihList[index];
              final count = state.getCountForSubih(subih.id ?? -1);
              return MyDhikrCardWidget(
                subih: subih,
                count: count,
                onTap: () {
                  if (subih.id != null) {
                    context.read<SabihBloc>().add(
                          PerformSubihTapEvent(subihId: subih.id!),
                        );
                  }
                },
                onReset: () {
                  if (subih.id != null) {
                    context.read<SabihBloc>().add(
                          ResetTodayCounterEvent(
                            subihId: subih.id!,
                          ),
                        );
                  }
                },
                onEdit: subih.isCustom
                    ? () {
                        _showEditDhikrDialog(subih);
                      }
                    : null,
                onDelete: subih.isCustom
                    ? () {
                        _showDeleteConfirmation(subih);
                      }
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: BlocBuilder<SabihBloc, SabihState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: _showAddDhikrDialog,
            tooltip: 'إضافة أدعية مخصصة',
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  void _showAddDhikrDialog() {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: const AddDhikrDialog(),
      ),
      title: 'إضافة أدعية مخصصة',
      subtitle: 'أدعية مخصصة هي أدعية يمكنك إضافتها لتصبح أدعيتك الأولى',
      // backgroundColor: context.scaffoldBackgroundColor,
    );
  }

  void _showEditDhikrDialog(SubihModel subih) {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: AddDhikrDialog(subihToEdit: subih),
      ),
      title: 'تعديل أدعية مخصصة',
      subtitle: 'أدعية مخصصة هي أدعية يمكنك إضافتها لتصبح أدعيتك الأولى',
      // backgroundColor: context.scaffoldBackgroundColor,
    );
  }

  Future<void> _showDeleteConfirmation(SubihModel subih) async {
    final result = await showDeleteConfirmationDialog<bool>(
      context,
    );

    if (result != null && result == true) {
      if (subih.id != null) {
        final request = SubihRequest.fromModel(subih);
        if (context.mounted) {
          context.read<SabihBloc>().add(DeleteSubihEvent(request: request));
        }
      }
    }
  }
}
