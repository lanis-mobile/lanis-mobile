import 'package:intl/intl.dart';

import '../../client/storage.dart';

final regMatchAll = RegExp(r'.*');
final regMatchSimple = RegExp(r'\s*(?:[\d\w]\s*(?:;\s*|$))*');
final regGroupSimple = RegExp(r'(?<=;|^)[\d\w\s]+(?=;|$)');

String buildFilterRegex(String simpleList) {
  return regGroupSimple.allMatches(simpleList).map((element) => element.group(0)!.trim()).join("|");
}

Future<List> filter(list) async {

  final String? klassenStufeStorage = await globalStorage.read(key: "filter-klassenStufe");
  late Pattern klassenStufe;

  if (klassenStufeStorage == null || klassenStufeStorage == "") {
    klassenStufe = regMatchAll;
  } else if (regMatchSimple.hasMatch(klassenStufeStorage)) {
    klassenStufe = RegExp(buildFilterRegex(klassenStufeStorage));
  } else {
    klassenStufe = RegExp(klassenStufeStorage);
  }

  final String? klasseStorage = await globalStorage.read(key: "filter-klasse");
  late Pattern klasse;

  if (klasseStorage == null || klasseStorage == "") {
    klasse = regMatchAll;
  } else if (regMatchSimple.hasMatch(klasseStorage)) {
    klasse = RegExp(buildFilterRegex(klasseStorage));
  } else {
    klasse = RegExp(klasseStorage);
  }

  final String? lehrerKuerzelStorage = await globalStorage.read(key: "filter-lehrerKuerzel");
  late Pattern lehrerKuerzel;

  if (lehrerKuerzelStorage == null || lehrerKuerzelStorage == "") {
    lehrerKuerzel = regMatchAll;
  } else if (regMatchSimple.hasMatch(lehrerKuerzelStorage)) {
    lehrerKuerzel = RegExp(buildFilterRegex(lehrerKuerzelStorage));
  } else {
    lehrerKuerzel = RegExp(lehrerKuerzelStorage);
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
