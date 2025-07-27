import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/notification_schedules/data/database/notification_configs.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/repo/notification_schedules_repo.dart';
import 'package:quran_app/features/notification_schedules/presentation/bloc/notification_schedule_bloc.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/improved_schedule_dialog.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/schedule_card_widget.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/schedules_summary_widget.dart';

class NotificationSchedulesScreen extends StatelessWidget {
  const NotificationSchedulesScreen({
    required this.notifKey,
    super.key,
  });
  const NotificationSchedulesScreen.forKey(this.notifKey, {super.key});

  final String notifKey;

  @override
  Widget build(BuildContext context) {
    // 1. get config (static or via provider)
    final config = NotificationConfigs.of(notifKey);

    // 2. get repo
    final repo = sl.get<NotificationSchedulesRepo>();

    return BlocProvider(
      create: (_) => NotificationScheduleBloc(
        repo: repo,
        notifKey: notifKey,
        title: config.title,
        body: config.body,
        channel: config.channel,
      )..add(LoadSchedules()),
      child: BlocConsumer<NotificationScheduleBloc, NotificationScheduleState>(
        listenWhen: (previous, current) =>
            current.hasError || current.hasSuccess,
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'إخفاء',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<NotificationScheduleBloc>().add(ClearError());
                  },
                ),
              ),
            );
          }

          if (state.hasSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
            context.read<NotificationScheduleBloc>().add(ClearError());
          }
        },
        builder: (context, state) {
          return BaseHomeWidget(
            title: 'إدارة مواعيد الإشعار',
            floatingActionButton: _buildFAB(context, state),
            isScroll: false,
            body: state.isLoading
                ? const _LoadingWidget()
                : Column(
                    children: [
                      // Summary Statistics
                      if (state.schedules.isNotEmpty)
                        SchedulesSummaryWidget(
                          totalCount: state.schedules.length,
                          enabledCount: state.enabledCount,
                          disabledCount: state.disabledCount,
                        ),

                      // Schedules List
                      Expanded(
                        child: state.isEmpty
                            ? const _EmptyStateWidget()
                            : _buildSchedulesList(context, state),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context, NotificationScheduleState state) {
    return FloatingActionButton.extended(
      onPressed: state.isSubmitting ? null : () => _showAddDialog(context),
      backgroundColor: context.primaryColor,
      foregroundColor: Colors.white,
      icon: state.isSubmitting
          ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Icon(Icons.add, size: 24.sp),
      label: Text(
        state.isSubmitting ? 'جاري الحفظ...' : 'إضافة موعد',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSchedulesList(
    BuildContext context,
    NotificationScheduleState state,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationScheduleBloc>().add(LoadSchedules());
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: state.schedules.length,
        itemBuilder: (context, index) {
          final schedule = state.schedules[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ScheduleCardWidget(
              schedule: schedule,
              onEdit: () => _showEditDialog(context, schedule),
              onDelete: () => _showDeleteDialog(context, schedule),
              onToggle: () => _toggleSchedule(context, schedule),
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showImprovedScheduleDialog(
      context,
      NotificationScheduleCustomModel(
        notifKey: notifKey,
        enabled: true,
        scheduleType: ScheduleType.daily,
      ),
      (created) {
        context.read<NotificationScheduleBloc>().add(AddSchedule(created));
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    NotificationScheduleCustomModel schedule,
  ) {
    showImprovedScheduleDialog(
      context,
      schedule,
      (updated) {
        context.read<NotificationScheduleBloc>().add(EditSchedule(updated));
      },
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    NotificationScheduleCustomModel schedule,
  ) async {
    final result = await showDeleteConfirmationDialog<bool>(
      context,
      title: 'حذف موعد',
      message:
          'هل أنت متأكد من حذف هذا الموعد؟\nسيتم إلغاء جميع الإشعارات المرتبطة به.',
    );

    if (result == true) {
      context
          .read<NotificationScheduleBloc>()
          .add(DeleteSchedule(schedule.id!));
    }
  }

  void _toggleSchedule(
    BuildContext context,
    NotificationScheduleCustomModel schedule,
  ) {
    context.read<NotificationScheduleBloc>().add(ToggleSchedule(schedule));
  }
}

// Loading Widget
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل المواعيد...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Empty State Widget
class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.schedule_outlined,
                size: 60.sp,
                color: context.primaryColor.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'لا توجد مواعيد',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'اضغط على زر "إضافة موعد" لإنشاء موعد إشعار جديد',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () => const NotificationSchedulesScreen(notifKey: '')
                  ._showAddDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
              icon: Icon(Icons.add, size: 20.sp),
              label: Text(
                'إضافة موعد جديد',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
