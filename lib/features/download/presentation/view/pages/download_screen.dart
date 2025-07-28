import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_sliver_widget.dart';
import 'package:quran_app/features/download/presentation/bloc/download_bloc.dart';
import 'package:quran_app/features/download/presentation/view/widgets/add_download_widget.dart';
import 'package:quran_app/features/download/presentation/view/widgets/download_item_widget.dart';

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
    return BlocProvider(
      create: (context) => DownloadBloc()..add(LoadDownloadTasksEvent()),
      child: BlocBuilder<DownloadBloc, DownloadState>(
        buildWhen: (prev, curr) => prev.loadState != curr.loadState,
        builder: (context, state) {
          return AppScaffoldWidget(
            title: 'التنزيلات',
            onRefresh: () async {
              context.read<DownloadBloc>().add(LoadDownloadTasksEvent());
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<DownloadBloc, DownloadState>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () {
                        context.showBottomSheetUIHeader(
                          child: BlocProvider.value(
                            value: context.read<DownloadBloc>(),
                            child: const AddDownloadWidget(),
                          ),
                          // backgroundColor: context.scaffoldBackgroundColor,
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: context.primaryColor,
                      ),
                    );
                  },
                ),
                BlocBuilder<DownloadBloc, DownloadState>(
                  builder: (ctx, state) {
                    return PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuAction(value, ctx),
                      icon: Icon(
                        Icons.more_vert,
                        color: context.primaryColor,
                      ),
                      color: context.scaffoldBackgroundColor,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'refresh',
                          child: Row(
                            children: [
                              Icon(Icons.refresh, color: context.primaryColor),
                              const SizedBox(width: 8),
                              Text('تحديث', style: titleSmall(context)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'cancel_all',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text('إلغاء الكل', style: titleSmall(context)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            sliverChildPosition: SliverChildPosition.end,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    // horizontal: 8.sp,
                    vertical: 8.sp,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    labelColor: context.primaryColor,
                    unselectedLabelColor: context.gray1,
                    indicatorColor: context.primaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'الكل', icon: Icon(Icons.list)),
                      Tab(text: 'نشط', icon: Icon(Icons.download)),
                      Tab(text: 'مكتمل', icon: Icon(Icons.check_circle)),
                      Tab(text: 'متوقف', icon: Icon(Icons.pause_circle)),
                      Tab(text: 'فشل', icon: Icon(Icons.error)),
                    ],
                  ),
                ),
              ),
            ],
            body: BlocConsumer<DownloadBloc, DownloadState>(
              listener: (context, state) {
                if (state.loadState == RequestState.error &&
                    state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: Colors.red,
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
                      _buildDownloadList(context, state, null),
                      _buildDownloadList(context, state, [
                        DownloadTaskStatus.running,
                        DownloadTaskStatus.enqueued,
                      ]),
                      _buildDownloadList(context, state, [
                        DownloadTaskStatus.complete,
                      ]),
                      _buildDownloadList(context, state, [
                        DownloadTaskStatus.paused,
                      ]),
                      _buildDownloadList(context, state, [
                        DownloadTaskStatus.failed,
                      ]),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDownloadList(
    BuildContext context,
    DownloadState state,
    List<DownloadTaskStatus>? statusFilter,
  ) {
    if (state.loadState == RequestState.loading && state.downloads.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final filteredDownloads = statusFilter == null
        ? state.downloads
        : state.downloads
            .where((task) => statusFilter.contains(task.status))
            .toList();

    if (filteredDownloads.isEmpty) {
      return _buildEmptyState(statusFilter);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredDownloads.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final task = filteredDownloads[index];
        return DownloadItemWidget(task: task);
      },
    );
  }

  Widget _buildEmptyState(List<DownloadTaskStatus>? statusFilter) {
    String message;
    IconData icon;

    if (statusFilter == null) {
      message = 'لا يوجد تنزيلات بعد.\nأضف تنزيلاً للبدء!';
      icon = Icons.download_outlined;
    } else if (statusFilter.contains(DownloadTaskStatus.running) ||
        statusFilter.contains(DownloadTaskStatus.enqueued)) {
      message = 'لا يوجد تنزيلات نشطة';
      icon = Icons.download_outlined;
    } else if (statusFilter.contains(DownloadTaskStatus.complete)) {
      message = 'لا يوجد تنزيلات مكتملة';
      icon = Icons.check_circle_outline;
    } else if (statusFilter.contains(DownloadTaskStatus.paused)) {
      message = 'لا يوجد تنزيلات متوقفة';
      icon = Icons.pause_circle_outline;
    } else if (statusFilter.contains(DownloadTaskStatus.failed)) {
      message = 'لا يوجد تنزيلات فشلت';
      icon = Icons.error_outline;
    } else {
      message = 'لا يوجد تنزيلات';
      icon = Icons.download_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, BuildContext ctx) {
    switch (action) {
      case 'refresh':
        ctx.read<DownloadBloc>().add(LoadDownloadTasksEvent());
      case 'cancel_all':
        _showCancelAllDialog(ctx);
    }
  }

  Future<void> _showCancelAllDialog(BuildContext ctx) async {
    final result = await showDeleteConfirmationDialog<bool>(
      context,
      title: 'إلغاء الكل',
      message: 'هل أنت متأكد من إلغاء جميع التنزيلات النشطة؟',
    );
    if ((result ?? false) == true) {
      if (ctx.mounted) {
        ctx.read<DownloadBloc>().add(CancelAllDownloadsEvent());
      }
    }
  }
}
