import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/manage_version/data/models/app_version_model.dart';
import 'package:quran_app/features/manage_version/presentation/bloc/version_bloc.dart';

class UpdateDialogWidget extends StatelessWidget {
  const UpdateDialogWidget({
    required this.versionModel,
    super.key,
    this.onUpdate,
    this.onSkip,
    this.onCancel,
  });

  final AppVersionModel versionModel;
  final VoidCallback? onUpdate;
  final VoidCallback? onSkip;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VersionBloc, VersionState>(
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: context.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(context),
              SizedBox(height: 16.h),

              // Version info
              _buildVersionInfo(context),
              SizedBox(height: 16.h),

              // Release notes
              if (versionModel.releaseNotes?.isNotEmpty == true) ...[
                _buildReleaseNotes(context),
                SizedBox(height: 16.h),
              ],

              // Download progress (if downloading)
              if (state.downloadState == RequestState.loading) ...[
                _buildDownloadProgress(context, state),
                SizedBox(height: 16.h),
              ],

              // Action buttons
              _buildActionButtons(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.system_update,
          size: 48.sp,
          color: _getPriorityColor(context),
        ),
        SizedBox(height: 12.h),
        Text(
          versionModel.isUpdateRequired ? 'تحديث مطلوب' : 'تحديث متاح',
          style: titleLarge(context).copyWith(
            fontWeight: FontWeight.bold,
            color: _getPriorityColor(context),
          ),
        ),
        if (versionModel.updatePriority != UpdatePriority.normal) ...[
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: _getPriorityColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              versionModel.updatePriority.displayText,
              style: titleSmall(context).copyWith(
                color: _getPriorityColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: context.primaryScheme.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: context.primaryScheme.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'النسخة الحالية:',
                style: titleMedium(context).copyWith(
                  color: context.gray1,
                ),
              ),
              Text(
                versionModel.currentVersion,
                style: titleMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'النسخة الجديدة:',
                style: titleMedium(context).copyWith(
                  color: context.gray1,
                ),
              ),
              Text(
                versionModel.latestVersion,
                style: titleMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.primaryScheme,
                ),
              ),
            ],
          ),
          if (versionModel.downloadSize?.isNotEmpty == true) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'حجم التحميل:',
                  style: titleMedium(context).copyWith(
                    color: context.gray1,
                  ),
                ),
                Text(
                  versionModel.downloadSize!,
                  style: titleMedium(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReleaseNotes(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: context.gray1.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ما الجديد:',
            style: titleMedium(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            versionModel.releaseNotes!,
            style: titleSmall(context).copyWith(
              color: context.gray1,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadProgress(BuildContext context, VersionState state) {
    final progressValue = state.totalBytes > 0
        ? state.downloadedBytes / state.totalBytes
        : state.downloadProgress / 100.0;

    final progressText = state.totalBytes > 0
        ? '${(state.downloadedBytes / 1024 / 1024).toStringAsFixed(1)} MB / ${(state.totalBytes / 1024 / 1024).toStringAsFixed(1)} MB'
        : '${state.downloadProgress}%';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'جاري التحميل...',
              style: titleMedium(context).copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              progressText,
              style: titleSmall(context).copyWith(
                color: context.gray1,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        LinearProgressIndicator(
          value: progressValue.clamp(0.0, 1.0),
          backgroundColor: context.gray1.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(context.primaryScheme),
        ),
        SizedBox(height: 8.h),
        // Only show download control buttons if they are actively downloading
        if (state.downloadStatus == DownloadStatus.downloading ||
            state.downloadStatus == DownloadStatus.paused) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.downloadStatus == DownloadStatus.downloading)
                TextButton.icon(
                  onPressed: () =>
                      context.read<VersionBloc>().add(PauseDownloadEvent()),
                  icon: const Icon(Icons.pause),
                  label: const Text('إيقاف مؤقت'),
                ),
              if (state.downloadStatus == DownloadStatus.paused)
                TextButton.icon(
                  onPressed: () =>
                      context.read<VersionBloc>().add(ResumeDownloadEvent()),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('استكمال'),
                ),
              SizedBox(width: 8.w),
              TextButton.icon(
                onPressed: () =>
                    context.read<VersionBloc>().add(CancelDownloadEvent()),
                icon: const Icon(Icons.cancel),
                label: const Text('إلغاء'),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, VersionState state) {
    if (state.downloadState == RequestState.loading) {
      return const SizedBox.shrink(); // Hide buttons during download
    }

    return Column(
      children: [
        // Primary action button
        SizedBox(
          width: double.infinity,
          child: ProgressButtonState(
            onPressed: () {
              context.read<VersionBloc>().add(
                    ProcessDownloadLinkEvent(
                      downloadUrl: versionModel.downloadUrl,
                    ),
                  );
              context.read<VersionBloc>().add(DismissUpdateDialogEvent());
              Navigator.of(context).pop();
              onUpdate?.call();
            },
            text:
                versionModel.isUpdateRequired ? 'تحديث الآن' : 'تحميل التحديث',
            icon: Icon(
              Icons.download,
              color: context.onPrimary,
            ),
          ),
        ),

        // Secondary actions
        if (!versionModel.isUpdateRequired) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    context.read<VersionBloc>().add(
                          SkipVersionEvent(version: versionModel.latestVersion),
                        );
                    context.read<VersionBloc>().add(DismissUpdateDialogEvent());
                    Navigator.of(context).pop();
                    onSkip?.call();
                  },
                  child: Text(
                    'تخطي هذا التحديث',
                    style: titleMedium(context).copyWith(
                      color: context.gray1,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    context.read<VersionBloc>().add(DismissUpdateDialogEvent());
                    Navigator.of(context).pop();
                    onCancel?.call();
                  },
                  child: Text(
                    'تذكيرني لاحقاً',
                    style: titleMedium(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Color _getPriorityColor(BuildContext context) {
    switch (versionModel.updatePriority) {
      case UpdatePriority.low:
        return Colors.green;
      case UpdatePriority.normal:
        return context.primaryScheme;
      case UpdatePriority.high:
        return Colors.orange;
      case UpdatePriority.critical:
        return Colors.red;
    }
  }
}

/// Extension to show update dialog easily
extension UpdateDialogExtension on BuildContext {
  Future<void> showUpdateDialog(AppVersionModel versionModel) {
    return showDialog<void>(
      context: this,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => UpdateDialogWidget(versionModel: versionModel),
    );
  }
}
