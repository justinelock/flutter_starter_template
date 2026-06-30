import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/environment/env_provider.dart';
import '../logging/app_logger.dart';
import 'api_interceptor.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final env = ref.watch(envConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: env.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'content-type': 'application/json; charset=utf-8'},
    ),
  );
  dio.interceptors.add(ApiInterceptor(ref.watch(appLoggerProvider)));
  return ApiClient(dio);
}, name: 'apiClientProvider');

class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<dynamic>(path, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> post(String path, {Object? data}) {
    return _dio.post<dynamic>(path, data: data);
  }
}
