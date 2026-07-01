import 'app_exception.dart';
import 'failure.dart';

/// 错误映射器 (ErrorMapper)
/// 
/// 该工具类负责将底层的异常对象 (Exception/Object) 转换为领域层统一使用的 [Failure] 对象。
/// 这种转换确保了 UI 层只需要处理 [Failure]，而不需要了解底层是网络异常、数据库异常还是业务异常。
class ErrorMapper {
  /// 私有构造函数，防止实例化。
  const ErrorMapper._();

  /// 将任意错误对象转换为 [Failure]
  /// 
  /// [error] 捕获到的异常对象。
  /// 
  /// 逻辑说明：
  /// 1. 优先识别自定义的 [AppException]，直接提取其预设的错误信息和代码。
  /// 2. 对于未知的错误类型，返回一个通用的提示信息，避免将敏感的底层堆栈暴露给最终用户。
  static Failure toFailure(Object error) {
    // 处理已知的业务或包装异常
    if (error is AppException) {
      return Failure(message: error.message, code: error.code);
    }
    
    // 兜底逻辑：处理意外的运行期异常
    // 在实际项目中，此处还可以扩展对 DioException, SocketException 等第三方异常的特化处理。
    return const Failure(message: 'Something went wrong. Please try again.');
  }
}
