import 'package:flutter/material.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';

/// The app's only switch.
///
/// Every toggle in the app goes through this widget so its colours live in one
/// file. Call sites pass `value` and `onChanged` and nothing else — a colour
/// passed at a call site is how the switch became unreadable in the first
/// place.
///
/// What was wrong: `AdaptiveSwitch(activeColor: gold)` sets the *track* gold,
/// while the theme resolved the selected *thumb* to gold as well. Gold on gold
/// left the on-state a faint blob with no edge, and off looked much the same.
///
/// What it does now: the on-track carries the brand gold and the thumb sits on
/// it in the page's own background colour, so the thumb reads as a hole punched
/// in a gold pill. Off is a hollow track with a visible outline. The two states
/// differ in fill, not just in shade, which also survives greyscale and the
/// common forms of colour blindness.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    required this.onChanged,
    super.key,
    this.semanticLabel,
  });

  final bool value;

  /// Null disables the switch.
  final ValueChanged<bool>? onChanged;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final enabled = onChanged != null;

    // The thumb takes the page background so the contrast against the gold
    // track is the same contrast the page already guarantees for its text.
    final onThumb = skin.ground;
    final offThumb = skin.inkSoft.withValues(alpha: enabled ? 0.85 : 0.35);

    final onTrack = enabled
        ? AppColors.gold
        : AppColors.gold.withValues(alpha: 0.35);
    final offTrack = skin.isDark
        ? skin.ink.withValues(alpha: 0.08)
        : skin.ink.withValues(alpha: 0.05);

    final switchWidget = Switch(
      value: value,
      onChanged: onChanged,
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected) ? onThumb : offThumb,
      ),
      trackColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected) ? onTrack : offTrack,
      ),
      // Without an outline the off-track is nearly the page colour and the
      // control disappears until it is switched on.
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected)
            ? Colors.transparent
            : skin.inkSoft.withValues(alpha: enabled ? 0.45 : 0.2),
      ),
      trackOutlineWidth: WidgetStateProperty.all(1.2),
      // The default M3 thumb grows when selected; a constant size keeps the
      // two states the same shape so only the colour changes.
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    if (semanticLabel == null) {
      return switchWidget;
    }

    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: switchWidget,
    );
  }
}
