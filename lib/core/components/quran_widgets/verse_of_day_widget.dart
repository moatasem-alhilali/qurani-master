import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';

class VerseOfDayWidget extends StatefulWidget {
  const VerseOfDayWidget({
    this.verses,
    this.width,
    this.height,
    this.primaryColor,
    this.secondaryColor,
    this.textColor,
    this.backgroundColor,
    this.autoPlay,
    this.cycleDuration,
    this.typewriterSpeed,
    this.showControls,
    this.onVerseChanged,
    super.key,
  });

  final List<QuranVerse>? verses;
  final double? width;
  final double? height;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? textColor;
  final Color? backgroundColor;
  final bool? autoPlay;
  final Duration? cycleDuration;
  final Duration? typewriterSpeed;
  final bool? showControls;
  final Function(QuranVerse verse)? onVerseChanged;

  @override
  State<VerseOfDayWidget> createState() => _VerseOfDayWidgetState();
}

class _VerseOfDayWidgetState extends State<VerseOfDayWidget>
    with TickerProviderStateMixin {
  late AnimationController _typewriterController;
  late AnimationController _fadeController;
  late AnimationController _backgroundController;
  late AnimationController _slideController;

  late Animation<double> _typewriterAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<Offset> _slideAnimation;

  int currentVerseIndex = 0;
  String displayedText = '';
  bool isPlaying = false;
  List<QuranVerse> verses = [];

  @override
  void initState() {
    super.initState();

    verses = widget.verses ?? _getDefaultVerses();

    _typewriterController = AnimationController(
      duration: widget.typewriterSpeed ?? const Duration(seconds: 3),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _typewriterAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _typewriterController,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeInOut,
      ),
    );

    _typewriterAnimation.addListener(_updateDisplayedText);

    _typewriterController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.autoPlay == true) {
          Future.delayed(widget.cycleDuration ?? const Duration(seconds: 5),
              () {
            if (mounted && isPlaying) {
              _nextVerse();
            }
          });
        }
      }
    });

    _backgroundController.repeat();
    _fadeController.forward();
    _slideController.forward();

    if (widget.autoPlay != false) {
      _startTypewriter();
    }
  }

  void _updateDisplayedText() {
    if (verses.isEmpty) return;

    final verse = verses[currentVerseIndex];
    final fullText = verse.arabicText;
    final progress = _typewriterAnimation.value;
    final targetLength = (fullText.length * progress).round();

    setState(() {
      displayedText = fullText.substring(0, targetLength);
    });
  }

  void _startTypewriter() {
    setState(() {
      isPlaying = true;
    });
    _typewriterController.reset();
    _typewriterController.forward();
  }

  void _nextVerse() {
    setState(() {
      currentVerseIndex = (currentVerseIndex + 1) % verses.length;
    });

    _slideController.reset();
    _fadeController.reset();

    _slideController.forward();
    _fadeController.forward();

    widget.onVerseChanged?.call(verses[currentVerseIndex]);
    _startTypewriter();
  }

  void _previousVerse() {
    setState(() {
      currentVerseIndex =
          currentVerseIndex > 0 ? currentVerseIndex - 1 : verses.length - 1;
    });

    _slideController.reset();
    _fadeController.reset();

    _slideController.forward();
    _fadeController.forward();

    widget.onVerseChanged?.call(verses[currentVerseIndex]);
    _startTypewriter();
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      _startTypewriter();
    } else {
      _typewriterController.stop();
    }
  }

  List<QuranVerse> _getDefaultVerses() {
    return [
      QuranVerse(
        arabicText:
            'وَإِذَا قُرِئَ الْقُرْآنُ فَاسْتَمِعُوا لَهُ وَأَنصِتُوا لَعَلَّكُمْ تُرْحَمُونَ',
        translation:
            'And when the Quran is recited, listen to it and be silent that you may receive mercy.',
        surahName: 'الأعراف',
        ayahNumber: 204,
      ),
      QuranVerse(
        arabicText: 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
        translation: 'And say: My Lord! Increase me in knowledge.',
        surahName: 'طه',
        ayahNumber: 114,
      ),
      QuranVerse(
        arabicText: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
        translation:
            'And whoever fears Allah - He will make for him a way out.',
        surahName: 'الطلاق',
        ayahNumber: 2,
      ),
    ];
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    _fadeController.dispose();
    _backgroundController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (verses.isEmpty) return const SizedBox.shrink();

    final currentVerse = verses[currentVerseIndex];

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 200.h,
      child: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.primaryColor ?? context.primaryScheme,
                      widget.secondaryColor ??
                          context.primaryScheme.withOpacity(0.7),
                    ],
                    stops: [
                      _backgroundAnimation.value,
                      1.0,
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: IslamicBackgroundPainter(
                    animationValue: _backgroundAnimation.value,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              );
            },
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'آية اليوم',
                            style: TextStyle(
                              color: widget.textColor ?? Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${currentVerse.surahName} - آية ${currentVerse.ayahNumber}',
                            style: TextStyle(
                              color: (widget.textColor ?? Colors.white)
                                  .withOpacity(0.8),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.showControls != false)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: _previousVerse,
                            icon: Icon(
                              Icons.skip_previous,
                              color: widget.textColor ?? Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          IconButton(
                            onPressed: _togglePlayPause,
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: widget.textColor ?? Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          IconButton(
                            onPressed: _nextVerse,
                            icon: Icon(
                              Icons.skip_next,
                              color: widget.textColor ?? Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Arabic text with typewriter effect
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: displayedText,
                                style: TextStyle(
                                  color: widget.textColor ?? Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.8,
                                  fontFamily: 'Arabic',
                                ),
                              ),
                              // Blinking cursor
                              if (isPlaying &&
                                  displayedText.length <
                                      currentVerse.arabicText.length)
                                WidgetSpan(
                                  child: AnimatedBuilder(
                                    animation: _typewriterController,
                                    builder: (context, child) {
                                      return Opacity(
                                        opacity: (math.sin(
                                                  _typewriterController.value *
                                                      math.pi *
                                                      4,
                                                ) +
                                                1) /
                                            2,
                                        child: Text(
                                          '|',
                                          style: TextStyle(
                                            color: widget.textColor ??
                                                Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Translation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      currentVerse.translation,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            (widget.textColor ?? Colors.white).withOpacity(0.9),
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Progress indicator
          if (isPlaying)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _typewriterAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _typewriterAnimation.value,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.textColor ?? Colors.white,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class QuranVerse {
  QuranVerse({
    required this.arabicText,
    required this.translation,
    required this.surahName,
    required this.ayahNumber,
  });
  final String arabicText;
  final String translation;
  final String surahName;
  final int ayahNumber;
}

class IslamicBackgroundPainter extends CustomPainter {
  IslamicBackgroundPainter({
    required this.animationValue,
    required this.color,
  });
  final double animationValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw flowing Islamic patterns
    for (var i = 0; i < 5; i++) {
      final y = (size.height / 5) * i + (animationValue * 50) % 50;
      final path = Path();

      path.moveTo(0, y);

      for (double x = 0; x <= size.width; x += 20) {
        final wave =
            math.sin((x / size.width + animationValue) * 4 * math.pi) * 10;
        path.lineTo(x, y + wave);
      }

      canvas.drawPath(path, paint);
    }

    // Draw geometric stars
    for (var i = 0; i < 3; i++) {
      final centerX = size.width * (0.2 + i * 0.3);
      final centerY = size.height * 0.5;
      final radius = 15 + math.sin(animationValue * 2 * math.pi + i) * 5;

      _drawStar(canvas, Offset(centerX, centerY), radius, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 8;
    final outerRadius = radius;
    final innerRadius = radius * 0.5;

    for (var i = 0; i < points * 2; i++) {
      final angle = (math.pi * i) / points;
      final currentRadius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + currentRadius * math.cos(angle);
      final y = center.dy + currentRadius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Predefined verse collections
class VerseCollections {
  static List<QuranVerse> get wisdom => [
        QuranVerse(
          arabicText: 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
          translation: 'And say: My Lord! Increase me in knowledge.',
          surahName: 'طه',
          ayahNumber: 114,
        ),
        QuranVerse(
          arabicText: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
          translation: 'Indeed, with hardship comes ease.',
          surahName: 'الشرح',
          ayahNumber: 6,
        ),
      ];

  static List<QuranVerse> get hope => [
        QuranVerse(
          arabicText: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
          translation:
              'And whoever fears Allah - He will make for him a way out.',
          surahName: 'الطلاق',
          ayahNumber: 2,
        ),
        QuranVerse(
          arabicText:
              'وَاللَّهُ غَالِبٌ عَلَىٰ أَمْرِهِ وَلَٰكِنَّ أَكْثَرَ النَّاسِ لَا يَعْلَمُونَ',
          translation:
              'And Allah is predominant over His affair, but most of the people do not know.',
          surahName: 'يوسف',
          ayahNumber: 21,
        ),
      ];

  static List<QuranVerse> get guidance => [
        QuranVerse(
          arabicText:
              'وَإِذَا قُرِئَ الْقُرْآنُ فَاسْتَمِعُوا لَهُ وَأَنصِتُوا لَعَلَّكُمْ تُرْحَمُونَ',
          translation:
              'And when the Quran is recited, listen to it and be silent that you may receive mercy.',
          surahName: 'الأعراف',
          ayahNumber: 204,
        ),
      ];
}

// Predefined verse widgets
class WisdomVerseWidget extends StatelessWidget {
  const WisdomVerseWidget({
    this.width,
    this.height,
    super.key,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return VerseOfDayWidget(
      verses: VerseCollections.wisdom,
      width: width,
      height: height,
      primaryColor: Colors.blue.shade600,
      secondaryColor: Colors.blue.shade400,
      autoPlay: true,
      cycleDuration: const Duration(seconds: 8),
    );
  }
}

class HopeVerseWidget extends StatelessWidget {
  const HopeVerseWidget({
    this.width,
    this.height,
    super.key,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return VerseOfDayWidget(
      verses: VerseCollections.hope,
      width: width,
      height: height,
      primaryColor: Colors.green.shade600,
      secondaryColor: Colors.green.shade400,
      autoPlay: true,
      cycleDuration: const Duration(seconds: 10),
    );
  }
}
