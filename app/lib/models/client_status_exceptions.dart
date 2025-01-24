import 'package:sph_plan/generated/l10n.dart';

abstract class LanisException implements Exception {
  final String cause;
  LanisException(this.cause);

  @override
  String toString() => cause;
}

class WrongCredentialsException implements LanisException {
  @override
  final String cause;

  WrongCredentialsException([String? cause])
      : cause = cause ?? AppLocalizations.current.wrongCredentials;
}

class LanisDownException implements LanisException {
  @override
  final String cause;

  LanisDownException([String? cause])
      : cause = cause ?? AppLocalizations.current.lanisDown;
}

class LoginTimeoutException implements LanisException {
  @override
  final String cause;
  final String time;

  LoginTimeoutException(this.time, [String? cause])
      : cause = (cause ?? AppLocalizations.current.loginTimeout(time))
      .replaceAll('{time}', time);
}

class CredentialsIncompleteException implements LanisException {
  @override
  final String cause;

  CredentialsIncompleteException([String? cause])
      : cause = cause ?? AppLocalizations.current.credentialsIncomplete;
}

class NetworkException implements LanisException {
  @override
  final String cause;

  NetworkException([String? cause])
      : cause = cause ?? AppLocalizations.current.networkError;
}

class UnknownException implements LanisException {
  @override
  final String cause;

  UnknownException([String? cause])
      : cause = cause ?? AppLocalizations.current.unknownError;
}

class UnauthorizedException implements LanisException {
  @override
  final String cause;

  UnauthorizedException([String? cause])
      : cause = cause ?? AppLocalizations.current.unauthorized;
}

class EncryptionCheckFailedException implements LanisException {
  @override
  final String cause;

  EncryptionCheckFailedException([String? cause])
      : cause = cause ?? AppLocalizations.current.encryptionCheckFailed;
}

class UnsaltedOrUnknownException implements LanisException {
  @override
  final String cause;

  UnsaltedOrUnknownException([String? cause])
      : cause = cause ?? AppLocalizations.current.unsaltedOrUnknown;
}

class NotSupportedException implements LanisException {
  @override
  final String cause;

  NotSupportedException([String? cause])
      : cause = cause ?? AppLocalizations.current.notSupported;
}

class NoConnectionException implements LanisException {
  @override
  final String cause;

  NoConnectionException([String? cause])
      : cause = cause ?? AppLocalizations.current.noConnection;
}

class AccountAlreadyExistsException implements LanisException {
  @override
  final String cause;

  AccountAlreadyExistsException([String? cause])
      : cause = cause ?? AppLocalizations.current.accountExists;
}
