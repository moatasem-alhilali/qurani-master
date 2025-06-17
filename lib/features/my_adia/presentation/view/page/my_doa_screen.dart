import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/bottom_sheet/extension_sheet.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
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
    return BaseHome(
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
            previous.loadState != current.loadState ||
            previous.subihList != current.subihList ||
            previous.countsMap != current.countsMap,
        builder: (context, state) {
          if (state.loadState == LoadState.initial) {
            return const Center(child: Text('ابدأ رحلة ذكرك'));
          }

          if (state.loadState == LoadState.loading && state.subihList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.loadState == LoadState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'حدث خطأ'),
                  const SizedBox(height: 16),
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

          if (state.subihList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('لم يتم العثور على عناصر أدعيتي'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showAddDhikrDialog,
                    child: const Text('أضف أدعيتك الأول'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: state.subihList.length,
            // shrinkWrap: true,
            itemBuilder: (context, index) {
              final subih = state.subihList[index];
              final count = state.getCountForSubih(subih.id ?? -1);
              if (!subih.isCustom) return const SizedBox();
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDhikrDialog,
        tooltip: 'إضافة أدعية مخصصة',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDhikrDialog() {
    context.showSmoothSheetStyle(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: const AddDhikrDialog(),
      ),
      title: 'إضافة أدعية مخصصة',
      backgroundColor: context.scaffoldBackgroundColor,
    );
  }

  void _showEditDhikrDialog(SubihModel subih) {
    context.showSmoothSheetStyle(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: AddDhikrDialog(subihToEdit: subih),
      ),
      title: 'تعديل أدعية مخصصة',
      backgroundColor: context.scaffoldBackgroundColor,
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
