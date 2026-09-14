part of 'next_prayer_countdown_widget.dart';

/// المشهد العلوي: سماء تتبدّل مع وقت الصلاة، وقوس اليوم، وظلّ الأفق.
class _SkyHeroPanel extends StatelessWidget {
  const _SkyHeroPanel({
    required this.palette,
    required this.pathData,
    required this.locationLabel,
    required this.currentPrayerLabel,
    required this.countdownText,
    required this.onSettingsTap,
    this.reveal = 1,
    this.notice,
  });

  /// نسبة ظهور القوس في لحظة الافتتاح.
  final double reveal;

  final _SkyPalette palette;
  final _SkyPathData pathData;
  final String locationLabel;
  final String currentPrayerLabel;
  final String countdownText;
  final VoidCallback onSettingsTap;
  final _LocationNoticeConfig? notice;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final topInset = MediaQuery.paddingOf(context).top;

    // أيقونات شريط الحالة تنقلب مع سطوع السماء: فاتحة في الفجر والمغرب
    // والعشاء، وداكنة في وضح النهار — وإلا اختفت فوق سماء الظهر.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: palette.lightStatusBarIcons
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: palette.sky,
              stops: palette.stops,
            ),
          ),
          child: Stack(
            children: [
              if (palette.hasStars)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _StarFieldPainter(color: palette.ink),
                  ),
                ),
              Positioned.fill(
                child: Align(
                  alignment: palette.orbAlignment,
                  child: _SkyOrb(palette: palette),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: (topInset + 4.h).clamp(10.h, 62.h)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Row(
                      children: [
                        // Expanded + Align: الشارة تأخذ عرضها الطبيعي فقط،
                        // وزرّ الإعدادات يبقى ملتصقًا بالحافة المقابلة.
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: _SkyChip(
                              palette: palette,
                              icon: AppIcons.mapPin,
                              label: locationLabel,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _SkyIconButton(
                          palette: palette,
                          icon: AppIcons.settings,
                          onTap: onSettingsTap,
                          tooltip: 'الإعدادات',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'أنت الآن في وقت',
                    style: TextStyle(
                      color: palette.inkSoft.withValues(alpha: 0.84),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    currentPrayerLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.ink,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.28,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  _SkyChip(
                    palette: palette,
                    icon: AppIcons.clock,
                    label: countdownText,
                    emphasised: true,
                  ),
                  if (notice != null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
                      child: _LocationNoticeCard(
                        notice: notice!,
                        palette: palette,
                      ),
                    ),
                  SizedBox(height: 6.h),
                  // القوس وخطّ الأفق يتراكبان: نهاية القوس تنزل خلف الأرض
                  // بدل أن تقف فوقها، فيبدو المشهد طبقةً واحدة.
                  SizedBox(
                    height: 104.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 22.w,
                          left: 22.w,
                          height: 72.h,
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _SunPathPainter(
                              data: pathData,
                              ink: palette.ink,
                              orbCore: palette.orbCore,
                              reveal: reveal,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          height: 48.h,
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _HorizonPainter(
                              // في الوضع الداكن يأخذ الأفق لون الأرضية
                              // نفسها، فيبدو المسجد محفورًا في الليل
                              // ولا يبقى خطّ قطع بين المشهد والمحتوى.
                              color: skin.isDark
                                  ? skin.ground
                                  : palette.horizon.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// وهج الضوء في السماء — لا قرص صلب.
///
/// الشمس نفسها هي العلامة المتحرّكة على القوس؛ قرصٌ ثانٍ هنا كان يزاحم
/// اسم الصلاة ويربك المعنى. ما بقي هو أثر الضوء فقط.
class _SkyOrb extends StatelessWidget {
  const _SkyOrb({required this.palette});

  final _SkyPalette palette;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 190.w,
        height: 190.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              palette.orbCore.withValues(alpha: 0.32),
              palette.orbGlow.withValues(alpha: 0.13),
              palette.orbGlow.withValues(alpha: 0),
            ],
            stops: const [0, 0.42, 1],
          ),
        ),
      ),
    );
  }
}

/// شارة زجاجية فوق السماء — تأخذ لونها من لوحة الوقت الحالية.
class _SkyChip extends StatelessWidget {
  const _SkyChip({
    required this.palette,
    required this.icon,
    required this.label,
    this.emphasised = false,
  });

  final _SkyPalette palette;
  final HugeIconData icon;
  final String label;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: emphasised ? 12.w : 9.w,
        vertical: emphasised ? 5.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: palette.veil.withValues(alpha: emphasised ? 0.26 : 0.18),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: palette.veil.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(icon, color: palette.ink.withValues(alpha: 0.9), size: 13.sp),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: palette.ink,
                fontSize: emphasised ? 11.5.sp : 10.5.sp,
                fontWeight: emphasised ? FontWeight.w700 : FontWeight.w600,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkyIconButton extends StatelessWidget {
  const _SkyIconButton({
    required this.palette,
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final _SkyPalette palette;
  final HugeIconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.veil.withValues(alpha: 0.18),
            border: Border.all(color: palette.veil.withValues(alpha: 0.32)),
          ),
          child: Center(
            child: AppIcon(icon, color: palette.ink, size: 16.sp),
          ),
        ),
      ),
    );
  }
}

/// مواقيت اليوم: التاريخ ثم صفوف نحيلة على الأرضية مباشرة.
///
/// لا صندوق حول القائمة ولا ظل: الارتفاع الوحيد في الشاشة كلها محجوز
/// لصفّ الصلاة الحالية، فتقع عليه العين أولًا بلا منافس.
class _PrayerBoard extends StatelessWidget {
  const _PrayerBoard({
    required this.entries,
    required this.hijriText,
    required this.gregorianText,
    required this.windowProgress,
    required this.remainingText,
    required this.onOpenAll,
  });

  final List<_PrayerMiniEntry> entries;
  final String hijriText;
  final String gregorianText;

  /// ما مضى من وقت الصلاة الحالية إلى التي بعدها، من ٠ إلى ١.
  final double windowProgress;

  /// «بقي ٤٥ د» — يظهر تحت الصفّ المرتفع.
  final String remainingText;

  final VoidCallback onOpenAll;

  int get _highlightIndex {
    final current = entries.indexWhere((e) => e.isCurrent);
    if (current != -1) return current;
    return entries.indexWhere((e) => e.isNext);
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final highlight = _highlightIndex;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gregorianText,
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
                      '$hijriText · توقيت أم القرى',
                      maxLines: 1,
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
              SizedBox(width: 8.w),
              _BoardLink(label: 'كل المواقيت', onTap: onOpenAll),
            ],
          ),
          SizedBox(height: 6.h),
          Divider(height: 1, thickness: 1, color: skin.hairline),
          for (var i = 0; i < entries.length; i++)
            _PrayerRow(
              entry: entries[i],
              isFirst: i == 0,
              isLast: i == entries.length - 1,
              raised: i == highlight,
              passed: highlight >= 0 && i <= highlight,
              fillBelow: highlight < 0
                  ? 0
                  : i < highlight
                      ? 1
                      : i == highlight
                          ? windowProgress
                          : 0,
              remainingText: i == highlight ? remainingText : null,
              onTap: onOpenAll,
            ),
        ],
      ),
    );
  }
}

class _BoardLink extends StatelessWidget {
  const _BoardLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: skin.accent,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 13.sp),
          ],
        ),
      ),
    );
  }
}

/// صفّ صلاة واحد، معلّق على سكّة اليوم.
///
/// السكّة هي الفكرة: خطّ واحد يمرّ بالصلوات الخمس، مملوء ذهبًا إلى لحظة
/// «الآن» بالضبط وباهت بعدها. فالقائمة تصير خطّ زمن يقول للمستخدم أين هو
/// من يومه، لا مجرّد خمسة أسطر متشابهة.
class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.entry,
    required this.isFirst,
    required this.isLast,
    required this.raised,
    required this.passed,
    required this.fillBelow,
    required this.onTap,
    this.remainingText,
  });

  final _PrayerMiniEntry entry;
  final bool isFirst;
  final bool isLast;

  /// هذا هو وقت الصلاة الحالي — يُرفع عن بقية الصفوف.
  final bool raised;

  /// مضى وقت هذه الصلاة (أو هو الجاري).
  final bool passed;

  /// كم امتلأ من السكّة تحت هذه النقطة: ١ لما مضى، وكسرٌ للوقت الجاري.
  final double fillBelow;

  final String? remainingText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 22.w,
              child: CustomPaint(
                painter: _RailPainter(
                  track: skin.hairline,
                  isFirst: isFirst,
                  isLast: isLast,
                  passed: passed,
                  isNow: raised,
                  fillBelow: fillBelow,
                ),
              ),
            ),
            Expanded(
              child: raised
                  ? _RaisedRowBody(
                      entry: entry,
                      remainingText: remainingText,
                      fill: fillBelow,
                      skin: skin,
                    )
                  : _PlainRowBody(entry: entry, isLast: isLast, skin: skin),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlainRowBody extends StatelessWidget {
  const _PlainRowBody({
    required this.entry,
    required this.isLast,
    required this.skin,
  });

  final _PrayerMiniEntry entry;
  final bool isLast;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.fromLTRB(4.w, 11.h, 2.w, 11.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              entry.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink.withValues(alpha: 0.88),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (entry.isNext) ...[
            Text(
              'التالية',
              style: TextStyle(
                color: skin.accent,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 7.w),
          ],
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Text(
              entry.time,
              style: TextStyle(
                color: skin.ink.withValues(alpha: 0.88),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                fontFeatures: const [ui.FontFeature.tabularFigures()],
              ),
            ),
          ),
          SizedBox(width: 2.w),
          _AthanBell(prayer: entry.type, skin: skin),
        ],
      ),
    );
  }
}

/// جسم الصفّ الحالي: مرتفع، وتحته خطّ يقيس ما مضى من وقته وكم بقي للتالية.
class _RaisedRowBody extends StatelessWidget {
  const _RaisedRowBody({
    required this.entry,
    required this.remainingText,
    required this.fill,
    required this.skin,
  });

  final _PrayerMiniEntry entry;
  final String? remainingText;
  final double fill;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: skin.raised,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: skin.raisedBorder, width: 1.2),
        boxShadow: skin.raisedShadow,
      ),
      padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 9.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: skin.accent,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  entry.isCurrent ? 'الآن' : 'التالية',
                  style: TextStyle(
                    color: skin.isDark
                        ? AppColors.brandNight
                        : AppColors.brandIvory,
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 7.w),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Text(
                  entry.time,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [ui.FontFeature.tabularFigures()],
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              _AthanBell(prayer: entry.type, skin: skin),
            ],
          ),
          if (remainingText != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999.r),
                    child: LinearProgressIndicator(
                      value: fill.clamp(0.0, 1.0),
                      minHeight: 3.h,
                      backgroundColor: skin.hairline,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.gold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  remainingText!,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.86),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// جرس أذان صلاة واحدة.
///
/// يستمع إلى [AthanMuteStore] الخاصّ بهذه الصلاة وحدها، فاللمسة تعيد بناء
/// هذه الأيقونة فقط — لا الصفّ ولا القائمة ولا الشاشة. والكتابة في قاعدة
/// البيانات وإعادة جدولة الإشعار تجريان بعد ذلك بلا انتظار من الواجهة.
class _AthanBell extends StatelessWidget {
  const _AthanBell({required this.prayer, required this.skin});

  final Prayer prayer;
  final AppSkin skin;

  @override
  Widget build(BuildContext context) {
    final listenable = AthanMuteStore.instance.listenableFor(prayer);

    // الشروق ليس صلاة يُؤذَّن لها.
    if (listenable == null) return SizedBox(width: 4.w);

    return ValueListenableBuilder<bool>(
      valueListenable: listenable,
      builder: (context, enabled, _) {
        return Tooltip(
          message: enabled ? 'كتم أذان هذه الصلاة' : 'تشغيل أذان هذه الصلاة',
          child: InkResponse(
            onTap: () {
              AthanMuteStore.instance.toggle(prayer);
              unawaited(HapticFeedback.selectionClick());
            },
            radius: 20.r,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: AppIcon(
                  enabled ? AppIcons.sound : AppIcons.mute,
                  key: ValueKey(enabled),
                  color: enabled
                      ? skin.accent
                      : skin.inkSoft.withValues(alpha: 0.38),
                  size: 16.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// يرسم سكّة اليوم: الخطّ العمودي ونقطة هذه الصلاة عليه.
class _RailPainter extends CustomPainter {
  const _RailPainter({
    required this.track,
    required this.isFirst,
    required this.isLast,
    required this.passed,
    required this.isNow,
    required this.fillBelow,
  });

  final Color track;
  final bool isFirst;
  final bool isLast;
  final bool passed;
  final bool isNow;
  final double fillBelow;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.52;
    final cy = size.height * 0.5;
    const gap = 7.0;

    final trackPaint = Paint()
      ..color = track
      ..strokeWidth = 2;
    final livePaint = Paint()
      ..color = AppColors.gold
      ..strokeWidth = 2;

    if (!isFirst) {
      canvas.drawLine(
        Offset(cx, 0),
        Offset(cx, cy - gap),
        passed ? livePaint : trackPaint,
      );
    }

    if (!isLast) {
      final top = cy + gap;
      final bottom = size.height;
      canvas.drawLine(Offset(cx, top), Offset(cx, bottom), trackPaint);
      if (fillBelow > 0) {
        canvas.drawLine(
          Offset(cx, top),
          Offset(cx, top + (bottom - top) * fillBelow.clamp(0.0, 1.0)),
          livePaint,
        );
      }
    }

    if (isNow) {
      // نقطة «الآن»: هالة ثم قرص ذهبي مصمت — أوضح علامة في القائمة.
      canvas
        ..drawCircle(
          Offset(cx, cy),
          9,
          Paint()..color = AppColors.gold.withValues(alpha: 0.16),
        )
        ..drawCircle(Offset(cx, cy), 5, Paint()..color = AppColors.gold);
      return;
    }

    canvas.drawCircle(
      Offset(cx, cy),
      3.4,
      Paint()..color = passed ? AppColors.gold : track,
    );
  }

  @override
  bool shouldRepaint(covariant _RailPainter oldDelegate) =>
      oldDelegate.fillBelow != fillBelow ||
      oldDelegate.passed != passed ||
      oldDelegate.isNow != isNow ||
      oldDelegate.track != track;
}

class _LocationNoticeCard extends StatelessWidget {
  const _LocationNoticeCard({required this.notice, required this.palette});

  final _LocationNoticeConfig notice;
  final _SkyPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(9.w),
      decoration: BoxDecoration(
        color: palette.veil.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: palette.veil.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notice.message,
            style: TextStyle(
              color: palette.ink,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          if (notice.primaryAction != null ||
              notice.secondaryAction != null) ...[
            SizedBox(height: 7.h),
            Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: [
                if (notice.primaryAction != null)
                  _NoticeActionChip(
                    action: notice.primaryAction!,
                    palette: palette,
                  ),
                if (notice.secondaryAction != null)
                  _NoticeActionChip(
                    action: notice.secondaryAction!,
                    palette: palette,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NoticeActionChip extends StatelessWidget {
  const _NoticeActionChip({required this.action, required this.palette});

  final _LocationNoticeAction action;
  final _SkyPalette palette;

  @override
  Widget build(BuildContext context) {
    if (action.isRefreshIcon) {
      return InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.veil.withValues(alpha: 0.2),
            border: Border.all(color: palette.veil.withValues(alpha: 0.5)),
          ),
          child: Center(
            child: AppIcon(AppIcons.refresh, color: palette.ink, size: 15.sp),
          ),
        ),
      );
    }

    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: palette.ink,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          action.label,
          style: TextStyle(
            color: palette.sky.first,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
