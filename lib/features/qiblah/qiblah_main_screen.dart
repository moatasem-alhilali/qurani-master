import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/quran_widgets/qibla_compass_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

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
  double _qiblaDirection2 = 0;
  bool _wasAligned = false; // Track alignment state for haptic feedback

  // Performance optimization - reduce rebuilds
  late ValueNotifier<bool> _alignmentNotifier;

  // Performance optimization - cache alignment calculation
  bool _cachedIsAligned = false;
  double _lastQiblaDirection = -1;

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
            // logger.d(
            //   'direction: ${direction.direction}, qiblah: ${direction.qiblah}',
            // );

            // Performance optimization - only update if significant change
            final currentDiff = (_currentDirection - direction.direction).abs();
            final qiblaDiff = (_qiblaDirection - direction.qiblah).abs();

            if (currentDiff > 1.0 || qiblaDiff > 1.0 || _isLoading) {
              setState(() {
                _currentDirection = direction.direction;
                _qiblaDirection = direction.qiblah;
                _qiblaDirection2 = normalizeDegree(direction.qiblah);
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
    if (_qiblaDirection2 == _lastQiblaDirection) {
      return _cachedIsAligned;
    }

    // Update cache
    _lastQiblaDirection = _qiblaDirection2;

    // Calculate alignment based on _qiblaDirection2 being close to 0
    // When facing Qibla correctly, _qiblaDirection2 becomes 0
    var difference = _qiblaDirection2;
    if (difference > 180) {
      difference = 360 - difference;
    }

    _cachedIsAligned =
        difference <= _alignmentThreshold; // Use the same threshold

    // Debug logging
    print(
      'QiblaDirection2: $_qiblaDirection2°, Difference from 0: ${difference.toInt()}°, Aligned: $_cachedIsAligned',
    );

    // Update alignment notifier for performance
    if (_alignmentNotifier.value != _cachedIsAligned) {
      _alignmentNotifier.value = _cachedIsAligned;
    }

    return _cachedIsAligned;
  }

  void _onDirectionChange(double direction) {
    // Handle direction change with improved logic
    final isAligned = _calculateAlignment();

    if (isAligned && !_wasAligned) {
      // User just became aligned - provide haptic feedback
      HapticFeedback.heavyImpact();
      _wasAligned = true;
    } else if (!isAligned && _wasAligned) {
      // User moved away from alignment
      _wasAligned = false;
    }

    // Force UI update to reflect alignment changes
    setState(() {});

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
                color: context.onSurfaceColor,
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
              backgroundColor: context.primaryColor,
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
            valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
            strokeWidth: 3,
          ),
          SizedBox(height: 20.h),
          Text(
            'جاري تحديد اتجاه القبلة...',
            style: context.titleMedium?.copyWith(
              color: context.primaryColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'تأكد من تفعيل GPS والسماح بأذونات الموقع',
            style: context.titleSmall?.copyWith(
              color: context.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static const double _alignmentThreshold = 10; // عدل حسب ما تحب

  bool get isAligned {
    if (_currentPosition == null) return false;
    return _calculateAlignment();
  }

  String get directionInstruction {
    if (_currentPosition == null) return 'جاري تحديد الموقع...';

    if (isAligned) return 'متوجه للقبلة ✓';

    // Base instruction on _qiblaDirection2 value
    // When _qiblaDirection2 is 0, you're facing Qibla
    // When _qiblaDirection2 is > 0 and < 180, turn left
    // When _qiblaDirection2 is > 180, turn right

    if (_qiblaDirection2 <= 180) {
      // Turn left to reach 0
      return 'استدر يساراً ${_qiblaDirection2.toInt()}°';
    } else {
      // Turn right to reach 0
      return 'استدر يميناً ${(360 - _qiblaDirection2).toInt()}°';
    }
  }

  Widget _buildAnimatedCompass() {
    // Use the new stream-based compass that works like the old code
    return QiblaCompassWidgetWithStream(
      size: 280.w,
      distance: _distanceToMecca,
      cityName: _cityName,
      showDistance: true,
      primaryColor: context.primaryColor,
      kaabaColor: Colors.green,
      showAnimation: true,
    );
  }

  double normalizeDegree(double degree) {
    return ((degree % 360) + 360) % 360;
  }

  Widget _buildDirectionIndicator() {
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
                style: context.titleSmall?.copyWith(
                  color: context.primaryColor,
                ),
              ),
              Text(
                '${_currentDirection.toInt()}°',
                style: context.titleMedium?.copyWith(
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
                  directionInstruction,
                  style: context.titleSmall?.copyWith(
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
                style: context.titleSmall?.copyWith(
                  color: context.primaryColor,
                ),
              ),
              Text(
                '${_qiblaDirection2.toInt()}°',
                style: context.titleMedium?.copyWith(
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
                  color: context.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: context.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: context.primaryColor,
                      size: 20.w,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'موقعك الحالي',
                            style: context.titleSmall?.copyWith(
                              color: context.primaryColor,
                            ),
                          ),
                          Text(
                            _cityName ?? 'يتم تحديد الموقع...',
                            style: context.titleMedium?.copyWith(
                              color: context.primaryColor,
                            ),
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
                            style: context.titleSmall?.copyWith(
                              color: context.primaryColor,
                            ),
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

            SizedBox(height: 10.h),

            // Refresh button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: ElevatedButton.icon(
                onPressed: _refreshQiblah,
                icon: const Icon(Icons.refresh),
                label: const Text('تحديث الاتجاه'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor.withOpacity(0.1),
                  foregroundColor: context.primaryColor,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    side: BorderSide(
                      color: context.primaryColor.withOpacity(0.3),
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
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: context.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: context.primaryColor,
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
      child: AppScaffoldWidget(
        title: 'القبلة',
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
