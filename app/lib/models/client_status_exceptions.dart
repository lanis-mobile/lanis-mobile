import 'package:sph_plan/generated/l10n.dart';

abstract class LanisException implements Exception {
  final String cause;

  LanisException(this.cause);

  @override
  String toString() => cause;
}

class WrongCredentialsException extends LanisException {
  WrongCredentialsException([String? cause])
      : super(cause ?? AppLocalizations.current.wrongCredentials);
}

class LanisDownException extends LanisException {
  LanisDownException([String? cause])
      : super(cause ?? AppLocalizations.current.lanisDown);
}

class LoginTimeoutException extends LanisException {
  final String time;

  LoginTimeoutException(this.time, [String? cause])
      : super((cause ?? AppLocalizations.current.loginTimeout(time))
      .replaceAll('{time}', time));
}

class CredentialsIncompleteException extends LanisException {
  CredentialsIncompleteException([String? cause])
      : super(cause ?? AppLocalizations.current.credentialsIncomplete);
}

class NetworkException extends LanisException {
  NetworkException([String? cause])
      : super(cause ?? AppLocalizations.current.networkError);
}

class UnknownException extends LanisException {
  UnknownException([String? cause])
      : super(cause ?? AppLocalizations.current.unknownError);
}

class UnauthorizedException extends LanisException {
  UnauthorizedException([String? cause])
      : super(cause ?? AppLocalizations.current.unauthorized);
}

class EncryptionCheckFailedException extends LanisException {
  EncryptionCheckFailedException([String? cause])
      : super(cause ?? AppLocalizations.current.encryptionCheckFailed);
}

class UnsaltedOrUnknownException extends LanisException {
  UnsaltedOrUnknownException([String? cause])
      : super(cause ?? AppLocalizations.current.unsaltedOrUnknown);
}

class NotSupportedException extends LanisException {
  NotSupportedException([String? cause])
      : super(cause ?? AppLocalizations.current.notSupported);
}

class NoConnectionException extends LanisException {
  NoConnectionException([String? cause])
      : super(cause ?? AppLocalizations.current.noConnection);
}

class AccountAlreadyExistsException extends LanisException {
  AccountAlreadyExistsException([String? cause])
      : super(cause ?? AppLocalizations.current.accountExists);
}
