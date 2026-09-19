import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/snackbar_export.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_preset_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_item_model.dart';
import 'package:quran_app/features/daily_wird/presentation/bloc/daily_wird_bloc.dart';
import 'package:quran_app/features/daily_wird/presentation/view/daily_wird_destination_resolver.dart';
import 'package:quran_app/features/daily_wird/presentation/view/pages/daily_wird_focus_screen.dart';
import 'package:quran_app/features/daily_wird/presentation/view/widgets/daily_wird_common.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/l10n/l10n.dart';

part 'daily_wird_screen_body_part.dart';
part 'daily_wird_screen_presets_part.dart';
part 'daily_wird_screen_items_part.dart';
part 'daily_wird_screen_reminder_part.dart';

class DailyWirdScreen extends StatelessWidget {
  const DailyWirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (_) => sl<DailyWirdBloc>()..add(const DailyWirdLoadEvent()),
      child: BlocConsumer<DailyWirdBloc, DailyWirdState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          context.showCustomSnackbar(
            state.errorMessage ?? context.l10n.dailyWirdUnexpectedError,
            style: SnackBarType.error,
          );
        },
        builder: (context, state) {
          // أرضية واحدة من الترويسة إلى آخر عمل في الزاد.
          return Theme(
            data: Theme.of(context)
                .copyWith(scaffoldBackgroundColor: skin.ground),
            child: AppScaffoldWidget(
              title: context.l10n.dailyWirdTitle,
              showLargeHeader: false,
              initialOffset: null,
              onRefresh: () async {
                context.read<DailyWirdBloc>().add(const DailyWirdLoadEvent());
              },
              trailing: IconButton(
                tooltip: context.l10n.dailyWirdSettingsTooltip,
                onPressed: state.settings == null
                    ? null
                    : () => _showSettingsSheet(context, state),
                icon: AppIcon(
                  AppIcons.settings,
                  color: state.settings == null
                      ? skin.inkSoft.withValues(alpha: 0.38)
                      : skin.accent,
                  size: 18.sp,
                ),
              ),
              body: ColoredBox(
                color: skin.ground,
                child: _Body(state: state),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showSettingsSheet(
    BuildContext context,
    DailyWirdState state,
  ) async {
    final settings = state.settings;
    if (settings == null) {
      return;
    }
    final dailyWirdBloc = context.read<DailyWirdBloc>();
    final skin = AppSkin.of(context);

    var draft = settings;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: skin.ground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ColoredBox(
              color: skin.ground,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 20.h),
                children: [
                  SizedBox(height: 10.h),
                  Center(
                    child: Container(
                      width: 34.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: skin.hairline,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                  ),
                  HomeSectionHeader(
                    title: context.l10n.dailyWirdRemindersHeader,
                  ),
                  _ReminderRow(
                    label: context.l10n.wirdMorningAdhkar,
                    value: draft.morningReminderEnabled,
                    time: draft.morningReminderTime,
                    onChanged: (value) => setState(() {
                      draft = draft.copyWith(morningReminderEnabled: value);
                    }),
                    onPickTime: () async {
                      final selected =
                          await _pickTime(context, draft.morningReminderTime);
                      if (selected == null) return;
                      setState(() {
                        draft = draft.copyWith(morningReminderTime: selected);
                      });
                    },
                  ),
                  _ReminderRow(
                    label: context.l10n.wirdEveningAdhkar,
                    value: draft.eveningReminderEnabled,
                    time: draft.eveningReminderTime,
                    onChanged: (value) => setState(() {
                      draft = draft.copyWith(eveningReminderEnabled: value);
                    }),
                    onPickTime: () async {
                      final selected =
                          await _pickTime(context, draft.eveningReminderTime);
                      if (selected == null) return;
                      setState(() {
                        draft = draft.copyWith(eveningReminderTime: selected);
                      });
                    },
                  ),
                  _ReminderRow(
                    label: context.l10n.dailyWirdReminderSleepLabel,
                    value: draft.nightReminderEnabled,
                    time: draft.nightReminderTime,
                    onChanged: (value) => setState(() {
                      draft = draft.copyWith(nightReminderEnabled: value);
                    }),
                    onPickTime: () async {
                      final selected =
                          await _pickTime(context, draft.nightReminderTime);
                      if (selected == null) return;
                      setState(() {
                        draft = draft.copyWith(nightReminderTime: selected);
                      });
                    },
                  ),
                  _ReminderRow(
                    label: context.l10n.dailyWirdReminderSummaryTitle,
                    value: draft.endOfDaySummaryEnabled,
                    time: draft.endOfDaySummaryTime,
                    isLast: true,
                    onChanged: (value) => setState(() {
                      draft = draft.copyWith(endOfDaySummaryEnabled: value);
                    }),
                    onPickTime: () async {
                      final selected =
                          await _pickTime(context, draft.endOfDaySummaryTime);
                      if (selected == null) return;
                      setState(() {
                        draft = draft.copyWith(endOfDaySummaryTime: selected);
                      });
                    },
                  ),
                  skin.divider(),
                  HomeSectionHeader(title: context.l10n.dailyWirdProgramHeader),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: [
                        for (final preset in state.presets)
                          DailyWirdChoiceChip(
                            label: preset.name,
                            selected: draft.selectedPresetId == preset.id,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                draft = draft.copyWith(
                                  selectedPresetId: preset.id,
                                  onboardingCompleted: true,
                                );
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: DailyWirdPrimaryButton(
                      label: context.l10n.dailyWirdSaveSetup,
                      icon: AppIcons.save,
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        if (draft.selectedPresetId !=
                                settings.selectedPresetId &&
                            draft.selectedPresetId != null) {
                          dailyWirdBloc.add(
                            DailyWirdSelectPresetEvent(draft.selectedPresetId!),
                          );
                        }
                        dailyWirdBloc.add(DailyWirdUpdateSettingsEvent(draft));
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _pickTime(BuildContext context, String initialValue) async {
    final parts = initialValue.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.first) ?? 7,
      minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
    );
    final selected = await AdaptiveTimePicker.show(
      context: context,
      initialTime: initial,
    );
    if (selected == null) {
      return null;
    }
    return _toTimeString(selected);
  }

  String _toTimeString(TimeOfDay value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
