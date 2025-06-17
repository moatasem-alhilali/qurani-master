import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/bottom_sheet/extension_sheet.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/pages/analytics_screen.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/dhikr_card.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({
    required this.isLoading,
    super.key,
  });

  final bool isLoading;
  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      title: 'المسبحة (الذكر)',
      leading: IconButton(
        onPressed: () {
          context.push(
            BlocProvider.value(
              value: context.read<SabihBloc>(),
              child: const AnalyticsScreen(),
            ),
          );
        },
        icon: const Icon(Icons.analytics_outlined),
      ),
      isScroll: !widget.isLoading,
      body: widget.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'جاري تحميل الذكر',
                    style: titleMedium(context).copyWith(
                      color: FxColors.gray1,
                    ),
                  ),
                ],
              ),
            )
          : BlocConsumer<SabihBloc, SabihState>(
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

                if (state.loadState == LoadState.loading &&
                    state.subihList.isEmpty) {
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
                        const Text('لم يتم العثور على عناصر ذكر'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _showAddDhikrDialog,
                          child: const Text('أضف ذكرك الأول'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < state.subihList.length; i++)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 8,
                              width: i == _currentPage ? 24 : 8,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: i == _currentPage
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.getHight(60),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: state.subihList.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                          final subih = state.subihList[index];
                          if (subih.id != null) {
                            context.read<SabihBloc>().add(
                                  GetCountsForPeriodEvent(
                                    from: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                    ),
                                    to: DateTime.now(),
                                    periodType: PeriodType.today,
                                  ),
                                );
                          }
                        },
                        itemBuilder: (context, index) {
                          final subih = state.subihList[index];
                          final count = state.getCountForSubih(subih.id ?? -1);

                          return DhikrCardWidget(
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
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDhikrDialog,
        tooltip: 'إضافة ذكر مخصص',
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
      title: 'إضافة ذكر مخصص',
      backgroundColor: FxColors.background,
    );
  }

  void _showEditDhikrDialog(SubihModel subih) {
    context.showSmoothSheetStyle(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: AddDhikrDialog(subihToEdit: subih),
      ),
      title: 'تعديل الذكر',
      backgroundColor: FxColors.background,
    );
  }

  Future<void> _showDeleteConfirmation(SubihModel subih) async {
    final result = await showDeleteConfirmationDialog<bool>(
      context,
    );

    if (result == true) {
      if (subih.id != null) {
        final request = SubihRequest.fromModel(subih);
        if (context.mounted) {
          context.read<SabihBloc>().add(DeleteSubihEvent(request: request));
        }
      }
    }
  }
}
