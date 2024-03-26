// import 'dart:io';

// import 'package:quran_app/main.dart';

// abstract class Failure {
//   final String messageError;
//   Failure(this.messageError);
// }

// class ApiFailure extends Failure {
//   ApiFailure(super.message);
// }

// class CashFailure extends Failure {
//   CashFailure(super.message);
// }

// class ServerFailure extends Failure {
//   ServerFailure(super.messageError);

//   //from Server Failure
//   factory ServerFailure.fromServerFailure(DioException dioError) {
//     switch (dioError.type) {
//       case DioExceptionType.connectionTimeout:
//         return ServerFailure('connection Time out');
//       case DioExceptionType.sendTimeout:
//         return ServerFailure('send Time out');

//       case DioExceptionType.receiveTimeout:
//         return ServerFailure('receive Time out');

//       case DioExceptionType.badCertificate:
//         return ServerFailure('bad Certificate');
//       case DioExceptionType.badResponse:
//         return ServerFailure.fromResponsive(
//           dioError.response!.data['response']['status']['code'],
//           dioError.response!.data['response']['status']['message'],
//         );
//       case DioExceptionType.cancel:
//         return ServerFailure('cancel');
//       case DioExceptionType.connectionError:
//         return ServerFailure('there is no internet connection');
//       case DioExceptionType.unknown:
//         if (dioError is SocketException) {
//           return ServerFailure('Socket Exception');
//         }
//         return ServerFailure('غير قادر على معالجة العملية');
//       default:
//         return ServerFailure('ops there is an error,please try again');
//     }
//   }

//   factory ServerFailure.fromResponsive(int statusCode, dynamic data) {
//     if (statusCode == 400 ||
//         statusCode == 401 ||
//         statusCode == 403 ||
//         statusCode == 422) {
//       // logger.e(data);

//       return ServerFailure(data);
//     } else if (statusCode == 403) {
//       return ServerFailure('not found');
//     } else if (statusCode == 500) {
//       return ServerFailure('Internal server error');
//     } else {
//       return ServerFailure('ops there is an error,please try again');
//     }
//   }

//   factory ServerFailure.badResponse(Object e) {
//     try {
//       if (e is DioException) {
//         if (e.type == DioExceptionType.badResponse) {
//           var message = e.response!.data['response']['status']['message'];
//           logger.e(e.response!.data);
//           return ServerFailure(message.toString());
//         } else {
//           return ServerFailure('غير قادر على معالجة العملية');
//         }
//       } else {
//         return ServerFailure('غير قادر على معالجة العملية');
//       }
//     } catch (e) {
//       logger.e(e);

//       return ServerFailure('غير قادر على معالجة العملية');
//     }
//   }
//   factory ServerFailure.notAuth(Object e) {
//     try {
//       if (e is DioException) {
//         if (e.type == DioExceptionType.badResponse) {
//           // var message = e.response!.data['response']['status']['message'];
//           logger.e(e.response!.data);

//           return ServerFailure('message.toString()');
//         } else {
//           return ServerFailure('غير قادر على معالجة العملية');
//         }
//       } else {
//         return ServerFailure('غير قادر على معالجة العملية');
//       }
//     } catch (e) {
//       logger.i(e);

//       return ServerFailure('غير قادر على معالجة العملية');
//     }
//   }
// }
