import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_sliver_widget.dart';
import 'package:quran_app/features/download/presentation/bloc/download_bloc.dart';
import 'package:quran_app/features/download/presentation/view/widgets/add_download_widget.dart';
import 'package:quran_app/features/download/presentation/view/widgets/download_item_widget.dart';
import 'package:quran_app/l10n/l10n.dart';

/// شاشة التنزيلات.
///
/// كان فوق القائمة شريط تبويبات بخمس أيقونات ملوّنة، وتحته بطاقة لكل مهمّة.
/// صار الشريط أسماءً صغيرة يعلّمها خطّ ذهبي، والمهامّ صفوفًا نحيلة.
class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (context) => DownloadBloc()..add(LoadDownloadTasksEvent()),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: BlocBuilder<DownloadBloc, DownloadState>(
          buildWhen: (prev, curr) => prev.loadState != curr.loadState,
          builder: (context, state) {
            return AppScaffoldWidget(
              title: context.l10n.downloadTitle,
              onRefresh: () async {
                context.read<DownloadBloc>().add(LoadDownloadTasksEvent());
              },
              trailing: _HeaderActions(onCancelAll: _showCancelAllDialog),
              sliverChildPosition: SliverChildPosition.end,
              slivers: [
                SliverToBoxAdapter(
                  child: _FilterTabs(controller: _tabController),
                ),
              ],
              body: BlocConsumer<DownloadBloc, DownloadState>(
                listener: (context, state) {
                  // errorMessage holds the technical (English) cause for
                  // logs; the user sees a localized message.
                  if (state.loadState == RequestState.error &&
                      state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.cleanupDownloadActionFailed),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    height: context.getHight(80),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _DownloadList(
                          emptyText: context.l10n.downloadEmptyAll,
                        ),
                        _DownloadList(
                          statuses: const [
                            DownloadTaskStatus.running,
                            DownloadTaskStatus.enqueued,
                          ],
                          emptyText: context.l10n.downloadEmptyActive,
                        ),
                        _DownloadList(
                          statuses: const [DownloadTaskStatus.complete],
                          emptyText: context.l10n.downloadEmptyCompleted,
                        ),
                        _DownloadList(
                          statuses: const [DownloadTaskStatus.paused],
                          emptyText: context.l10n.downloadEmptyPaused,
                        ),
                        _DownloadList(
                          statuses: const [DownloadTaskStatus.failed],
                          emptyText: context.l10n.downloadEmptyFailed,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showCancelAllDialog(BuildContext ctx) async {
    final result = await showDeleteConfirmationDialog<bool>(
      context,
      title: context.l10n.downloadCancelAll,
      message: context.l10n.downloadCancelAllConfirm,
    );
    if ((result ?? false) && ctx.mounted) {
      ctx.read<DownloadBloc>().add(CancelAllDownloadsEvent());
    }
  }
}

/// أفعال الرأس: إضافة تنزيل، وتحديث أو إلغاء الكل.
class _HeaderActions extends StatelessWidget {
  const _HeaderActions({required this.onCancelAll});

  final Future<void> Function(BuildContext context) onCancelAll;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: context.l10n.downloadAdd,
          onPressed: () {
            context.showBottomSheetUIHeader(
              child: BlocProvider.value(
                value: context.read<DownloadBloc>(),
                child: const AddDownloadWidget(),
              ),
            );
          },
          icon: AppIcon(AppIcons.add, color: skin.accent, size: 18.sp),
        ),
        PopupMenuButton<String>(
          color: skin.raised,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: skin.hairline),
          ),
          icon: AppIcon(AppIcons.more, color: skin.accent, size: 18.sp),
          onSelected: (value) {
            if (value == 'refresh') {
              context.read<DownloadBloc>().add(LoadDownloadTasksEvent());
              return;
            }
            onCancelAll(context);
          },
          itemBuilder: (menuContext) => [
            PopupMenuItem<String>(
              value: 'refresh',
              height: 36.h,
              child: Text(
                context.l10n.commonRefresh,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'cancel_all',
              height: 36.h,
              child: Text(
                context.l10n.downloadCancelAll,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// شريط التصفية: أسماء صغيرة وخطّ ذهبي تحت المختار، بلا أيقونات.
class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      children: [
        TabBar(
          controller: controller,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelColor: skin.ink,
          unselectedLabelColor: skin.inkSoft.withValues(alpha: 0.62),
          indicatorColor: AppColors.gold,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
          labelStyle: TextStyle(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            Tab(text: context.l10n.downloadFilterAll),
            Tab(text: context.l10n.downloadStatusActive),
            Tab(text: context.l10n.downloadStatusCompleted),
            Tab(text: context.l10n.downloadStatusPaused),
            Tab(text: context.l10n.downloadStatusFailed),
          ],
        ),
        Padding(
          padding: AppSkin.gutter,
          child: Divider(height: 1, thickness: 1, color: skin.hairline),
        ),
      ],
    );
  }
}

/// قائمة تنزيلات مصفّاة بحالة، أو كلّها.
class _DownloadList extends StatelessWidget {
  const _DownloadList({required this.emptyText, this.statuses});

  final List<DownloadTaskStatus>? statuses;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        final filter = statuses;

        if (state.loadState == RequestState.loading &&
            state.downloads.isEmpty) {
          return const _DownloadsSkeleton();
        }

        final items = filter == null
            ? state.downloads
            : state.downloads
                .where((task) => filter.contains(task.status))
                .toList();

        if (items.isEmpty) {
          return _EmptyNote(text: emptyText);
        }

        return ListView.builder(
          padding: EdgeInsets.only(top: 4.h, bottom: 18.h),
          itemCount: items.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => DownloadItemWidget(
            task: items[index],
            isLast: index == items.length - 1,
          ),
        );
      },
    );
  }
}

/// سطر واحد يشرح الفراغ — بلا أيقونة عملاقة.
class _EmptyNote extends StatelessWidget {
  const _EmptyNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon(AppIcons.download, color: skin.accent, size: 15.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// هيكل انتظار بشكل الصفوف نفسها.
class _DownloadsSkeleton extends StatelessWidget {
  const _DownloadsSkeleton();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      children: List.generate(
        4,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: index == 3
              ? null
              : BoxDecoration(
                  border: Border(bottom: BorderSide(color: skin.hairline)),
                ),
          child: Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: skin.hairline,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  height: 9.h,
                  decoration: BoxDecoration(
                    color: skin.hairline,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
