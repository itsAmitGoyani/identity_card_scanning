import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:identity_card_scanning/models/department_model.dart';
import 'package:identity_card_scanning/models/entry_receipt_model.dart';
import 'package:identity_card_scanning/models/login_model.dart';
import 'package:identity_card_scanning/resources/api_response.dart';
import 'package:identity_card_scanning/util/constants.dart';
import 'package:identity_card_scanning/util/shared_preference.dart';

class ApiProvider {
  final Dio _dio, _authDio;

  ApiProvider()
      : _dio = Dio(BaseOptions(
          baseUrl: apiBaseUrl,
          connectTimeout: 15000,
          receiveTimeout: 5000,
        )),
        _authDio = Dio(BaseOptions(
          baseUrl: apiBaseUrl,
          connectTimeout: 15000,
          receiveTimeout: 5000,
        )) {
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        error: true,
        requestBody: true,
        request: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ));
    }
    _authDio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (RequestOptions requestOptions,
            RequestInterceptorHandler interceptorHandler) async {
          String? tokenType, accessToken, refreshToken;
          DateTime? accessTokenExpiresAtUtc;
          final authData = getAuthData;
          tokenType = authData?.tokenType;
          accessToken = authData?.accessToken;
          accessTokenExpiresAtUtc = authData?.accessTokenExpiresAtUtc;
          if (tokenType != null &&
              accessToken != null &&
              accessTokenExpiresAtUtc != null &&
              accessTokenExpiresAtUtc.toLocal().isAfter(DateTime.now())) {
            requestOptions.headers["authorization"] = "$tokenType $accessToken";
            interceptorHandler.next(requestOptions);
            return;
          }
          interceptorHandler.reject(DioError(
            type: DioErrorType.response,
            requestOptions: requestOptions,
            response: Response(statusCode: 401, requestOptions: requestOptions),
          ));
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          handler.next(response);
        },
        onError: (DioError error, ErrorInterceptorHandler handler) async {
          handler.next(error);
        },
      ),
      if (kDebugMode)
        PrettyDioLogger(
          error: true,
          requestBody: true,
          request: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
        ),
    ]);
  }

  Future<ApiResponse<LoginModel>> sendLoginRequest(
      {required String userName, required String password}) async {
    try {
      Response response = await _dio.post('/v1/auth/login',
          data: {"userName": userName, "password": password});
      return ApiResponse<LoginModel>(data: LoginModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse<LoginModel>(error: _handleDioException(e));
    } catch (error) {
      return ApiResponse<LoginModel>(error: error.toString());
    }
  }

  Future<ApiResponse<List<DepartmentModel>>> getDepartments() async {
    try {
      Response response = await _authDio.get('/v1/departments');
      return ApiResponse<List<DepartmentModel>>(
          data: (response.data as List<dynamic>)
              .map((e) => DepartmentModel.fromJson(e))
              .toList());
    } on DioError catch (e) {
      return ApiResponse<List<DepartmentModel>>(error: _handleDioException(e));
    } catch (error) {
      return ApiResponse<List<DepartmentModel>>(error: error.toString());
    }
  }

  Future<ApiResponse<EntryReceiptModel>> sendEntryRequest({
    required String departmentId,
    required String mobileNumber,
    required String name,
    required String gender,
    required String address,
    required String cnic,
    required String? vehicle,
    required int? children,
    required DateTime dateOfBirth,
    required DateTime dateOfIssue,
    required DateTime dateOfExpiry,
  }) async {
    try {
      Response response = await _authDio.post('/v1/departments/entry', data: {
        "departmentId": departmentId,
        "phoneNumber": mobileNumber,
        "name": name,
        "gender": gender,
        "address": address,
        "cnic": cnic,
        "vahicle": vehicle,
        "children": children,
        "dateOfBirth": dateOfBirth.toIso8601String(),
        "cardIssue": dateOfIssue.toIso8601String(),
        "cardExpiry": dateOfExpiry.toIso8601String(),
      });
      return ApiResponse<EntryReceiptModel>(
          data: EntryReceiptModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse<EntryReceiptModel>(error: _handleDioException(e));
    } catch (error) {
      return ApiResponse<EntryReceiptModel>(error: error.toString());
    }
  }

  String _handleDioException(Exception? exception) {
    if (exception is DioError) {
      switch (exception.type) {
        case DioErrorType.cancel:
          return "Your request has been cancelled. Please try again!";
        case DioErrorType.connectTimeout:
          return "Connection timed out. Please try again!";
        case DioErrorType.other:
          if (exception.error is SocketException) {
            return "No internet connection";
          }
          if (exception.error is HandshakeException) {
            return "Service temporarily unavailable. Please try again later!";
          } else {
            return exception.error.toString();
          }
        case DioErrorType.receiveTimeout:
          return "Request timed out. Please try again";
        case DioErrorType.response:
          switch (exception.response?.statusCode) {
            case 400:
              return exception.response?.data["title"] ?? "Bad request";
            case 401:
              return "Unauthorized";
            case 403:
              return "Unauthorized";
            case 404:
              return exception.response?.data["title"] ?? "404";
            case 409:
              return exception.response?.data["title"].toString() ?? "409";
            case 408:
              return exception.response?.data["title"].toString() ?? "408";
            case 500:
              return "Internal server error";
            case 502:
              return "502";
            case 503:
              return "Service unavailable. Please try later.";
            default:
              var responseCode = exception.response?.statusCode;
              if (responseCode == null) {
                return "Something went wrong.";
              } else {
                return "Error: $responseCode";
              }
          }
        case DioErrorType.sendTimeout:
          return "Sending timeout. Please try again!";
        default:
          return "Something went wrong.";
      }
    } else if (exception is SocketException) {
      return "No Internet Connection.";
    } else {
      return "Unexpected error";
    }
  }
}
