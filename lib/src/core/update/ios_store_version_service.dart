import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Result of an App Store version lookup.
class IosStoreVersionResult {
  const IosStoreVersionResult({
    required this.currentVersion,
    required this.storeVersion,
    required this.isUpdateAvailable,
    this.storeUrl,
    this.releaseNotes,
  });

  /// The version currently installed on the device.
  final String currentVersion;

  /// The latest version published on the App Store.
  final String storeVersion;

  /// `true` when [storeVersion] is strictly newer than [currentVersion].
  final bool isUpdateAvailable;

  /// The App Store page URL (`trackViewUrl`) used to send the user to update.
  final String? storeUrl;

  /// The "What's New" notes for the latest store version, if any.
  final String? releaseNotes;
}

/// Checks the App Store for the latest published version of this app.
///
/// This replaces the previous Remote Config based version management on iOS.
/// It performs a single request to Apple's public iTunes Lookup API using the
/// app's own bundle id, compares the store version against the installed one,
/// and reports whether an update is available. No server / Remote Config
/// involved — the store is the single source of truth.
class IosStoreVersionService {
  IosStoreVersionService({Dio? dio, PackageInfo? packageInfo})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            ),
        _packageInfo = packageInfo;

  final Dio _dio;
  PackageInfo? _packageInfo;

  static const String _lookupUrl = 'https://itunes.apple.com/lookup';

  /// Queries the App Store and returns the comparison result, or `null` when
  /// the lookup yields nothing usable (app not found in the resolved
  /// storefront, malformed response, or a network error). Callers treat `null`
  /// as "couldn't determine — assume up to date".
  Future<IosStoreVersionResult?> check() async {
    try {
      _packageInfo ??= await PackageInfo.fromPlatform();
      final bundleId = _packageInfo!.packageName;
      final currentVersion = _packageInfo!.version;
      if (bundleId.isEmpty) return null;

      // Resolve the storefront from the device region so the lookup targets the
      // store the user actually installs from (an app can differ per country).
      final country = ui.PlatformDispatcher.instance.locale.countryCode;

      final response = await _dio.get<Map<String, dynamic>>(
        _lookupUrl,
        queryParameters: {
          'bundleId': bundleId,
          if (country != null && country.isNotEmpty) 'country': country,
        },
      );

      final data = response.data;
      if (data == null) return null;

      final resultCount = (data['resultCount'] as num?)?.toInt() ?? 0;
      final results = data['results'];
      if (resultCount == 0 || results is! List || results.isEmpty) {
        return null;
      }

      final first = results.first as Map<String, dynamic>;
      final storeVersion = (first['version'] as String?)?.trim();
      if (storeVersion == null || storeVersion.isEmpty) return null;

      return IosStoreVersionResult(
        currentVersion: currentVersion,
        storeVersion: storeVersion,
        isUpdateAvailable: _isVersionNewer(storeVersion, currentVersion),
        storeUrl: (first['trackViewUrl'] as String?)?.trim(),
        releaseNotes: (first['releaseNotes'] as String?)?.trim(),
      );
    } catch (_) {
      // Network / parsing failures are non-fatal: never block the app over an
      // update check. Caller treats null as "no update".
      return null;
    }
  }

  /// Compares dotted numeric versions (e.g. `4.2.1`). Returns `true` when
  /// [candidate] is strictly newer than [current]. Non-numeric segments are
  /// treated as 0, and shorter versions are zero-padded so `4.2` == `4.2.0`.
  static bool _isVersionNewer(String candidate, String current) {
    if (candidate.isEmpty || current.isEmpty) return false;
    if (candidate == current) return false;

    List<int> parse(String v) => v
        .split('.')
        .map((part) => int.tryParse(part.trim()) ?? 0)
        .toList(growable: true);

    final a = parse(candidate);
    final b = parse(current);
    final maxLength = a.length > b.length ? a.length : b.length;
    while (a.length < maxLength) {
      a.add(0);
    }
    while (b.length < maxLength) {
      b.add(0);
    }

    for (var i = 0; i < maxLength; i++) {
      if (a[i] > b[i]) return true;
      if (a[i] < b[i]) return false;
    }
    return false;
  }
}
