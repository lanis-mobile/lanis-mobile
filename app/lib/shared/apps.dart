enum SPHAppEnum {
  vertretungsplan("vertretungsplan.php", "Vertretungsplan", false,
      AppSupportStatus.supported),
  kalender("kalender.php", "Kalender", false, AppSupportStatus.supported),
  nachrichten(
      "nachrichten.php", "Nachrichten", false, AppSupportStatus.supported),
  meinUnterricht("meinunterricht.php", "Mein Unterricht", true,
      AppSupportStatus.supported),
  stundenplan(
      "stundenplan.php", "Stundenplan", true, AppSupportStatus.supported),
  dateispeicher(
      "dateispeicher.php", "Dateispeicher", false, AppSupportStatus.supported);

  final String php;
  final String
      fullName; // The "humanised" form of .name, prefer to use this than magic strings.
  final bool onlyStudents;
  final AppSupportStatus status;

  const SPHAppEnum(this.php, this.fullName, this.onlyStudents, this.status);
}

enum AppSupportStatus {
  supported("Supportet"),
  unsupported("Unsupportet"),
  planned("Planned"),
  workedOn("Worked on"),;

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
