enum SPHAppEnum {
  stundenplan("stundenplan.php", false, AppSupportStatus.workedOn),
  nachrichten("nachrichten.php", false, AppSupportStatus.supported),
  vertretungsplan("vertretungsplan.php", false, AppSupportStatus.supported),
  meinUnterricht("meinunterricht.php", true, AppSupportStatus.supported),
  kalender("kalender.php", false, AppSupportStatus.supported),
  dateispeicher("dateispeicher.php", false, AppSupportStatus.planned);

  final String php;
  final bool onlyStudents;
  final AppSupportStatus status;
  const SPHAppEnum(this.php, this.onlyStudents, this.status);
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
  return SPHAppEnum.values.where((e) => e.php == link).firstOrNull?.status.text ?? AppSupportStatus.unsupported.text;
}