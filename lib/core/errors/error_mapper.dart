import 'app_exception.dart';
import 'failure.dart';

class ErrorMapper {
  const ErrorMapper._();

  static Failure toFailure(Object error) {
    if (error is AppException) {
      return Failure(message: error.message, code: error.code);
    }
    return const Failure(message: 'Something went wrong. Please try again.');
  }
}
