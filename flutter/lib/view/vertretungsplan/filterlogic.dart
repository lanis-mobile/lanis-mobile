import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';


const storage = FlutterSecureStorage();

AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);


Future<List> filter(list) async {
  var klassenStufe = await storage.read(key: "filter-klassenStufe", aOptions: _getAndroidOptions()) ?? RegExp(r'.*');
  var klasse = await storage.read(key: "filter-klasse", aOptions: _getAndroidOptions()) ?? RegExp(r'.*');
  var lehrerKuerzel = await storage.read(key: "filter-lehrerKuerzel", aOptions: _getAndroidOptions()) ?? RegExp(r'.*');

  var result = [];

  for (var item in list) {
    if (item["Klasse"]?.contains(klasse) == true &&
        item["Klasse"]?.contains(klassenStufe) == true &&
           (item["Vertreter"]?.contains(lehrerKuerzel) == true ||
            item["Lehrer"]?.contains(lehrerKuerzel) == true ||
            item["Lehrerkuerzel"]?.contains(lehrerKuerzel) == true ||
            item["Vertreterkuerzel"]?.contains(lehrerKuerzel) == true)
    ) {
      result.add(item);
    }
  }

  return result;
}


Future<void> setFilter(String klassenStufe, String klasse, String lehrerKuerzel) async {
  await storage.write(key: "filter-klassenStufe", value: klassenStufe, aOptions: _getAndroidOptions());
  await storage.write(key: "filter-klasse", value: klasse, aOptions: _getAndroidOptions());
  await storage.write(key: "filter-lehrerKuerzel", value: lehrerKuerzel, aOptions: _getAndroidOptions());
}

dynamic getFilter() async {
  return {
    "klassenStufe": await storage.read(key: "filter-klassenStufe", aOptions: _getAndroidOptions()) ?? "",
    "klasse": await storage.read(key: "filter-klasse", aOptions: _getAndroidOptions()) ?? "",
    "lehrerKuerzel": await storage.read(key: "filter-lehrerKuerzel", aOptions: _getAndroidOptions()) ?? ""
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
