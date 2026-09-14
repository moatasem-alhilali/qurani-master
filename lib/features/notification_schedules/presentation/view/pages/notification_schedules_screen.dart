import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/notification/model/notification_schedule_model.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/notification_schedules/data/database/notification_configs.dart';
import 'package:quran_app/features/notification_schedules/data/model/notification_custom_schedule_model.dart';
import 'package:quran_app/features/notification_schedules/data/repo/notification_schedules_repo.dart';
import 'package:quran_app/features/notification_schedules/presentation/bloc/notification_schedule_bloc.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/improved_schedule_dialog.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/schedule_row_widget.dart';
import 'package:quran_app/features/notification_schedules/presentation/view/widgets/schedules_summary_widget.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';

/// مواعيد إشعار واحد: ملخّص رقمي ثم قائمة صفوف نحيلة.
class NotificationSchedulesScreen extends StatelessWidget {
  const NotificationSchedulesScreen({
    required this.notifKey,
    super.key,
  });

  const NotificationSchedulesScreen.forKey(this.notifKey, {super.key});

  final String notifKey;

  @override
  Widget build(BuildContext context) {
    final config = NotificationConfigs.of(notifKey);
    final repo = sl.get<NotificationSchedulesRepo>();

    return BlocProvider(
      create: (_) => NotificationScheduleBloc(
        repo: repo,
        notifKey: notifKey,
        title: config.title,
        body: config.body,
        channel: config.channel,
      )..add(LoadSchedules()),
      child: _SchedulesView(notifKey: notifKey),
    );
  }
}

class _SchedulesView extends StatelessWidget {
  const _SchedulesView({required this.notifKey});

  final String notifKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationScheduleBloc, NotificationScheduleState>(
      listenWhen: (previous, current) => current.hasError || current.hasSuccess,
      listener: (context, state) {
        if (state.hasError) {
          AdaptiveSnackBar.show(
            context,
            message: state.error ?? 'حدث خطأ غير متوقع',
            type: AdaptiveSnackBarType.error,
          );
          context.read<NotificationScheduleBloc>().add(ClearError());
        } else if (state.hasSuccess) {
          AdaptiveSnackBar.show(
            context,
            message: state.successMessage ?? 'تم الحفظ',
            type: AdaptiveSnackBarType.success,
          );
          context.read<NotificationScheduleBloc>().add(ClearError());
        }
      },
      builder: (context, state) {
        return SettingsScaffold(
          title: 'مواعيد الإشعار',
          onRefresh: () async {
            context.read<NotificationScheduleBloc>().add(LoadSchedules());
          },
          floatingActionButton: _AddScheduleButton(
            busy: state.isSubmitting,
            onPressed: () => _openAddSheet(context),
          ),
          children: [
            if (state.isLoading)
              const _LoadingRow()
            else ...[
              if (state.schedules.isNotEmpty)
                SchedulesSummaryWidget(
                  totalCount: state.schedules.length,
                  enabledCount: state.enabledCount,
                  disabledCount: state.disabledCount,
                ),
              SettingsGroup(
                title: 'المواعيد',
                children: [
                  if (state.isEmpty)
                    const SettingsHint(
                      'لا توجد مواعيد بعد — أضف موعداً من زر «إضافة موعد».',
                    )
                  else
                    for (var i = 0; i < state.schedules.length; i++)
                      ScheduleRowWidget(
                        schedule: state.schedules[i],
                        isLast: i == state.schedules.length - 1,
                        onEdit: () => _openEditSheet(
                          context,
                          state.schedules[i],
                        ),
                        onDelete: () => _confirmDelete(
                          context,
                          state.schedules[i],
                        ),
                        onToggle: () => context
                            .read<NotificationScheduleBloc>()
                            .add(ToggleSchedule(state.schedules[i])),
                      ),
                ],
              ),
              SizedBox(height: 46.h),
            ],
          ],
        );
      },
    );
  }

  void _openAddSheet(BuildContext context) {
    final bloc = context.read<NotificationScheduleBloc>();
    showImprovedScheduleDialog(
      context,
      NotificationScheduleCustomModel(
        notifKey: notifKey,
        enabled: true,
        scheduleType: ScheduleType.daily,
      ),
      (created) => bloc.add(AddSchedule(created)),
    );
  }

  void _openEditSheet(
    BuildContext context,
    NotificationScheduleCustomModel schedule,
  ) {
    final bloc = context.read<NotificationScheduleBloc>();
    showImprovedScheduleDialog(
      context,
      schedule,
      (updated) => bloc.add(EditSchedule(updated)),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    NotificationScheduleCustomModel schedule,
  ) async {
    final bloc = context.read<NotificationScheduleBloc>();
    final result = await showDeleteConfirmationDialog<bool>(
      context,
      title: 'حذف موعد',
      message: 'هل أنت متأكد من حذف هذا الموعد؟\n'
          'سيتم إلغاء جميع الإشعارات المرتبطة به.',
    );

    final id = schedule.id;
    if (result ?? false) {
      if (id != null) {
        bloc.add(DeleteSchedule(id));
      }
    }
  }
}

/// زر الإضافة: التعبئة الذهبية الوحيدة في الشاشة.
class _AddScheduleButton extends StatelessWidget {
  const _AddScheduleButton({required this.busy, required this.onPressed});

  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const foreground = settingsOnGold;

    return FloatingActionButton.extended(
      onPressed: busy ? null : onPressed,
      backgroundColor: AppColors.gold,
      foregroundColor: foreground,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.r),
      ),
      icon: busy
          ? SizedBox.square(
              dimension: 14.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(foreground),
              ),
            )
          : AppIcon(AppIcons.add, size: 15.sp, color: foreground),
      label: Text(
        busy ? 'جارٍ الحفظ...' : 'إضافة موعد',
        style: TextStyle(
          color: foreground,
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _LoadingRow extends StatelessWidget {
  const _LoadingRow();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          SizedBox.square(
            dimension: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(skin.accent),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'جارٍ تحميل المواعيد...',
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
