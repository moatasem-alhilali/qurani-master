import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/features/manage_version/presentation/bloc/version_bloc.dart';
import 'package:quran_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionManagementScreen extends StatefulWidget {
  const VersionManagementScreen({super.key});

  @override
  State<VersionManagementScreen> createState() =>
      _VersionManagementScreenState();
}

class _VersionManagementScreenState extends State<VersionManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger a version check when screen loads
    context.read<VersionBloc>().add(
          CheckForUpdatesEvent(forceRefresh: true, isManualCheck: true),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إدارة الإصدارات',
          style: titleMedium(context).copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<VersionBloc, VersionState>(
        listener: (context, state) {
          // Handle error messages
          if (state.versionCheckState == RequestState.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage!,
                  style: titleMedium(context).copyWith(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<VersionBloc>().add(
                    CheckForUpdatesEvent(
                      forceRefresh: true,
                      isManualCheck: true,
                    ),
                  );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connection Status Card
                  _buildConnectionStatusCard(state),
                  SizedBox(height: 16.h),

                  // Current Version Card
                  _buildCurrentVersionCard(state),
                  SizedBox(height: 16.h),

                  // Latest Version Card
                  if (state.latestVersionInfo != null)
                    _buildLatestVersionCard(state),

                  SizedBox(height: 16.h),

                  // Update Status Card
                  _buildUpdateStatusCard(state),
                  SizedBox(height: 16.h),

                  // Actions Card
                  if (state.latestVersionInfo != null) _buildActionsCard(state),

                  SizedBox(height: 16.h),

                  // Download Card
                  if (state.hasUpdateAvailable && state.canDownload)
                    _buildDownloadCard(state),

                  SizedBox(height: 16.h),

                  // Debug Info Card (for development)
                  if (state.latestVersionInfo != null)
                    _buildDebugInfoCard(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConnectionStatusCard(VersionState state) {
    return CardWidget(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Icon(
            state.isConnected ? Icons.wifi : Icons.wifi_off,
            color: state.isConnected ? Colors.green : Colors.red,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حالة الاتصال',
                  style: titleMedium(context).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  state.isConnected ? 'متصل بالإنترنت' : 'غير متصل بالإنترنت',
                  style: titleMedium(context).copyWith(
                    fontSize: 14.sp,
                    color: state.isConnected ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          if (state.versionCheckState == RequestState.loading)
            SizedBox(
              width: 20.sp,
              height: 20.sp,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.primaryScheme,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentVersionCard(VersionState state) {
    return CardWidget(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Icon(
            Icons.phone_android,
            color: context.primaryScheme,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإصدار الحالي',
                  style: titleMedium(context).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  state.currentVersion ?? 'غير محدد',
                  style: titleMedium(context).copyWith(
                    fontSize: 14.sp,
                    color: context.gray1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestVersionCard(VersionState state) {
    final versionInfo = state.latestVersionInfo!;
    return CardWidget(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.cloud_download,
                color: context.primaryScheme,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'أحدث إصدار متاح',
                  style: titleMedium(context).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildVersionDetailRow('الإصدار:', versionInfo.latestVersion),
          if (versionInfo.releaseNotes != null) ...[
            SizedBox(height: 8.h),
            _buildVersionDetailRow(
              'ملاحظات الإصدار:',
              versionInfo.releaseNotes!,
            ),
          ],
          if (versionInfo.downloadSize != null) ...[
            SizedBox(height: 8.h),
            _buildVersionDetailRow('حجم التحميل:', versionInfo.downloadSize!),
          ],
          SizedBox(height: 8.h),
          _buildVersionDetailRow(
            'أولوية التحديث:',
            versionInfo.updatePriority.displayText,
          ),
          if (versionInfo.lastChecked != null) ...[
            SizedBox(height: 8.h),
            _buildVersionDetailRow(
              'آخر فحص:',
              _formatDateTime(versionInfo.lastChecked!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpdateStatusCard(VersionState state) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (state.hasUpdateAvailable) {
      if (state.isUpdateRequired) {
        statusColor = Colors.red;
        statusText = 'تحديث مطلوب';
        statusIcon = Icons.warning;
      } else {
        statusColor = Colors.orange;
        statusText = 'تحديث متاح';
        statusIcon = Icons.info;
      }
    } else {
      statusColor = Colors.green;
      statusText = 'أنت تستخدم أحدث إصدار';
      statusIcon = Icons.check_circle;
    }

    return CardWidget(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حالة التحديث',
                  style: titleMedium(context).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  statusText,
                  style: titleMedium(context).copyWith(
                    fontSize: 14.sp,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(VersionState state) {
    final versionInfo = state.latestVersionInfo!;

    return CardWidget(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإجراءات',
            style: titleMedium(context).copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),

          // Refresh Button
          _buildActionButton(
            icon: Icons.refresh,
            title: 'فحص التحديثات',
            subtitle: 'تحقق من وجود إصدارات جديدة',
            onTap: state.versionCheckState == RequestState.loading
                ? null
                : () {
                    context.read<VersionBloc>().add(
                          CheckForUpdatesEvent(
                            forceRefresh: true,
                            isManualCheck: true,
                          ),
                        );
                  },
          ),

          SizedBox(height: 8.h),

          // Copy Download Link Button
          if (versionInfo.downloadUrl.isNotEmpty)
            _buildActionButton(
              icon: Icons.copy,
              title: 'نسخ رابط التحميل',
              subtitle: 'نسخ رابط تحميل الإصدار الجديد',
              onTap: () => _copyToClipboard(versionInfo.downloadUrl),
            ),

          SizedBox(height: 8.h),

          // Open Download Link Button
          if (versionInfo.downloadUrl.isNotEmpty)
            _buildActionButton(
              icon: Icons.open_in_browser,
              title: 'فتح رابط التحميل',
              subtitle: 'فتح رابط التحميل في المتصفح',
              onTap: () => _openDownloadLink(versionInfo.downloadUrl),
            ),

          if (state.hasUpdateAvailable) ...[
            SizedBox(height: 8.h),

            // Skip Version Button (only for non-required updates)
            if (!state.isUpdateRequired)
              _buildActionButton(
                icon: Icons.skip_next,
                title: 'تخطي هذا الإصدار',
                subtitle: 'عدم عرض تنبيهات لهذا الإصدار',
                onTap: () {
                  context.read<VersionBloc>().add(
                        SkipVersionEvent(version: versionInfo.latestVersion),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم تخطي الإصدار ${versionInfo.latestVersion}',
                        style:
                            titleMedium(context).copyWith(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
          ],

          SizedBox(height: 8.h),

          // Clear Cache Button
          _buildActionButton(
            icon: Icons.clear_all,
            title: 'مسح ذاكرة التخزين المؤقت',
            subtitle: 'مسح بيانات الإصدارات المحفوظة',
            onTap: () {
              context.read<VersionBloc>().add(ClearVersionCacheEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم مسح ذاكرة التخزين المؤقت',
                    style: titleMedium(context).copyWith(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadCard(VersionState state) {
    return CardWidget(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.download,
                color: context.primaryScheme,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'تحميل التحديث',
                  style: titleMedium(context).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (state.downloadStatus != DownloadStatus.none) ...[
            _buildDownloadProgress(state),
            SizedBox(height: 12.h),
            _buildDownloadControls(state),
          ] else ...[
            ElevatedButton.icon(
              onPressed: () {
                final downloadUrl = state.latestVersionInfo!.downloadUrl;
                context.read<VersionBloc>().add(
                      ProcessDownloadLinkEvent(downloadUrl: downloadUrl),
                    );
              },
              icon: Icon(Icons.download, size: 20.sp),
              label: Text(
                'بدء التحميل',
                style: titleMedium(context).copyWith(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryScheme,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDownloadProgress(VersionState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'حالة التحميل: ${state.downloadStatus.displayText}',
              style: titleMedium(context).copyWith(fontSize: 14.sp),
            ),
            Text(
              '${state.downloadProgress}%',
              style: titleMedium(context).copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        LinearProgressIndicator(
          value: state.downloadProgress / 100,
          backgroundColor: context.gray1.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(context.primaryScheme),
        ),
        if (state.downloadProgressText.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            state.downloadProgressText,
            style: titleMedium(context).copyWith(
              fontSize: 12.sp,
              color: context.gray1,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDownloadControls(VersionState state) {
    return Row(
      children: [
        if (state.downloadStatus.canPause)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<VersionBloc>().add(PauseDownloadEvent());
              },
              icon: Icon(Icons.pause, size: 18.sp),
              label: const Text('إيقاف مؤقت'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        if (state.downloadStatus.canResume) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<VersionBloc>().add(ResumeDownloadEvent());
              },
              icon: Icon(Icons.play_arrow, size: 18.sp),
              label: const Text('متابعة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
        if (state.downloadStatus.canCancel)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<VersionBloc>().add(CancelDownloadEvent());
              },
              icon: Icon(Icons.stop, size: 18.sp),
              label: const Text('إلغاء'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDebugInfoCard(VersionState state) {
    final versionInfo = state.latestVersionInfo!;

    return CardWidget(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات تقنية',
            style: titleMedium(context).copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          _buildVersionDetailRow(
            'رابط التحميل موجود:',
            versionInfo.downloadUrl.isNotEmpty ? 'نعم' : 'لا',
          ),
          SizedBox(height: 8.h),
          _buildVersionDetailRow(
            'الإصدار الأدنى المطلوب:',
            versionInfo.minimumRequiredVersion ?? 'غير محدد',
          ),
          SizedBox(height: 8.h),
          _buildVersionDetailRow(
            'حالة الاستماع:',
            state.isListening ? 'نشط' : 'غير نشط',
          ),
          SizedBox(height: 8.h),
          _buildVersionDetailRow(
            'حالة فحص الإصدار:',
            _getRequestStateText(state.versionCheckState),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: titleMedium(context).copyWith(
              fontSize: 14.sp,
              color: context.gray1,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: titleMedium(context).copyWith(
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.gray1.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: onTap != null ? context.primaryScheme : context.gray1,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: titleMedium(context).copyWith(
                      fontSize: 14.sp,
                      color: onTap != null ? null : context.gray1,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: titleMedium(context).copyWith(
                      fontSize: 12.sp,
                      color: context.gray1,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: context.gray1,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }

  String _getRequestStateText(RequestState state) {
    switch (state) {
      case RequestState.initial:
        return 'ابتدائي';
      case RequestState.loading:
        return 'جاري التحميل';
      case RequestState.success:
        return 'نجح';
      case RequestState.error:
        return 'خطأ';
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم نسخ الرابط إلى الحافظة',
            style: titleMedium(context).copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _openDownloadLink(String url) async {
    try {
      final uri = Uri.parse(url);

      // Check if it's an APK file URL
      final isApkUrl = url.toLowerCase().endsWith('.apk');

      if (isApkUrl) {
        // For APK files, try multiple strategies
        var launched = false;

        // Strategy 1: Try with platformDefault mode first
        try {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
            launched = true;
          }
        } catch (e) {
          logger.w('Strategy 1 failed: $e');
        }

        // Strategy 2: Try with inAppBrowserView mode (opens in browser)
        if (!launched) {
          try {
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              launched = true;
            }
          } catch (e) {
            logger.w('Strategy 2 failed: $e');
          }
        }

        // Strategy 3: Try with externalNonBrowserApplication mode
        if (!launched) {
          try {
            if (await canLaunchUrl(uri)) {
              await launchUrl(
                uri,
                mode: LaunchMode.externalNonBrowserApplication,
              );
              launched = true;
            }
          } catch (e) {
            logger.w('Strategy 3 failed: $e');
          }
        }

        if (!launched) {
          throw Exception('Cannot launch APK URL with any method');
        }

        // Show success message for APK
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم فتح رابط تحميل التطبيق. يرجى المتابعة من المتصفح.',
                style: titleMedium(context).copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        // For non-APK URLs, use the standard approach
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw Exception('Cannot launch URL');
        }
      }
    } catch (e) {
      logger.e('Failed to open download link: url: $url, error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'فشل في فتح الرابط مباشرة',
                  style: titleMedium(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'يمكنك نسخ الرابط ولصقه في المتصفح',
                  style: titleMedium(context).copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'نسخ الرابط',
              textColor: Colors.white,
              onPressed: () => _copyToClipboard(url),
            ),
          ),
        );
      }
    }
  }
}
