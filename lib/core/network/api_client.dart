import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/environment/env_provider.dart';
import '../logging/app_logger.dart';
import 'api_interceptor.dart';

/// API 客户端 Provider
/// 
/// 负责初始化 [Dio] 实例并配置全局网络参数。
/// 使用 Riverpod 的 Provider 模式，确保应用内网络客户端的单例性，并能根据环境配置自动响应。
final apiClientProvider = Provider<ApiClient>((ref) {
  // 监听环境配置；Dio 根地址为 env.apiBaseUrl（baseUrl + apiPrefix）。
  final env = ref.watch(envConfigProvider);
  
  final dio = Dio(
    BaseOptions(
      // Dio 根地址 = 主机 (baseUrl) + API 前缀 (apiPrefix)，业务 path 仍相对此根拼接。
      baseUrl: env.apiBaseUrl,
      // 超时控制：防止在弱网环境下请求无限挂起，提升用户体验。
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      // 默认头部：统一设置内容类型为 JSON。
      headers: {'content-type': 'application/json; charset=utf-8'},
    ),
  );

  // 注入拦截器：处理日志打印、Token 刷新、错误转换等横切关注点。
  // 通过 ref.watch 获取 AppLogger，确保日志行为与全局配置同步。
  dio.interceptors.add(ApiInterceptor(ref.watch(appLoggerProvider)));

  return ApiClient(dio);
}, name: 'apiClientProvider');

/// 基础网络请求客户端 (ApiClient)
/// 
/// 对 [Dio] 进行轻量级包装，对外提供简洁的请求接口。
/// 这样做的好处是：
/// 1. 隔离第三方库（Dio）的复杂性。
/// 2. 方便以后如果需要更换网络库（如切换到 http 或 graphql）时，业务层的改动最小。
class ApiClient {
  /// 构造函数，注入已配置好的 [Dio] 实例。
  const ApiClient(this._dio);

  final Dio _dio;

  /// 发起 GET 请求
  /// 
  /// [path] 请求路径（相对于 [EnvConfig.apiBaseUrl]）。
  /// [queryParameters] URL 查询参数。
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    // 显式声明动态返回类型，内部通过 Dio 发起异步请求。
    return _dio.get<dynamic>(path, queryParameters: queryParameters);
  }

  /// 发起 POST 请求
  /// 
  /// [path] 请求路径。
  /// [data] 请求体数据，可以是 Map, List 或 String。
  Future<Response<dynamic>> post(String path, {Object? data}) {
    // 处理标准的 POST 请求，Dio 会根据 data 的类型自动设置 Body 内容。
    return _dio.post<dynamic>(path, data: data);
  }
}
