import 'package:dio/dio.dart';
import 'package:quran_app/core/services/api_serves.dart';

class DioHelper {
  static late Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiServes.baseUrl,
        headers: {
          'content-type': "application/json",
          'Accept': "application/json",
        },
      ),
    );
  }

  static Future<Response<dynamic>> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
  }) async {
    return await dio!.get(
      url,
      queryParameters: queryParameters,
      data: data,
      options: options ??
          Options(
              // headers: {
              //   "Authorization": 'Bearer $token',
              // },
              ),
    );
  }

  static Future<Response<dynamic>> post({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio!.post(
      url,
      data: data,
      options: options ??
          Options(
              // headers: {"Authorization": 'Bearer $token'},
              ),
      queryParameters: queryParameters,
    );
  }

  static Future<Response<dynamic>> put({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio!.put(
      url,
      data: data,
      options: Options(
          // headers: {"Authorization": 'Bearer $token'},
          ),
      queryParameters: queryParameters,
    );
  }

  static Future<Response<dynamic>> delete({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio!.delete(
      url,
      data: data,
      options: Options(
          // headers: {"Authorization": 'Bearer $token'},
          ),
      queryParameters: queryParameters,
    );
  }
}
