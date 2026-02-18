part of 'custom_exception_handler.dart';

/// Base Result class
/// [S] represents the type of the success value
/// [E] should be [CustomException] or a subclass of it
sealed class Result<S, E extends CustomException> {
  const Result();
}

final class Success<S, E extends CustomException> extends Result<S, E> {
  const Success(this.value);
  final S value;
}

final class Failure<S, E extends CustomException> extends Result<S, E> {
  const Failure(this.exception);
  final E exception;
}
