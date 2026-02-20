part of 'custom_exception_handler.dart';

sealed class CustomException implements Exception {
  CustomException();
}

final class AppException extends CustomException {
  AppException(this.code);

  final AppExceptionCode code;

  @override
  String toString() => 'AppException{code: $code}';
}

final class UnknownException extends CustomException {
  UnknownException({this.code = UnknownExceptionCode.unknown, this.message});

  final UnknownExceptionCode code;
  final String? message;

  @override
  String toString() => 'UnknownException{code: $code, message: $message}';
}
