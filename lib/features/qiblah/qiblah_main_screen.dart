import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/qiblah/qiblah_compass.dart';
import 'package:quran_app/l10n/l10n.dart';

part 'qiblah_main_screen_compass_part.dart';
part 'qiblah_main_screen_widgets_part.dart';

/// شاشة القبلة: البوصلة هي البطل، وما حولها سطور نحيلة لا تزاحمها.
class QiblahMainScreen extends StatefulWidget {
  const QiblahMainScreen({super.key});

  @override
  State<QiblahMainScreen> createState() => _QiblahMainScreenState();
}

class _QiblahMainScreenState extends State<QiblahMainScreen>
    with TickerProviderStateMixin {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  StreamSubscription<QiblahDirection>? _qiblahStream;
  Position? _currentPosition;
  String? _cityName;
  double? _distanceToMecca;
  bool _isLoading = true;
  String? _errorMessage;

  double _currentDirection = 0;
  double _qiblaDirection = 0;
  double _qiblaDirection2 = 0;

  /// نتذكّر حالة المحاذاة حتى تهتزّ مرّة واحدة عند الوصول لا مع كل قراءة.
  bool _wasAligned = false;
  bool _cachedIsAligned = false;
  double _lastQiblaDirection = -1;

  late final AnimationController _fadeController = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  );
  late final AnimationController _slideController = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );

  static const double meccaLatitude = 21.4225;
  static const double meccaLongitude = 39.8262;

  /// هامش المحاذاة بالدرجات.
  static const double _alignmentThreshold = 10;

  @override
  void initState() {
    super.initState();
    _initializeQiblah();
  }

  @override
  void dispose() {
    _qiblahStream?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _initializeQiblah() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final deviceSupported = await _deviceSupport;
      if (deviceSupported != true) {
        if (!mounted) return;
        setState(() {
          _errorMessage = context.l10n.qiblahErrorNoSensor;
          _isLoading = false;
        });
        return;
      }

      final hasPermission = await _checkAndRequestLocationPermission();
      if (!hasPermission) {
        if (!mounted) return;
        setState(() {
          _errorMessage ??= context.l10n.qiblahErrorPermissionRequired;
          _isLoading = false;
        });
        return;
      }

      await _getCurrentLocation();
      await _startQiblahStream();

      _fadeController.forward();
      _slideController.forward();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = context.l10n.qiblahErrorGeneric(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _checkAndRequestLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return false;
      setState(() {
        _errorMessage = context.l10n.qiblahErrorLocationServiceOff;
      });
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return false;
      setState(() {
        _errorMessage = context.l10n.qiblahErrorPermissionDeniedForever;
      });
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
      });

      _calculateDistanceToMecca(position);
      await _getCityName(position);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = context.l10n.qiblahErrorLocationFailed;
      });
    }
  }

  void _calculateDistanceToMecca(Position position) {
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      meccaLatitude,
      meccaLongitude,
    );

    setState(() {
      _distanceToMecca = distance / 1000;
    });
  }

  Future<void> _getCityName(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        setState(() {
          _cityName = placemark.locality ??
              placemark.administrativeArea ??
              placemark.country ??
              context.l10n.qiblahUnknownLocation;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cityName = context.l10n.qiblahUnknownLocation;
      });
    }
  }

  Future<void> _startQiblahStream() async {
    try {
      _qiblahStream = FlutterQiblah.qiblahStream.listen(
        (QiblahDirection direction) {
          if (!mounted) return;

          // لا نعيد البناء إلا عند تغيّر محسوس، حفاظًا على سلاسة القرص.
          final currentDiff = (_currentDirection - direction.direction).abs();
          final qiblaDiff = (_qiblaDirection - direction.qiblah).abs();

          if (currentDiff > 1.0 || qiblaDiff > 1.0 || _isLoading) {
            setState(() {
              _currentDirection = direction.direction;
              _qiblaDirection = direction.qiblah;
              _qiblaDirection2 = _normalizeDegree(direction.qiblah);
              _isLoading = false;
            });

            _onDirectionChange();
          }
        },
        onError: (Object error) {
          if (mounted) {
            setState(() {
              _errorMessage =
                  context.l10n.qiblahErrorDirection(error.toString());
              _isLoading = false;
            });
          }
        },
        cancelOnError: false,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = context.l10n.qiblahErrorStreamFailed;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshQiblah() async {
    await _qiblahStream?.cancel();
    await _initializeQiblah();
  }

  double _normalizeDegree(double degree) => ((degree % 360) + 360) % 360;

  bool _calculateAlignment() {
    if (_qiblaDirection2 == _lastQiblaDirection) {
      return _cachedIsAligned;
    }
    _lastQiblaDirection = _qiblaDirection2;

    var difference = _qiblaDirection2;
    if (difference > 180) {
      difference = 360 - difference;
    }

    return _cachedIsAligned = difference <= _alignmentThreshold;
  }

  void _onDirectionChange() {
    final aligned = _calculateAlignment();

    if (aligned && !_wasAligned) {
      // الاتجاه الصحيح يُحسّ: اهتزازة واحدة عند لحظة المحاذاة.
      unawaited(HapticFeedback.mediumImpact());
      _wasAligned = true;
    } else if (!aligned && _wasAligned) {
      _wasAligned = false;
    }
  }

  bool get _isAligned {
    if (_currentPosition == null) return false;
    return _calculateAlignment();
  }

  String get _directionInstruction {
    if (_currentPosition == null) return context.l10n.qiblahLocating;
    if (_isAligned) return context.l10n.qiblahAligned;

    if (_qiblaDirection2 <= 180) {
      return context.l10n.qiblahTurnLeft(_qiblaDirection2.toInt());
    }
    return context.l10n.qiblahTurnRight((360 - _qiblaDirection2).toInt());
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        title: context.l10n.qiblahTitle,
        trailing: IconButton(
          tooltip: context.l10n.qiblahRefreshTooltip,
          onPressed: _refreshQiblah,
          icon: AppIcon(AppIcons.refresh, size: 16.sp, color: skin.accent),
        ),
        body: ColoredBox(
          color: skin.ground,
          child: _errorMessage != null
              ? _QiblahMessage(
                  icon: AppIcons.warning,
                  title: _errorMessage!,
                  actionLabel: context.l10n.commonRetry,
                  onAction: _refreshQiblah,
                )
              : _isLoading
                  ? _QiblahMessage(
                      icon: AppIcons.compass,
                      title: context.l10n.qiblahLoadingTitle,
                      subtitle: context.l10n.qiblahLoadingSubtitle,
                    )
                  : _buildCompassView(context, skin),
        ),
      ),
    );
  }
}
