import 'package:dio/dio.dart';

class AssetFailure extends Failure {
  AssetFailure(super.message);
}

abstract class Failure {
  Failure(this.message);
  final String message;
}

class LogicFailure extends Failure {
  LogicFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
  factory ServerFailure.fromServerFailure(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('connection Time out');
      case DioExceptionType.sendTimeout:
        return ServerFailure('send Time out');

      case DioExceptionType.receiveTimeout:
        return ServerFailure('receive Time out');

      case DioExceptionType.badCertificate:
        return ServerFailure('bad Certificate');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponsive(
          dioError.response!.statusCode!,
          dioError.response!.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure('cancel');
      case DioExceptionType.connectionError:
        return ServerFailure('there is no internet connection');
      case DioExceptionType.unknown:
        // if (dioError.message!.contains("SocketException")) {
        //   return ServerFailure("there is no internet connection");
        // }
        return ServerFailure('unknown Error:${dioError.error}');
      default:
        return ServerFailure('ops there is an error,please try again');
    }
  }

  factory ServerFailure.fromResponsive(int statusCode, dynamic data) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure('your  responsive error message');
    } else if (statusCode == 403) {
      return ServerFailure('not found');
    } else if (statusCode == 500) {
      return ServerFailure('Internal server error');
    } else {
      return ServerFailure('ops there is an error,please try again');
    }
  }
}
