import 'package:dio/dio.dart';

import '../logging/app_logger.dart';
import '../logging/log_sanitizer.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor(this._logger);

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug({
      'request': options.uri.toString(),
      'method': options.method,
      'headers': LogSanitizer.sanitize(options.headers),
      'data': LogSanitizer.sanitize(options.data),
    });
    handler.next(options);
  }

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
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.warning(
      'Network error: ${err.requestOptions.uri}',
      error: err.message,
    );
    handler.next(err);
  }
}
