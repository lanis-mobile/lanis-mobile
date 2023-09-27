import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class SPHclient {
  final statusCodes = {
    0: "No errors",
    -1: "Wrong credits",
    -2: "no username or password or schoolID defined",
    -3: "network error",
    -4: "unknown error",
    -5: "Not authenticated"
  };

  String username = "";
  String password = "";
  String schoolID = "5182";

  final dio = Dio();

  final storage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  SPHclient();

  Future<void> prepareDio() async {
    final Directory appDocDir = await getApplicationCacheDirectory();
    final String appDocPath = appDocDir.path;
    debugPrint(
        "APPDOCPATH: ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $appDocPath");
    final jar = PersistCookieJar(
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

  Future<void> loadCreditsFromStorage() async {
    username =
        await storage.read(key: "username", aOptions: _getAndroidOptions()) ??
            "";
    password =
        await storage.read(key: "password", aOptions: _getAndroidOptions()) ??
            "";
    schoolID =
        await storage.read(key: "schoolID", aOptions: _getAndroidOptions()) ??
            "";
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
              ""
    };
  }

  Future<int> login() async {
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
      debugPrint("vplanDate: $dates");

      for (String date in dates) {
        var planForDate = await getVplan(date);
        debugPrint(planForDate.toString());
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
    //   Fetching the vPlan on an expired Date. This ensures, that the user is
    //   authenticated and when he is there will be an minimal response
    final response = await getVplan("26.09.23"); //some expired date

    if (response is List) {
      return true;
    } else {
      return false;
    }
  }
}

SPHclient client = SPHclient();
