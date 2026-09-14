import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/download/data/models/download_task_model.dart';
import 'package:quran_app/features/download/presentation/bloc/download_bloc.dart';

/// صفّ تنزيل: اسم الملفّ وحالته، وخطّ تقدّم رفيع تحته.
///
/// كانت كل مهمّة بطاقة بحشو ١٦ وأزرار ملوّنة (برتقالي وأحمر وأخضر وأزرق)،
/// فتقرأ الشاشة كلوحة ألوان. صار الصفّ نحيلاً بلون واحد، والحالة تُقرأ من
/// الأيقونة والنصّ لا من لون الزرّ.
class DownloadItemWidget extends StatelessWidget {
  const DownloadItemWidget({
    required this.task,
    this.isLast = false,
    super.key,
  });

  final DownloadTaskModel task;
  final bool isLast;

  bool get _isBusy =>
      task.status == DownloadTaskStatus.running ||
      task.status == DownloadTaskStatus.enqueued;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        final progress = state.getProgressForTask(task.taskId);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: isLast
              ? null
              : BoxDecoration(
                  border: Border(bottom: BorderSide(color: skin.hairline)),
                ),
          child: Column(
            children: [
              Row(
                children: [
                  _StatusChip(status: task.status),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          task.fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: skin.ink,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          task.statusText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: skin.inkSoft.withValues(alpha: 0.78),
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isBusy)
                    // النسبة بالأرقام تُقرأ من اليسار، فنثبّت اتجاهها.
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '$progress%',
                        style: TextStyle(
                          color: skin.accent,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [ui.FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ..._actions(context, skin),
                  _MoreMenu(taskId: task.taskId),
                ],
              ),
              if (_isBusy) ...[
                SizedBox(height: 7.h),
                _ProgressLine(value: progress / 100),
              ],
            ],
          ),
        );
      },
    );
  }

  List<Widget> _actions(BuildContext context, AppSkin skin) {
    void send(DownloadEvent event) {
      HapticFeedback.selectionClick();
      context.read<DownloadBloc>().add(event);
    }

    switch (task.status) {
      case DownloadTaskStatus.running:
      case DownloadTaskStatus.enqueued:
        return [
          _ActionIcon(
            icon: AppIcons.pause,
            label: 'إيقاف مؤقّت',
            onTap: () => send(PauseDownloadEvent(taskId: task.taskId)),
          ),
          _ActionIcon(
            icon: AppIcons.close,
            label: 'إلغاء',
            color: AppColors.error,
            onTap: () => send(CancelDownloadEvent(taskId: task.taskId)),
          ),
        ];
      case DownloadTaskStatus.paused:
        return [
          _ActionIcon(
            icon: AppIcons.play,
            label: 'متابعة',
            onTap: () => send(ResumeDownloadEvent(taskId: task.taskId)),
          ),
          _ActionIcon(
            icon: AppIcons.close,
            label: 'إلغاء',
            color: AppColors.error,
            onTap: () => send(CancelDownloadEvent(taskId: task.taskId)),
          ),
        ];
      case DownloadTaskStatus.failed:
        return [
          _ActionIcon(
            icon: AppIcons.refresh,
            label: 'إعادة المحاولة',
            onTap: () => send(RetryDownloadEvent(taskId: task.taskId)),
          ),
        ];
      case DownloadTaskStatus.complete:
        return [
          _ActionIcon(
            icon: AppIcons.link,
            label: 'فتح الملفّ',
            onTap: () => send(OpenDownloadedFileEvent(taskId: task.taskId)),
          ),
        ];
      case DownloadTaskStatus.canceled:
      case DownloadTaskStatus.undefined:
        return const [];
    }
  }
}

/// مربّع أيقونة يدلّ على حالة المهمّة.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final DownloadTaskStatus status;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final icon = switch (status) {
      DownloadTaskStatus.running => AppIcons.download,
      DownloadTaskStatus.enqueued => AppIcons.clock,
      DownloadTaskStatus.paused => AppIcons.pause,
      DownloadTaskStatus.complete => AppIcons.check,
      DownloadTaskStatus.failed => AppIcons.error,
      DownloadTaskStatus.canceled => AppIcons.cancel,
      DownloadTaskStatus.undefined => AppIcons.download,
    };

    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: AppIcon(
          icon,
          color: status == DownloadTaskStatus.failed
              ? AppColors.error
              : skin.accent,
          size: 15.sp,
        ),
      ),
    );
  }
}

/// زرّ فعل: أيقونة على الأرضية، بلا تعبئة ولا إطار.
class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final HugeIconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: AppIcon(icon, color: color ?? skin.accent, size: 15.sp),
        ),
      ),
    );
  }
}

/// قائمة الحذف: من القائمة فقط، أو مع الملفّ.
class _MoreMenu extends StatelessWidget {
  const _MoreMenu({required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: skin.raised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: skin.hairline),
      ),
      onSelected: (value) {
        context.read<DownloadBloc>().add(
              RemoveDownloadTaskEvent(
                taskId: taskId,
                deleteFile: value == 'delete_with_file',
              ),
            );
      },
      icon: AppIcon(
        AppIcons.more,
        color: skin.inkSoft.withValues(alpha: 0.7),
        size: 15.sp,
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'delete',
          height: 36.h,
          child: Text(
            'حذف من القائمة',
            style: TextStyle(
              color: skin.ink,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete_with_file',
          height: 36.h,
          child: Text(
            'حذف الملفّ',
            style: TextStyle(
              color: AppColors.error,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// خطّ التقدّم: شعرة تمتلئ ذهبًا.
class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      height: 3.h,
      decoration: BoxDecoration(
        color: skin.hairline,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
        alignment: AlignmentDirectional.centerStart,
        widthFactor: value.clamp(0.0, 1.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
      ),
    );
  }
}
