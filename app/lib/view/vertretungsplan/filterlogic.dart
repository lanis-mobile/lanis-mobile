import 'package:intl/intl.dart';

import '../../client/storage.dart';



Future<List> filter(list) async {
  var klassenStufe = await globalStorage.read(
          key: "filter-klassenStufe") ??
      RegExp(r'.*');
  var klasse = await globalStorage.read(
          key: "filter-klasse") ??
      RegExp(r'.*');
  var lehrerKuerzel = await globalStorage.read(
          key: "filter-lehrerKuerzel") ??
      RegExp(r'.*');

  var result = [];

  for (var item in list) {
    if (item["Klasse"]?.contains(klasse) == true &&
        item["Klasse"]?.contains(klassenStufe) == true &&
        (item["Vertreter"]?.contains(lehrerKuerzel) == true ||
            item["Lehrer"]?.contains(lehrerKuerzel) == true ||
            item["Lehrerkuerzel"]?.contains(lehrerKuerzel) == true ||
            item["Vertreterkuerzel"]?.contains(lehrerKuerzel) == true)) {
      result.add(item);
    }
  }

  return result;
}

Future<void> setFilter(
    String klassenStufe, String klasse, String lehrerKuerzel) async {
  await globalStorage.write(
      key: "filter-klassenStufe",
      value: klassenStufe
  );
  await globalStorage.write(
      key: "filter-klasse", value: klasse);
  await globalStorage.write(
      key: "filter-lehrerKuerzel",
      value: lehrerKuerzel
  );
}

dynamic getFilter() async {
  return {
    "klassenStufe": await globalStorage.read(
            key: "filter-klassenStufe") ??
        "",
    "klasse": await globalStorage.read(
            key: "filter-klasse") ??
        "",
    "lehrerKuerzel": await globalStorage.read(
            key: "filter-lehrerKuerzel") ??
        ""
  };
}

String formatDateString(String dateEn, String dateDe) {
  DateFormat eingabeFormat = DateFormat('yyyy-MM-dd');
  DateTime zielDatum = eingabeFormat.parse(dateEn);

  // Wochentag auf Deutsch
  var wochentagFormat = DateFormat.EEEE('de_DE');
  String wochentag = wochentagFormat.format(zielDatum);

  return '$wochentag, $dateDe';
}
