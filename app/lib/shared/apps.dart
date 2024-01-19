enum SPHAppEnum {
  stundenplan,
  nachrichten,
  nachrichtenBeta,
  vertretungsplan,
  meinUnterricht,
  kalender,
  dateispeicher,
  logout
}

extension SPHApp on SPHAppEnum {
  String get str {
    return switch (this) {
      SPHAppEnum.stundenplan => "stundenplan",
      SPHAppEnum.nachrichten => "nachrichten",
      SPHAppEnum.nachrichtenBeta => "nachrichten - beta-version",
      SPHAppEnum.vertretungsplan => "vertretungsplan",
      SPHAppEnum.meinUnterricht => "mein unterricht",
      SPHAppEnum.kalender => "kalender",
      SPHAppEnum.dateispeicher => "dateispeicher",
      SPHAppEnum.logout => "logout"
    };
  }
}