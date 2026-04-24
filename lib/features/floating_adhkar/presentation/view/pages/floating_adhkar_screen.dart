import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';
import 'package:quran_app/features/floating_adhkar/presentation/bloc/floating_adhkar_bloc.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/pages/floating_adhkar_my_adhkar_screen.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/pages/floating_adhkar_settings_screen.dart';

class FloatingAdhkarScreen extends StatelessWidget {
  const FloatingAdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FloatingAdhkarBloc, FloatingAdhkarState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null || message.trim().isEmpty) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        final settings = state.settings;

        return AppScaffoldWidget(
          title: 'الأذكار العشوائية العائمة',
          onRefresh: () async {
            context
                .read<FloatingAdhkarBloc>()
                .add(const FloatingAdhkarLoadEvent());
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'إدارة الأذكار',
                onPressed: () {
                  context.push(
                    BlocProvider.value(
                      value: context.read<FloatingAdhkarBloc>(),
                      child: const FloatingAdhkarMyAdhkarScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.menu_book_rounded),
              ),
              IconButton(
                tooltip: 'الإعدادات',
                onPressed: settings == null
                    ? null
                    : () {
                        context.push(
                          BlocProvider.value(
                            value: context.read<FloatingAdhkarBloc>(),
                            child: const FloatingAdhkarSettingsScreen(),
                          ),
                        );
                      },
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
          body: settings == null && state.loadState == RequestState.loading
              ? const Center(child: CircularProgressIndicator())
              : _Body(state: state),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final FloatingAdhkarState state;

  @override
  Widget build(BuildContext context) {
    final settings = state.settings;
    if (settings == null) {
      return const SizedBox.shrink();
    }

    final accent = context.primaryColor;
    final customCountLabel =
        '${state.counts.customEnabledCount}/${state.counts.customTotalCount}';

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatusCard(state: state),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'الأذكار الافتراضية',
                  value: '${state.counts.builtInCount}',
                  icon: Icons.auto_awesome_rounded,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _StatCard(
                  title: 'أذكارك الخاصة',
                  value: customCountLabel,
                  icon: Icons.menu_book_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _PreviewCard(item: state.previewItem),
          SizedBox(height: 14.h),
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: context.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: settings.enabled,
                  onChanged: state.isSupportedPlatform
                      ? (value) {
                          context.read<FloatingAdhkarBloc>().add(
                                FloatingAdhkarToggleFeatureEvent(value),
                              );
                        }
                      : null,
                  title: const Text('تشغيل الخدمة'),
                  subtitle: Text(
                    state.isSupportedPlatform
                        ? 'تستمر بالعمل في الخلفية وتعرض '
                            'ذكرًا واحدًا في كل مرة.'
                        : 'الظهور فوق التطبيقات الأخرى '
                            'غير مدعوم على هذه المنصة.',
                  ),
                ),
                Divider(
                  height: 1,
                  color: context.outline.withValues(alpha: 0.16),
                ),
                ListTile(
                  leading: Icon(Icons.timer_outlined, color: accent),
                  title: const Text('معدل الظهور'),
                  subtitle: Text(_formatIntervalText(settings.intervalMinutes)),
                ),
                ListTile(
                  leading: Icon(Icons.visibility_outlined, color: accent),
                  title: const Text('مدة بقاء الذكر'),
                  subtitle: Text('${settings.visibleSeconds} ثانية'),
                ),
                ListTile(
                  leading: Icon(Icons.merge_type_rounded, color: accent),
                  title: const Text('مصادر الأذكار'),
                  subtitle: Text(
                    _describeSources(settings),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          FilledButton.icon(
            onPressed: settings.enabled && state.hasOverlayPermission
                ? () {
                    context
                        .read<FloatingAdhkarBloc>()
                        .add(const FloatingAdhkarPreviewNowEvent());
                  }
                : null,
            icon: const Icon(Icons.play_circle_outline_rounded),
            label: const Text('عرض ذكر الآن'),
          ),
          SizedBox(height: 8.h),
          OutlinedButton.icon(
            onPressed: state.isSupportedPlatform && !state.hasOverlayPermission
                ? () {
                    context.read<FloatingAdhkarBloc>().add(
                          const FloatingAdhkarRequestOverlayPermissionEvent(),
                        );
                  }
                : () {
                    context.push(
                      BlocProvider.value(
                        value: context.read<FloatingAdhkarBloc>(),
                        child: const FloatingAdhkarSettingsScreen(),
                      ),
                    );
                  },
            icon: Icon(
              state.isSupportedPlatform && !state.hasOverlayPermission
                  ? Icons.security_rounded
                  : Icons.tune_rounded,
            ),
            label: Text(
              state.isSupportedPlatform && !state.hasOverlayPermission
                  ? 'منح الصلاحية المطلوبة'
                  : 'فتح الإعدادات',
            ),
          ),
          SizedBox(height: 8.h),
          OutlinedButton.icon(
            onPressed: () {
              context.push(
                BlocProvider.value(
                  value: context.read<FloatingAdhkarBloc>(),
                  child: const FloatingAdhkarMyAdhkarScreen(),
                ),
              );
            },
            icon: const Icon(Icons.edit_note_rounded),
            label: const Text('إدارة الأذكار'),
          ),
        ],
      ),
    );
  }

  String _describeSources(FloatingAdhkarSettings settings) {
    if (settings.includeBuiltIn && settings.includeCustom) {
      return settings.mixSources
          ? 'دمج بين الافتراضي والمخصص'
          : 'تناوب بين الافتراضي والمخصص';
    }
    if (settings.includeBuiltIn) {
      return 'الأذكار الافتراضية فقط';
    }
    if (settings.includeCustom) {
      return 'أذكار المستخدم فقط';
    }
    return 'لا يوجد مصدر مفعّل';
  }

  String _formatIntervalText(int minutes) {
    if (minutes == 1) {
      return 'كل دقيقة';
    }

    return 'كل $minutes دقائق';
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.state});

  final FloatingAdhkarState state;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final status = state.status;
    final settings = state.settings;
    final titleColor = context.onSurfaceColor;
    final subtitleColor = context.onSurfaceVariant.withValues(alpha: 0.88);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            context.surfaceColor,
            context.surfaceVariant.withValues(alpha: 0.55),
          ],
        ),
        border: Border.all(
          color: accent.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Icon(
                    Icons.layers_clear_rounded,
                    color: accent,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'حالة الميزة',
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        status.label,
                        style: TextStyle(
                          color: accent,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Text(
              _buildDescription(
                status: status,
                isEnabled: settings?.enabled ?? false,
              ),
              style: TextStyle(
                color: subtitleColor,
                fontSize: 12.2.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildDescription({
    required FloatingAdhkarFeatureStatus status,
    required bool isEnabled,
  }) {
    switch (status) {
      case FloatingAdhkarFeatureStatus.unsupported:
        return 'النافذة العائمة فوق التطبيقات الأخرى '
            'متاحة على أندرويد فقط. يمكنك إدارة الأذكار '
            'من داخل التطبيق، لكن التشغيل الخارجي غير متوفر هنا.';
      case FloatingAdhkarFeatureStatus.permissionRequired:
        return 'الميزة جاهزة، لكنها تحتاج إلى صلاحية '
            'الظهور فوق التطبيقات الأخرى قبل البدء.';
      case FloatingAdhkarFeatureStatus.misconfigured:
        return 'فعّل مصدرًا واحدًا على الأقل، أو فعّل '
            'بعض أذكارك الخاصة حتى يبدأ التدوير العشوائي.';
      case FloatingAdhkarFeatureStatus.active:
        return 'الخدمة تعمل الآن في الخلفية. سيظهر ذكر '
            'واحد ثم يختفي عند الضغط أو بعد انتهاء المدة المحددة.';
      case FloatingAdhkarFeatureStatus.inactive:
        return isEnabled
            ? 'الإعدادات محفوظة، لكن الخدمة ليست نشطة '
                'حاليًا. يمكنك إعادة المعاينة أو فتح الإعدادات.'
            : 'الميزة متوقفة الآن. عند تشغيلها ستعرض '
                'الأذكار فوق التطبيقات الأخرى حسب ضبطك.';
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: context.outline.withValues(alpha: 0.22),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accent, size: 22.sp),
            SizedBox(height: 10.h),
            Text(
              value,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                color: context.onSurfaceVariant,
                fontSize: 11.4.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.item});

  final FloatingAdhkarItem? item;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final text = item?.text.trim().isNotEmpty ?? false
        ? item!.text
        : 'اللهم أعني على ذكرك وشكرك وحسن عبادتك';
    final title = item?.title ?? 'معاينة شكل البطاقة';
    final source = item?.sourceLabel ?? 'افتراضي';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: accent,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  source,
                  style: TextStyle(
                    color: context.onSurfaceVariant,
                    fontSize: 10.5.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Text(
              text,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
