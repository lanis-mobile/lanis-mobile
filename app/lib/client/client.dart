import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/parser.dart';

class SPHclient {
  final statusCodes = {
    0: "No errors",
    -1: "Wrong credits",
    -2: "no username or password or schoolID defined",
    -3: "network error",
    -4: "unknown error, are you logged in?",
    -5: "Not authenticated"
  };

  String username = "";
  String password = "";
  String schoolID = "";
  String schoolName = "";
  dynamic userData = {};
  late PersistCookieJar jar;

  final dio = Dio();

  final storage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> prepareDio() async {
    final Directory appDocDir = await getApplicationCacheDirectory();
    final String appDocPath = appDocDir.path;
    jar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage("$appDocPath/cookies"));
    dio.interceptors.add(CookieManager(jar));
    dio.options.followRedirects = false;
    dio.options.validateStatus =
        (status) => status != null && (status == 200 || status == 302);
  }

  Future<void> overwriteCredits(
      String username, String password, String schoolID) async {
    this.username = username;
    this.password = password;
    this.schoolID = schoolID;

    await storage.write(
        key: "username", value: username, aOptions: _getAndroidOptions());
    await storage.write(
        key: "password", value: password, aOptions: _getAndroidOptions());
    await storage.write(
        key: "schoolID", value: schoolID, aOptions: _getAndroidOptions());
  }

  Future<void> loadFromStorage() async {
    username =
        await storage.read(key: "username", aOptions: _getAndroidOptions()) ??
            "";
    password =
        await storage.read(key: "password", aOptions: _getAndroidOptions()) ??
            "";
    schoolID =
        await storage.read(key: "schoolID", aOptions: _getAndroidOptions()) ??
            "";

    schoolName =
        await storage.read(key: "schoolName", aOptions: _getAndroidOptions()) ??
            "";

    userData =
        jsonDecode(await storage.read(key: "userData", aOptions: _getAndroidOptions()) ??
            "{}");
  }

  Future<dynamic> getCredits() async {
    return {
      "username":
          await storage.read(key: "username", aOptions: _getAndroidOptions()) ??
              "",
      "password":
          await storage.read(key: "password", aOptions: _getAndroidOptions()) ??
              "",
      "schoolID":
          await storage.read(key: "schoolID", aOptions: _getAndroidOptions()) ??
              "",
      "schoolName": await storage.read(
              key: "schoolName", aOptions: _getAndroidOptions()) ??
          ""
    };
  }

  Future<int> login() async {
    jar.deleteAll();
    dio.options.validateStatus =
        (status) => status != null && (status == 200 || status == 302);
    try {
      if (username != "" && password != "" && schoolID != "") {
        final response1 = await dio.post(
            "https://login.schulportal.hessen.de/?i=$schoolID",
            queryParameters: {
              "user": '$schoolID.$username',
              "user2": username,
              "password": password
            },
            options: Options(contentType: "application/x-www-form-urlencoded"));
        if (response1.headers.value(HttpHeaders.locationHeader) != null) {
          //credits are valid
          final response2 =
              await dio.get("https://connect.schulportal.hessen.de");

          String location2 =
              response2.headers.value(HttpHeaders.locationHeader) ?? "";
          await dio.get(location2);

          schoolName = (await getSchoolInfo(schoolID))["Name"];
          await storage.write(
              key: "schoolName",
              value: schoolName,
              aOptions: _getAndroidOptions());

          userData = await fetchUserData();

          await storage.write(
              key: "userData",
              value: jsonEncode(userData),
              aOptions: _getAndroidOptions());

          return 0;
        } else {
          return -1;
        }
      } else {
        return -2;
      }
    } on SocketException {
      return -3;
    } on DioException {
      return -3;
    } catch (e) {
      debugPrint(e.toString());
      return -4;
    }
  }

  Future<dynamic> getLoginURL() async {
    final dioHttp = Dio();
    final cookieJar = CookieJar();
    dioHttp.interceptors.add(CookieManager(cookieJar));
    dioHttp.options.followRedirects = false;
    dioHttp.options.validateStatus =
        (status) => status != null && (status == 200 || status == 302);

    try {
      if (username != "" && password != "" && schoolID != "") {
        final response1 = await dioHttp.post(
            "https://login.schulportal.hessen.de/?i=$schoolID",
            queryParameters: {
              "user": '$schoolID.$username',
              "user2": username,
              "password": password
            },
            options: Options(contentType: "application/x-www-form-urlencoded"));
        if (response1.headers.value(HttpHeaders.locationHeader) != null) {
          //credits are valid
          final response2 =
          await dioHttp.get("https://connect.schulportal.hessen.de");

          String location2 =
              response2.headers.value(HttpHeaders.locationHeader) ?? "";

          return location2;
        } else {
          return -1;
        }
      } else {
        return -2;
      }
    } catch (e) {
      return -4;
    }
  }

  Future<dynamic> getVplan(String date) async {
    try {
      final response = await dio.post(
          "https://start.schulportal.hessen.de/vertretungsplan.php",
          queryParameters: {"tag": date, "ganzerPlan": "true"},
          data: 'tag=$date&ganzerPlan=true',
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
      return -3;
      //network error
    } catch (e) {
      return -4;
      //unknown error;
    }
  }

  Future<dynamic> getCalendar(String startDate, String endDate) async {
    try {
      final response = await dio.post(
          "https://start.schulportal.hessen.de/kalender.php",
          queryParameters: {
            "f": "getEvents",
            "start": startDate,
            "end": endDate
          },
          data: 'f=getEvents&start=$startDate&end=$endDate',
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
      return -3;
      //network error
    } catch (e) {
      return -4;
      //unknown error
    }
  }

  Future<dynamic> getVplanDates() async {
    try {
      final response = await dio
          .get('https://start.schulportal.hessen.de/vertretungsplan.php');

      String text = response.toString();

      if (text.contains("Fehler - Schulportal Hessen - ")) {
        return -5;
      } else {
        RegExp datePattern = RegExp(r'data-tag="(\d{2})\.(\d{2})\.(\d{4})"');
        Iterable<RegExpMatch> matches = datePattern.allMatches(text);

        var uniqueDates = [];

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

        if (uniqueDates.isEmpty) {
          return [];
        }

        return uniqueDates;
      }
    } on SocketException {
      return -3;
      //network error
    } catch (e) {
      return -4;
      //unknown error;
    }
  }

  Future<dynamic> getFullVplan() async {
    try {
      var dates = await getVplanDates();

      List fullPlan = [];

      for (String date in dates) {
        var planForDate = await getVplan(date);
        if (planForDate is int) {
          return planForDate;
        } else {
          fullPlan.addAll(List.from(planForDate));
        }
      }

      return fullPlan;
    } catch (e) {
      return -4;
      //unknown error;
    }
  }

  Future<bool> isAuth() async {
    try {
      final response = await dio.get(
          "https://start.schulportal.hessen.de/benutzerverwaltung.php?a=userData");
      String responseText = response.data.toString();
      if (responseText.contains("Fehler - Schulportal Hessen") ||
          username.isEmpty ||
          password.isEmpty ||
          schoolID.isEmpty) {
        return false;
      } else if (responseText.contains(username)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getSchoolInfo(String schoolID) async {
    final response = await dio.get(
        "https://startcache.schulportal.hessen.de/exporteur.php?a=school&i=5182");
    return jsonDecode(response.data.toString());
  }

  Future<dynamic> fetchUserData() async {
    final response = await dio.get(
        "https://start.schulportal.hessen.de/benutzerverwaltung.php?a=userData");
    var document = parse(response.data);
    var userDataTableBody =
        document.querySelector("div.col-md-12 table.table.table-striped tbody");

    //TODO find out how "Zugeordnete Eltern/Erziehungsberechtigte" is used in this scope

    if (userDataTableBody != null) {
      var result = {};

      var rows = userDataTableBody.querySelectorAll("tr");
      for (var row in rows) {
        var key = row.children[0].innerHtml;
        var value = row.children[1].text;

        key = (key.substring(0, key.length - 1)).toLowerCase();

        result[key] = value;
      }

      return result;
    } else {
      return {};
    }
  }

  Future<void> saveUserData(data) async {
    await storage.write(
        key: "userData",
        value: jsonEncode(data),
        aOptions: _getAndroidOptions());
  }

  Future<void> deleteAllSettings() async {
    jar.deleteAll();
    storage.deleteAll(aOptions: _getAndroidOptions());
  }

  Future<dynamic> getMeinUnterrichtOverview() async {
    final response = await dio.get(
        "https://start.schulportal.hessen.de/meinunterricht.php");
    var document = parse(response.data);
    var schoolClasses = document.querySelectorAll("tr.printable");
    var result = [];

    for (var schoolClass in schoolClasses) {
      var teacher = schoolClass.getElementsByClassName("teacher")[0];

      result.add({
        "name": schoolClass.querySelector(".name")?.text,
        "teacher": {
          "short": teacher.getElementsByClassName("btn btn-primary dropdown-toggle btn-xs")[0].text,
          "name": teacher.getElementsByClassName("dropdown-menu")[0].text
        },
        "thema": {
          "title": schoolClass.getElementsByClassName("thema")[0].text,
          "date": schoolClass.getElementsByClassName("datum")[0].text
        },
        "data": {
          "entry": schoolClass.attributes["data-entry"],
          "book": schoolClass.attributes["data-entry"]
        }
      });
    }

    debugPrint(result.toString());
  }
}

SPHclient client = SPHclient();
