import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrayerHomePage extends StatelessWidget {
  const PrayerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final times = <PrayerTime>[
      PrayerTime(
        name: 'العِشاء',
        time: '07:25',
        icon: CupertinoIcons.moon_stars,
      ),
      PrayerTime(name: 'المغرب', time: '07:25', icon: CupertinoIcons.sunset),
      PrayerTime(name: 'العَصر', time: '07:25', icon: CupertinoIcons.sun_max),
      PrayerTime(name: 'الظُّهر', time: '07:25', icon: CupertinoIcons.sunrise),
      PrayerTime(
        name: 'الفجر',
        time: '03:25',
        icon: CupertinoIcons.cloud_moon_bolt,
      ), // فقط أيقونة تقريبية
    ];
    const overlap = 36.0; // كما هو عندك
    const fabDiameter = 64.0;
    const notchDepth = 26.0; // نفس القيمة في الكليبّر

    return LayoutBuilder(
      builder: (context, constraints) {
        final headerHeight = constraints.maxHeight * 0.46; // قريب من الصورة
        return Stack(
          clipBehavior: Clip.none,
          children: [
            PrayerHeader(
              height: headerHeight,
              hijriDate: '9 محرم 1444 هـ',
              nextPrayerName: 'الفجر',
              nextPrayerTime: '03:25',
              nextPrayerSubtitle: 'الصلاة التالية 03:25 • 15:25',
              times: times,
            ),

            // لوحة الميزات البيضاء المتداخلة
            Positioned(
              top: headerHeight - overlap,
              left: 0,
              right: 0,
              child: const FeaturesPanel(),
            ),
            // الزر الدائري المتداخل بالمنتصف
            Positioned(
              // مركز الزر = panelTop + notchDepth
              top: headerHeight -
                  overlap +
                  notchDepth -
                  notchDepth -
                  (fabDiameter / 2),
              left: 0,
              right: 0,
              child: const CenterActionButton(),
            ),
          ],
        );
      },
    );
  }
}

class PrayerHeader extends StatelessWidget {
  const PrayerHeader({
    required this.height,
    required this.hijriDate,
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.nextPrayerSubtitle,
    required this.times,
    super.key,
  });

  final double height;
  final String hijriDate;
  final String nextPrayerName;
  final String nextPrayerTime;
  final String nextPrayerSubtitle;
  final List<PrayerTime> times;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // خلفية متدرجة مع نقشة خفيفة (نقش هندسي مبسّط عبر Painter)
          CustomPaint(
            size: Size.fromHeight(height),
            painter: _HeaderBackgroundPainter(
              start: cs.primary,
              end: const Color(0xFF0A6E63),
            ),
          ),

          // محتوى الهيدر
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // الصف العلوي (أيقونات)
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.bell,
                      color: cs.onPrimary.withOpacity(0.95),
                    ),
                    const Spacer(),
                    Text(
                      hijriDate,
                      style: TextStyle(
                        color: cs.onPrimary.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: cs.onPrimary.withOpacity(0.9),
                      size: 16,
                    ),
                  ],
                ),
                const Spacer(),

                // عنوان الصلاة القادمة + الوقت
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nextPrayerName,
                      style: TextStyle(
                        color: cs.onPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.cloud_drizzle,
                      color: cs.onPrimary.withOpacity(0.95),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  nextPrayerTime,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  nextPrayerSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onPrimary.withOpacity(0.9),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                // شريط أوقات الصلوات
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    reverse: true, // يتماشى مع RTL
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (_, i) => PrayerChip(time: times[i]),
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemCount: times.length,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerTime {
  PrayerTime({
    required this.name,
    required this.time,
    required this.icon,
  });
  final String name;
  final String time;
  final IconData icon;
}

class PrayerChip extends StatelessWidget {
  const PrayerChip({required this.time, super.key});

  final PrayerTime time;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 86,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(time.icon, color: Colors.white, size: 18),
          const SizedBox(height: 6),
          Text(
            time.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time.time,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturesPanel extends StatelessWidget {
  const FeaturesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // نفس القيم المستعملة في التموضع
    const fabDiameter = 64.0;
    const notchDepth = 26.0; // كم ينزل الجيب لأسفل داخل اللوح
    const notchMargin = 8.0; // مسافة أمان بين الزر والجيب
    const shoulder = 46.0; // عرض الكتف يمين/يسار الزر

    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: ClipPath(
        clipper: SmoothNotchClipper(
          cornerRadius: 18,
          fabRadius: fabDiameter / 2, // 32
          notchDepth: notchDepth,
          notchMargin: notchMargin,
          shoulderWidth: shoulder,
          smoothness: NotchSmoothness.soft, // جرّب default/soft/verySoft
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 52, 16, 18),
          decoration: BoxDecoration(
            color: cs.surface,
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المميزات',
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              GridView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.9,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                children: const [
                  FeatureIconButton(
                    label: 'أذان',
                    icon: CupertinoIcons.speaker_2_fill,
                  ),
                  FeatureIconButton(
                    label: 'مجتمعنا',
                    icon: CupertinoIcons.person_3_fill,
                  ),
                  FeatureIconButton(
                    label: 'قبلة',
                    icon: CupertinoIcons.compass_fill,
                  ),
                  FeatureIconButton(
                    label: 'مسبحة',
                    icon: CupertinoIcons.circle_grid_hex_fill,
                  ),
                  FeatureIconButton(
                    label: 'قرآن',
                    icon: CupertinoIcons.book_solid,
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

/// نفس فكرة animated-bottom-navigation-bar: جيب ناعم عبر Cubic Bézier بكتفين
enum NotchSmoothness { hard, normal, soft, verySoft }

class SmoothNotchClipper extends CustomClipper<Path> {
  SmoothNotchClipper({
    required this.cornerRadius,
    required this.fabRadius,
    required this.notchDepth,
    required this.notchMargin,
    required this.shoulderWidth,
    this.smoothness = NotchSmoothness.normal,
  });

  final double cornerRadius; // زوايا اللوح
  final double fabRadius; // نصف قطر الزر (64 => 32)
  final double notchDepth; // عمق الجيب "لتحت"
  final double notchMargin; // فراغ بين الزر والجيب
  final double shoulderWidth; // عرض الكتف يمين/يسار
  final NotchSmoothness smoothness;

  /// معاملات نُعومة تشبه المكتبة (كلما زادت، صار الكتف أنعم)
  double get _k1 {
    switch (smoothness) {
      case NotchSmoothness.hard:
        return 0.40;
      case NotchSmoothness.normal:
        return 0.55;
      case NotchSmoothness.soft:
        return 0.65;
      case NotchSmoothness.verySoft:
        return 0.75;
    }
  }

  double get _k2 {
    switch (smoothness) {
      case NotchSmoothness.hard:
        return 0.45;
      case NotchSmoothness.normal:
        return 0.55;
      case NotchSmoothness.soft:
        return 0.65;
      case NotchSmoothness.verySoft:
        return 0.75;
    }
  }

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // الحافة العليا baseline عند y=0 — سننزل تحتها بعمق notchDepth
    final r = fabRadius + notchMargin; // نصف قطر الجيب الفعلي
    final half = r + shoulderWidth; // نصف عرض الجيب مع الأكتاف

    // نقاط البداية/النهاية على الحافة العليا
    final leftStart = Offset(cornerRadius, 0);
    final rightStart = Offset(w - cornerRadius, 0);

    // نقاط الكتف والقمّة (داخل اللوح) — لأسفل (+depth)
    final p0 = Offset(cx - half, 0); // بداية الكتف اليسار
    final p3 = Offset(cx, notchDepth); // قمة الجيب
    final p6 = Offset(cx + half, 0); // نهاية الكتف اليمين

    // نقاط التحكّم (Cubic) — متناظرة
    final c1 = Offset(cx - half * _k1, 0);
    final c2 = Offset(cx - r * _k2, notchDepth * 0.6);
    final c3 = Offset(cx + r * _k2, notchDepth * 0.6);
    final c4 = Offset(cx + half * _k1, 0);

    final path = Path()
      ..moveTo(0, cornerRadius)
      ..quadraticBezierTo(0, 0, leftStart.dx, leftStart.dy)
      ..lineTo(p0.dx, p0.dy)
      // كتف يسار -> قمة الجيب
      ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p3.dx, p3.dy)
      // قمة الجيب -> كتف يمين
      ..cubicTo(c3.dx, c3.dy, c4.dx, c4.dy, p6.dx, p6.dy)
      ..lineTo(rightStart.dx, rightStart.dy)
      ..quadraticBezierTo(w, 0, w, cornerRadius)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant SmoothNotchClipper old) =>
      cornerRadius != old.cornerRadius ||
      fabRadius != old.fabRadius ||
      notchDepth != old.notchDepth ||
      notchMargin != old.notchMargin ||
      shoulderWidth != old.shoulderWidth ||
      smoothness != old.smoothness;
}

class FeatureIconButton extends StatelessWidget {
  const FeatureIconButton({
    required this.label,
    required this.icon,
    super.key,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap ?? () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.primary.withOpacity(0.16)),
            ),
            child: Icon(icon, color: cs.primary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF5B6B68),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// الزر الدائري المتداخل في المنتصف
class CenterActionButton extends StatelessWidget {
  const CenterActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [cs.primary, const Color(0xFF15A391)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 14,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: const Center(
              // أيقونة الأدوات (مطاعم/إعدادات) كما في الصورة
              child: Icon(
                CupertinoIcons.wrench_fill,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopNotchedClipper extends CustomClipper<Path> {
  // نصف قطر الجيب (نصف قطر الزر تقريبا)

  _TopNotchedClipper({
    this.radius = 28,
    this.notchRadius = 40, // يناسب زر قطره 64px
  });
  final double radius; // نصف قطر الزوايا
  final double notchRadius;

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;

    // ابدأ من أعلى اليسار بزوايا مستديرة
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    // خط إلى بداية الجيب
    path.lineTo(centerX - notchRadius, 0);

    // منحنى الجيب (نصف دائرة لأعلى)
    path.arcToPoint(
      Offset(centerX + notchRadius, 0),
      radius: Radius.circular(notchRadius),
      clockwise: false, // يجعل القوس للأعلى (نحت)
    );

    // أكمل إلى اليمين ثم نزول الزوايا
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

/// خلفية رأس الصفحة (تدرّج + نقش سداسي بسيط)
class _HeaderBackgroundPainter extends CustomPainter {
  _HeaderBackgroundPainter({required this.start, required this.end});
  final Color start;
  final Color end;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [start, end],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // نقش هندسي خفيف جداً
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    const double step = 26;
    for (var x = -size.height; x < size.width + size.height; x += step) {
      final p1 = Offset(x, 0);
      final p2 = Offset(x + size.height, size.height);
      canvas.drawLine(p1, p2, gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeaderBackgroundPainter oldDelegate) =>
      oldDelegate.start != start || oldDelegate.end != end;
}
