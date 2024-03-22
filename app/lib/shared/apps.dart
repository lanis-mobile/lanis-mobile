enum SPHAppEnum {
  vertretungsplan("vertretungsplan.php", "Vertretungsplan", false,
      AppSupportStatus.supported),
  kalender("kalender.php", "Kalender", false, AppSupportStatus.supported),
  nachrichten(
      "nachrichten.php", "Nachrichten", false, AppSupportStatus.supported),
  meinUnterricht("meinunterricht.php", "Mein Unterricht", true,
      AppSupportStatus.supported),
  stundenplan(
      "stundenplan.php", "Stundenplan", false, AppSupportStatus.workedOn),
  dateispeicher(
      "dateispeicher.php", "Dateispeicher", false, AppSupportStatus.supported);

  final String php;
  final String
      fullName; // The "humanised" form of .name, prefer to use this than magic strings.
  final bool onlyStudents;
  final AppSupportStatus status;

  const SPHAppEnum(this.php, this.fullName, this.onlyStudents, this.status);

  static SPHAppEnum fromJson(String json) => values.byName(json);
}

enum AppSupportStatus {
  supported("Unterstützt"),
  unsupported("nicht Unterstützt"),
  planned("Geplant"),
  workedOn("in Arbeit");

  final String text;
  const AppSupportStatus(this.text);
}

String getAppSupportStatus(String link) {
  return SPHAppEnum.values
          .where((e) => e.php == link)
          .firstOrNull
          ?.status
          .text ??
      AppSupportStatus.unsupported.text;
}
