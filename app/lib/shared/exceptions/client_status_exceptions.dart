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
  WrongCredentialsException([this.cause = "Falsche Anmeldedaten"]);
}

class CredentialsIncompleteException implements LanisException {
  @override
  String cause;
  CredentialsIncompleteException([this.cause = "Nicht alle Anmeldedaten angegeben"]);
}

class NetworkException implements LanisException {
  @override
  String cause;
  NetworkException([this.cause = "Netzwerkfehler"]);
}

class LoggedOffOrUnknownException implements LanisException {
  @override
  String cause;
  LoggedOffOrUnknownException([this.cause = "Unbekannter Fehler! Bist du eingeloggt?"]);
}

class UnauthorizedException implements LanisException {
  @override
  String cause;
  UnauthorizedException([this.cause = "Keine Erlaubnis"]);
}

class EncryptionCheckFailedException implements LanisException {
  @override
  String cause;
  EncryptionCheckFailedException([this.cause = "Verschlüsselungsüberprüfung fehlgeschlagen"]);
}

class UnsaltedOrUnknownException implements LanisException {
  @override
  String cause;
  UnsaltedOrUnknownException([this.cause = "Unbekannter Fehler! Antwort war nicht salted."]);
}

class NotSupportedException implements LanisException {
  @override
  String cause;
  NotSupportedException([this.cause = "Nicht unterstützt!"]);
}

class NoConnectionException implements LanisException {
  @override
  String cause;
  NoConnectionException([this.cause = "Keine verbindung zum SPH"]);
}