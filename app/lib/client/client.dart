import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/parser.dart';
import 'package:sph_plan/client/client_submodules/datastorage.dart';
import 'package:sph_plan/client/client_submodules/mein_unterricht.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:sph_plan/client/cryptor.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:sph_plan/themes.dart';

import '../shared/account_types.dart';
import '../shared/apps.dart';
import '../shared/types/startup_app.dart';
import 'client_submodules/calendar.dart';
import 'client_submodules/conversations.dart';
import 'client_submodules/substitutions.dart';
import 'client_submodules/timetable.dart';
import 'connection_checker.dart';

class SPHclient {
  String username = "";
  String password = "";
  String schoolID = "";
  String schoolName = "";

  /// The list of fetchers and which are used by the different views.
  /// Properties of each LoadApp can change.
  final Map<SPHAppEnum, LoadApp> applets = {};

  /// Loaded from [loadFromStorage] to be *only* used in [initialiseApplets].
  /// Map of bools which indicate if a applet should be periodically loaded.
  /// Just a convenience variable because of how [initState] in [startup.dart] works.
  late final Map<String, dynamic> shouldFetchApplets;
  int updateAppsIntervall = 15;

  dynamic userData = {};
  List<dynamic> supportedApps = [];
  Timer? preventLogoutTimer;

  late Cryptor cryptor = Cryptor();
  late CookieJar jar;
  final dio = Dio();

  late SubstitutionsParser substitutions = SubstitutionsParser(dio, this);
  late CalendarParser calendar = CalendarParser(dio, this);
  late DataStorageParser dataStorage = DataStorageParser(dio, this);
  late MeinUnterrichtParser meinUnterricht = MeinUnterrichtParser(dio, this);
  late ConversationsParser conversations = ConversationsParser(dio, this);
  late TimetableParser timetable = TimetableParser(dio, this);

  Future<void> prepareDio() async {
    jar = CookieJar();
    dio.interceptors.add(CookieManager(jar));
    dio.options.followRedirects = false;
    dio.options.validateStatus =
        (status) => status != null && (status == 200 || status == 302);
  }

  ///Overwrites the user's credentials with the given ones and saves them to the storage.
  Future<void> overwriteCredits(
      String username, String password, String schoolID) async {
    this.username = username;
    this.password = password;
    this.schoolID = schoolID;

    await globalStorage.write(key: StorageKey.userUsername, value: username);
    await globalStorage.write(
        key: StorageKey.userPassword, value: password, secure: true);
    await globalStorage.write(key: StorageKey.userSchoolID, value: schoolID);
  }

  ///Loads the user's credentials from the storage.
  ///
  ///Has to be called before [login] to ensure that no [CredentialsIncompleteException] is thrown.
  Future<void> loadFromStorage() async {
    updateAppsIntervall = int.parse((await globalStorage.read(
        key: StorageKey.settingsUpdateAppsIntervall)));

    shouldFetchApplets = jsonDecode(await globalStorage.read(key: StorageKey.settingsShouldFetchApplets));

    username = await globalStorage.read(key: StorageKey.userUsername);
    password =
        await globalStorage.read(key: StorageKey.userPassword, secure: true);
    schoolID = await globalStorage.read(key: StorageKey.userSchoolID);

    schoolName = await globalStorage.read(key: StorageKey.userSchoolName);

    userData = jsonDecode(await globalStorage.read(key: StorageKey.userData));

    supportedApps = jsonDecode(
        await globalStorage.read(key: StorageKey.userSupportedApplets));

    return;
  }

  /// Initialises [client.applets].
  ///
  ///  How to add new applet:
  ///   1. Create Fetcher.
  ///   2. Create SPHAppEnum.
  ///   3. Add LoadApp in this function.
  ///
  /// This step occurs right after the start of the app.
  void initialiseApplets() {
    if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
      client.applets.addEntries([
        MapEntry(
            SPHAppEnum.vertretungsplan,
            LoadApp(
                applet: SPHAppEnum.vertretungsplan,
                shouldFetch: client.shouldFetchApplets[SPHAppEnum.vertretungsplan.name] ?? true,
                fetchers: [
                  SubstitutionsFetcher(Duration(minutes: updateAppsIntervall))
                ]))
      ]);
    }
    if (client.doesSupportFeature(SPHAppEnum.kalender)) {
      client.applets.addEntries([
        MapEntry(
            SPHAppEnum.kalender,
            LoadApp(
                applet: SPHAppEnum.kalender,
                shouldFetch: client.shouldFetchApplets[SPHAppEnum.kalender.name] ?? false,
                fetchers: [
                  CalendarFetcher(null),
                ]))
      ]);
    }
    if (client.doesSupportFeature(SPHAppEnum.nachrichten)) {
      client.applets.addEntries([
        MapEntry(
            SPHAppEnum.nachrichten,
            LoadApp(
                applet: SPHAppEnum.nachrichten,
                shouldFetch: client.shouldFetchApplets[SPHAppEnum.nachrichten.name] ?? false,
                fetchers: [
                  InvisibleConversationsFetcher(
                      Duration(minutes: updateAppsIntervall)),
                  VisibleConversationsFetcher(
                      Duration(minutes: updateAppsIntervall))
                ]))
      ]);
    }
    if (client.doesSupportFeature(SPHAppEnum.meinUnterricht)) {
      client.applets.addEntries([
        MapEntry(
            SPHAppEnum.meinUnterricht,
            LoadApp(
                applet: SPHAppEnum.meinUnterricht,
                shouldFetch: client.shouldFetchApplets[SPHAppEnum.meinUnterricht.name] ?? false,
                fetchers: [
                  MeinUnterrichtFetcher(
                      Duration(minutes: updateAppsIntervall)),
                ]))
      ]);
    }
  }

  ///Logs the user in and fetches the necessary metadata.
  Future<void> login({userLogin = false}) async {
    debugPrint("Trying to log in");

    if (!(await connectionChecker.hasInternetAccess)) {
      throw NoConnectionException();
    }

    jar.deleteAll();
    dio.options.validateStatus =
        (status) => status != null && (status == 200 || status == 302);
    try {
      String loginURL = await getLoginURL();
      await dio.get(loginURL);

      preventLogoutTimer?.cancel();
      preventLogoutTimer = Timer.periodic(
          const Duration(seconds: 60), (timer) => preventLogout());

      if (userLogin) {
        await fetchRedundantData();
      }
      await getSchoolTheme();

      await cryptor.start(dio);
      debugPrint("Encryption connected");

      return;
    } on SocketException {
      throw NetworkException();
    } on DioException {
      throw NetworkException();
    } on LanisException {
      rethrow;
    } catch (e) {
      throw LoggedOffOrUnknownException();
    }
  }

  ///Periodically sends a request to the server to prevent the user from being logged out.
  ///Without this the user cannot access encrypted data after 3-4 minutes.
  Future<void> preventLogout() async {
    final uri = Uri.parse("https://start.schulportal.hessen.de/ajax_login.php");
    String sid;
    try {
      sid = (await jar.loadForRequest(uri))
          .firstWhere((element) => element.name == "sid")
          .value;
    } on StateError {
      return;
    }
    debugPrint("Refreshing session");
    try {
      await dio.post("https://start.schulportal.hessen.de/ajax_login.php",
          queryParameters: {"name": sid},
          options: Options(contentType: "application/x-www-form-urlencoded"));
    } on DioException {
      return;
    }
  }

  ///Fetches the user's data and the supported apps.
  Future<void> fetchRedundantData() async {
    final schoolInfo = await getSchoolInfo(schoolID);

    schoolName = schoolInfo["Name"];
    await globalStorage.write(
        key: StorageKey.userSchoolName, value: schoolName);

    userData = await fetchUserData();
    supportedApps = await getSupportedApps();

    await globalStorage.write(
        key: StorageKey.userData, value: jsonEncode(userData));

    await globalStorage.write(
        key: StorageKey.userSupportedApplets, value: jsonEncode(supportedApps));
  }

  ///Fetches the school's accent color and saves it to the storage.
  Future<void> getSchoolTheme() async {
    debugPrint("Trying to get a school accent color.");

    if (await globalStorage.read(key: StorageKey.schoolAccentColor) == "") {
      try {
        dynamic schoolInfo = await client.getSchoolInfo(schoolID);

        int schoolColor = int.parse(
            "FF${schoolInfo["Farben"]["bg"].substring(1)}",
            radix: 16);

        Themes.schoolTheme = Themes.getNewTheme(Color(schoolColor));

        if ((await globalStorage.read(key: StorageKey.settingsSelectedColor)) ==
            "school") {
          ColorModeNotifier.set("school", Themes.schoolTheme);
        }

        await globalStorage.write(
            key: StorageKey.schoolAccentColor, value: schoolColor.toString());
      } on Exception catch (_) {}
    }
  }

  ///returns a URL that when called loggs the user in.
  ///
  ///This can be used to open lanis in the browser of the user.
  Future<String> getLoginURL() async {
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
          throw WrongCredentialsException();
        }
      } else {
        throw CredentialsIncompleteException();
      }
    } on CredentialsIncompleteException {
      rethrow;
    } catch (e) {
      throw LoggedOffOrUnknownException();
    }
  }

  ///returns the user's school's information.
  Future<dynamic> getSchoolInfo(String schoolID) async {
    final response = await dio.get(
        "https://startcache.schulportal.hessen.de/exporteur.php?a=school&i=$schoolID");
    return jsonDecode(response.data.toString());
  }

  ///returns the lanis fast navigation menubar.
  Future<dynamic> getSupportedApps() async {
    final response = await dio.get(
        "https://start.schulportal.hessen.de/startseite.php?a=ajax&f=apps");
    return jsonDecode(response.data.toString())["entrys"];
  }

  ///check weather the user is able to use a feature of the application.
  bool doesSupportFeature(SPHAppEnum feature) {
    var app = supportedApps
        .where((element) => element["link"].toString() == feature.php)
        .singleOrNull;
    if (app == null) return false;
    if (feature.onlyStudents) {
      return getAccountType() == AccountType.student;
    } else {
      return true;
    }
  }

  ///returns the user's account type.
  ///
  /// [AccountType.student] || [AccountType.teacher] || [AccountType.parent]
  AccountType getAccountType() {
    if (userData.containsKey("klasse")) {
      return AccountType.student;
    } else {
      return AccountType.teacher;
    }
  }

  ///parsed personal information of the user.
  Future<dynamic> fetchUserData() async {
    final response = await dio.get(
        "https://start.schulportal.hessen.de/benutzerverwaltung.php?a=userData");
    var document = parse(response.data);
    var userDataTableBody =
        document.querySelector("div.col-md-12 table.table.table-striped tbody");

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

  ///resets the application's settings and deletes all stored data.
  ///
  ///The login screen has to be opened after this method is called.
  Future<void> deleteAllSettings() async {
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

    jar.deleteAll();
    globalStorage.deleteAll();
    ColorModeNotifier.set("standard", Themes.standardTheme);
    ThemeModeNotifier.set("system");
    client.applets.clear();

    var tempDir = await getTemporaryDirectory();
    await deleteSubfoldersAndFiles(tempDir);
  }

  // This function generates a unique hash for a given source string
  String generateUniqueHash(String source) {
    var bytes = utf8.encode(source);
    var digest = sha256.convert(bytes);

    var shortHash = digest
        .toString()
        .replaceAll(RegExp(r'[^A-z0-9]'), '')
        .substring(0, 12);

    return shortHash;
  }

  /// This function checks if a file exists in the temporary directory downloaded by [downloadFile]
  Future<bool> doesFileExist(String url, String filename) async {
    var tempDir = await getTemporaryDirectory();
    String urlHash = generateUniqueHash(url);
    String folderPath = "${tempDir.path}/$urlHash";
    String filePath = "$folderPath/$filename";

    File existingFile = File(filePath);
    return existingFile.existsSync();
  }

  ///downloads a file from an URL and returns the path of the file.
  ///
  ///The file is stored in the temporary directory of the device.
  ///So calling the same URL twice will result in the same file and one Download.
  Future<String> downloadFile(String url, String filename) async {
    try {
      var tempDir = await getTemporaryDirectory();
      String urlHash = generateUniqueHash(url);
      String folderPath = "${tempDir.path}/$urlHash";
      String savePath = "$folderPath/$filename";

      Directory folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }

      if (await doesFileExist(url, filename)) {
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
    } catch (e) {
      return "";
    }
  }
}

SPHclient client = SPHclient();
