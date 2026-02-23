import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Centralized Dio HTTP client with base configuration.
class DioClient {
  late final Dio _dio;

  DioClient({String? baseUrl}) {
    const apiBaseUrlFromEnv = String.fromEnvironment('API_BASE_URL');
    final resolvedBaseUrl = baseUrl ??
        (apiBaseUrlFromEnv.trim().isNotEmpty
            ? apiBaseUrlFromEnv
            : 'http://10.0.2.2:3001/api');

    _dio = Dio(
      BaseOptions(
        baseUrl: resolvedBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: true,
          logPrint: (obj) => debugPrint('[DIO] $obj'),
        ),
      );
    }
  }

  Dio get dio => _dio;

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  /// POST request with JSON body
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }
}
