enum SPHAppEnum {
  stundenplan,
  nachrichten,
  vertretungsplan,
  meinUnterricht,
  kalender,
  dateispeicher;

  static SPHAppEnum fromJson(String json) => values.byName(json);
}

extension SPHApp on SPHAppEnum {
  String get php {
    return switch (this) {
      SPHAppEnum.stundenplan => "stundenplan.php",
      SPHAppEnum.nachrichten => "nachrichten.php",
      SPHAppEnum.vertretungsplan => "vertretungsplan.php",
      SPHAppEnum.meinUnterricht => "meinunterricht.php",
      SPHAppEnum.kalender => "kalender.php",
      SPHAppEnum.dateispeicher => "dateispeicher.php",
    };
  }

  String get fullName {
    return switch (this) {
      SPHAppEnum.stundenplan => "Stundenplan",
      SPHAppEnum.nachrichten => "Nachrichten",
      SPHAppEnum.vertretungsplan => "Vertretungsplan",
      SPHAppEnum.meinUnterricht => "Mein Unterricht",
      SPHAppEnum.kalender => "Kalender",
      SPHAppEnum.dateispeicher => "Dateispeicher",
    };
  }

  bool get onlyStudents {
    return switch (this) {
      SPHAppEnum.meinUnterricht => true,
      _ => false,
    };
  }
}