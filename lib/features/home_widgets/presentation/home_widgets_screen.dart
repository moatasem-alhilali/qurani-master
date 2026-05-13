import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/home_widgets/home_widgets_service.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';

class HomeWidgetsScreen extends StatefulWidget {
  const HomeWidgetsScreen({super.key});

  @override
  State<HomeWidgetsScreen> createState() => _HomeWidgetsScreenState();
}

class _HomeWidgetsScreenState extends State<HomeWidgetsScreen> {
  final HomeWidgetsService _service = HomeWidgetsService();
  bool _isRefreshing = false;
  bool _isPinSupported = false;

  @override
  void initState() {
    super.initState();
    _loadSupport();
  }

  Future<void> _loadSupport() async {
    final supported = await _service.isAndroidPinSupported();
    if (!mounted) return;
    setState(() => _isPinSupported = supported);
  }

  Future<void> _refreshWidgets() async {
    setState(() => _isRefreshing = true);
    try {
      await _service.refreshAll();
      await _service.startBackgroundUpdates();
      _showMessage('تم تحديث التطبيقات المصغرة وتفعيل التحديث بالخلفية');
    } catch (_) {
      _showMessage('تعذر تحديث التطبيقات المصغرة الآن');
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _pin(HomeWidgetType type) async {
    final didRequest = await _service.requestPinWidget(type);
    _showMessage(
      didRequest
          ? 'تم إرسال طلب إضافة التطبيق المصغر'
          : 'التثبيت المباشر غير مدعوم على هذا الجهاز',
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'التطبيقات المصغرة',
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 28.h),
        children: [
          _InfoPanel(
            title: defaultTargetPlatform == TargetPlatform.iOS
                ? 'ويدجتات iPhone جاهزة'
                : 'ويدجتات Android جاهزة',
            subtitle: defaultTargetPlatform == TargetPlatform.iOS
                ? 'أضفها من شاشة التطبيقات المصغرة، وتشمل ويدجتات شاشة '
                    'القفل للصلاة والذكر.'
                : 'يمكنك إضافتها يدويا، أو تثبيتها مباشرة من الأزرار إذا '
                    'كان المشغل يدعم ذلك.',
            icon: Icons.widgets_rounded,
          ),
          SizedBox(height: 14.h),
          FilledButton.icon(
            onPressed: _isRefreshing ? null : _refreshWidgets,
            icon: _isRefreshing
                ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
            label: const Text('تحديث وتفعيل التحديث بالخلفية'),
          ),
          SizedBox(height: 14.h),
          _WidgetOptionTile(
            title: 'الصلاة القادمة',
            subtitle: 'وقت الصلاة القادمة والوقت المتبقي',
            icon: Icons.access_time_filled_rounded,
            canPin: _isPinSupported,
            onPin: () => _pin(HomeWidgetType.prayer),
          ),
          _WidgetOptionTile(
            title: 'ذكر عشوائي',
            subtitle: 'ذكر متجدد من مصادر الأذكار',
            icon: Icons.auto_awesome_rounded,
            canPin: _isPinSupported,
            onPin: () => _pin(HomeWidgetType.dhikr),
          ),
          _WidgetOptionTile(
            title: 'آية اليوم',
            subtitle: 'آية يومية من مكتبة القرآن داخل التطبيق',
            icon: Icons.menu_book_rounded,
            canPin: _isPinSupported,
            onPin: () => _pin(HomeWidgetType.ayah),
          ),
          _WidgetOptionTile(
            title: 'ورد اليوم',
            subtitle: 'متابعة مختصرة للتقدم اليومي',
            icon: Icons.task_alt_rounded,
            canPin: _isPinSupported,
            onPin: () => _pin(HomeWidgetType.wird),
          ),
          if (defaultTargetPlatform == TargetPlatform.iOS) ...[
            const SizedBox(height: 10),
            const _InfoPanel(
              title: 'شاشة القفل',
              subtitle:
                  'أضفت ويدجت صلاة القفل وذكر القفل بصيغ iOS Lock Screen: '
                  'Inline وRectangular وCircular.',
              icon: Icons.lock_rounded,
              compact: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.compact = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 13.w : 16.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: context.outline.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.primaryColor,
            size: compact ? 20.sp : 26.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: compact ? 12.sp : 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: context.onSurfaceVariant,
                    fontSize: compact ? 10.sp : 11.sp,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetOptionTile extends StatelessWidget {
  const _WidgetOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.canPin,
    required this.onPin,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool canPin;
  final VoidCallback onPin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.outline.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.primaryColor, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurfaceVariant,
                    fontSize: 10.sp,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'تثبيت',
            onPressed: canPin ? onPin : null,
            icon: const Icon(Icons.push_pin_rounded),
          ),
        ],
      ),
    );
  }
}
