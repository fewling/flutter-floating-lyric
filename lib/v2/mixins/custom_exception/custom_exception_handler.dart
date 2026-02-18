import '../../../utils/logger.dart';

part 'custom_exception.dart';
part 'exception_code.dart';
part 'result.dart';

mixin CustomExceptionHandler {
  /// Run the operation and catch any exceptions.
  ///
  /// If an exception is caught, it will be handled and returned as a [Failure] containing a [CustomException].
  /// Returns a [Success] containing the result if the operation completes successfully.
  Result<T, CustomException> tryRun<T>(T Function() operation) {
    try {
      final result = operation();
      return Success(result);
    } on CustomException catch (e, st) {
      logger.e('tryRun: CustomException: $e', stackTrace: st);
      return Failure(e);
    } catch (e, st) {
      logger.e('tryRun: UnknownException: $e', stackTrace: st);
      return Failure(_handleUnknownException(e));
    }
  }

  /// Run the operation and catch any exceptions.
  ///
  /// If an exception is caught, it will be handled and returned as a [Failure] containing a [CustomException].
  /// Returns a [Success] containing the result if the operation completes successfully.
  Future<Result<T, CustomException>> tryRunAsync<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Success(result);
    } on CustomException catch (e, st) {
      logger.e('tryRunAsync: CustomException: $e', error: e, stackTrace: st);
      return Failure(e);
    } catch (e, st) {
      logger.e('tryRunAsync: UnknownException: $e', error: e, stackTrace: st);
      return Failure(_handleUnknownException(e));
    }
  }

  /// A helper function to convert an object to a [CustomException].
  ///
  /// This is useful when you want to catch an exception where the type could not be inferred.
  ///
  /// For example, when catching an exception from stream using `onError` where the type is `Object`.
  /// ```dart
  /// stream.listen(
  ///   (data) {},
  ///   onError: (Object e) {
  ///     final exception = exceptionFromObject(e);
  ///     // Handle the exception...
  ///   },
  /// );
  /// ```
  CustomException exceptionFromObject(dynamic object) {
    logger.d('exceptionFromObject: object: $object (${object.runtimeType})');

    if (object is CustomException) return object;

    return UnknownException(message: '$object');
  }

  CustomException _handleUnknownException(dynamic e) {
    return UnknownException(message: '$e');
  }
}
