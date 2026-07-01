import 'package:dio/dio.dart';

import '../logging/app_logger.dart';
import '../logging/log_sanitizer.dart';

/// 网络请求拦截器 (ApiInterceptor)
/// 
/// 该类继承自 [Interceptor]，负责统一处理所有通过 [ApiClient] 发出的 HTTP 请求。
/// 其核心职责是提供请求与响应的可见性（日志），并确保敏感信息（如密码、Token）在打印前被脱敏。
class ApiInterceptor extends Interceptor {
  /// 构造函数，注入全局日志工具。
  ApiInterceptor(this._logger);

  final AppLogger _logger;

  /// 请求发起前的拦截逻辑
  /// 
  /// 逻辑说明：
  /// 在请求发出前，记录目标 URL、HTTP 方法以及经过脱敏处理的请求头和请求体。
  /// 这对于在开发阶段追踪网络通信的正确性至关重要。
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug({
      'request': options.uri.toString(),
      'method': options.method,
      // 【安全策略】：调用 LogSanitizer 过滤掉请求头中的 Authorization 或 Cookie 等敏感信息。
      'headers': LogSanitizer.sanitize(options.headers),
      // 【安全策略】：过滤请求体中的 password, secret_key 等敏感字段。
      'data': LogSanitizer.sanitize(options.data),
    });
    // 继续执行后续拦截器或发起网络请求。
    handler.next(options);
  }

  /// 收到响应后的拦截逻辑
  /// 
  /// 逻辑说明：
  /// 记录响应的状态码和脱敏后的返回数据。
  /// 如果后端返回的是错误结构，日志系统能帮助开发者快速判断是逻辑错误还是网络错误。
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.debug({
      'response': response.requestOptions.uri.toString(),
      'status': response.statusCode,
      'data': LogSanitizer.sanitize(response.data),
    });
    // 将成功响应传递回业务调用层。
    handler.next(response);
  }

  /// 网络错误拦截逻辑
  /// 
  /// 逻辑说明：
  /// 捕获由于网络超时、连接中断或服务器返回非 2xx 状态码导致的异常。
  /// 此处仅负责记录警告日志，具体的错误映射（如转化为 Failure）由 Repository 层配合 ErrorMapper 完成。
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.warning(
      'Network error: ${err.requestOptions.uri}',
      error: err.message,
    );
    // 将错误继续向下传递，触发全局错误处理流程。
    handler.next(err);
  }
}
