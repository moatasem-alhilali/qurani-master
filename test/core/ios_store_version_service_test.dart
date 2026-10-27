import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quran_app/src/core/update/ios_store_version_service.dart';

/// Covers the two reasons the iOS update prompt never appeared even though the
/// App Store page showed an update:
///
///  1. Apple's CDN caches `itunes.apple.com/lookup` on the full URL and served
///     a response several releases old (1.2.19 while the store had 1.2.22), so
///     the app compared against a stale version and concluded "up to date".
///     Measured against the live endpoint: the plain URL stayed on 1.2.19 for
///     more than a day, while the same URL plus a unique parameter returned
///     1.2.22 from every storefront.
///  2. The storefront came from the device region, which is not the Apple ID's
///     store. An empty result there was read as "no update" instead of being
///     retried against the default storefront.
void main() {
  late _RecordingAdapter adapter;
  late Dio dio;

  final installed = PackageInfo(
    appName: 'Tamaneena',
    packageName: 'com.tamaanina.app',
    version: '1.2.21',
    buildNumber: '34',
  );

  IosStoreVersionService serviceWith(PackageInfo info) =>
      IosStoreVersionService(dio: dio, packageInfo: info);

  setUp(() {
    adapter = _RecordingAdapter();
    dio = Dio()..httpClientAdapter = adapter;
  });

  group('cache busting', () {
    test('every lookup carries a unique _cb parameter', () async {
      adapter.respondWith = (_) => _storeResponse('1.2.22');
      final service = serviceWith(installed);

      await service.check();
      await service.check();

      expect(adapter.requests, hasLength(2));
      final first = adapter.requests[0].queryParameters['_cb'] as String?;
      final second = adapter.requests[1].queryParameters['_cb'] as String?;
      expect(first, isNotNull);
      expect(second, isNotNull);
      expect(
        first,
        isNot(second),
        reason: 'a repeated URL is answered from Apple\u2019s CDN cache',
      );
    });

    test('lookup asks the network not to cache', () async {
      adapter.respondWith = (_) => _storeResponse('1.2.22');

      await serviceWith(installed).check();

      expect(
        adapter.requests.single.headers['Cache-Control'],
        'no-cache',
      );
    });
  });

  group('storefront resolution', () {
    test('falls back to the default storefront when the region has none',
        () async {
      // The test locale is en_US, so the first request carries country=US.
      adapter.respondWith = (options) =>
          options.queryParameters.containsKey('country')
              ? _emptyResponse()
              : _storeResponse('1.2.22');

      final result = await serviceWith(installed).check();

      expect(adapter.requests, hasLength(2));
      expect(adapter.requests[0].queryParameters['country'], 'US');
      expect(
        adapter.requests[1].queryParameters.containsKey('country'),
        isFalse,
      );
      expect(result, isNotNull);
      expect(result!.storeVersion, '1.2.22');
      expect(result.isUpdateAvailable, isTrue);
    });

    test('does not retry when the first storefront answers', () async {
      adapter.respondWith = (_) => _storeResponse('1.2.22');

      await serviceWith(installed).check();

      expect(adapter.requests, hasLength(1));
    });

    test('returns null when no storefront has the app', () async {
      adapter.respondWith = (_) => _emptyResponse();

      expect(await serviceWith(installed).check(), isNull);
    });
  });

  group('comparison', () {
    test('a newer store version is an update', () async {
      adapter.respondWith = (_) => _storeResponse('1.2.22');

      final result = await serviceWith(installed).check();

      expect(result!.currentVersion, '1.2.21');
      expect(result.storeVersion, '1.2.22');
      expect(result.isUpdateAvailable, isTrue);
      expect(result.storeUrl, 'https://apps.apple.com/app/id6761408570');
      expect(result.releaseNotes, 'تحسينات');
    });

    test('the same version is not an update', () async {
      adapter.respondWith = (_) => _storeResponse('1.2.21');

      final result = await serviceWith(installed).check();

      expect(result!.isUpdateAvailable, isFalse);
    });

    test('the stale cached version is not an update', () async {
      // What the old code actually received: three releases behind the store.
      adapter.respondWith = (_) => _storeResponse('1.2.19');

      final result = await serviceWith(installed).check();

      expect(result!.isUpdateAvailable, isFalse);
    });

    test('a network failure is swallowed', () async {
      adapter.respondWith = (options) => throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          );

      expect(await serviceWith(installed).check(), isNull);
    });
  });
}

ResponseBody _storeResponse(String version) => _json({
      'resultCount': 1,
      'results': [
        {
          'version': version,
          'trackViewUrl': 'https://apps.apple.com/app/id6761408570',
          'releaseNotes': 'تحسينات',
        },
      ],
    });

ResponseBody _emptyResponse() =>
    _json({'resultCount': 0, 'results': <Object>[]});

ResponseBody _json(Map<String, Object?> body) => ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

/// Minimal Dio adapter that records the requests and replays canned answers,
/// so the lookup contract is asserted without a mocking package.
class _RecordingAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];

  /// The canned answer each request gets.
  late ResponseBody Function(RequestOptions options) respondWith;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return respondWith(options);
  }

  @override
  void close({bool force = false}) {}
}
