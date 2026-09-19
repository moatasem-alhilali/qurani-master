part of 'prayer_time_settings_screen.dart';

/// مدّة الصامت: رقم يُكتب مباشرة، مع زرّي نقصان وزيادة للتعديل السريع.
class _DurationRow extends StatefulWidget {
  const _DurationRow({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  State<_DurationRow> createState() => _DurationRowState();
}

class _DurationRowState extends State<_DurationRow> {
  late final TextEditingController _controller =
      TextEditingController(text: '${widget.value}');

  @override
  void didUpdateWidget(covariant _DurationRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لا نلمس الحقل ما دام المستخدم يكتب فيه القيمة نفسها.
    if (widget.value != oldWidget.value &&
        _controller.text != '${widget.value}') {
      _controller.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _step(int delta) {
    final next = (widget.value + delta).clamp(1, 360);
    HapticFeedback.selectionClick();
    _controller.text = '$next';
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      child: Row(
        children: [
          SizedBox(width: 38.w),
          Expanded(
            child: Text(
              context.l10n.prayerTimeSilentDuration,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _DurationStepButton(
            icon: Icons.remove_rounded,
            enabled: widget.enabled && widget.value > 1,
            onTap: () => _step(-5),
          ),
          SizedBox(
            width: 54.w,
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              cursorColor: skin.accent,
              style: TextStyle(
                color: skin.accent,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                fontFeatures: const [ui.FontFeature.tabularFigures()],
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                suffixText: context.l10n.prayerTimeMinutesSuffix,
                suffixStyle: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.7),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: skin.hairline),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: skin.hairline),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: skin.accent),
                ),
              ),
              onChanged: (text) {
                final parsed = int.tryParse(text.trim());
                if (parsed != null) {
                  widget.onChanged(parsed);
                }
              },
            ),
          ),
          _DurationStepButton(
            icon: Icons.add_rounded,
            enabled: widget.enabled && widget.value < 360,
            onTap: () => _step(5),
          ),
        ],
      ),
    );
  }
}

class _DurationStepButton extends StatelessWidget {
  const _DurationStepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(9.r),
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: enabled ? skin.iconChip : Colors.transparent,
          borderRadius: BorderRadius.circular(9.r),
          border: enabled ? null : Border.all(color: skin.hairline),
        ),
        child: Icon(
          icon,
          size: 15.sp,
          color: enabled ? skin.accent : skin.inkSoft.withValues(alpha: 0.38),
        ),
      ),
    );
  }
}
