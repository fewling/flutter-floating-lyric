part of 'custom_exception_handler.dart';

enum AppExceptionCode {
  unknown(19999, 'An unknown error occurred.');

  const AppExceptionCode(this.code, this.label);

  final int code;
  final String label;
}

enum UnknownExceptionCode {
  unknown(999999, 'An unknown error occurred.');

  const UnknownExceptionCode(this.code, this.label);

  final int code;
  final String label;
}
