class WrongCredentialsException implements Exception {
  String cause;
  WrongCredentialsException(this.cause);
}

class NetworkException implements Exception {
  String cause;
  NetworkException(this.cause);
}

class LoggedOffOrUnknownException implements Exception {
  String cause;
  LoggedOffOrUnknownException(this.cause);
}

class UnauthorizedException implements Exception {
  String cause;
  UnauthorizedException(this.cause);
}

class EncryptionCheckFailedException implements Exception {
  String cause;
  EncryptionCheckFailedException(this.cause);
}

class UnsaltedOrUnknownException implements Exception {
  String cause;
  UnsaltedOrUnknownException(this.cause);
}

class NotSupportedException implements Exception {
  String cause;
  NotSupportedException(this.cause);
}

class NoConnectionException implements Exception {
  String cause;
  NoConnectionException(this.cause);
}