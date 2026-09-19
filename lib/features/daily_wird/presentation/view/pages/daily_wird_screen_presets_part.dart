part of 'daily_wird_screen.dart';

/// اختيار البرنامج أول مرّة: صفوف نحيلة، وكل صفّ باب لزادٍ جاهز.
class _PresetSelectionSection extends StatelessWidget {
  const _PresetSelectionSection({required this.presets});

  final List<DailyWirdPreset> presets;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.dailyWirdChoosePresetTitle,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                context.l10n.dailyWirdChoosePresetSubtitle,
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
        skin.divider(),
        for (var i = 0; i < presets.length; i++)
          _PresetRow(
            preset: presets[i],
            isLast: i == presets.length - 1,
          ),
        SizedBox(height: 22.h),
      ],
    );
  }
}

class _PresetRow extends StatelessWidget {
  const _PresetRow({required this.preset, required this.isLast});

  final DailyWirdPreset preset;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<DailyWirdBloc>().add(
              DailyWirdSelectPresetEvent(preset.id),
            );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          children: [
            const DailyWirdIconChip(icon: AppIcons.quran),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    preset.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    preset.description,
                    maxLines: 2,
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
            AppIcon(
              Directionality.of(context) == TextDirection.rtl
                  ? AppIcons.chevronLeft
                  : AppIcons.chevronRight,
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}
