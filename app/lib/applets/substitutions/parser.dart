import 'dart:convert';
import 'dart:io';

import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

import '../../core/applet_parser.dart';
import '../../models/client_status_exceptions.dart';
import '../../models/substitution.dart';

class SubstitutionsParser extends AppletParser<SubstitutionPlan> {
  final DateFormat entryFormat = DateFormat('dd_MM_yyyy');
  SubstitutionsParser(super.sph, super.appletDefinition);

  @override
  SubstitutionPlan typeFromJson(String json) {
    return SubstitutionPlan.fromJson(jsonDecode(json));
  }

  @override
  Future<SubstitutionPlan> getHome() async {
    String document = await getSubstitutionPlanDocument();
    Document parsedDocument = parse(document);
    DateTime? lastEdit = parseLastEditDate(document);
    var dates = getSubstitutionDates(document);

    if (dates.isEmpty) {
      SubstitutionPlan plan = parseSubstitutionsNonAJAX(parsedDocument);
      return plan;
    }

    final fullPlan = SubstitutionPlan();
    fullPlan.lastUpdated = lastEdit ?? DateTime.now();
    List<Future<SubstitutionDay>> futures = dates.map((date) => getSubstitutionsAJAX(date)).toList();
    List<SubstitutionDay> plans = await Future.wait(futures);
    for (SubstitutionDay day in plans) {
      fullPlan.add(
          day.withDayInfo(
            parseInformationTables(parsedDocument.getElementById('tag${entryFormat.format(day.dateTime)}')!)
          )
      );
    }
    await fullPlan.removeEmptyDays();
    return fullPlan;
  }

  Future<String> getSubstitutionPlanDocument() async {
    try {
      final response = await sph.session.dio
          .get("https://start.schulportal.hessen.de/vertretungsplan.php");
      return response.data;
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      rethrow;
    }
  }

  SubstitutionPlan parseSubstitutionsNonAJAX(Document document) {
    DateFormat entryFormat = DateFormat('dd_MM_yyyy');
    final SubstitutionPlan fullPlan = SubstitutionPlan();
    final dates = document
        .querySelectorAll("[data-tag]")
        .map((element) => element.attributes["data-tag"]!);
    for (var date in dates) {
      DateTime parsedDate = entryFormat.parse(date);
      String parsedDateStr = parsedDate.format('dd.MM.yyyy');
      SubstitutionDay substitutionDay =
          SubstitutionDay(parsedDate: parsedDateStr);
      final vtable = document.querySelector("#vtable$date");
      if (vtable == null) {
        return fullPlan;
      }
      final headers = vtable
          .querySelectorAll("th")
          .map((e) => e.attributes["data-field"]!)
          .toList(growable: false);
      for (var row in vtable.querySelectorAll("tbody tr").where(
          (element) => element.querySelectorAll("td[colspan]").isEmpty)) {
        final fields = row.querySelectorAll("td");
        substitutionDay.add(Substitution(
            tag: parsedDate.format('dd.MM.yyyy'),
            tag_en: date,
            stunde: parseStunde(fields[headers.indexOf("Stunde")].text.trim()),
            fach: headers.contains("Fach")
                ? fields[headers.indexOf("Fach")].text.trim()
                : null,
            art: headers.contains("Art")
                ? fields[headers.indexOf("Art")].text.trim()
                : null,
            raum: headers.contains("Raum")
                ? fields[headers.indexOf("Raum")].text.trim()
                : null,
            hinweis: headers.contains("Hinweis")
                ? fields[headers.indexOf("Hinweis")].text.trim()
                : null,
            lehrer: headers.contains("Lehrer")
                ? fields[headers.indexOf("Lehrer")].text.trim()
                : null,
            vertreter: headers.contains("Vertreter")
                ? fields[headers.indexOf("Vertreter")].text.trim()
                : null,
            klasse: headers.contains("Klasse")
                ? fields[headers.indexOf("Klasse")].text.trim()
                : null));
      }
      fullPlan.add(substitutionDay);
    }
    fullPlan.removeEmptyDays();
    return fullPlan;
  }

  Future<SubstitutionDay> getSubstitutionsAJAX(String date) async {
    try {
      final response = await sph.session.dio
          .post("https://start.schulportal.hessen.de/vertretungsplan.php",
              queryParameters: {"a": "my"},
              data: {"tag": date, "ganzerPlan": "true"},
              options: Options(
                headers: {
                  "Accept": "*/*",
                  "Content-Type":
                      "application/x-www-form-urlencoded; charset=UTF-8",
                  "Sec-Fetch-Dest": "empty",
                  "Sec-Fetch-Mode": "cors",
                  "Sec-Fetch-Site": "same-origin",
                },
              ));
      return SubstitutionDay(
          parsedDate: date,
          substitutions: (jsonDecode(response.toString()) as List)
              .map((e) => Substitution(
                  tag: e["Tag"],
                  tag_en: e["Tag_en"],
                  stunde: parseStunde(e["Stunde"]),
                  vertreter: e["Vertreter"],
                  lehrer: e["Lehrer"],
                  klasse: e["Klasse"],
                  klasse_alt: e["Klasse_alt"],
                  fach: e["Fach"],
                  fach_alt: e["Fach_alt"],
                  raum: e["Raum"],
                  raum_alt: e["Raum_alt"],
                  hinweis: e["Hinweis"],
                  hinweis2: e["Hinweis2"],
                  art: e["Art"],
                  Lehrerkuerzel: e["Lehrerkuerzel"],
                  Vertreterkuerzel: e["Vertreterkuerzel"],
                  lerngruppe: e["Lerngruppe"],
                  hervorgehoben: e["_hervorgehoben"]))
              .toList());
    } on SocketException {
      throw NetworkException();
    }
  }

  ///Returns a list of all available substitution dates in the format "dd.MM.yyyy"
  ///
  /// If the list is empty, the substitution plan is either empty or in non-AJAX format
  List<String> getSubstitutionDates(String document) {
    if (document.contains("Fehler - Schulportal Hessen - ")) {
      throw UnauthorizedException();
    } else {
      RegExp datePattern = RegExp(r'data-tag="(\d{2})\.(\d{2})\.(\d{4})"');
      Iterable<RegExpMatch> matches = datePattern.allMatches(document);

      List<String> uniqueDates = [];

      for (RegExpMatch match in matches) {
        int day = int.parse(match.group(1) ?? "00");
        int month = int.parse(match.group(2) ?? "00");
        int year = int.parse(match.group(3) ?? "00");
        DateTime extractedDate = DateTime(year, month, day);

        String dateString = extractedDate.format("dd.MM.yyyy");

        if (!uniqueDates.any((date) => date == dateString)) {
          uniqueDates.add(dateString);
        }
      }

      return uniqueDates;
    }
  }

  ///parses a the first occurrence of a string this type into a DateTime object
  ///"Letzte Aktualisierung: 08.05.2024 um 13:35:30 Uhr"
  DateTime? parseLastEditDate(String document) {
    RegExp lastEditPattern = RegExp(
        r'Letzte Aktualisierung: (\d{2})\.(\d{2})\.(\d{4}) um (\d{2}):(\d{2}):(\d{2}) Uhr');
    RegExpMatch? match = lastEditPattern.firstMatch(document);
    if (match == null) return null;
    int day = int.parse(match.group(1) ?? "00");
    int month = int.parse(match.group(2) ?? "00");
    int year = int.parse(match.group(3) ?? "00");
    int hour = int.parse(match.group(4) ?? "00");
    int minute = int.parse(match.group(5) ?? "00");
    int second = int.parse(match.group(6) ?? "00");
    return DateTime(year, month, day, hour, minute, second);
  }

  String parseStunde(String stunde) {
    final numbers =
        RegExp(r'\d+').allMatches(stunde).map((m) => m.group(0)!).toList();
    if (numbers.isEmpty || numbers.length > 2) return stunde;
    return numbers.length == 2 ? '${numbers[0]} - ${numbers[1]}' : numbers[0];
  }

  List<SubstitutionInfo> parseInformationTables(Element element) {
    List<SubstitutionInfo> infos = [];

    List<Element> tables = element.getElementsByClassName('infos');
    if (tables.isEmpty) return [];
    Element? table = tables[0];

    var rows = table.querySelectorAll('tr');
    bool isHeader = false;
    SubstitutionInfo? tmpInfo;
    for (var row in rows) {
      var cells = row.querySelectorAll('td');
      // This makes sure that different header class names are supported (e.g. subheader, sub-header)
      if (row.classes.join(',').contains('header')) isHeader = true;
      if (isHeader) {
        if (tmpInfo != null) {
          infos.add(tmpInfo);
        }
        tmpInfo =
            SubstitutionInfo(header: cells[0].text.trim(), values: []);
      } else {
        tmpInfo?.values.add(cells[0].innerHtml.trim());
      }
      isHeader = false;
    }
    if (tmpInfo != null) {
      infos.add(tmpInfo);
    }

    return infos;
  }
}
