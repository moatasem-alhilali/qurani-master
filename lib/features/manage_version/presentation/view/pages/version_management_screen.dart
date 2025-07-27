import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/features/manage_version/presentation/bloc/version_bloc.dart';

class VersionManagementScreen extends StatefulWidget {
  const VersionManagementScreen({super.key});

  @override
  State<VersionManagementScreen> createState() =>
      _VersionManagementScreenState();
}

class _VersionManagementScreenState extends State<VersionManagementScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late AnimationController _pulseController;
  late List<Animation<double>> _cardAnimations;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create staggered animations for cards
    _cardAnimations = List.generate(5, (index) {
      final start = index * 0.1;
      final end = start + 0.6;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    // Create pulse animation for loading states
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _staggerController.forward();
    _pulseController.repeat(reverse: true);

    // Trigger a version check when screen loads
    context.read<VersionBloc>().add(
          CheckForUpdatesEvent(forceRefresh: true, isManualCheck: true),
        );
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseHomeWidget(
      title: 'إدارة الإصدارات',
      showBackground: false,
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
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
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
            color: context.primaryColor,
            backgroundColor: context.surfaceColor,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connection Status Card
                  _buildAnimatedCard(
                    animation: _cardAnimations[0],
                    child: _buildConnectionStatusCard(state),
                  ),
                  SizedBox(height: 16.h),

                  // Current Version Card
                  _buildAnimatedCard(
                    animation: _cardAnimations[1],
                    child: _buildCurrentVersionCard(state),
                  ),
                  SizedBox(height: 16.h),

                  // Latest Version Card
                  if (state.latestVersionInfo != null)
                    _buildAnimatedCard(
                      animation: _cardAnimations[2],
                      child: _buildLatestVersionCard(state),
                    ),

                  if (state.latestVersionInfo != null) SizedBox(height: 16.h),

                  // Update Status Card
                  _buildAnimatedCard(
                    animation: _cardAnimations[3],
                    child: _buildUpdateStatusCard(state),
                  ),
                  SizedBox(height: 16.h),

                  // Actions Card
                  if (state.latestVersionInfo != null)
                    _buildAnimatedCard(
                      animation: _cardAnimations[4],
                      child: _buildActionsCard(state),
                    ),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedCard({
    required Animation<double> animation,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildEnhancedCard({
    required Widget child,
    Color? backgroundColor,
    Gradient? gradient,
    bool elevated = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: context.secondaryColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: child,
      ),
    );
  }

  Widget _buildConnectionStatusCard(VersionState state) {
    final isConnected = state.isConnected;
    final isLoading = state.versionCheckState == RequestState.loading;

    return _buildEnhancedCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isConnected
            ? [
                Colors.green.withOpacity(0.1),
                Colors.green.withOpacity(0.05),
              ]
            : [
                Colors.red.withOpacity(0.1),
                Colors.red.withOpacity(0.05),
              ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            // Animated Icon Container
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isConnected
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isConnected ? Icons.wifi : Icons.wifi_off,
                color: isConnected ? Colors.green : Colors.red,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
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
                  SizedBox(height: 6.h),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      isConnected ? 'متصل بالإنترنت' : 'غير متصل بالإنترنت',
                      key: ValueKey(isConnected),
                      style: titleMedium(context).copyWith(
                        fontSize: 14.sp,
                        color: isConnected ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 20.sp,
                        height: 20.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentVersionCard(VersionState state) {
    return _buildEnhancedCard(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.primaryColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone_android,
                color: context.primaryColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
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
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      state.currentVersion ?? 'غير محدد',
                      style: titleMedium(context).copyWith(
                        fontSize: 14.sp,
                        color: context.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestVersionCard(VersionState state) {
    final versionInfo = state.latestVersionInfo!;
    return _buildEnhancedCard(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cloud_download,
                  color: context.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 16.w),
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
      ),
    );
  }

  Widget _buildUpdateStatusCard(VersionState state) {
    Color statusColor;
    String statusText;
    IconData statusIcon;
    Gradient? statusGradient;

    if (state.hasUpdateAvailable) {
      if (state.isUpdateRequired) {
        statusColor = Colors.red;
        statusText = 'تحديث مطلوب';
        statusIcon = Icons.warning;
        statusGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.red.withOpacity(0.05),
          ],
        );
      } else {
        statusColor = Colors.orange;
        statusText = 'تحديث متاح';
        statusIcon = Icons.info;
        statusGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        );
      }
    } else {
      statusColor = Colors.green;
      statusText = 'أنت تستخدم أحدث إصدار';
      statusIcon = Icons.check_circle;
      statusGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.green.withOpacity(0.1),
          Colors.green.withOpacity(0.05),
        ],
      );
    }

    return _buildEnhancedCard(
      gradient: statusGradient,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
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
                  SizedBox(height: 6.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: statusColor.withAlpha(30),
                      ),
                    ),
                    child: Text(
                      statusText,
                      style: titleMedium(context).copyWith(
                        fontSize: 14.sp,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Animated indicator for required updates
            if (state.isUpdateRequired)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.priority_high,
                        color: Colors.red,
                        size: 16.sp,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(VersionState state) {
    final versionInfo = state.latestVersionInfo!;

    return _buildEnhancedCard(
      child: Padding(
        padding: EdgeInsets.all(20.w),
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

            // Open Download Link Button
            if (versionInfo.downloadUrl.isNotEmpty)
              _buildActionButton(
                icon: Icons.download,
                title: 'تحميل التحديث',
                subtitle: 'فتح رابط التحميل في المتصفح',
                onTap: () => context.read<VersionBloc>().add(
                      OpenDownloadLinkEvent(
                        downloadUrl: versionInfo.downloadUrl,
                      ),
                    ),
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
                          style: titleMedium(context)
                              .copyWith(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: onTap != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        context.primaryColor.withAlpha(5),
                        context.primaryColor.withAlpha(2),
                      ],
                    )
                  : null,
              color: onTap != null ? null : context.gray6.withAlpha(30),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: onTap != null
                    ? context.primaryColor.withAlpha(20)
                    : context.gray1.withAlpha(20),
                width: 1.5,
              ),
              boxShadow: onTap != null
                  ? [
                      BoxShadow(
                        color: context.primaryColor.withOpacity(0.1),
                        blurRadius: 8.r,
                        offset: Offset(0, 2.h),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: onTap != null
                        ? context.primaryColor.withOpacity(0.1)
                        : context.gray1.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: onTap != null ? context.primaryColor : context.gray1,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: titleMedium(context).copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: onTap != null ? null : context.gray1,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: titleMedium(context).copyWith(
                          fontSize: 12.sp,
                          color: context.gray1,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: onTap != null ? 0 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: onTap != null
                        ? context.primaryColor.withOpacity(0.7)
                        : context.gray1.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
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
}
