part of 'qiblah_main_screen.dart';

/// واجهة البوصلة.
///
/// مفصولة في امتداد على حالة الشاشة بدل أن تُحشر في الصنف نفسه: تقرأ
/// الحقول الخاصّة كما هي — الامتداد داخل المكتبة نفسها — فينكمش ملفّ
/// الشاشة إلى المنطق وحده دون تمرير عشرة معاملات إلى ودجت جديدة.
extension _QiblahCompassView on _QiblahMainScreenState {
  Widget _buildCompassView(BuildContext context, AppSkin skin) {
    final width = MediaQuery.sizeOf(context).width;
    final compassSize = (width - 88.w).clamp(190.0, 320.w);

    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 14.h),
            Center(
              child: QiblahCompass(
                headingDegrees: _currentDirection,
                qiblahOffsetDegrees: _qiblaDirection,
                isAligned: _isAligned,
                size: compassSize,
              ),
            ),
            SizedBox(height: 16.h),
            // سطر التوجيه: أكبر ما في الشاشة بعد البوصلة.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: Text(
                _directionInstruction,
                key: ValueKey(_directionInstruction),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isAligned ? skin.accent : skin.ink,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
            ),
            Text(
              _isAligned
                  ? context.l10n.qiblahHintAligned
                  : context.l10n.qiblahHintMove,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
            SizedBox(height: 14.h),
            skin.divider(),
            HomeSectionHeader(title: context.l10n.qiblahReadingsHeader),
            Padding(
              padding: AppSkin.gutter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ReadingRow(
                    icon: AppIcons.direction,
                    label: context.l10n.qiblahCurrentHeading,
                    value: '${_currentDirection.toInt()}°',
                  ),
                  _ReadingRow(
                    icon: AppIcons.compass,
                    label: context.l10n.qiblahAngle,
                    value: '${_qiblaDirection2.toInt()}°',
                  ),
                  _ReadingRow(
                    icon: AppIcons.mapPin,
                    label: context.l10n.qiblahCurrentLocation,
                    value: _cityName ?? context.l10n.qiblahLocating,
                    isNumeric: false,
                  ),
                  _ReadingRow(
                    icon: AppIcons.mosque,
                    label: context.l10n.qiblahDistanceToMecca,
                    value: _distanceToMecca == null
                        ? '—'
                        : context.l10n
                            .qiblahDistanceKm(_distanceToMecca!.toInt()),
                    isNumeric: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            skin.divider(),
            HomeSectionHeader(title: context.l10n.qiblahInstructionsHeader),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                context.l10n.qiblahInstructions,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.78),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.9,
                ),
              ),
            ),
            SizedBox(height: 22.h),
          ],
        ),
      ),
    );
  }
}
