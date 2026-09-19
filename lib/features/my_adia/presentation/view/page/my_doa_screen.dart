import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/my_adia/presentation/view/widget/my_dhikr_card_widget.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/library_screen_kit.dart';
import 'package:quran_app/l10n/l10n.dart';

/// أدعيتي: أدعية أضافها المستخدم بنفسه، ولكلٍّ عدّاد ترديد لليوم.
///
/// كانت كل دعوة بطاقة فيها شارة عدد وزرّ «تسبيح» منفصل. الآن الصفّ نفسه
/// هو الزرّ، والعدّاد يمتلئ ذهبًا مع كل لمسة.
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
    final skin = AppSkin.of(context);

    return GroundScaffoldTheme(
      child: AppScaffoldWidget(
        title: context.l10n.myDuasTitle,
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
                    content: Text(
                      state.errorMessage ?? context.l10n.myDuasActionFailed,
                    ),
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
                      child: _emptyState(
                        title: context.l10n.myDuasEmptyCustomTitle,
                        message: context.l10n.myDuasEmptyCustomMessage,
                      ),
                    );
                  }

                  final totalCountToday = displayItems.fold<int>(
                    0,
                    (sum, item) => sum + state.getCountForSubih(item.id ?? -1),
                  );

                  return librarySliverGround(
                    context,
                    sliver: SliverList.builder(
                      itemCount: displayItems.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _SummaryStrip(
                            totalItems: displayItems.length,
                            totalToday: totalCountToday,
                          );
                        }

                        final subih = displayItems[index - 1];
                        final count = state.getCountForSubih(subih.id ?? -1);

                        return MyDhikrCardWidget(
                          subih: subih,
                          count: count,
                          isLast: index == displayItems.length,
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
                              ? () => _showEditDhikrDialog(subih)
                              : null,
                          onDelete: subih.isCustom
                              ? () => _showDeleteConfirmation(subih)
                              : null,
                        );
                      },
                    ),
                  );
                },
                sliverList: state.subihList,
                context: context,
                onEmptyList: SliverFillRemaining(
                  hasScrollBody: false,
                  child: _emptyState(
                    title: context.l10n.myDuasEmptyTitle,
                    message: context.l10n.myDuasEmptyMessage,
                  ),
                ),
              );
            },
          ),
        ],
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddDhikrDialog,
          tooltip: context.l10n.myDuasAddNew,
          backgroundColor: AppColors.gold,
          foregroundColor:
              skin.isDark ? AppColors.brandNight : AppColors.brandIvory,
          child: AppIcon(
            AppIcons.add,
            color: skin.isDark ? AppColors.brandNight : AppColors.brandIvory,
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _emptyState({required String title, required String message}) {
    return LibraryEmptyState(
      title: title,
      message: message,
      icon: AppIcons.dailyWird,
      actionLabel: context.l10n.myDuasAdd,
      onAction: _showAddDhikrDialog,
    );
  }

  void _showAddDhikrDialog() {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: const AddDhikrDialog(),
      ),
      title: context.l10n.myDuasAddNew,
      subtitle: context.l10n.myDuasAddSubtitle,
    );
  }

  void _showEditDhikrDialog(SubihModel subih) {
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: AddDhikrDialog(subihToEdit: subih),
      ),
      title: context.l10n.myDuasEditTitle,
      subtitle: context.l10n.myDuasEditSubtitle,
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

/// شريط ملخّص اليوم: رقمان على الأرضية مباشرة، بلا بطاقة.
class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.totalItems,
    required this.totalToday,
  });

  final int totalItems;
  final int totalToday;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 10.h),
          child: Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: context.l10n.myDuasCountLabel,
                  value: '$totalItems',
                ),
              ),
              Container(width: 1, height: 22.h, color: skin.hairline),
              Expanded(
                child: _SummaryStat(
                  label: context.l10n.myDuasTodayLabel,
                  value: '$totalToday',
                ),
              ),
            ],
          ),
        ),
        skin.divider(),
      ],
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: skin.accent,
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.78),
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
