class WrongCredentialsException implements Exception {
  String cause;
  WrongCredentialsException([this.cause = "Falsche Anmeldedaten"]);
}

class CredentialsIncompleteException implements Exception {
  String cause;
  CredentialsIncompleteException([this.cause = "Nicht alle Anmeldedaten angegeben"])
}

class NetworkException implements Exception {
  String cause;
  NetworkException([this.cause = "Netzwerkfehler"]);
}

class LoggedOffOrUnknownException implements Exception {
  String cause;
  LoggedOffOrUnknownException([this.cause = "Unbekannter Fehler! Bist du eingeloggt?"]);
}

class UnauthorizedException implements Exception {
  String cause;
  UnauthorizedException([this.cause = "Keine Erlaubnis"]);
}

class EncryptionCheckFailedException implements Exception {
  String cause;
  EncryptionCheckFailedException([this.cause = "Verschlüsselungsüberprüfung fehlgeschlagen"]);
}

class UnsaltedOrUnknownException implements Exception {
  String cause;
  UnsaltedOrUnknownException([this.cause = "Unbekannter Fehler! Antwort war nicht salted."]);
}

class NotSupportedException implements Exception {
  String cause;
  NotSupportedException([this.cause = "Nicht unterstützt!"]);
}

class NoConnectionException implements Exception {
  String cause;
  NoConnectionException([this.cause = "Kein Internet."]);
}