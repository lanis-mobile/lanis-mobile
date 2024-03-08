import 'dart:convert';
import 'dart:io';

import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/client/client.dart';

import '../../shared/apps.dart';
import '../../shared/exceptions/client_status_exceptions.dart';

class SubstitutionsParser {
  late Dio dio;
  late SPHclient client;

  SubstitutionsParser(Dio dioClient, this.client) {
    dio = dioClient;
  }

  Future<Map<String, List<dynamic>>> getVplanNonAJAX() async {
    debugPrint("Trying to get substitution plan using non-JSON parser");
    DateFormat eingabeFormat = DateFormat('dd_MM_yyyy');
    final Map<String, List<dynamic>> fullPlan = {"dates": [], "entries": []};
    final document = parse((await dio
            .get("https://start.schulportal.hessen.de/vertretungsplan.php"))
        .data);
    final dates = document
        .querySelectorAll("[data-tag]")
        .map((element) => element.attributes["data-tag"]!);
    for (var date in dates) {
      final parsedDate = eingabeFormat.parse(date);
      fullPlan["dates"]!.add(date.replaceAll("_", "."));
      var entries = [];
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
        var entry = {
          "Stunde": headers.contains("Stunde")
              ? fields[headers.indexOf("Stunde")].text.trim()
              : "",
          "Klasse": headers.contains("Klasse")
              ? fields[headers.indexOf("Klasse")].text.trim()
              : "",
          "Vertreter": headers.contains("Vertretung")
              ? fields[headers.indexOf("Vertretung")].text.trim()
              : "",
          "Lehrer": headers.contains("Lehrer")
              ? fields[headers.indexOf("Lehrer")].text.trim()
              : "",
          "Art": headers.contains("Art")
              ? fields[headers.indexOf("Art")].text.trim()
              : "",
          "Fach": headers.contains("Fach")
              ? fields[headers.indexOf("Fach")].text.trim()
              : "",
          "Raum": headers.contains("Raum")
              ? fields[headers.indexOf("Raum")].text.trim()
              : "",
          "Hinweis": headers.contains("Hinweis")
              ? fields[headers.indexOf("Hinweis")].text.trim()
              : "",
          "Tag": parsedDate.format('dd.MM.yyyy')
        };
        entries.add(entry);
      }
      fullPlan["entries"]!.add(entries);
    }
    return fullPlan;
  }

  Future<dynamic> getSubstitutionsAJAX(String date) async {
    debugPrint("Trying to get substitution plan for $date");

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
      return jsonDecode(response.toString());
    } on SocketException {
      debugPrint("Substitution plan error: -3");
      throw NetworkException();
    } catch (e) {
      debugPrint("Substitution plan error: -4");
      throw LoggedOffOrUnknownException();
    }
  }

  Future<List<String>> getSubstitutionDates() async {
    try {
      final response = await dio
          .get('https://start.schulportal.hessen.de/vertretungsplan.php');

      String text = response.toString();

      if (text.contains("Fehler - Schulportal Hessen - ")) {
        throw UnauthorizedException();
      } else {
        RegExp datePattern = RegExp(r'data-tag="(\d{2})\.(\d{2})\.(\d{4})"');
        Iterable<RegExpMatch> matches = datePattern.allMatches(text);

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
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      throw LoggedOffOrUnknownException();
    }
  }

  Future<dynamic> getAllSubstitutions({skipCheck = false}) async {
    if (!skipCheck) {
      if (!client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
        throw NotSupportedException();
      }
    }

    try {
      var dates = await getSubstitutionDates();
      debugPrint(dates.toString());

      if (dates.isEmpty) {
        return getVplanNonAJAX();
      }

      final Map fullPlan = {"dates": [], "entries": []};

      for (String date in dates) {
        var plan = await getSubstitutionsAJAX(date);

        fullPlan["dates"].add(date);
        fullPlan["entries"].add(List.from(plan));
      }
      return fullPlan;
    } catch (e) {
      throw LoggedOffOrUnknownException();
    }
  }
}
