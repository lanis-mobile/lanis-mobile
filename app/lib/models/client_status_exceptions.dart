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
  static const _fallback = 'Falsche Anmeldedaten!';

  WrongCredentialsException([String? cause])
      : cause =
      cause ?? AppLocalizations.current.wrongCredentials ?? _fallback;
}

class LanisDownException implements LanisException {
  @override
  final String cause;
  static const _fallback = 'Lanis ist down!';

  LanisDownException([String? cause])
      : cause = cause ?? AppLocalizations.current.lanisDown ?? _fallback;
}

class LoginTimeoutException implements LanisException {
  @override
  final String cause;
  final String time;
  static const _fallback = 'Warte {time} vor nächstem Versuch';

  LoginTimeoutException(this.time, [String? cause])
      : cause = (cause ?? AppLocalizations.current.loginTimeout(time))
      ?.replaceAll('{time}', time) ??
      _fallback.replaceAll('{time}', time);
}

class CredentialsIncompleteException implements LanisException {
  @override
  final String cause;
  static const _fallback = 'Anmeldedaten unvollständig';

  CredentialsIncompleteException([String? cause])
      : cause = cause ??
      AppLocalizations.current.credentialsIncomplete ??
      _fallback;
}

class NetworkException implements LanisException {
  @override
  final String cause;
  static const _fallback = 'Netzwerkfehler';

  NetworkException([String? cause])
      : cause = cause ?? AppLocalizations.current.networkError ?? _fallback;
}

class UnknownException implements LanisException {
  @override
  final String cause;
  static const _fallback = 'Unbekannter Fehler';

  UnknownException([String? cause])
      : cause = cause ?? AppLocalizations.current.unknownError ?? _fallback;
}

class UnauthorizedException implements LanisException {
  @override
  final String cause;
  static const _fallback = 'Keine Erlaubnis';

  UnauthorizedException([String? cause])
      : cause = cause ?? AppLocalizations.current.unauthorized ?? _fallback;
}

class EncryptionCheckFailedException implements LanisException {
  @override
  final String cause;
  static const _fallback = 'Verschlüsselungsüberprüfung fehlgeschlagen';

  EncryptionCheckFailedException([String? cause])
      : cause = cause ??
      AppLocalizations.current.encryptionCheckFailed ??
      _fallback;
}

class UnsaltedOrUnknownException implements LanisException {
  @override
  final String cause;
  static const _fallback = 'Unbekannte ungesalzene Antwort';

  UnsaltedOrUnknownException([String? cause])
      : cause =
      cause ?? AppLocalizations.current.unsaltedOrUnknown ?? _fallback;
}

class NotSupportedException implements LanisException {
  @override
  final String cause;
  static const _fallback = 'Nicht unterstützt';

  NotSupportedException([String? cause])
      : cause = cause ?? AppLocalizations.current.notSupported ?? _fallback;
}

class NoConnectionException implements LanisException {
  @override
  final String cause;
  static const _fallback = 'Keine SPH-Verbindung';

  NoConnectionException([String? cause])
      : cause = cause ?? AppLocalizations.current.noConnection ?? _fallback;
}

class AccountAlreadyExistsException implements LanisException {
  @override
  final String cause;
  static const _fallback = 'Account existiert bereits';

  AccountAlreadyExistsException([String? cause])
      : cause = cause ?? AppLocalizations.current.accountExists ?? _fallback;
}
