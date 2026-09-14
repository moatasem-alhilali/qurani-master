import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/presentation/bloc/floating_adhkar_bloc.dart';
import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/remote/sabih_repository_imp.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/library_screen_kit.dart';
import 'package:quran_app/gen/fonts.gen.dart';

part 'floating_adhkar_my_adhkar_screen_tabs_part.dart';
part 'floating_adhkar_my_adhkar_screen_lists_part.dart';
part 'floating_adhkar_my_adhkar_screen_manage_part.dart';

/// إدارة الأذكار العائمة: ما يظهر من الافتراضي، وما أضافه المستخدم.
///
/// كانت كل قائمة بطاقات بحدود وشارات؛ صارت صفوفًا نحيلة بمفتاح واحد في
/// طرف كل صفّ، والتبويب شريطًا بخطّ ذهبي تحت الاسم بدل صندوق مظلّل.
class FloatingAdhkarMyAdhkarScreen extends StatelessWidget {
  const FloatingAdhkarMyAdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SabihBloc>(
      create: (_) => SabihBloc(
        repository: SabihRepositoryImpl(
          sabihService: DatabaseSabihService(),
        ),
      )..add(LoadAllSubihEvent()),
      child: const _FloatingAdhkarMyAdhkarView(),
    );
  }
}

class _FloatingAdhkarMyAdhkarView extends StatefulWidget {
  const _FloatingAdhkarMyAdhkarView();

  @override
  State<_FloatingAdhkarMyAdhkarView> createState() =>
      _FloatingAdhkarMyAdhkarViewState();
}

class _FloatingAdhkarMyAdhkarViewState
    extends State<_FloatingAdhkarMyAdhkarView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool get _showBuiltInTab => _tabController.index == 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChanged)
      ..dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (!_tabController.indexIsChanging && mounted) {
      setState(() {});
    }
  }

  void _selectTab(int index) {
    if (_tabController.index == index) return;
    unawaited(HapticFeedback.selectionClick());
    _tabController.animateTo(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final floatingBloc = context.read<FloatingAdhkarBloc>();
    final skin = AppSkin.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<SabihBloc, SabihState>(
          listenWhen: (previous, current) =>
              previous.actionState != current.actionState,
          listener: (context, state) {
            if (state.actionState == RequestState.success ||
                state.actionState == RequestState.error) {
              floatingBloc.add(const FloatingAdhkarLoadEvent());
            }
          },
        ),
        BlocListener<FloatingAdhkarBloc, FloatingAdhkarState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null,
          listener: (context, state) {
            final message = state.errorMessage;
            if (message == null || message.trim().isEmpty) {
              return;
            }

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
        ),
      ],
      child: GroundScaffoldTheme(
        child: AppScaffoldWidget(
          title: 'إدارة الأذكار',
          showLargeHeader: false,
          initialOffset: null,
          onRefresh: () async {
            context.read<SabihBloc>().add(RefreshAllSubihEvent());
            floatingBloc.add(const FloatingAdhkarLoadEvent());
          },
          floatingActionButton: _showBuiltInTab
              ? null
              : FloatingActionButton(
                  onPressed: () => _showAddDialog(context),
                  tooltip: 'إضافة ذكر خاص',
                  backgroundColor: AppColors.gold,
                  child: AppIcon(
                    AppIcons.add,
                    color: skin.isDark
                        ? AppColors.brandNight
                        : AppColors.brandIvory,
                    size: 18.sp,
                  ),
                ),
          body: ColoredBox(
            color: skin.ground,
            child: BlocBuilder<SabihBloc, SabihState>(
              builder: (context, sabihState) {
                return BlocBuilder<FloatingAdhkarBloc, FloatingAdhkarState>(
                  builder: (context, floatingState) {
                    final customItems = sabihState.subihList
                        .where((item) => item.isCustom)
                        .toList();
                    final builtInItems =
                        List<FloatingAdhkarItem>.of(floatingState.builtInItems)
                          ..sort((first, second) {
                            if (first.isDeleted == second.isDeleted) {
                              return first.title.compareTo(second.title);
                            }
                            return first.isDeleted ? 1 : -1;
                          });
                    final activeBuiltInCount =
                        builtInItems.where((item) => !item.isDeleted).length;

                    final isLoadingBuiltIn =
                        floatingState.loadState == RequestState.loading &&
                            builtInItems.isEmpty;
                    final isLoadingCustom =
                        sabihState.loadState == RequestState.loading &&
                            customItems.isEmpty;

                    if (isLoadingBuiltIn || isLoadingCustom) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 60.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.gold),
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TabStrip(
                          activeIndex: _tabController.index,
                          builtInLabel:
                              '$activeBuiltInCount من ${builtInItems.length}',
                          customLabel: '${customItems.length}',
                          onSelect: _selectTab,
                        ),
                        if (_showBuiltInTab)
                          _BuiltInList(
                            items: builtInItems,
                            onToggleItem: (itemId, enabled) {
                              _setBuiltInItemEnabled(context, itemId, enabled);
                            },
                          )
                        else
                          _CustomList(
                            items: customItems,
                            selectionMap: floatingState.customSelectionMap,
                            onAddItem: () => _showAddDialog(context),
                            onToggleItem: (itemId, enabled) {
                              _setCustomItemEnabled(context, itemId, enabled);
                            },
                            onEditItem: (item) =>
                                _showEditDialog(context, item),
                            onDeleteItem: (item) =>
                                _showDeleteDialog(context, item),
                          ),
                        SizedBox(height: 26.h),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: const AddDhikrDialog(),
      ),
      title: 'إضافة ذكر مخصص',
      subtitle: 'سيصبح متاحًا ضمن الأذكار العائمة عند تفعيله.',
    );
  }

  void _showEditDialog(BuildContext context, SubihModel item) {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: AddDhikrDialog(subihToEdit: item),
      ),
      title: 'تعديل الذكر',
      subtitle: 'حدّث النص ثم احفظ التغييرات مباشرة.',
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, SubihModel item) async {
    final result = await showDeleteConfirmationDialog<bool>(context);
    if (result != true || item.id == null || !context.mounted) {
      return;
    }

    context.read<SabihBloc>().add(
          DeleteSubihEvent(
            request: SubihRequest.fromModel(item),
          ),
        );
  }

  void _setBuiltInItemEnabled(
    BuildContext context,
    String itemId,
    bool enabled,
  ) {
    unawaited(HapticFeedback.selectionClick());
    context.read<FloatingAdhkarBloc>().add(
          FloatingAdhkarSetBuiltInItemEnabledEvent(
            itemId: itemId,
            enabled: enabled,
          ),
        );
  }

  void _setCustomItemEnabled(
    BuildContext context,
    int itemId,
    bool enabled,
  ) {
    unawaited(HapticFeedback.selectionClick());
    context.read<FloatingAdhkarBloc>().add(
          FloatingAdhkarSetCustomItemEnabledEvent(
            subihId: itemId,
            enabled: enabled,
          ),
        );
  }
}
