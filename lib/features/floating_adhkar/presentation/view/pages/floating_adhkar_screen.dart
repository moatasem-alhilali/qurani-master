import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_item.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';
import 'package:quran_app/features/floating_adhkar/presentation/bloc/floating_adhkar_bloc.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/pages/floating_adhkar_my_adhkar_screen.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/pages/floating_adhkar_settings_screen.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/widgets/floating_adhkar_widgets.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/library_screen_kit.dart';
import 'package:quran_app/gen/fonts.gen.dart';

/// الأذكار العائمة.
///
/// كانت الشاشة ستة صناديق ملوّنة متلاصقة، كلٌّ منها بحدّ وخلفية، فلا يُعرف
/// أيّها المهم. الآن: حالة الخدمة وحدها ترتفع، وما دونها صفوف نحيلة
/// يفصلها خطّ شعرة.
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
        final skin = AppSkin.of(context);

        return GroundScaffoldTheme(
          child: AppScaffoldWidget(
            title: 'الأذكار العائمة',
            showLargeHeader: false,
            initialOffset: null,
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
                  onPressed: () => _openManageAdhkar(context),
                  icon: AppIcon(
                    AppIcons.bookOpen,
                    color: skin.accent,
                    size: 16.sp,
                  ),
                ),
                IconButton(
                  tooltip: 'الإعدادات',
                  onPressed:
                      settings == null ? null : () => _openSettings(context),
                  icon: AppIcon(
                    AppIcons.sliders,
                    color: skin.accent,
                    size: 16.sp,
                  ),
                ),
              ],
            ),
            body: ColoredBox(
              color: skin.ground,
              child: settings == null && state.loadState == RequestState.loading
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.h),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.gold),
                        ),
                      ),
                    )
                  : _Body(state: state),
            ),
          ),
        );
      },
    );
  }

  static void _openManageAdhkar(BuildContext context) {
    context.push(
      BlocProvider.value(
        value: context.read<FloatingAdhkarBloc>(),
        child: const FloatingAdhkarMyAdhkarScreen(),
      ),
    );
  }

  static void _openSettings(BuildContext context) {
    context.push(
      BlocProvider.value(
        value: context.read<FloatingAdhkarBloc>(),
        child: const FloatingAdhkarSettingsScreen(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.state});

  final FloatingAdhkarState state;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _showAdvancedSettings = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final settings = state.settings;
    if (settings == null) {
      return const SizedBox.shrink();
    }

    final skin = AppSkin.of(context);
    final isIosReminderMode = state.usesIosReminders;
    final canPreview = settings.enabled && state.hasOverlayPermission;
    final needsPermission =
        state.isSupportedPlatform && !state.hasOverlayPermission;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ServiceCard(state: state, settings: settings),
        skin.divider(),
        const HomeSectionHeader(title: 'معاينة الذكر'),
        _PreviewBlock(item: state.previewItem),
        skin.divider(),
        FloatingAdhkarRow(
          icon: AppIcons.settings,
          title: 'إعدادات متقدمة',
          subtitle: 'معدل الظهور ومدّة البقاء والمصادر',
          trailing: AppIcon(
            _showAdvancedSettings ? AppIcons.up : AppIcons.down,
            color: skin.accent,
            size: 15.sp,
          ),
          onTap: () => setState(
            () => _showAdvancedSettings = !_showAdvancedSettings,
          ),
        ),
        if (_showAdvancedSettings) ...[
          FloatingAdhkarRow(
            icon: AppIcons.clock,
            title: 'معدل الظهور',
            subtitle: formatFloatingInterval(settings.intervalMinutes),
            onTap: () => FloatingAdhkarScreen._openSettings(context),
          ),
          if (!isIosReminderMode)
            FloatingAdhkarRow(
              icon: AppIcons.eye,
              title: 'مدة بقاء الذكر',
              subtitle: '${settings.visibleSeconds} ثانية',
              onTap: () => FloatingAdhkarScreen._openSettings(context),
            ),
          FloatingAdhkarRow(
            icon: AppIcons.source,
            title: 'مصادر الأذكار',
            subtitle: describeFloatingSources(settings),
            onTap: () => FloatingAdhkarScreen._openSettings(context),
          ),
        ],
        skin.divider(),
        if (needsPermission)
          FloatingAdhkarRow(
            icon: AppIcons.security,
            title: isIosReminderMode
                ? 'السماح بالإشعارات'
                : 'منح الصلاحية المطلوبة',
            subtitle: 'بدونها لن يظهر الذكر فوق التطبيقات',
            tone: AppColors.error,
            onTap: () {
              context.read<FloatingAdhkarBloc>().add(
                    const FloatingAdhkarRequestOverlayPermissionEvent(),
                  );
            },
          ),
        FloatingAdhkarRow(
          icon: AppIcons.play,
          title: isIosReminderMode ? 'إرسال ذكر الآن' : 'عرض ذكر الآن',
          subtitle: canPreview
              ? 'جرّب شكل الذكر كما سيظهر لك'
              : 'فعّل الخدمة وامنح الصلاحية أولًا',
          enabled: canPreview,
          onTap: () {
            context
                .read<FloatingAdhkarBloc>()
                .add(const FloatingAdhkarPreviewNowEvent());
          },
        ),
        FloatingAdhkarRow(
          icon: AppIcons.noteEdit,
          title: 'إدارة الأذكار',
          subtitle: 'اختر ما يظهر من الافتراضي وأضف أذكارك',
          isLast: true,
          onTap: () => FloatingAdhkarScreen._openManageAdhkar(context),
        ),
        SizedBox(height: 18.h),
      ],
    );
  }
}

/// حالة الخدمة ومفتاحها وإحصاؤها: العنصر المرتفع الوحيد في الشاشة.
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.state, required this.settings});

  final FloatingAdhkarState state;
  final FloatingAdhkarSettings settings;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final isIosReminderMode = state.usesIosReminders;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 6.h),
      child: Container(
        decoration: BoxDecoration(
          color: skin.raised,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: skin.raisedBorder.withValues(alpha: 0.55),
          ),
          boxShadow: skin.raisedShadow,
        ),
        padding: EdgeInsets.fromLTRB(12.w, 10.h, 10.w, 11.h),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: skin.iconChip,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Center(
                    child: AppIcon(
                      AppIcons.layers,
                      color: skin.accent,
                      size: 16.sp,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isIosReminderMode ? 'تذكيرات iPhone' : 'الخدمة العائمة',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        state.isSupportedPlatform
                            ? state.status.label
                            : 'غير مدعوم على هذه المنصة',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.accent,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: settings.enabled,
                  activeTrackColor: AppColors.gold,
                  onChanged: state.isSupportedPlatform
                      ? (value) {
                          context.read<FloatingAdhkarBloc>().add(
                                FloatingAdhkarToggleFeatureEvent(value),
                              );
                        }
                      : null,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Divider(height: 1, thickness: 1, color: skin.hairline),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _ServiceStat(
                    label: 'الافتراضية',
                    value: '${state.counts.builtInCount}',
                  ),
                ),
                Container(width: 1, height: 20.h, color: skin.hairline),
                Expanded(
                  child: _ServiceStat(
                    label: 'الخاصة',
                    value: '${state.counts.customEnabledCount} '
                        'من ${state.counts.customTotalCount}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceStat extends StatelessWidget {
  const _ServiceStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: skin.accent,
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.78),
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// نصّ الذكر كما سيظهر — على الأرضية مباشرة، الخطّ وحده يميّزه.
class _PreviewBlock extends StatelessWidget {
  const _PreviewBlock({required this.item});

  final FloatingAdhkarItem? item;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final hasText = item?.text.trim().isNotEmpty ?? false;
    final text = hasText ? item!.text : 'اللهم أعني على ذكرك وشكرك وحسن عبادتك';
    final source = item?.sourceLabel ?? 'افتراضي';

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: FontFamily.scheherazade,
              color: skin.ink,
              fontSize: 16.sp,
              height: 1.9,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            item?.title ?? source,
            style: TextStyle(
              color: skin.accent,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
