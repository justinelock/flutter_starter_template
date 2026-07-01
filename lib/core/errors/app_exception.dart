/// 应用基础异常类 (AppException)
/// 
/// 该类是项目中所有自定义异常的基类，实现了 [Exception] 接口。
/// 通过将异常结构化（包含消息和错误码），我们可以更精确地在 UI 层进行错误分类和展示。
class AppException implements Exception {
  /// 构造函数
  /// [message] 用户可读或用于日志的错误描述。
  /// [code] 选填的错误码，通常与后端定义的 API 状态码对应，用于逻辑判断。
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

/// 网络请求异常
/// 场景：HTTP 状态码非 2xx、连接超时、DNS 解析失败等。
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

/// 身份认证异常
/// 场景：Token 过期、登录凭据错误、权限不足（401/403）。
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

/// 数据校验异常
/// 场景：表单验证失败、后端返回字段缺失、JSON 解析格式不匹配。
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

/// 存储异常
/// 场景：SharedPreferences 读取失败、SecureStorage 无法访问 Keychain。
class StorageException extends AppException {
  const StorageException(super.message, {super.code});
}

/// 版本检查异常
/// 场景：获取版本接口失败、解析版本号格式错误。
class VersionException extends AppException {
  const VersionException(super.message, {super.code});
}

/// 未知或未捕获的异常
/// 场景：作为代码中所有未分类异常的最后兜底方案。
class UnknownException extends AppException {
  const UnknownException(super.message, {super.code});
}
