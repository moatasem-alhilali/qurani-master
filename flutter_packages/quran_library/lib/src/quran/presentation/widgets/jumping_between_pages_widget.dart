part of '../../../../quran.dart';

class JumpingPageControllerWidget extends StatelessWidget {
  const JumpingPageControllerWidget({
    super.key,
    required this.backgroundColor,
    required this.isDark,
    required this.textColor,
    required this.quranCtrl,
  });

  final Color? backgroundColor;
  final bool isDark;
  final Color? textColor;
  final QuranCtrl quranCtrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CurvyArrowButton(
              height: 55,
              isLeft: true,
              backgroundColor:
                  backgroundColor ?? AppColors.getBackgroundColor(isDark),
              iconColor: textColor ?? AppColors.getTextColor(isDark),
              iconData: Icons.arrow_back_ios_new,
              onPressed: () {
                // الانتقال للصفحة السابقة
                // currentPageNumber يبدأ من 1، و animateToPage يتوقع index يبدأ من 0
                // الصفحة السابقة = currentPageNumber - 2 (كـ index)
                final currentPage = quranCtrl.state.currentPageNumber.value;
                if (currentPage > 1) {
                  quranCtrl.animateToPage(currentPage - 2);
                }
              },
            ),
            CurvyArrowButton(
              height: 55,
              isLeft: false,
              backgroundColor:
                  backgroundColor ?? AppColors.getBackgroundColor(isDark),
              iconColor: textColor ?? AppColors.getTextColor(isDark),
              iconData: Icons.arrow_forward_ios_outlined,
              onPressed: () {
                // الانتقال للصفحة التالية
                // currentPageNumber يبدأ من 1، و animateToPage يتوقع index يبدأ من 0
                // الصفحة التالية = currentPageNumber (كـ index)
                final currentPage = quranCtrl.state.currentPageNumber.value;
                if (currentPage < 604) {
                  quranCtrl.animateToPage(currentPage);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CurvyArrowButton extends StatelessWidget {
  const CurvyArrowButton({
    super.key,
    required this.isLeft,
    required this.backgroundColor,
    required this.iconColor,
    required this.iconData,
    required this.onPressed,
    this.height = 55,
  });

  final bool isLeft;
  final Color backgroundColor;
  final Color iconColor;
  final IconData iconData;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double width = height; // مساحة أكبر لمنحنيات أوضح
    return SizedBox(
      height: height + 55,
      width: width,
      child: InkWell(
        onTap: onPressed,
        hoverColor: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: CurvyArrowPainter(
                  color: backgroundColor,
                  isLeft: isLeft,
                ),
              ),
            ),
            // التحكم
            Center(
              child: Icon(iconData, size: 22, color: iconColor),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvyArrowPainter extends CustomPainter {
  CurvyArrowPainter({
    required this.color,
    required this.isLeft,
  });

  final Color color;
  final bool isLeft;

  @override
  void paint(Canvas canvas, Size size) {
    final double r = size.height * 0.28; // نصف قطر أكبر لمظهر أكثر نعومة
    final double bulge = size.width * 0.28; // اتساع الانحناءة الجانبية
    final double overshoot = size.width * 0.28; // مدى البروز للخارج

    final Path path = Path();

    if (isLeft) {
      // شكل مع بروز منحني واضح لليسار باستخدام Cubic Bezier
      path.moveTo(r + bulge, 0);
      path.lineTo(size.width - r, 0);
      path.quadraticBezierTo(size.width, 0, size.width, r);
      path.lineTo(size.width, size.height - r);
      path.quadraticBezierTo(
          size.width, size.height, size.width - r, size.height);
      path.lineTo(r + bulge, size.height);
      // منحنى جانبي أكثر امتلاءً
      path.cubicTo(
        -overshoot,
        size.height * 0.85,
        -overshoot,
        size.height * 0.15,
        r + bulge,
        0,
      );
      path.close();
    } else {
      // شكل مع بروز منحني واضح لليمين باستخدام Cubic Bezier
      path.moveTo(r, 0);
      path.lineTo(size.width - r - bulge, 0);
      path.cubicTo(
        size.width + overshoot,
        size.height * 0.15,
        size.width + overshoot,
        size.height * 0.85,
        size.width - r - bulge,
        size.height,
      );
      path.lineTo(r, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - r);
      path.lineTo(0, r);
      path.quadraticBezierTo(0, 0, r, 0);
      path.close();
    }

    // ظل طفيف
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: .15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.save();
    canvas.translate(0, 1);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // تعبئة الشكل
    final Paint fillPaint = Paint()..color = color;
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CurvyArrowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isLeft != isLeft;
  }
}
