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
                  ? 'ثبّت الجهاز، السهم على علامة القبلة'
                  : 'حرّك الجهاز ببطء حتى يصل السهم إلى العلامة',
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
            const HomeSectionHeader(title: 'قراءة البوصلة'),
            Padding(
              padding: AppSkin.gutter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ReadingRow(
                    icon: AppIcons.direction,
                    label: 'اتجاهك الحالي',
                    value: '${_currentDirection.toInt()}°',
                  ),
                  _ReadingRow(
                    icon: AppIcons.compass,
                    label: 'زاوية القبلة',
                    value: '${_qiblaDirection2.toInt()}°',
                  ),
                  _ReadingRow(
                    icon: AppIcons.mapPin,
                    label: 'موقعك الحالي',
                    value: _cityName ?? 'يتم تحديد الموقع...',
                    isNumeric: false,
                  ),
                  _ReadingRow(
                    icon: AppIcons.mosque,
                    label: 'المسافة إلى مكة',
                    value: _distanceToMecca == null
                        ? '—'
                        : '${_distanceToMecca!.toInt()} كم',
                    isNumeric: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            skin.divider(),
            const HomeSectionHeader(title: 'تعليمات الاستخدام'),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
              child: Text(
                '• امسك الهاتف مستويًا أمامك.\n'
                '• تحرّك ببطء حتى يلتقي السهم الذهبي بالعلامة العلوية.\n'
                '• عند المحاذاة تضيء الحلقة وتشعر باهتزازة خفيفة.\n'
                '• أبعد الأجسام المعدنية عن الهاتف.\n'
                '• إذا اضطرب المؤشر، حرّك الهاتف على شكل رقم ٨.',
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
