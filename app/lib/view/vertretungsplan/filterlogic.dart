import 'package:intl/intl.dart';

import '../../client/storage.dart';

Future<List> filter(list) async {
  late Pattern klassenStufe;

  if (await globalStorage.read(key: "filter-klassenStufe") == null ||
      await globalStorage.read(key: "filter-klassenStufe") == "") {
    klassenStufe = RegExp(r'.*');
  } else {
    klassenStufe =
        RegExp((await globalStorage.read(key: "filter-klassenStufe"))!);
  }

  late Pattern klasse;

  if (await globalStorage.read(key: "filter-klasse") == null ||
      await globalStorage.read(key: "filter-klasse") == "") {
    klasse = RegExp(r'.*');
  } else {
    klasse = RegExp((await globalStorage.read(key: "filter-klasse"))!);
  }

  late Pattern lehrerKuerzel;

  if (await globalStorage.read(key: "filter-lehrerKuerzel") == null ||
      await globalStorage.read(key: "filter-lehrerKuerzel") == "") {
    lehrerKuerzel = RegExp(r'.*');
  } else {
    lehrerKuerzel =
        RegExp((await globalStorage.read(key: "filter-lehrerKuerzel"))!);
  }

  var result = [];

  for (var item in list) {
    var itemKlasse = item["Klasse"] ?? "";
    if (itemKlasse.contains(klasse) == true &&
        itemKlasse.contains(klassenStufe) == true) {

      var itemVertreter = item["Vertreter"] ?? "";
      var itemLehrer = item["Lehrer"] ?? "";
      var itemLehrerkuerzel = item["Lehrerkuerzel"] ?? "";
      var itemVertreterkuerzel = item["Vertreterkuerzel"] ?? "";

      if (itemVertreter.contains(lehrerKuerzel) == true ||
          itemLehrer.contains(lehrerKuerzel) == true ||
          itemLehrerkuerzel.contains(lehrerKuerzel) == true ||
          itemVertreterkuerzel.contains(lehrerKuerzel) == true) {
        result.add(item);
      }
    }
  }

  return result;
}

Future<void> setFilter(
    String klassenStufe, String klasse, String lehrerKuerzel) async {
  await globalStorage.write(key: "filter-klassenStufe", value: klassenStufe);
  await globalStorage.write(key: "filter-klasse", value: klasse);
  await globalStorage.write(key: "filter-lehrerKuerzel", value: lehrerKuerzel);
}

dynamic getFilter() async {
  return {
    "klassenStufe": await globalStorage.read(key: "filter-klassenStufe") ?? "",
    "klasse": await globalStorage.read(key: "filter-klasse") ?? "",
    "lehrerKuerzel": await globalStorage.read(key: "filter-lehrerKuerzel") ?? ""
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
