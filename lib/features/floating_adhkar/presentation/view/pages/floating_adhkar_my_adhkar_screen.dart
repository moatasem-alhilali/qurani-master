import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
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

  @override
  Widget build(BuildContext context) {
    final floatingBloc = context.read<FloatingAdhkarBloc>();

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
                child: const AppIcon(AppIcons.add, size: 15),
              ),
        body: BlocBuilder<SabihBloc, SabihState>(
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
                  return const Center(child: CircularProgressIndicator());
                }

                return Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _AdhkarTabs(
                        controller: _tabController,
                      ),
                      SizedBox(height: 10.h),
                      if (_showBuiltInTab)
                        _BuiltInTabContent(
                          items: builtInItems,
                          activeCount: activeBuiltInCount,
                          onToggleItem: (itemId, enabled) {
                            _setBuiltInItemEnabled(context, itemId, enabled);
                          },
                        )
                      else
                        _CustomTabContent(
                          items: customItems,
                          selectionMap: floatingState.customSelectionMap,
                          onAddItem: () => _showAddDialog(context),
                          onToggleItem: (itemId, enabled) {
                            _setCustomItemEnabled(context, itemId, enabled);
                          },
                          onEditItem: (item) => _showEditDialog(context, item),
                          onDeleteItem: (item) =>
                              _showDeleteDialog(context, item),
                        ),
                    ],
                  ),
                );
              },
            );
          },
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
    context.read<FloatingAdhkarBloc>().add(
          FloatingAdhkarSetCustomItemEnabledEvent(
            subihId: itemId,
            enabled: enabled,
          ),
        );
  }
}

class _AdhkarTabs extends StatelessWidget {
  const _AdhkarTabs({
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: context.outline.withValues(alpha: 0.22),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: TabBar(
          controller: controller,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(11.r),
          ),
          labelColor: context.onPrimaryColor,
          unselectedLabelColor: context.onSurfaceVariant,
          labelStyle: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
          ),
          tabs: const [
            Tab(text: 'الأذكار الافتراضية'),
            Tab(text: 'الأذكار الخاصة'),
          ],
        ),
      ),
    );
  }
}

class _BuiltInTabContent extends StatelessWidget {
  const _BuiltInTabContent({
    required this.items,
    required this.activeCount,
    required this.onToggleItem,
  });

  final List<FloatingAdhkarItem> items;
  final int activeCount;
  final void Function(String itemId, bool enabled) onToggleItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          title: 'الأذكار الافتراضية',
          subtitle: 'هذه أذكار التطبيق الجاهزة. يمكنك فقط تشغيل الذكر أو '
              'إيقاف ظهوره ضمن الأذكار العائمة.',
          countLabel: '$activeCount/${items.length}',
        ),
        SizedBox(height: 8.h),
        if (items.isEmpty)
          const _SectionEmptyCard(
            title: 'لا توجد أذكار افتراضية متاحة',
            subtitle:
                'لم يتم العثور على مكتبة الأذكار الافتراضية داخل التطبيق.',
          )
        else
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _BuiltInAdhkarCard(
                item: item,
                enabled: !item.isDeleted,
                onChanged: (value) => onToggleItem(item.id, value),
              ),
            ),
          ),
      ],
    );
  }
}

class _CustomTabContent extends StatelessWidget {
  const _CustomTabContent({
    required this.items,
    required this.selectionMap,
    required this.onAddItem,
    required this.onToggleItem,
    required this.onEditItem,
    required this.onDeleteItem,
  });

  final List<SubihModel> items;
  final Map<int, bool> selectionMap;
  final VoidCallback onAddItem;
  final void Function(int itemId, bool enabled) onToggleItem;
  final void Function(SubihModel item) onEditItem;
  final void Function(SubihModel item) onDeleteItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          title: 'الأذكار الخاصة',
          subtitle: 'هذه الأذكار التي يضيفها المستخدم ويمكنه تعديلها أو حذفها '
              'أو إيقافها من الظهور.',
          countLabel: '${items.length}',
        ),
        SizedBox(height: 8.h),
        if (items.isEmpty)
          _SectionEmptyCard(
            title: 'لا توجد أذكار خاصة بعد',
            subtitle: 'أضف ذكرك أو دعاءك الخاص ليصبح ضمن الدوران العشوائي '
                'العائم.',
            actionLabel: 'إضافة ذكر جديد',
            onAction: onAddItem,
          )
        else
          ...items.map(
            (item) {
              final itemId = item.id;
              final enabled = itemId != null && (selectionMap[itemId] ?? true);

              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _CustomAdhkarCard(
                  item: item,
                  enabled: enabled,
                  onChanged: itemId == null
                      ? null
                      : (value) => onToggleItem(itemId, value),
                  onEdit: () => onEditItem(item),
                  onDelete: itemId == null ? null : () => onDeleteItem(item),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.countLabel,
  });

  final String title;
  final String subtitle;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                style: TextStyle(
                  color: context.onSurfaceVariant,
                  fontSize: 10.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            countLabel,
            style: TextStyle(
              color: context.primaryColor,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionEmptyCard extends StatelessWidget {
  const _SectionEmptyCard({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.outline.withValues(alpha: 0.22),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                color: context.onSurfaceVariant,
                fontSize: 10.5.sp,
                height: 1.45,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 9.h),
              FilledButton.icon(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  minimumSize: Size.fromHeight(34.h),
                ),
                icon: const AppIcon(AppIcons.add, size: 12.5),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BuiltInAdhkarCard extends StatelessWidget {
  const _BuiltInAdhkarCard({
    required this.item,
    required this.enabled,
    this.onChanged,
  });

  final FloatingAdhkarItem item;
  final bool enabled;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final titleColor = enabled
        ? context.onSurfaceColor
        : context.onSurfaceVariant.withValues(alpha: 0.78);
    final bodyColor = enabled
        ? context.onSurfaceVariant
        : context.onSurfaceVariant.withValues(alpha: 0.70);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: enabled
              ? context.outline.withValues(alpha: 0.22)
              : context.outline.withValues(alpha: 0.32),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(11.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: enabled,
                  onChanged: onChanged,
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                _InfoChip(
                  label: item.sourceLabel,
                  backgroundColor: context.primaryColor.withValues(alpha: 0.08),
                  foregroundColor: context.primaryColor,
                ),
                _InfoChip(
                  label: enabled ? 'مفعّل' : 'موقوف',
                  backgroundColor: enabled
                      ? context.secondaryColor.withValues(alpha: 0.10)
                      : context.outline.withValues(alpha: 0.16),
                  foregroundColor: enabled
                      ? context.secondaryColor
                      : context.onSurfaceVariant,
                ),
              ],
            ),
            SizedBox(height: 7.h),
            Text(
              item.text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: bodyColor,
                fontSize: 10.5.sp,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 9.8.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CustomAdhkarCard extends StatelessWidget {
  const _CustomAdhkarCard({
    required this.item,
    required this.enabled,
    required this.onEdit,
    this.onChanged,
    this.onDelete,
  });

  final SubihModel item;
  final bool enabled;
  final ValueChanged<bool>? onChanged;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.outline.withValues(alpha: 0.22),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(11.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: context.onSurfaceColor,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: enabled,
                  onChanged: onChanged,
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              item.content,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.onSurfaceVariant,
                fontSize: 10.5.sp,
                height: 1.45,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                OutlinedButton.icon(
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, 32.h),
                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                  ),
                  icon: const AppIcon(AppIcons.edit, size: 12),
                  label: const Text('تعديل'),
                ),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, 32.h),
                    padding: EdgeInsets.symmetric(horizontal: 11.w),
                  ),
                  icon: const AppIcon(AppIcons.delete, size: 12),
                  label: const Text('حذف'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
