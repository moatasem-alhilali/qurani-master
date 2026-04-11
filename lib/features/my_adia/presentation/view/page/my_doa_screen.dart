import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/my_adia/presentation/view/widget/my_dhikr_card_widget.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';

class MuDoaScreen extends StatefulWidget {
  const MuDoaScreen({super.key});

  @override
  State<MuDoaScreen> createState() => _MuDoaScreenState();
}

class _MuDoaScreenState extends State<MuDoaScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SabihBloc>().add(LoadAllSubihEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'أدعيتي',
      onRefresh: () async {
        context.read<SabihBloc>().add(RefreshAllSubihEvent());
      },
      slivers: [
        BlocConsumer<SabihBloc, SabihState>(
          listenWhen: (previous, current) =>
              previous.actionState != current.actionState,
          listener: (context, state) {
            if (state.actionState == RequestState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'تعذر تنفيذ العملية.'),
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              previous.loadState != current.loadState ||
              previous.subihList != current.subihList ||
              previous.countsMap != current.countsMap ||
              previous.actionState != current.actionState,
          builder: (context, state) {
            return state.loadState.whenSliver<SubihModel>(
              onSuccess: () {
                final displayItems = state.subihList
                    .where((element) => element.isCustom)
                    .toList();

                if (displayItems.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 56,
                              color: context.primaryColor,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد أدعية مضافة',
                              style: context.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'هذا القسم يعرض الأدعية التي أضفتها فقط.',
                              textAlign: TextAlign.center,
                              style: context.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: _showAddDhikrDialog,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('إضافة دعاء'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final totalCountToday = displayItems.fold<int>(
                  0,
                  (sum, item) => sum + state.getCountForSubih(item.id ?? -1),
                );

                return SliverList.builder(
                  itemCount: displayItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _SummaryHeader(
                        totalItems: displayItems.length,
                        totalToday: totalCountToday,
                      );
                    }

                    final subih = displayItems[index - 1];
                    final count = state.getCountForSubih(subih.id ?? -1);

                    return MyDhikrCardWidget(
                      subih: subih,
                      count: count,
                      onTap: () {
                        final subihId = subih.id;
                        if (subihId == null) return;

                        context.read<SabihBloc>().add(
                              PerformSubihTapEvent(subihId: subihId),
                            );
                      },
                      onReset: () {
                        final subihId = subih.id;
                        if (subihId == null) return;

                        context.read<SabihBloc>().add(
                              ResetTodayCounterEvent(subihId: subihId),
                            );
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
              sliverList: state.subihList,
              context: context,
              onEmptyList: SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 56,
                          color: context.primaryColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد أدعية بعد',
                          style: context.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'أضف دعاءك الأول وسيظهر هنا مباشرة.',
                          textAlign: TextAlign.center,
                          style: context.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _showAddDhikrDialog,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('إضافة دعاء'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDhikrDialog,
        // label: const Text('إضافة دعاء'),
        tooltip: 'إضافة دعاء جديد',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _showAddDhikrDialog() {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: const AddDhikrDialog(),
      ),
      title: 'إضافة دعاء جديد',
      subtitle: 'اكتب الدعاء ليظهر ضمن أدعيتك الخاصة.',
    );
  }

  void _showEditDhikrDialog(SubihModel subih) {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: AddDhikrDialog(subihToEdit: subih),
      ),
      title: 'تعديل الدعاء',
      subtitle: 'يمكنك تعديل النص أو الوصف وحفظ التغييرات مباشرة.',
    );
  }

  Future<void> _showDeleteConfirmation(SubihModel subih) async {
    final sabihBloc = context.read<SabihBloc>();
    final result = await showDeleteConfirmationDialog<bool>(context);

    if (!mounted || result != true || subih.id == null) {
      return;
    }

    sabihBloc.add(
      DeleteSubihEvent(
        request: SubihRequest.fromModel(subih),
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({
    required this.totalItems,
    required this.totalToday,
  });

  final int totalItems;
  final int totalToday;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ملخص اليوم',
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(
                title: 'عدد الأدعية',
                value: '$totalItems',
              ),
              _StatChip(
                title: 'مرات الترديد',
                value: '$totalToday',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$title: ',
              style: context.labelMedium?.copyWith(
                color: context.primaryColor,
              ),
            ),
            Text(
              value,
              style: context.labelLarge?.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
