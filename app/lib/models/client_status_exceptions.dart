interface class LanisException implements Exception {
  late String cause;
  LanisException(this.cause);
  LanisException.fromCode(dynamic data) {
    cause = data.toString();
  }
}

class WrongCredentialsException implements LanisException {
  @override
  String cause;
  WrongCredentialsException([this.cause = "Falsche Anmeldedaten!"]);
}

class LanisDownException implements LanisException {
  @override
  String cause;
  LanisDownException([this.cause = "Lanis ist down!"]);
}

class LoginTimeoutException implements WrongCredentialsException {
  @override
  String cause;
  final String time;
  LoginTimeoutException(this.time,
      [this.cause =
          "Zu oft falsch eingeloggt! Für den nächsten Versuch musst du kurz warten!"]);
}

class CredentialsIncompleteException implements LanisException {
  @override
  String cause;
  CredentialsIncompleteException(
      [this.cause = "Nicht alle Anmeldedaten angegeben"]);
}

class NetworkException implements LanisException {
  @override
  String cause;
  NetworkException([this.cause = "Netzwerkfehler"]);
}

class UnknownException implements LanisException {
  @override
  String cause;
  UnknownException([this.cause = "Unbekannter Fehler!"]);
}

class UnauthorizedException implements LanisException {
  @override
  String cause;
  UnauthorizedException([this.cause = "Keine Erlaubnis"]);
}

class EncryptionCheckFailedException implements LanisException {
  @override
  String cause;
  EncryptionCheckFailedException(
      [this.cause = "Verschlüsselungsüberprüfung fehlgeschlagen"]);
}

class UnsaltedOrUnknownException implements LanisException {
  @override
  String cause;
  UnsaltedOrUnknownException(
      [this.cause = "Unbekannter Fehler! Antwort war nicht salted."]);
}

class NotSupportedException implements LanisException {
  @override
  String cause;
  NotSupportedException([this.cause = "Nicht unterstützt!"]);
}

class NoConnectionException implements LanisException {
  @override
  String cause;
  NoConnectionException([this.cause = "Keine Verbindung zum SPH"]);
}

class AccountAlreadyExistsException implements LanisException {
  @override
  String cause;
  AccountAlreadyExistsException([this.cause = "Account existiert bereits"]);
}