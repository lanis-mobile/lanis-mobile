import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dart_date/dart_date.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/parser.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:sph_plan/client/cryptor.dart';

class SPHclient {
  final statusCodes = {
     0: "Alles supper Brudi!",
    -1: "Falsche Anmeldedaten",
    -2: "Nicht alle Anmeldedaten angegeben",
    -3: "Netzwerkfehler",
    -4: "Unbekannter Fehler! Bist du eingeloggt?",
    -5: "Keine Erlaubnis",
    -6: "Verschlüsselungsüberprüfung fehlgeschlagen",
    -7: "Unbekannter Fehler! Antwort war nicht salted."
  };

  String username = "";
  String password = "";
  String schoolID = "";
  String schoolName = "";
  dynamic userData = {};
  List<dynamic> supportedApps = [];
  late PersistCookieJar jar;
  final dio = Dio();
  late Cryptor cryptor = Cryptor();

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
      String username, String password, String schoolID, String schoolIDHelper) async {
    this.username = username;
    this.password = password;
    this.schoolID = schoolID;

    await globalStorage.write(
        key: "username", value: username);
    await globalStorage.write(
        key: "password", value: password);
    await globalStorage.write(
        key: "schoolID", value: schoolID);
    await globalStorage.write(
        key: "schoolIDHelper", value: schoolIDHelper);
  }

  Future<String> getSchoolIDHelperString() async {
    return await globalStorage.read(key: "schoolIDHelper") ?? "Max-Planck-Schule - Rüsselsheim (5182)";
  }

  Future<void> loadFromStorage() async {
    username =
        await globalStorage.read(key: "username") ??
            "";
    password =
        await globalStorage.read(key: "password") ??
            "";
    schoolID =
        await globalStorage.read(key: "schoolID") ??
            "";

    schoolName =
        await globalStorage.read(key: "schoolName") ??
            "";

    userData =
        jsonDecode(await globalStorage.read(key: "userData") ??
            "{}");

    supportedApps =
        jsonDecode(await globalStorage.read(key: "supportedApps") ??
            "[]");
  }

  Future<dynamic> getCredits() async {
    return {
      "username":
          await globalStorage.read(key: "username") ??
              "",
      "password":
          await globalStorage.read(key: "password") ??
              "",
      "schoolID":
          await globalStorage.read(key: "schoolID") ??
              "",
      "schoolName": await globalStorage.read(
              key: "schoolName") ??
          ""
    };
  }

  Future<int> login({userLogin = false, startEncryption = false}) async {
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

          if (startEncryption) {
            int encryptionStatusName = await startLanisEncryption();
            debugPrint("Encryption connected with status code: $encryptionStatusName");
          }

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

  Future<void> fetchRedundantData() async {
    schoolName = (await getSchoolInfo(schoolID))["Name"];
    await globalStorage.write(
        key: "schoolName",
        value: schoolName);

    userData = await fetchUserData();
    supportedApps = await getSupportedApps();

    await globalStorage.write(
        key: "userData",
        value: jsonEncode(userData));

    await globalStorage.write(
        key: "supportedApps",
        value: jsonEncode(supportedApps));
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
        "https://startcache.schulportal.hessen.de/exporteur.php?a=school&i=$schoolID");
    return jsonDecode(response.data.toString());
  }

  Future<dynamic> getSupportedApps() async {
    final response = await dio.get(
        "https://start.schulportal.hessen.de/startseite.php?a=ajax&f=apps");
    return jsonDecode(response.data.toString())["entrys"];
  }

  bool doesSupportFeature(String featureName) {
    for (var app in supportedApps) {
      if (app["Name"] == featureName) {
        return true;
      }
    }
    return false;
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
    await globalStorage.write(
        key: "userData",
        value: jsonEncode(data)
    );
  }

  Future<void> deleteAllSettings() async {
    jar.deleteAll();
    globalStorage.deleteAll();
  }

  Future<dynamic> getMeinUnterrichtOverview() async {
    var result = {"aktuell": [], "anwesenheiten": [], "kursmappen": []};

    final response = await dio
        .get("https://start.schulportal.hessen.de/meinunterricht.php");
    var encryptedHTML = cryptor.decryptEncodedTags(response.data);
    var document = parse(encryptedHTML);

    //Aktuelle Einträge
        () {
      var schoolClasses = document.querySelectorAll("tr.printable");
      for (var schoolClass in schoolClasses) {
        var teacher = schoolClass.getElementsByClassName("teacher")[0];

        result["aktuell"]?.add({
          "name": schoolClass
              .querySelector(".name")
              ?.text,
          "teacher": {
            "short": teacher
                .getElementsByClassName(
                "btn btn-primary dropdown-toggle btn-xs")[0]
                .text,
            "name": teacher.querySelector("ul>li>a>i.fa")?.parent?.text
          },
          "thema": {
            "title": schoolClass.getElementsByClassName("thema")[0].text,
            "date": schoolClass.getElementsByClassName("datum")[0].text
          },
          "data": {
            "entry": schoolClass.attributes["data-entry"],
            "book": schoolClass.attributes["data-entry"]
          },
          "_courseURL": schoolClass
              .querySelector("td>h3>a")
              ?.attributes["href"]
        });
      }
    }();

    //Anwesenheiten
    var anwesendDOM = document.getElementById("anwesend");
        () {
      var thead = anwesendDOM?.querySelector("thead>tr");
      var tbody = anwesendDOM?.querySelectorAll("tbody>tr");

      var keys = [];
      thead?.children.forEach((element) => keys.add(element.text));

      tbody?.forEach((elem) {
        var textElements = [];
        for (var i = 0; i < elem.children.length; i++) {
          var element = elem.children[i];
          element
              .querySelector("div.hidden.hidden_encoded")
              ?.innerHtml = "";

          if (keys[i] != "Kurs") {
            textElements.add(
                element.text.replaceAll(" ", "").replaceAll("\n", ""));
          } else {
            textElements.add(element.text);
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
          "title": mappe.getElementsByTagName("h2")[0].text,
          "teacher": mappe
              .querySelector("div.btn-group>button")
              ?.attributes["title"],
          "_courseURL":
          mappe
              .querySelector("a.btn.btn-primary")
              ?.attributes["href"]
        });
      }
      result["kursmappen"] = parsedMappen;
    }();
    return result;

  }

  Future<dynamic> getMeinUnterrichtCourseView(String url) async {
    try {
      var result = {"historie": [], "leistungen": [], "leistungskontrollen": [], "anwesenheiten": [], "name": ["name"]};

      final response = await dio
          .get("https://start.schulportal.hessen.de/$url");
      var encryptedHTML = cryptor.decryptEncodedTags(response.data);
      var document = parse(encryptedHTML);

      //course name
      var heading = document.getElementById("content")?.querySelector("h1");
      heading?.children[0].innerHtml = "";
      result["name"] = [heading?.text.replaceAll("\n", "").replaceAll("  ", "")];

      //historie
      (){
        var historySection = document.getElementById("history");
        var tableRows = historySection?.querySelectorAll("table>tbody>tr");

        tableRows?.forEach((tableRow) {
          tableRow.children[2].querySelector("div.hidden.hidden_encoded")?.innerHtml = "";

          List<String> markups = [];

          tableRow.children[1].querySelectorAll("span.markup").forEach((element) {
            String text = element.text;
            if (text.startsWith(" ")) {
              markups.add(text.substring(1));
            } else {
              markups.add(text);
            }
          });

          result["historie"]?.add({
            "time": tableRow.children[0].text.replaceAll(" ", "").replaceAll("\n", " "),
            "title": tableRow.children[1].querySelector("big>b")?.text,
            "markup": markups.join("\n\n"),
            "presence": tableRow.children[2].text.replaceAll("\n", "").replaceAll("  ", "")
          });
        });
      }();
      
      //anwesenheiten
      (){
        var presenceSection = document.getElementById("attendanceTable");
        var tableRows = presenceSection?.querySelectorAll("table>tbody>tr");

        tableRows?.forEach((row) {
          var encodedElements = row.getElementsByClassName("hidden_encoded");
          for (var e in encodedElements) {
            e.innerHtml = "";
          }

          result["anwesenheiten"]?.add({
            "type": row.children[0].text,
            "count": row.children[1].text
          });
        });
      }();

      return result;
    } catch (e) {
      return -4;
    }
  }

  Future<dynamic> getConversationsOverview(bool invisible) async {
    try {
      final response =
      await dio.post("https://start.schulportal.hessen.de/nachrichten.php",
          data: {"a": "headers", "getType": invisible ? "unvisibleOnly" : "visibleOnly", "last": "0"},
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

      final Map<String, dynamic> encryptedJSON = jsonDecode(response.toString());

      final String? decryptedConversations = cryptor.decryptString(encryptedJSON["rows"]);

      if (decryptedConversations == null) {
        return -7;
        // unknown error (encrypted isn't salted)
      }

      return jsonDecode(decryptedConversations);
    } on (SocketException, DioException) {
      return -3;
      // network error
    } catch (e) {
      return -4;
      // unknown error
    }
  }


  Future<dynamic> getSingleConversation(String uniqueID) async {
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

      final Map<String, dynamic> encryptedJSON = jsonDecode(response.toString());

      final String? decryptedConversations = cryptor.decryptString(encryptedJSON["message"]);

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
