import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_schedule_model.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_permission_service.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_call_logs_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_execution_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_settings_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_upsert_schedule_screen.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_schedule_item_card.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_ui_kit.dart';

part 'smart_outreach_schedules_screen_logic_part.dart';

class SmartOutreachSchedulesScreen extends StatelessWidget {
  const SmartOutreachSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SmartOutreachSchedulesBloc>(
      create: (_) => sl<SmartOutreachSchedulesBloc>()
        ..add(const LoadSmartOutreachSchedulesEvent()),
      child: const _SmartOutreachSchedulesView(),
    );
  }
}

class _SmartOutreachSchedulesView extends StatefulWidget {
  const _SmartOutreachSchedulesView();

  @override
  State<_SmartOutreachSchedulesView> createState() =>
      _SmartOutreachSchedulesViewState();
}

class _SmartOutreachSchedulesViewState
    extends State<_SmartOutreachSchedulesView> with WidgetsBindingObserver {
  final SmartOutreachPermissionService _permissionService =
      SmartOutreachPermissionService();

  SmartOutreachPermissionSnapshot? _permissionSnapshot;
  bool _isCheckingPermissions = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensurePermissions(requestIfNeeded: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// بوّابة [setState] لامتداد هذه الحالة في ملفّ الجزء.
  ///
  /// `setState` معلَّم `@protected`، فنداؤه من امتداد — ولو كان في المكتبة
  /// نفسها — يرفع `invalid_use_of_protected_member`.
  void rebuild(VoidCallback fn) => setState(fn);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocConsumer<SmartOutreachSchedulesBloc,
        SmartOutreachSchedulesState>(
      listener: (context, state) {
        if (state.validationErrors.isEmpty) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(state.validationErrors.join('\n'))),
          );

        context
            .read<SmartOutreachSchedulesBloc>()
            .add(const ClearSmartOutreachScheduleFeedbackEvent());
      },
      builder: (context, state) {
        return AppScaffoldWidget(
          title: 'صحبة الفجر',
          showLargeHeader: false,
          initialOffset: null,
          onRefresh: () async {
            context
                .read<SmartOutreachSchedulesBloc>()
                .add(const LoadSmartOutreachSchedulesEvent());
          },
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              _openUpsertScreen(context);
            },
            backgroundColor: skin.accent,
            foregroundColor: outreachOnAccent(skin),
            tooltip: 'إضافة قائمة',
            child: AppIcon(
              AppIcons.add,
              color: outreachOnAccent(skin),
              size: 19.sp,
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    SmartOutreachSchedulesState state,
  ) {
    final skin = AppSkin.of(context);
    final notice = _buildPermissionsNotice();
    final enabledCount =
        state.schedules.where((bundle) => bundle.schedule.isEnabled).length;
    final contactsCount = state.schedules.fold<int>(
      0,
      (total, bundle) => total + bundle.contacts.length,
    );

    return OutreachGround(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
          child: Text(
            'قوائم اتصال هادئة تبدأ يوم من تحبّ بالخير',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
        OutreachStatsRow(
          cells: <OutreachStatCell>[
            OutreachStatCell(
              label: 'القوائم',
              value: '${state.schedules.length}',
            ),
            OutreachStatCell(label: 'المفعّلة', value: '$enabledCount'),
            OutreachStatCell(label: 'الأرقام', value: '$contactsCount'),
          ],
        ),
        if (notice != null) notice,
        const HomeSectionHeader(title: 'قوائم الاتصال'),
        _buildContent(context, state),
        skin.divider(),
        const HomeSectionHeader(title: 'أدوات'),
        OutreachRow(
          title: 'سجل المكالمات',
          subtitle: 'نتيجة كل اتصال: من ردّ ومن لم يردّ',
          icon: AppIcons.clock,
          showChevron: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SmartOutreachCallLogsScreen(),
              ),
            );
          },
        ),
        OutreachRow(
          title: 'إعدادات الاتصال',
          subtitle: 'المدد الافتراضية وسلوك القوائم الجديدة',
          icon: AppIcons.settings,
          showChevron: true,
          isLast: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SmartOutreachSettingsScreen(),
              ),
            );
          },
        ),
        SizedBox(height: 64.h),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    SmartOutreachSchedulesState state,
  ) {
    if (state.loadState == RequestState.loading && state.schedules.isEmpty) {
      return const OutreachLoading();
    }

    if (state.schedules.isEmpty) {
      return OutreachEmptyState(
        title: 'لا توجد قوائم بعد',
        icon: AppIcons.contacts,
        message: 'أضف قائمة وحدّد وقتها والأرقام التي تودّ الاتصال بها.',
        actionLabel: 'إضافة قائمة',
        onAction: () => _openUpsertScreen(context),
      );
    }

    final nextIndex = _nextScheduleIndex(state.schedules);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final entry in state.schedules.asMap().entries)
          SmartOutreachScheduleItemCard(
            bundle: entry.value,
            isNext: entry.key == nextIndex,
            isLast: entry.key == state.schedules.length - 1,
            countdownLabel: entry.key == nextIndex
                ? _remainingLabel(_minutesUntilNextRun(entry.value.schedule))
                : null,
            onTap: () => _openUpsertScreen(context, bundle: entry.value),
            onStart: () => _handleStartNow(context, entry.value.schedule.id!),
            onDelete: () {
              context.read<SmartOutreachSchedulesBloc>().add(
                    DeleteSmartOutreachScheduleEvent(entry.value.schedule.id!),
                  );
            },
            onToggle: (enabled) => _handleToggle(
              context,
              scheduleId: entry.value.schedule.id!,
              enabled: enabled,
            ),
          ),
      ],
    );
  }

  /// الجدولة الأقرب موعدًا بين المفعّلة — هي وحدها التي ترتفع في الشاشة.
}
