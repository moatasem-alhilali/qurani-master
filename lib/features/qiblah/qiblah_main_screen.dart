import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/quran_widgets/qibla_compass_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/main.dart';

class QiblahMainScreen extends StatefulWidget {
  const QiblahMainScreen({super.key});

  @override
  State<QiblahMainScreen> createState() => _QiblahMainScreenState();
}

class _QiblahMainScreenState extends State<QiblahMainScreen>
    with TickerProviderStateMixin {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  // State variables
  StreamSubscription<QiblahDirection>? _qiblahStream;
  Position? _currentPosition;
  String? _cityName;
  double? _distanceToMecca;
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasLocationPermission = false;

  // Direction tracking
  double _currentDirection = 0;
  double _qiblaDirection = 0;
  bool _wasAligned = false; // Track alignment state for haptic feedback

  // Performance optimization - reduce rebuilds
  late ValueNotifier<bool> _alignmentNotifier;

  // Performance optimization - cache alignment calculation
  bool _cachedIsAligned = false;
  double _lastCurrentDirection = -1;
  double _lastQiblaDirection = -1;

  // Debug flag - set to true to see direction values
  static const bool _debugMode = false;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;

  // Constants
  static const double meccaLatitude = 21.4225;
  static const double meccaLongitude = 39.8262;

  @override
  void initState() {
    super.initState();
    _alignmentNotifier = ValueNotifier<bool>(false);
    _initializeAnimations();
    _initializeQiblah();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  Future<void> _initializeQiblah() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Check device support
      final deviceSupported = await _deviceSupport;
      if (deviceSupported != true) {
        setState(() {
          _errorMessage = 'جهازك لا يدعم استشعار الاتجاه';
          _isLoading = false;
        });
        return;
      }

      // Check and request location permissions
      final hasPermission = await _checkAndRequestLocationPermission();
      if (!hasPermission) {
        setState(() {
          _errorMessage = 'يجب السماح بالوصول للموقع لتحديد اتجاه القبلة';
          _isLoading = false;
        });
        return;
      }

      // Get current location
      await _getCurrentLocation();

      // Start listening to qiblah direction
      await _startQiblahStream();

      // Start animations
      _fadeController.forward();
      _slideController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ في تحديد اتجاه القبلة: $e';
        _isLoading = false;
      });
    }
  }

  Future<bool> _checkAndRequestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _errorMessage = 'خدمات الموقع غير مفعلة. يرجى تفعيلها من الإعدادات';
      });
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _errorMessage =
            'تم رفض أذونات الموقع نهائياً. يرجى تفعيلها من إعدادات التطبيق';
      });
      return false;
    }

    setState(() {
      _hasLocationPermission = true;
    });
    return true;
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Calculate distance to Mecca
      _calculateDistanceToMecca(position);

      // Get city name
      await _getCityName(position);
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في الحصول على الموقع الحالي';
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
      _distanceToMecca = distance / 1000; // Convert to kilometers
    });
  }

  Future<void> _getCityName(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        setState(() {
          _cityName = placemark.locality ??
              placemark.administrativeArea ??
              placemark.country ??
              'موقع غير معروف';
        });
      }
    } catch (e) {
      setState(() {
        _cityName = 'موقع غير معروف';
      });
    }
  }

  Future<void> _startQiblahStream() async {
    try {
      _qiblahStream = FlutterQiblah.qiblahStream.listen(
        (QiblahDirection direction) {
          if (mounted) {
            // Performance optimization - only update if significant change
            final currentDiff = (_currentDirection - direction.direction).abs();
            final qiblaDiff = (_qiblaDirection - direction.qiblah).abs();

            if (currentDiff > 1.0 || qiblaDiff > 1.0 || _isLoading) {
              setState(() {
                _currentDirection = direction.direction;
                _qiblaDirection = direction.qiblah;
                _isLoading = false;
              });

              // Call the direction change handler
              _onDirectionChange(direction.direction);
            }
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _errorMessage = 'خطأ في تحديد الاتجاه: $error';
              _isLoading = false;
            });
          }
        },
        cancelOnError: false, // Keep listening even if there are errors
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في بدء تتبع الاتجاه';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshQiblah() async {
    await _qiblahStream?.cancel();
    await _initializeQiblah();
  }

  // Performance-optimized alignment calculation with caching
  bool _calculateAlignment() {
    // Only recalculate if values have changed
    if (_currentDirection == _lastCurrentDirection &&
        _qiblaDirection == _lastQiblaDirection) {
      return _cachedIsAligned;
    }

    // Update cache
    _lastCurrentDirection = _currentDirection;
    _lastQiblaDirection = _qiblaDirection;

    // Calculate the angular difference correctly
    var difference = (_currentDirection - _qiblaDirection).abs();
    if (difference > 180) {
      difference = 360 - difference;
    }

    _cachedIsAligned = difference <= 10.0; // Within 10 degrees

    // Update alignment notifier for performance
    if (_alignmentNotifier.value != _cachedIsAligned) {
      _alignmentNotifier.value = _cachedIsAligned;
    }

    // Debug logging (remove in production)
    if (_debugMode) {
      logger.d(
        'Current: $_currentDirection°, Qibla: $_qiblaDirection°, Diff: ${difference.toStringAsFixed(1)}°, Aligned: $_cachedIsAligned',
      );
    }

    return _cachedIsAligned;
  }

  void _onDirectionChange(double direction) {
    // Handle direction change with improved logic
    final isAligned = _calculateAlignment();

    if (isAligned && !_wasAligned) {
      // User just became aligned - provide haptic feedback
      HapticFeedback.lightImpact();
      _wasAligned = true;
    } else if (!isAligned && _wasAligned) {
      // User moved away from alignment
      _wasAligned = false;
    }

    // You can add additional logic here for when direction changes
    // For example, logging or other UI updates

    // Optional: Add sound feedback or other notifications here
    // if (isAligned) {
    //   // Play alignment sound
    // }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80.w,
            color: Colors.red.withOpacity(0.7),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              _errorMessage ?? 'حدث خطأ غير متوقع',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: context.onBackground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 30.h),
          ElevatedButton.icon(
            onPressed: _refreshQiblah,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryScheme,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(context.primaryScheme),
            strokeWidth: 3,
          ),
          SizedBox(height: 20.h),
          Text(
            'جاري تحديد اتجاه القبلة...',
            style: context.titleMedium,
          ),
          SizedBox(height: 10.h),
          Text(
            'تأكد من تفعيل GPS والسماح بأذونات الموقع',
            style: context.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCompass() {
    // Don't rotate the entire compass - let the internal needle handle rotation
    return DetailedQiblaCompass(
      size: 280.w,
      qiblaDirection: _qiblaDirection,
      currentDirection: _currentDirection,
      distance: _distanceToMecca,
      cityName: _cityName,
    );
  }

  Widget _buildDirectionIndicator() {
    final isAligned = _calculateAlignment();
    // Calculate the direction to turn
    String directionText;
    if (isAligned) {
      directionText = 'متوجه للقبلة ✓';
    } else {
      final normalizedDiff = (_qiblaDirection - _currentDirection + 360) % 360;
      if (normalizedDiff <= 180) {
        directionText = 'استدر يميناً ${normalizedDiff.toInt()}°';
      } else {
        directionText = 'استدر يساراً ${(360 - normalizedDiff).toInt()}°';
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: isAligned
            ? Colors.green.withOpacity(0.15)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: isAligned ? Colors.green : Colors.orange,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isAligned ? Colors.green : Colors.orange).withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الاتجاه الحالي',
                style: context.titleSmall,
              ),
              Text(
                '${_currentDirection.toInt()}°',
                style: context.titleMedium.copyWith(
                  color: isAligned ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Icon(
                  isAligned ? Icons.check_circle : Icons.navigation,
                  color: isAligned ? Colors.green : Colors.orange,
                  size: 30.w,
                ),
                SizedBox(height: 5.h),
                Text(
                  directionText,
                  style: context.titleSmall.copyWith(
                    color: isAligned ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'اتجاه القبلة',
                style: context.titleSmall,
              ),
              Text(
                '${_qiblaDirection.toInt()}°',
                style: context.titleMedium.copyWith(
                  color: isAligned ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompassWidget() {
    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: Column(
          children: [
            // Location info card
            if (_currentPosition != null)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: context.primaryScheme.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: context.primaryScheme.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: context.primaryScheme,
                      size: 20.w,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'موقعك الحالي',
                            style: context.titleSmall,
                          ),
                          Text(
                            _cityName ?? 'يتم تحديد الموقع...',
                            style: context.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    if (_distanceToMecca != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'المسافة',
                            style: context.titleSmall,
                          ),
                          Text(
                            '${_distanceToMecca!.toInt()} كم',
                            style: context.titleMedium,
                          ),
                        ],
                      ),
                  ],
                ),
              ),

            SizedBox(height: 20.h),

            // Compass widget
            _buildAnimatedCompass(),

            SizedBox(height: 20.h),

            // Direction indicator
            _buildDirectionIndicator(),

            // Debug information (only shown when _debugMode is true)
            if (_debugMode)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معلومات التصحيح:',
                      style: context.titleMedium,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'الاتجاه الحالي: ${_currentDirection.toStringAsFixed(2)}°',
                      style: context.titleSmall,
                    ),
                    Text(
                      'اتجاه القبلة: ${_qiblaDirection.toStringAsFixed(2)}°',
                      style: context.titleSmall,
                    ),
                    Text(
                      'الفرق: ${(_qiblaDirection - _currentDirection).abs().toStringAsFixed(2)}°',
                      style: context.titleSmall,
                    ),
                  ],
                ),
              ),

            SizedBox(height: 10.h),

            // Refresh button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: ElevatedButton.icon(
                onPressed: _refreshQiblah,
                icon: const Icon(Icons.refresh),
                label: const Text('تحديث الاتجاه'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryScheme.withOpacity(0.1),
                  foregroundColor: context.primaryScheme,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    side: BorderSide(
                      color: context.primaryScheme.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Instructions card
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: context.primaryScheme.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: context.primaryScheme.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: context.primaryScheme,
                        size: 20.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'تعليمات الاستخدام',
                        style: context.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '• امسك الهاتف في وضع مستقيم أمامك\n'
                    '• تحرك ببطء حتى يصبح السهم الأخضر متجهاً للأعلى\n'
                    '• عند اتجاه القبلة ستظهر علامة ✓ وستشعر بالاهتزاز\n'
                    '• تأكد من عدم وجود أجسام معدنية قريبة من الهاتف\n'
                    '• إذا لم يعمل الكومباس، حرك الهاتف على شكل رقم 8',
                    style: context.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BaseHomeWidget(
        title: 'القبلة',
        // isScroll: false,
        //  actions: [
        //   IconButton(
        //     onPressed: _refreshQiblah,
        //     icon: const Icon(Icons.refresh),
        //     tooltip: 'تحديث',
        //   ),
        // ],
        body: _errorMessage != null
            ? _buildErrorWidget()
            : _isLoading
                ? _buildLoadingWidget()
                : _buildCompassWidget(),
      ),
    );
  }

  @override
  void dispose() {
    _qiblahStream?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    _alignmentNotifier.dispose();
    super.dispose();
  }
}
