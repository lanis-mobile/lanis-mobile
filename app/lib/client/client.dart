import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/parser.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:sph_plan/client/cryptor.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:sph_plan/themes.dart';

import '../shared/shared_functions.dart';

class SPHclient {
  final statusCodes = {
    0: "Alles supper Brudi!",
    -1: "Falsche Anmeldedaten",
    -2: "Nicht alle Anmeldedaten angegeben",
    -3: "Netzwerkfehler",
    -4: "Unbekannter Fehler! Bist du eingeloggt?",
    -5: "Keine Erlaubnis",
    -6: "Verschlüsselungsüberprüfung fehlgeschlagen",
    -7: "Unbekannter Fehler! Antwort war nicht salted.",
    -8: "Nicht unterstützt!",
    -9: "Kein Internet."
  };

  String username = "";
  String password = "";
  String schoolID = "";
  String schoolName = "";
  String schoolImage = "";
  String loadMode = "";
  dynamic userData = {};
  List<dynamic> supportedApps = [];
  late PersistCookieJar jar;
  final dio = Dio();
  late Cryptor cryptor = Cryptor();

  SubstitutionsFetcher? substitutionsFetcher;
  MeinUnterrichtFetcher? meinUnterrichtFetcher;
  VisibleConversationsFetcher? visibleConversationsFetcher;
  InvisibleConversationsFetcher? invisibleConversationsFetcher;
  CalendarFetcher? calendarFetcher;

  void prepareFetchers() {
    if (client.loadMode == "full") {
      if (client.doesSupportFeature("Vertretungsplan") && substitutionsFetcher == null) {
        substitutionsFetcher = SubstitutionsFetcher(const Duration(minutes: 15));
      }
      if ((client.doesSupportFeature("mein Unterricht") || client.doesSupportFeature("Mein Unterricht")) && meinUnterrichtFetcher == null) {
        meinUnterrichtFetcher = MeinUnterrichtFetcher(const Duration(minutes: 15));
      }
      if (client.doesSupportFeature("Nachrichten - Beta-Version")) {
        visibleConversationsFetcher ??= VisibleConversationsFetcher(const Duration(minutes: 15));
        invisibleConversationsFetcher ??= InvisibleConversationsFetcher(const Duration(minutes: 15));
      }
      if (client.doesSupportFeature("Kalender") && calendarFetcher == null) {
        calendarFetcher = CalendarFetcher(null);
      }
    } else {
      if (client.doesSupportFeature("Vertretungsplan") && substitutionsFetcher == null) {
        substitutionsFetcher = SubstitutionsFetcher(null);
      }
      if ((client.doesSupportFeature("mein Unterricht") || client.doesSupportFeature("Mein Unterricht")) && meinUnterrichtFetcher == null) {
        meinUnterrichtFetcher = MeinUnterrichtFetcher(null);
      }
      if (client.doesSupportFeature("Nachrichten - Beta-Version")) {
        visibleConversationsFetcher ??= VisibleConversationsFetcher(null);
        invisibleConversationsFetcher ??= InvisibleConversationsFetcher(null);
      }
      if (client.doesSupportFeature("Kalender") && calendarFetcher == null) {
        calendarFetcher = CalendarFetcher(null);
      }
    }
  }

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

  Future<void> overwriteCredits(String username, String password,
      String schoolID) async {
    this.username = username;
    this.password = password;
    this.schoolID = schoolID;

    await globalStorage.write(key: "username", value: username);
    await globalStorage.write(key: "password", value: password, secure: true);
    await globalStorage.write(key: "schoolID", value: schoolID);
  }


  Future<void> loadFromStorage() async {
    loadMode = await globalStorage.read(key: "loadMode") ?? "fast";

    username = await globalStorage.read(key: "username") ?? "";
    password = await globalStorage.read(key: "password", secure: true) ?? "";
    schoolID = await globalStorage.read(key: "schoolID") ?? "";

    schoolImage = await globalStorage.read(key: "schoolImage") ?? "";

    schoolName = await globalStorage.read(key: "schoolName") ?? "";

    userData = jsonDecode(await globalStorage.read(key: "userData") ?? "{}");

    supportedApps =
        jsonDecode(await globalStorage.read(key: "supportedApps") ?? "[]");
  }

  Future<dynamic> getCredits() async {
    return {
      "username": await globalStorage.read(key: "username") ?? "",
      "password": await globalStorage.read(key: "password", secure: true) ?? "",
      "schoolID": await globalStorage.read(key: "schoolID") ?? "",
      "schoolName": await globalStorage.read(key: "schoolName") ?? ""
    };
  }

  Future<int> login({userLogin = false}) async {
    debugPrint("Trying to log in");

    if (!(await InternetConnectionChecker().hasConnection)) {
      return -9;
    }

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

          if (userLogin) {
            await fetchRedundantData();
          }
          await getSchoolTheme();

          int encryptionStatusName = await startLanisEncryption();
          debugPrint(
              "Encryption connected with status code: $encryptionStatusName");

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
    } catch (e, stack) {
      recordError(e, stack);
      debugPrint(e.toString());
      return -4;
    }
  }

  Future<void> fetchRedundantData() async {
    final schoolInfo = await getSchoolInfo(schoolID);

    schoolImage = await getSchoolImage(schoolInfo["bgimg"]["sm"]["url"]);
    await globalStorage.write(key: "schoolImage", value: schoolImage);

    schoolName = schoolInfo["Name"];
    await globalStorage.write(key: "schoolName", value: schoolName);

    userData = await fetchUserData();
    supportedApps = await getSupportedApps();

    await globalStorage.write(key: "userData", value: jsonEncode(userData));

    await globalStorage.write(
        key: "supportedApps", value: jsonEncode(supportedApps));
  }

  Future<void> getSchoolTheme() async {
    debugPrint("Trying to get a school accent color.");

    if (await globalStorage.read(key: "schoolColor") == null) {
      try {
        dynamic schoolInfo = await client.getSchoolInfo(schoolID);

        int schoolColor = int.parse("FF${schoolInfo["Farben"]["bg"].substring(1)}", radix: 16);

        Themes.schoolTheme = Themes.getNewTheme(Color(schoolColor));

        if ((await globalStorage.read(key: "color")) == "school") {
          ColorModeNotifier.set("school", Themes.schoolTheme);
        }

        await globalStorage.write(key: "schoolColor", value: schoolColor.toString());
      } on Exception catch (_) {}
    }
  }

  Future<String> getSchoolImage(String url) async {
    try {
      final Directory dir = await getApplicationDocumentsDirectory();

      String savePath = "${dir.path}/school.jpg";

      Directory folder = Directory(dir.path);
      if (!(await folder.exists())) {
        await folder.create(recursive: true);
      }

      File existingFile = File(savePath);
      if (await existingFile.exists()) {
        return savePath;
      }

      await dio.download(
        url,
        savePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          headers: {
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
            "Sec-Fetch-Dest": "document",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-Site": "none",
          },
        ),
      );

      return savePath;
    } catch (e, stack) {
      recordError(e, stack);
      return "";
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
    } catch (e, stack) {
      recordError(e, stack);
      return -4;
    }
  }

  Future<dynamic> getVplan(String date) async {
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
      return -3;
      //network error
    } catch (e, stack) {
      debugPrint("Substitution plan error: -4");
      recordError(e, stack);
      return -4;
      //unknown error;
    }
  }

  Future<dynamic> getCalendar(String startDate, String endDate) async {
    if (!client.doesSupportFeature("Kalender")) {
      return -8;
    }

    debugPrint("Trying to get calendar...");

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
      debugPrint("Calendar: -3");
      return -3;
      //network error
    } catch (e, stack) {
      debugPrint("Calendar: -4");
      recordError(e, stack);
      return -4;
      //unknown error
    }
  }

  Future<dynamic> getEvent(String id) async {
    if (!(await InternetConnectionChecker().hasConnection)) {
      return -9;
    }

    try {
      final response = await dio.post(
          "https://start.schulportal.hessen.de/kalender.php",
          data: {
            "f": "getEvent",
            "id": id,
          },
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
    } catch (e, stack) {
      recordError(e, stack);
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
    } catch (e, stack) {
      recordError(e, stack);
      return -4;
      //unknown error;
    }
  }

  Future<dynamic> getFullVplan({skipCheck= false}) async {
    if (!skipCheck) {
      if (!client.doesSupportFeature("Vertretungsplan")) {
        return -8;
      }
    }
    
    try {
      var dates = await getVplanDates();

      final Map fullPlan = {"dates": [], "entries": []};

      for (String date in dates) {
        var plan = await getVplan(date);

        if (plan is int) {
          return plan;
        }

        fullPlan["dates"].add(date);
        fullPlan["entries"].add(List.from(plan));

      }
      return fullPlan;
    } catch (e, stack) {
      recordError(e, stack);
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
    } catch (e, stack) {
      recordError(e, stack);
      return false;
    }
  }

  Future<dynamic> getSchoolInfo(String schoolID) async {
    final response = await dio.get(
        "https://startcache.schulportal.hessen.de/exporteur.php?a=school&i=$schoolID");
    return jsonDecode(response.data.toString());
  }

  Future<dynamic> getSupportedApps() async {
    final response = await dio.get(
        "https://start.schulportal.hessen.de/startseite.php?a=ajax&f=apps");
    return jsonDecode(response.data.toString())["entrys"];
  }

  final List<String> _onlySupportedByStudents = [
    "mein Unterricht",
    "Mein Unterricht"
  ];

  bool doesSupportFeature(String featureName) {
    for (var app in supportedApps) {
      if (app["Name"] == featureName) {
        if ((_onlySupportedByStudents.contains(featureName))) {
          return isStudentAccount();
        } else {
          return true;
        }
      }
    }
    return false;
  }

  bool isStudentAccount() {
    return userData.containsKey("klasse");
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
        var key = row.children[0].text.trim();
        var value = row.children[1].text.trim();

        key = (key.substring(0, key.length - 1)).toLowerCase();

        result[key] = value;
      }

      return result;
    } else {
      return {};
    }
  }

  Future<void> saveUserData(data) async {
    await globalStorage.write(key: "userData", value: jsonEncode(data));
  }

  Future<void> deleteAllSettings() async {
    jar.deleteAll();
    globalStorage.deleteAll();
    ColorModeNotifier.set("standard", Themes.standardTheme);
    ThemeModeNotifier.set("system");

    var tempDir = await getTemporaryDirectory();
    await deleteSubfoldersAndFiles(tempDir);
  }

  Future<void> deleteSubfoldersAndFiles(Directory directory) async {
    await for (var entity in directory.list()) {
      if (entity is File) {
        await entity.delete(recursive: true);
      } else if (entity is Directory) {
        await deleteSubfoldersAndFiles(entity);
        await entity.delete(recursive: true);
      }
    }
  }

  Future<dynamic> getMeinUnterrichtOverview() async {
    if (!(client.doesSupportFeature("Mein Unterricht") || client.doesSupportFeature("mein Unterricht"))) {
      return -8;
    }
    
    debugPrint("Get Mein Unterricht overview");

    var result = {"aktuell": [], "anwesenheiten": [], "kursmappen": []};

    final response =
        await dio.get("https://start.schulportal.hessen.de/meinunterricht.php");
    var encryptedHTML = cryptor.decryptEncodedTags(response.data);
    var document = parse(encryptedHTML);

    //Aktuelle Einträge
    () {
      var schoolClasses = document.querySelectorAll("tr.printable");
      for (var schoolClass in schoolClasses) {
        var teacher = schoolClass.querySelector(".teacher");

        result["aktuell"]?.add({
          "name": schoolClass.querySelector(".name")?.text.trim(),
          "teacher": {
            "short": teacher
                ?.getElementsByClassName(
                    "btn btn-primary dropdown-toggle btn-xs")[0]
                .text.trim(),
            "name": teacher?.querySelector("ul>li>a>i.fa")?.parent?.text.trim()
          },
          "thema": {
            "title": schoolClass.querySelector(".thema")?.text.trim(),
            "date": schoolClass.querySelector(".datum")?.text.trim()
          },
          "data": {
            "entry": schoolClass.attributes["data-entry"],
            "book": schoolClass.attributes["data-entry"]
          },
          "_courseURL": schoolClass.querySelector("td>h3>a")?.attributes["href"]
        });
      }
    }();

    //Anwesenheiten
    var anwesendDOM = document.getElementById("anwesend");
    () {
      var thead = anwesendDOM?.querySelector("thead>tr");
      var tbody = anwesendDOM?.querySelectorAll("tbody>tr");

      var keys = [];
      thead?.children.forEach((element) => keys.add(element.text.trim()));

      tbody?.forEach((elem) {
        var textElements = [];
        for (var i = 0; i < elem.children.length; i++) {
          var element = elem.children[i];
          element.querySelector("div.hidden.hidden_encoded")?.innerHtml = "";

          if (keys[i] != "Kurs") {
            textElements
                .add(element.text.trim());
          } else {
            textElements.add(element.text.trim());
          }
        }

        var rowEntry = {};

        for (int i = 0; i < keys.length; i++) {
          var key = keys[i];
          var value = textElements[i];

          rowEntry[key] = value;
        }

        //get url of course
        var hyperlinkToCourse = elem.getElementsByTagName("a")[0];
        rowEntry["_courseURL"] = hyperlinkToCourse.attributes["href"];

        result["anwesenheiten"]?.add(rowEntry);
      });
    }();

    //Kursmappen
    var kursmappenDOM = document.getElementById("mappen");
    () {
      var parsedMappen = [];

      var mappen = kursmappenDOM?.getElementsByClassName("row")[0].children;

      for (var mappe in mappen!) {
        parsedMappen.add({
          "title": mappe.getElementsByTagName("h2")[0].text.trim(),
          "teacher":
              mappe.querySelector("div.btn-group>button")?.attributes["title"],
          "_courseURL":
              mappe.querySelector("a.btn.btn-primary")?.attributes["href"]
        });
      }
      result["kursmappen"] = parsedMappen;
    }();

    debugPrint("Successfully got Mein Unterricht.");
    return result;
  }

  Future<dynamic> setHomeworkDone(String courseID, String courseEntry, bool status) async {
    //returns the response of the http request. 1 means success.

    final response = await dio.post(
      "https://start.schulportal.hessen.de/meinunterricht.php",
      data: {
        "a": "sus_homeworkDone",
        "entry": courseEntry,
        "id": courseID,
        "b": status ? "done" : "undone"
      },
      options: Options(
        headers: {
          "Content-Type":
              "application/x-www-form-urlencoded; charset=UTF-8",
          "X-Requested-With": "XMLHttpRequest", //this is important
        },
      ),
    );


    return response.data;
  }

  Future<dynamic> getMeinUnterrichtCourseView(String url) async {
    try {
      var result = {
        "historie": [],
        "leistungen": [],
        "leistungskontrollen": [],
        "anwesenheiten": [],
        "name": ["name"],
      };

      String courseID = url.split("id=")[1];

      final response =
          await dio.get("https://start.schulportal.hessen.de/$url");
      var encryptedHTML = cryptor.decryptEncodedTags(response.data);
      var document = parse(encryptedHTML);

      //course name
      var heading = document.getElementById("content")?.querySelector("h1");
      heading?.children[0].innerHtml = "";
      result["name"] = [
        heading?.text.trim()
      ];

      //historie
      () {
        var historySection = document.getElementById("history");
        var tableRows = historySection?.querySelectorAll("table>tbody>tr");

        tableRows?.forEach((tableRow) {
          tableRow.children[2]
              .querySelector("div.hidden.hidden_encoded")
              ?.innerHtml = "";

          Map<String, String> markups = {};

          // There is also a css selector :has() but it's not implemented yet.
          final String? content = tableRow.children[1].querySelector("span.markup i.far.fa-comment-alt:first-child")?.parent?.text.trim();
          if (content != null && content.startsWith(" ")) {
            markups["content"] = content.substring(1);
          } else if (content != null) {
            markups["content"] = content;
          }

          final String? homework = tableRow.children[1].querySelector("span.homework + br + span.markup")?.text.trim();
          bool homeworkDone = false;

          if (homework != null) {
            homeworkDone = tableRow.querySelectorAll("span.done.hidden").isEmpty;
            if (homework.startsWith(" ")) {
              markups["homework"] = homework.substring(1);
            } else {
              markups["homework"] = homework;
            }
          }

          List files = [];
          if (tableRow.children[1].querySelector("div.alert.alert-info") != null) {
            String baseURL = "https://start.schulportal.hessen.de/";
            baseURL += tableRow.children[1].querySelector("div.alert.alert-info>a")!.attributes["href"]!;
            baseURL = baseURL.replaceAll("&b=zip", "");

            for (var fileDiv in tableRow.getElementsByClassName("files")[0].children) {
              String? filename = fileDiv.attributes["data-file"];
              files.add({
                "filename": filename,
                "filesize": fileDiv.querySelector("a>small")?.text,
                "url": "$baseURL&f=$filename",
              });
            }
          }

          result["historie"]?.add({
            "time": tableRow.children[0].text.trim().replaceAll("  ", "").replaceAll("\n", " ").replaceAll("  ", " "),
            "title": tableRow.children[1].querySelector("big>b")?.text.trim(),
            "markup": markups,
            "entry-id": tableRow.attributes["data-entry"],
            "course-id": courseID,
            "homework-done": homeworkDone,
            "presence": tableRow.children[2].text.trim(),
            "files": files
          });
        });
      }();

      //anwesenheiten
      () {
        var presenceSection = document.getElementById("attendanceTable");
        var tableRows = presenceSection?.querySelectorAll("table>tbody>tr");

        tableRows?.forEach((row) {
          var encodedElements = row.getElementsByClassName("hidden_encoded");
          for (var e in encodedElements) {
            e.innerHtml = "";
          }

          result["anwesenheiten"]?.add(
              {"type": row.children[0].text.trim(), "count": row.children[1].text.trim()});
        });
      }();

      //leistungen
      () {
        var marksSection = document.getElementById("marks");
        var tableRows = marksSection?.querySelectorAll("table>tbody>tr");

        tableRows?.forEach((row) {
          var encodedElements = row.getElementsByClassName("hidden_encoded");
          for (var e in encodedElements) {
            e.innerHtml = "";
          }

          if (row.children.length == 3) {
            result["leistungen"]?.add({
              "Name":
              row.children[0].text.trim(),
              "Datum":
              row.children[1].text.trim(),
              "Note": row.children[2].text.trim()
            });
          }
        });
      }();

      //leistungskontrollen
      () {
        var examSection = document.getElementById("klausuren");
        var lists = examSection?.children;

        lists?.forEach((element) {
          String exams = "";

          final elements = element.querySelectorAll("ul li");

          for (var element in elements) {
            var exam = element.text.trim().split("                                                                                                    ");
            exams += "${exam.first.trim()} ${exam.last != exam.first ? exam.last.trim() : ""}";
            if (element != elements.last) {
              exams += "\n";
            }
          }

          result["leistungskontrollen"]?.add({
            "title": element.querySelector("h1,h2,h3,h4,h5,h6")?.text.trim(),
            "value": exams == "" ? "Keine Daten!" : exams
          });
        });
      }();

      return result;
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      recordError(e, stack);
      return -4;
    }
  }

  Future<dynamic> getConversationsOverview(bool invisible) async {
    if (!client.doesSupportFeature("Nachrichten - Beta-Version")) {
      return -8;
    }

    debugPrint("Get new conversation data. Invisible: $invisible.");
    try {
      final response =
          await dio.post("https://start.schulportal.hessen.de/nachrichten.php",
              data: {
                "a": "headers",
                "getType": invisible ? "unvisibleOnly" : "visibleOnly",
                "last": "0"
              },
              options: Options(
                headers: {
                  "Accept": "*/*",
                  "Content-Type":
                      "application/x-www-form-urlencoded; charset=UTF-8",
                  "Sec-Fetch-Dest": "empty",
                  "Sec-Fetch-Mode": "cors",
                  "Sec-Fetch-Site": "same-origin",
                  "X-Requested-With": "XMLHttpRequest",
                },
              ));

      final Map<String, dynamic> encryptedJSON =
          jsonDecode(response.toString());

      final String? decryptedConversations =
          cryptor.decryptString(encryptedJSON["rows"]);

      if (decryptedConversations == null) {
        return -7;
        // unknown error (encrypted isn't salted)
      }

      return jsonDecode(decryptedConversations);
    } on (SocketException, DioException) {
      return -3;
      // network error
    } catch (e, stack) {
      recordError(e, stack);
      return -4;
      // unknown error
    }
  }

  String generateUniqueHash(String source) {
    var bytes = utf8.encode(source);
    var digest = sha256.convert(bytes);

    var shortHash = digest.toString().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').substring(0, 6);

    return shortHash;
  }

  Future<String> downloadFile(String url, String filename) async {
    try {
      var tempDir = await getTemporaryDirectory();

      // To ensure unique file names, we store each file in a folder
      // with a hashed value of the download URL.
      // It is necessary for a teacher to upload files with unique file names.
      String urlHash = generateUniqueHash(url);

      String folderPath = "${tempDir.path}/$urlHash";
      String savePath = "$folderPath/$filename";

      // Check if the folder exists, create it if not
      Directory folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }

      // Check if the file already exists
      File existingFile = File(savePath);
      if (existingFile.existsSync()) {
        return savePath;
      }

      Response response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );

      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return savePath;
    } catch (e, stack) {
      recordError(e, stack);
      return "";
    }
  }

  Future<dynamic> getSingleConversation(String uniqueID) async {
    if (!(await InternetConnectionChecker().hasConnection)) {
      return -9;
    }

    try {
      final encryptedUniqueID = cryptor.encryptString(uniqueID);

      final response =
          await dio.post("https://start.schulportal.hessen.de/nachrichten.php",
              queryParameters: {"a": "read", "msg": uniqueID},
              data: {"a": "read", "uniqid": encryptedUniqueID},
              options: Options(
                headers: {
                  "Accept": "*/*",
                  "Content-Type":
                      "application/x-www-form-urlencoded; charset=UTF-8",
                  "Sec-Fetch-Dest": "empty",
                  "Sec-Fetch-Mode": "cors",
                  "Sec-Fetch-Site": "same-origin",
                  "X-Requested-With": "XMLHttpRequest",
                },
              ));

      final Map<String, dynamic> encryptedJSON =
          jsonDecode(response.toString());

      final String? decryptedConversations =
          cryptor.decryptString(encryptedJSON["message"]);

      if (decryptedConversations == null) {
        return -7;
        // unknown error (encrypted isn't salted)
      }

      return jsonDecode(decryptedConversations);
    } on (SocketException, DioException) {
      return -3;
      // network error
    }
  }

  Future<int> startLanisEncryption() async {
    return await cryptor.start(dio);
  }

  bool getEncryptionAuthStatus() {
    return cryptor.authenticated;
  }
}

SPHclient client = SPHclient();
