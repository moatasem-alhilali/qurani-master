
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageCacheNetworkSVG extends StatefulWidget {
  /// Creates a widget that displays a SVG image from a network URL with caching.
  ///
  /// The [url] argument must not be null.
  ImageCacheNetworkSVG(
    String url, {
    Key? key,
    String? cacheKey,
    Widget? placeholder,
    Widget? errorWidget,
    double? width,
    double? height,
    Map<String, String>? headers,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool matchTextDirection = false,
    bool allowDrawingOutsideViewBox = false,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    Duration fadeDuration = const Duration(milliseconds: 300),
    ColorFilter? colorFilter,
    WidgetBuilder? placeholderBuilder,
    BaseCacheManager? cacheManager,
    bool useSvgRootCache = true,
    int? memCacheWidth,
    int? memCacheHeight,
    int? maxRetryCount = 3,
    Duration retryDelay = const Duration(seconds: 1),
    Duration cacheDuration = const Duration(days: 30),
    String? baseUrl,
  })  : _url = url,
        _cacheKey = cacheKey,
        _placeholder = placeholder,
        _errorWidget = errorWidget,
        _width = width,
        _height = height,
        _headers = headers,
        _fit = fit,
        _alignment = alignment,
        _matchTextDirection = matchTextDirection,
        _allowDrawingOutsideViewBox = allowDrawingOutsideViewBox,
        _color = color,
        _colorBlendMode = colorBlendMode,
        _semanticsLabel = semanticsLabel,
        _excludeFromSemantics = excludeFromSemantics,
        _theme = theme,
        _fadeDuration = fadeDuration,
        _colorFilter = colorFilter,
        _placeholderBuilder = placeholderBuilder,
        _cacheManager = cacheManager ?? DefaultCacheManager(),
        _useSvgRootCache = useSvgRootCache,
        _memCacheWidth = memCacheWidth,
        _memCacheHeight = memCacheHeight,
        _maxRetryCount = maxRetryCount,
        _retryDelay = retryDelay,
        _cacheDuration = cacheDuration,
        _baseUrl = baseUrl,
        super(key: key ?? ValueKey(url));

  final String _url;
  final String? _cacheKey;
  final Widget? _placeholder;
  final Widget? _errorWidget;
  final double? _width;
  final double? _height;
  final Map<String, String>? _headers;
  final BoxFit _fit;
  final AlignmentGeometry _alignment;
  final bool _matchTextDirection;
  final bool _allowDrawingOutsideViewBox;
  final Color? _color;
  final BlendMode _colorBlendMode;
  final String? _semanticsLabel;
  final bool _excludeFromSemantics;
  final SvgTheme _theme;
  final Duration _fadeDuration;
  final ColorFilter? _colorFilter;
  final WidgetBuilder? _placeholderBuilder;
  final BaseCacheManager _cacheManager;
  final bool _useSvgRootCache;
  final int? _memCacheWidth;
  final int? _memCacheHeight;
  final int? _maxRetryCount;
  final Duration _retryDelay;
  final Duration _cacheDuration;
  final String? _baseUrl;

  @override
  State<ImageCacheNetworkSVG> createState() => _ImageCacheNetworkSVGState();

  /// Pre-caches an SVG image from the given URL.
  ///
  /// This method can be called during app initialization to preload
  /// frequently used SVG images.
  static Future<void> preCache(
    String imageUrl, {
    String? cacheKey,
    BaseCacheManager? cacheManager,
    Map<String, String>? headers,
  }) async {
    final key = cacheKey ?? _generateKeyFromUrl(imageUrl);
    cacheManager ??= DefaultCacheManager();
    try {
      await cacheManager.getSingleFile(
        imageUrl,
        key: key,
        headers: headers ?? {},
      );
    } catch (e) {
      log('Failed to pre-cache SVG: $imageUrl, error: $e');
    }
  }

  /// Clears the cache for a specific SVG URL.
  static Future<void> clearCacheForUrl(
    String imageUrl, {
    String? cacheKey,
    BaseCacheManager? cacheManager,
  }) {
    final key = cacheKey ?? _generateKeyFromUrl(imageUrl);
    cacheManager ??= DefaultCacheManager();
    return cacheManager.removeFile(key);
  }

  /// Clears the entire SVG cache.
  static Future<void> clearCache({BaseCacheManager? cacheManager}) {
    cacheManager ??= DefaultCacheManager();
    return cacheManager.emptyCache();
  }

  /// Generates a cache key from a URL.
  static String _generateKeyFromUrl(String url) => url.split('?').first;
}

class _ImageCacheNetworkSVGState extends State<ImageCacheNetworkSVG>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isError = false;
  FileInfo? _fileInfo;
  late String _cacheKey;
  String get _effectiveUrl => widget._baseUrl != null
      ? Uri.parse(widget._baseUrl!).resolve(widget._url).toString()
      : widget._url;
  int _retryCount = 0;
  Uint8List? _svgBytes;
  bool _isDisposed = false;

  late final AnimationController _controller;
  late final Animation<double> _animation;

  // LRU cache for SVG bytes with a maximum size
  static final Map<String, Uint8List> _svgBytesCache = {};
  static const int _maxCacheEntries = 100;
  static final List<String> _cacheKeys = [];

  @override
  void initState() {
    super.initState();
    _cacheKey = widget._cacheKey ??
        ImageCacheNetworkSVG._generateKeyFromUrl(_effectiveUrl);
    _controller = AnimationController(
      vsync: this,
      duration: widget._fadeDuration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _loadImage();
  }

  @override
  void didUpdateWidget(ImageCacheNetworkSVG oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newUrl = widget._baseUrl != null
        ? Uri.parse(widget._baseUrl!).resolve(widget._url).toString()
        : widget._url;
    final oldUrl = oldWidget._baseUrl != null
        ? Uri.parse(oldWidget._baseUrl).resolve(oldWidget._url).toString()
        : oldWidget._url;

    if (newUrl != oldUrl ||
        widget._cacheKey != oldWidget._cacheKey ||
        widget._cacheManager != oldWidget._cacheManager) {
      _cacheKey = widget._cacheKey ??
          ImageCacheNetworkSVG._generateKeyFromUrl(_effectiveUrl);
      _isLoading = true;
      _isError = false;
      _fileInfo = null;
      _svgBytes = null;
      _retryCount = 0;
      _controller.reset();
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (_isDisposed) return;

    try {
      // First check in-memory cache (if enabled)
      if (widget._useSvgRootCache && _svgBytesCache.containsKey(_cacheKey)) {
        _svgBytes = _svgBytesCache[_cacheKey];
        _isLoading = false;
        _setState();
        _controller.forward();
        return;
      }

      // Check if the file is in the cache
      _fileInfo = await widget._cacheManager.getFileFromCache(_cacheKey);

      if (_fileInfo == null) {
        // Not in cache, start downloading
        await _downloadAndCacheFile();
      } else if (_fileInfo!.validTill.isBefore(DateTime.now())) {
        // Cache exists but is expired - use cached version and update in background
        _loadFromFile(_fileInfo!.file);
        // Start a background download to refresh the cache
        _downloadAndCacheFile(updateCacheOnly: true);
      } else {
        // Valid cache entry - load it
        _loadFromFile(_fileInfo!.file);
      }
    } catch (e) {
      await _handleError(e);
    }
  }

  Future<void> _downloadAndCacheFile({bool updateCacheOnly = false}) async {
    if (_isDisposed) return;

    try {
      final file = await widget._cacheManager.getSingleFile(
        _effectiveUrl,
        key: _cacheKey,
        headers: widget._headers ?? {},
      );

      if (_isDisposed) return;

      if (!updateCacheOnly) {
        _loadFromFile(file);
      }
    } catch (e) {
      if (!updateCacheOnly) {
        await _handleError(e);
      }
    }
  }

  Future<void> _loadFromFile(File file) async {
    if (_isDisposed) return;

    try {
      // Read SVG bytes for in-memory caching if enabled
      if (widget._useSvgRootCache) {
        _svgBytes = await file.readAsBytes();
        _updateInMemoryCache(_cacheKey, _svgBytes!);
      }

      _isLoading = false;
      _setState();
      _controller.forward();
    } catch (e) {
      await _handleError(e);
    }
  }

  void _updateInMemoryCache(String key, Uint8List bytes) {
    // Implementation of LRU cache
    if (_svgBytesCache.length >= _maxCacheEntries) {
      if (_cacheKeys.isNotEmpty) {
        final oldestKey = _cacheKeys.removeAt(0);
        _svgBytesCache.remove(oldestKey);
      }
    }

    // Remove key if it already exists to update its position
    if (_cacheKeys.contains(key)) {
      _cacheKeys.remove(key);
    }

    // Add to cache
    _svgBytesCache[key] = bytes;
    _cacheKeys.add(key);
  }

  Future<void> _handleError(dynamic error) async {
    if (_isDisposed) return;

    log('CachedNetworkSVGImage error: $error');

    // Retry logic
    if (widget._maxRetryCount != null && _retryCount < widget._maxRetryCount!) {
      _retryCount++;
      log('Retrying SVG download ($_retryCount/${widget._maxRetryCount})');
      await Future.delayed(widget._retryDelay);
      if (!_isDisposed) _loadImage();
    } else {
      _isError = true;
      _isLoading = false;
      _setState();
    }
  }

  void _setState() {
    if (mounted && !_isDisposed) setState(() {});
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget._width,
      height: widget._height,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (_isLoading) return _buildPlaceholderWidget();

    if (_isError) return _buildErrorWidget();

    return FadeTransition(
      opacity: _animation,
      child: _buildSVGImage(),
    );
  }

  Widget _buildPlaceholderWidget() =>
      Center(child: widget._placeholder ?? const CircularProgressIndicator());

  Widget _buildErrorWidget() =>
      Center(child: widget._errorWidget ?? const Icon(Icons.error_outline));

  Widget _buildSVGImage() {
    if (_fileInfo?.file == null && _svgBytes == null) return const SizedBox();

    // Use SVG memory if available
    if (_svgBytes != null) {
      return SvgPicture.memory(
        _svgBytes!,
        fit: widget._fit,
        width: widget._width,
        height: widget._height,
        alignment: widget._alignment,
        matchTextDirection: widget._matchTextDirection,
        allowDrawingOutsideViewBox: widget._allowDrawingOutsideViewBox,
        color: widget._color,
        colorBlendMode: widget._colorBlendMode,
        semanticsLabel: widget._semanticsLabel,
        excludeFromSemantics: widget._excludeFromSemantics,
        colorFilter: widget._colorFilter,
        placeholderBuilder: widget._placeholderBuilder,
        theme: widget._theme,
        cacheColorFilter: true,
      );
    }

    return SvgPicture.file(
      _fileInfo!.file,
      fit: widget._fit,
      width: widget._width,
      height: widget._height,
      alignment: widget._alignment,
      matchTextDirection: widget._matchTextDirection,
      allowDrawingOutsideViewBox: widget._allowDrawingOutsideViewBox,
      color: widget._color,
      colorBlendMode: widget._colorBlendMode,
      semanticsLabel: widget._semanticsLabel,
      excludeFromSemantics: widget._excludeFromSemantics,
      colorFilter: widget._colorFilter,
      placeholderBuilder: widget._placeholderBuilder,
      theme: widget._theme,
      cacheColorFilter: true,
    );
  }
}
