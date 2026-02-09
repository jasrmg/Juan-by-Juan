// custom exception, provides user-friendly error messages

// base app exception
class AppException implements Exception {
  final String message;
  final String? debugMessage;

  AppException(this.message, {this.debugMessage});

  @override
  String toString() => debugMessage ?? message;
}

// db operation errors
class DatabaseException extends AppException {
  DatabaseException(super.message, {super.debugMessage});
}

// validation errors (user inputs)
class ValidationException extends AppException {
  ValidationException(super.message, {super.debugMessage});
}

// calculation errors (bill splitting logic)
class CalculationException extends AppException {
  CalculationException(super.message, {super.debugMessage});
}
