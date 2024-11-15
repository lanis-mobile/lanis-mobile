import 'dart:convert';
import 'dart:io';

import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/client/storage.dart';

import '../../shared/apps.dart';
import '../../shared/exceptions/client_status_exceptions.dart';

/// {"strict": Bool, "filter": List<[String]>}
typedef EntryFilter = Map<String, dynamic>;
typedef SubstitutionFilter = Map<String, EntryFilter>;

EntryFilter parseEntryFilter(Map<String, dynamic> json) {
  return json.map((key, value) {
    if (value is bool) {
      return MapEntry(key, value);
    } else if (value is List<dynamic>) {
      return MapEntry(key, List<String>.from(value));
    } else {
      throw Exception('Unexpected type for value in EntryFilter');
    }
  });
}

class SubstitutionsParser {
  late Dio dio;
  late SPHclient client;
  SubstitutionFilter localFilter = {};

  SubstitutionsParser(Dio dioClient, this.client) {
    dio = dioClient;
  }

  Future<String> getSubstitutionPlanDocument() async {
    try {
      final response = await dio
          .get("https://start.schulportal.hessen.de/vertretungsplan.php");
      return response.data;
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      rethrow;
    }
  }

  SubstitutionPlan parseVplanNonAJAX(String documentString) {
    DateFormat eingabeFormat = DateFormat('dd_MM_yyyy');
    final SubstitutionPlan fullPlan = SubstitutionPlan();
    final document = parse(documentString);
    final dates = document
        .querySelectorAll("[data-tag]")
        .map((element) => element.attributes["data-tag"]!);
    for (var date in dates) {
      DateTime parsedDate = eingabeFormat.parse(date);
      SubstitutionDay substitutionDay =
          SubstitutionDay(date: parsedDate.format('dd.MM.yyyy'));
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
            stunde: fields[headers.indexOf("Stunde")].text.trim(),
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
      final response = await dio.post(
          "https://start.schulportal.hessen.de/vertretungsplan.php",
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
          date: date,
          substitutions: (jsonDecode(response.toString()) as List)
              .map((e) => Substitution(
                  tag: e["Tag"],
                  tag_en: e["Tag_en"],
                  stunde: e["Stunde"],
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
    } catch (e) {
      throw UnknownException();
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

  Future<SubstitutionPlan> getAllSubstitutions({required bool filtered, skipLoginCheck = false}) async {
    if (!skipLoginCheck) {
      if (!client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
        throw NotSupportedException();
      }
    }

    try {
      String document = await getSubstitutionPlanDocument();
      DateTime? lastEdit = parseLastEditDate(document);
      var dates = getSubstitutionDates(document);

      if (dates.isEmpty) {
        SubstitutionPlan plan = parseVplanNonAJAX(document);
        if (filtered) plan.filterAll(localFilter);
        return plan;
      }

      final fullPlan = SubstitutionPlan();
      fullPlan.lastUpdated = lastEdit ?? DateTime.now();
      List<Future<SubstitutionDay>> futures = dates.map((date) => getSubstitutionsAJAX(date)).toList();
      List<SubstitutionDay> plans = await Future.wait(futures);
      for (SubstitutionDay plan in plans) {
        fullPlan.add(plan);
      }
      if (filtered) fullPlan.filterAll(localFilter);
      fullPlan.removeEmptyDays();
      return fullPlan;
    } catch (e) {
      rethrow;
    }
  }

  void loadFilterFromStorage() async {
    String filterString = await globalStorage.read(key: StorageKey.substitutionsFilter);
    if (filterString == "") return;
    localFilter = Map<String, EntryFilter>.from(jsonDecode(filterString)).map((key, value) {
      return MapEntry(key, parseEntryFilter(Map<String, dynamic>.from(value)));
    });
  }

  void saveFilterToStorage() async {
    await globalStorage.write(key: StorageKey.substitutionsFilter, value: jsonEncode(localFilter));
  }

  ///parses a the first occurence of a string this type into a DateTime object
  ///"Letzte Aktualisierung: 08.05.2024 um 13:35:30 Uhr"
  DateTime? parseLastEditDate(String document) {
    RegExp lastEditPattern = RegExp(r'Letzte Aktualisierung: (\d{2})\.(\d{2})\.(\d{4}) um (\d{2}):(\d{2}):(\d{2}) Uhr');
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
}


/// A data class to store a single substitution information
class Substitution {
  ///String of the format "dd.MM.yyyy"
  final String tag;

  ///String of the format "yyyy-MM-dd"
  final String tag_en;

  ///String of the format "1" or "1 - 2"
  final String stunde;
  final String? vertreter;
  final String? lehrer;
  final String? klasse;
  final String? klasse_alt;
  final String? fach;
  final String? fach_alt;
  final String? raum;
  final String? raum_alt;
  final String? hinweis;
  final String? hinweis2;
  final String? art;
  final String? Lehrerkuerzel;
  final String? Vertreterkuerzel;
  final lerngruppe;
  final List? hervorgehoben;

  Substitution(
      {required this.tag,
      required this.tag_en,
      required this.stunde,
      this.vertreter,
      this.lehrer,
      this.klasse,
      this.klasse_alt,
      this.fach,
      this.fach_alt,
      this.raum,
      this.raum_alt,
      this.hinweis,
      this.hinweis2,
      this.art,
      this.Lehrerkuerzel,
      this.Vertreterkuerzel,
      this.lerngruppe,
      this.hervorgehoben});

  bool passesFilter(SubstitutionFilter substitutionsFilter) {
    Map<String, Function> filterFunctions = {
      "Klasse": (filter) => filterElement(klasse, filter["filter"], filter["strict"]),
      "Fach": (filter) => filterElement(fach, filter["filter"], filter["strict"]),
      "Fach_alt": (filter) => filterElement(fach_alt, filter["filter"], filter["strict"]),
      "Lehrer": (filter) => filterElement(lehrer, filter["filter"], filter["strict"]),
      "Raum": (filter) => filterElement(raum, filter["filter"], filter["strict"]),
      "Art": (filter) => filterElement(art, filter["filter"], filter["strict"]),
      "Hinweis": (filter) => filterElement(hinweis, filter["filter"], filter["strict"]),
      "Vertreter": (filter) => filterElement(vertreter, filter["filter"], filter["strict"]),
      "Stunde": (filter) => filterElement(stunde, filter["filter"], filter["strict"]),
      "Lehrerkuerzel": (filter) => filterElement(Lehrerkuerzel, filter["filter"], filter["strict"]),
      "Vertreterkuerzel": (filter) => filterElement(Vertreterkuerzel, filter["filter"], filter["strict"]),
      "Klasse_alt": (filter) => filterElement(klasse_alt, filter["filter"], filter["strict"]),
      "Raum_alt": (filter) => filterElement(raum_alt, filter["filter"], filter["strict"]),
      "Hinweis2": (filter) => filterElement(hinweis2, filter["filter"], filter["strict"]),
    };

    for (var key in substitutionsFilter.keys) {
      final filter = substitutionsFilter[key];
      if (filter == null || filter["filter"] == null || filter["filter"].isEmpty) {
        continue;
      }
      if (filterFunctions.containsKey(key) && !filterFunctions[key]!(filter)) {
        return false;
      }
    }
    return true;
  }

  ///returns true if the value contains all of the filter elements
  bool filterElement(String? value, List<String> filter, bool? strict) {
    if (value == null) {
      return false;
    }
    if (!(strict??true)) {
      return filter.any((element) => value.contains(element));
    }
    for (var singleFilter in filter) {
      if (!value.contains(singleFilter)) {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> toJson() => {
    'tag': tag,
    'tag_en': tag_en,
    'stunde': stunde,
    'vertreter': vertreter,
    'lehrer': lehrer,
    'klasse': klasse,
    'klasse_alt': klasse_alt,
    'fach': fach,
    'fach_alt': fach_alt,
    'raum': raum,
    'raum_alt': raum_alt,
    'hinweis': hinweis,
    'hinweis2': hinweis2,
    'art': art,
    'Lehrerkuerzel': Lehrerkuerzel,
    'Vertreterkuerzel': Vertreterkuerzel,
    'lerngruppe': lerngruppe,
    'hervorgehoben': hervorgehoben,
  };

  Substitution.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        tag_en = json['tag_en'],
        stunde = json['stunde'],
        vertreter = json['vertreter'],
        lehrer = json['lehrer'],
        klasse = json['klasse'],
        klasse_alt = json['klasse_alt'],
        fach = json['fach'],
        fach_alt = json['fach_alt'],
        raum = json['raum'],
        raum_alt = json['raum_alt'],
        hinweis = json['hinweis'],
        hinweis2 = json['hinweis2'],
        art = json['art'],
        Lehrerkuerzel = json['Lehrerkuerzel'],
        Vertreterkuerzel = json['Vertreterkuerzel'],
        lerngruppe = json['lerngruppe'],
        hervorgehoben = json['hervorgehoben'];

}

/// A data class to store all substitution information for a single day
class SubstitutionDay {
  final String date;
  final List<Substitution> substitutions;

  SubstitutionDay({required this.date, List<Substitution>? substitutions})
      : substitutions = substitutions ?? [];

  void add(Substitution substitution) {
    substitutions.add(substitution);
  }

  void filterAll(SubstitutionFilter filter) {
    substitutions.removeWhere((element) => !element.passesFilter(filter));
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'substitutions': substitutions.map((s) => s.toJson()).toList(),
  };

  SubstitutionDay.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        substitutions = (json['substitutions'] as List)
            .map((i) => Substitution.fromJson(i))
            .toList();
}

/// A data class to store all substitution information available
class SubstitutionPlan {
  final List<SubstitutionDay> days;
  DateTime lastUpdated = DateTime.now();

  SubstitutionPlan({List<SubstitutionDay>? days}) : days = days ?? [];

  void add(SubstitutionDay substitutionDay) {
    days.add(substitutionDay);
  }

  List<Substitution> get allSubstitutions {
    List<Substitution> allSubs = [];
    for (var day in days) {
      allSubs.addAll(day.substitutions);
    }
    return allSubs;
  }

  void removeEmptyDays() {
    days.removeWhere((day) => day.substitutions.isEmpty);
  }

  void filterAll(SubstitutionFilter filter) {
    for (var day in days) {
      day.filterAll(filter);
    }
    removeEmptyDays();
  }

  Map<String, dynamic> toJson() => {
    'days': days.map((d) => d.toJson()).toList(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  SubstitutionPlan.fromJson(Map<String, dynamic> json)
      : days = (json['days'] as List)
      .map((i) => SubstitutionDay.fromJson(i))
      .toList(),
        lastUpdated = DateTime.parse(json['lastUpdated']);
}
