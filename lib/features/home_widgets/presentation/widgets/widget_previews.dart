import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/features/home_widgets/presentation/widgets/widget_preview_card.dart';

/// معاينات الويدجتات، مبنيّة بترتيب تخطيطات الأندرويد نفسه.
///
/// تُقرأ هذه الملفّات جنبًا إلى جنب مع `res/layout/widget_*.xml`: كل معاينة
/// هنا تقابل تخطيطًا هناك، وأي تغيير في أحدهما يجب أن يتبعه الآخر — وإلا
/// صارت الشاشة تَعِد بما لا يظهر.
abstract final class WidgetPreviews {
  static Widget prayer() => _Frame(
        title: 'الصلاة القادمة',
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _big('04:18 ص'),
            const Spacer(),
            _big('الفجر', size: 18),
          ],
        ),
        caption: 'بعد 34 د',
      );

  static Widget prayerTimes() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _label('مواقيت الصلاة', bold: true),
              const Spacer(),
              _label('صنعاء'),
            ],
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Row(
              children: const [
                _TimeCell(name: 'الفجر', time: '04:18'),
                _TimeCell(name: 'الشروق', time: '05:41'),
                _TimeCell(name: 'الظهر', time: '12:06'),
                _TimeCell(name: 'العصر', time: '15:22'),
                _TimeCell(name: 'المغرب', time: '18:09'),
                _TimeCell(name: 'العشاء', time: '19:24'),
              ],
            ),
          ),
        ],
      );

  static Widget dhikr() => _Frame(
        title: 'ذكر اليوم',
        body: _body('لا إله إلا الله وحده لا شريك له، له الملك وله الحمد'),
        caption: 'أذكار طمأنينة',
      );

  static Widget ayah() => _Frame(
        title: 'آية عشوائية',
        body: _body('﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾'),
        caption: 'الرعد: 28',
      );

  static Widget wird() => _Frame(
        title: 'ورد اليوم',
        body: _big('60%'),
        caption: 'بقي جزء واحد',
      );

  static Widget tasbih() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _label('المسبحة', bold: true),
              const Spacer(),
              _label('تصفير'),
            ],
          ),
          SizedBox(height: 7.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: WidgetCanvas.chip,
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(color: WidgetCanvas.border),
                ),
                child: Text(
                  '33',
                  style: TextStyle(
                    color: WidgetCanvas.ink,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Text(
                  'سبحان الله وبحمده',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: WidgetCanvas.ink,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 9.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var i = 0; i < 10; i++)
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: _Bead(filled: i < 3),
                ),
            ],
          ),
        ],
      );

  static Widget qibla() => _Frame(
        title: 'القبلة',
        body: _big('294° شمال غرب'),
        caption: '947 كم إلى المسجد الحرام',
      );

  static Widget hijri() => _Frame(
        title: 'التاريخ الهجري',
        body: _big('12 رجب 1447 هـ'),
        caption: 'الأحد',
      );

  static Widget reading() => _Frame(
        title: 'متابعة القراءة',
        body: _big('سورة الكهف'),
        caption: 'صفحة 296',
      );

  static Widget tracker() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _label('صلوات اليوم', bold: true),
              const Spacer(),
              Text(
                '3 / 5',
                style: TextStyle(
                  color: WidgetCanvas.ink,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: const [
              _TrackerDot(name: 'الفجر', done: true),
              _TrackerDot(name: 'الظهر', done: true),
              _TrackerDot(name: 'العصر', done: true),
              _TrackerDot(name: 'المغرب', done: false),
              _TrackerDot(name: 'العشاء', done: false),
            ],
          ),
          const Spacer(),
          _label('بقي: المغرب، العشاء'),
        ],
      );

  static Widget shortcuts() => Row(
        children: const [
          _ShortcutChip(label: 'القرآن'),
          _ShortcutChip(label: 'الأذكار'),
          _ShortcutChip(label: 'المسبحة'),
          _ShortcutChip(label: 'القبلة'),
        ],
      );

  // ----------------------------- لبنات -----------------------------

  static Widget _big(String text, {double size = 16}) => Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: TextStyle(
          color: WidgetCanvas.ink,
          fontSize: size.sp,
          fontWeight: FontWeight.w800,
          height: 1.25,
        ),
      );

  static Widget _body(String text) => Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: TextStyle(
          color: WidgetCanvas.ink,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          height: 1.6,
        ),
      );

  static Widget _label(String text, {bool bold = false}) => Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: bold ? WidgetCanvas.muted : WidgetCanvas.faint,
          fontSize: 9.sp,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          height: 1.35,
        ),
      );
}

/// الهيكل المشترك: عنوان صغير، ثم السطر الكبير، ثم تعليق.
class _Frame extends StatelessWidget {
  const _Frame({
    required this.title,
    required this.body,
    required this.caption,
  });

  final String title;
  final Widget body;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: WidgetPreviews._label(title, bold: true),
        ),
        SizedBox(height: 5.h),
        body,
        SizedBox(height: 4.h),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: WidgetPreviews._label(caption),
        ),
      ],
    );
  }
}

class _TimeCell extends StatelessWidget {
  const _TimeCell({required this.name, required this.time});

  final String name;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              color: WidgetCanvas.muted,
              fontSize: 7.5.sp,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            time,
            style: TextStyle(
              color: WidgetCanvas.ink,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bead extends StatelessWidget {
  const _Bead({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7.w,
      height: 7.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? WidgetCanvas.border : Colors.transparent,
        border: filled ? null : Border.all(color: const Color(0xFF6B5836)),
      ),
    );
  }
}

class _TrackerDot extends StatelessWidget {
  const _TrackerDot({required this.name, required this.done});

  final String name;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 11.w,
            height: 11.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? WidgetCanvas.border : Colors.transparent,
              border: done ? null : Border.all(color: const Color(0xFF6B5836)),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            name,
            style: TextStyle(
              color: WidgetCanvas.faint,
              fontSize: 7.5.sp,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutChip extends StatelessWidget {
  const _ShortcutChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: WidgetCanvas.chip,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: WidgetCanvas.ink,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
