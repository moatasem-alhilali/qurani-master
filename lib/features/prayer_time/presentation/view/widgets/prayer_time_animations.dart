import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

class PrayerTimeAnimationWidget extends StatelessWidget {
  const PrayerTimeAnimationWidget({
    required this.prayerType,
    super.key,
    this.size = 50.0,
    this.isActive = false,
  });
  
  final Prayer prayerType;
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return switch (prayerType) {
      Prayer.fajr => _FajrIcon(size: size, isActive: isActive),
      Prayer.sunrise => _SunriseIcon(size: size, isActive: isActive),
      Prayer.dhuhr => _DhuhrIcon(size: size, isActive: isActive),
      Prayer.asr => _AsrIcon(size: size, isActive: isActive),
      Prayer.maghrib => _MaghribIcon(size: size, isActive: isActive),
      Prayer.isha => _IshaIcon(size: size, isActive: isActive),
      _ => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
    };
  }
}

class _FajrIcon extends StatelessWidget {
  const _FajrIcon({required this.size, required this.isActive});
  
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        gradient: const RadialGradient(
          colors: [
            Color(0xFFFFB74D),
            Color(0xFFF48FB1),
            Color(0xFFCE93D8),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: Container(
          width: size * 0.5,
          height: size * 0.5,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCC80),
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
        ),
      ),
    );
  }
}

class _SunriseIcon extends StatelessWidget {
  const _SunriseIcon({required this.size, required this.isActive});
  
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF90CAF9),
            Color(0xFFFFCC80),
            Color(0xFFFFF59D),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: size * 0.4,
          height: size * 0.4,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD54F),
            borderRadius: BorderRadius.circular(size * 0.2),
          ),
        ),
      ),
    );
  }
}

class _DhuhrIcon extends StatelessWidget {
  const _DhuhrIcon({required this.size, required this.isActive});
  
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        gradient: const RadialGradient(
          colors: [
            Color(0xFFFFF176),
            Color(0xFFFFB74D),
            Color(0xFF81D4FA),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Center(
        child: Container(
          width: size * 0.4,
          height: size * 0.4,
          decoration: BoxDecoration(
            color: const Color(0xFFFDD835),
            borderRadius: BorderRadius.circular(size * 0.2),
          ),
        ),
      ),
    );
  }
}

class _AsrIcon extends StatelessWidget {
  const _AsrIcon({required this.size, required this.isActive});
  
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFCC80),
            Color(0xFFFFAB91),
            Color(0xFFFFF59D),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: size * 0.45,
          height: size * 0.45,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800),
            borderRadius: BorderRadius.circular(size * 0.225),
          ),
        ),
      ),
    );
  }
}

class _MaghribIcon extends StatelessWidget {
  const _MaghribIcon({required this.size, required this.isActive});
  
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFF8A65),
            Color(0xFFE57373),
            Color(0xFFBA68C8),
          ],
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: size * 0.15),
          child: Container(
            width: size * 0.4,
            height: size * 0.4,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5722),
              borderRadius: BorderRadius.circular(size * 0.2),
            ),
          ),
        ),
      ),
    );
  }
}

class _IshaIcon extends StatelessWidget {
  const _IshaIcon({required this.size, required this.isActive});
  
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        gradient: const RadialGradient(
          colors: [
            Color(0xFF5C6BC0),
            Color(0xFF7E57C2),
            Color(0xFF212121),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: size * 0.15,
            top: size * 0.15,
            child: Container(
              width: size * 0.35,
              height: size * 0.35,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(size * 0.175),
              ),
            ),
          ),
          Positioned(
            right: size * 0.2,
            top: size * 0.2,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            right: size * 0.3,
            bottom: size * 0.25,
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
          Positioned(
            left: size * 0.6,
            top: size * 0.4,
            child: Container(
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
