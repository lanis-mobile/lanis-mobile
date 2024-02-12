import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
import '../shared/shared_functions.dart';
import '../shared/types/startup_app.dart';
import 'client_submodules/calendar.dart';
import 'client_submodules/conversations.dart';
import 'client_submodules/substitutions.dart';
import 'client_submodules/timetable.dart';

class SPHclient {
  String username = "";
  String password = "";
  String schoolID = "";
  String schoolName = "";
  String schoolImage = "";
  String schoolLogo = "";
  Map<SPHAppEnum, LoadApp>? applets;
  int updateAppsIntervall = 15;
  dynamic userData = {};
  List<dynamic> supportedApps = [];
  late CookieJar jar;
  final dio = Dio();
  Timer? preventLogoutTimer;
  late Cryptor cryptor = Cryptor();

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
  Future<void> overwriteCredits(String username, String password,
      String schoolID) async {
    this.username = username;
    this.password = password;
    this.schoolID = schoolID;

    await globalStorage.write(key: StorageKey.userUsername, value: username);
    await globalStorage.write(key: StorageKey.userPassword, value: password, secure: true);
    await globalStorage.write(key: StorageKey.userSchoolID, value: schoolID);
  }

  ///Loads the user's credentials from the storage.
  ///
  ///Has to be called before [login] to ensure that no [CredentialsIncompleteException] is thrown.
  Future<void> loadFromStorage() async {
    updateAppsIntervall = int.parse((await globalStorage.read(key: StorageKey.settingsUpdateAppsIntervall)));

    final String loadAppsString = await globalStorage.read(key: StorageKey.settingsLoadApps);
    if (loadAppsString != "") {
      applets = {};
      Map<String, dynamic> decodedLoadApps = json.decode(loadAppsString);
      for(final loadApp in decodedLoadApps.keys) {
        applets!.addEntries([
          MapEntry(
              SPHAppEnum.fromJson(loadApp),
              LoadApp.fromJson(decodedLoadApps[loadApp]!, Duration(minutes: updateAppsIntervall))
          )
        ]);
      }
    } else {
      applets = null;
    }

    username = await globalStorage.read(key: StorageKey.userUsername);
    password = await globalStorage.read(key: StorageKey.userPassword, secure: true);
    schoolID = await globalStorage.read(key: StorageKey.userSchoolID);

    schoolImage = await globalStorage.read(key: StorageKey.schoolImageLocation);
    schoolLogo = await globalStorage.read(key: StorageKey.schoolLogoLocation);

    schoolName = await globalStorage.read(key: StorageKey.userSchoolName);

    userData = jsonDecode(await globalStorage.read(key: StorageKey.userData));

    supportedApps =
        jsonDecode(await globalStorage.read(key: StorageKey.userSupportedApplets));

    return;
  }

  void initialiseLoadApps() {
    if (client.applets == null) {
      client.applets = {};
      if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
        client.applets!.addEntries([
          MapEntry(
              SPHAppEnum.vertretungsplan,
              LoadApp(
                  applet: SPHAppEnum.vertretungsplan,
                  shouldFetch: true,
                  fetchers: [
                    SubstitutionsFetcher(Duration(minutes: updateAppsIntervall))
                  ]))
        ]);
      }
      if (client.doesSupportFeature(SPHAppEnum.kalender)) {
        client.applets!.addEntries([
          MapEntry(
              SPHAppEnum.kalender,
              LoadApp(
                  applet: SPHAppEnum.kalender,
                  shouldFetch: false,
                  fetchers: [
                    CalendarFetcher(null),
                  ]))
        ]);
      }
      if (client.doesSupportFeature(SPHAppEnum.nachrichten)) {
        client.applets!.addEntries([
          MapEntry(
              SPHAppEnum.nachrichten,
              LoadApp(
                  applet: SPHAppEnum.nachrichten,
                  shouldFetch: false,
                  fetchers: [
                    InvisibleConversationsFetcher(Duration(minutes: updateAppsIntervall)),
                    VisibleConversationsFetcher(Duration(minutes: updateAppsIntervall))
                  ]))
        ]);
      }
      if (client.doesSupportFeature(SPHAppEnum.meinUnterricht)) {
        client.applets!.addEntries([
          MapEntry(
              SPHAppEnum.meinUnterricht,
              LoadApp(
                  applet: SPHAppEnum.meinUnterricht,
                  shouldFetch: false,
                  fetchers: [
                    MeinUnterrichtFetcher(Duration(minutes: updateAppsIntervall)),
                  ]))
        ]);
      }
    }
  }

  ///Logs the user in and fetches the necessary metadata.
  Future<void> login({userLogin = false}) async {
    debugPrint("Trying to log in");

    if (!(await InternetConnectionChecker().hasConnection)) {
      throw NoConnectionException();
    }

    jar.deleteAll();
    dio.options.validateStatus =
        (status) => status != null && (status == 200 || status == 302);
    try {
          String loginURL = await getLoginURL();
          await dio.get(loginURL);

          preventLogoutTimer?.cancel();
          preventLogoutTimer = Timer.periodic(const Duration(seconds: 60), (timer) => preventLogout());

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
    } catch (e, stack) {
      recordError(e, stack);
      debugPrint(e.toString());
      throw LoggedOffOrUnknownException();
    }
  }

  ///Periodically sends a request to the server to prevent the user from being logged out.
  ///Without this the user cannot access encrypted data after 3-4 minutes.
  Future<void> preventLogout() async {
    final uri = Uri.parse("https://start.schulportal.hessen.de/ajax_login.php");
    var sid = (await jar.loadForRequest(uri)).firstWhere((element) => element.name == "sid").value;
    debugPrint("Refreshing session");
    try {
      await dio.post("https://start.schulportal.hessen.de/ajax_login.php",
          queryParameters: {
            "name": sid
          },
          options: Options(contentType: "application/x-www-form-urlencoded"));
    } on DioException {
      return;
    }
  }

  ///Fetches the user's data and the supported apps.
  Future<void> fetchRedundantData() async {
    final schoolInfo = await getSchoolInfo(schoolID);

    schoolImage = await savePersistentImage(schoolInfo["bgimg"]["sm"]["url"], "school.jpg");
    await globalStorage.write(key: StorageKey.schoolImageLocation, value: schoolImage);

    String? schoolImageLink = schoolInfo["Logo"];
    if (schoolImageLink != null) {
      schoolLogo = await savePersistentImage(schoolInfo["Logo"], "logo.jpg");
      await globalStorage.write(key: StorageKey.schoolLogoLocation, value: schoolLogo);
    }

    schoolName = schoolInfo["Name"];
    await globalStorage.write(key: StorageKey.userSchoolName, value: schoolName);

    userData = await fetchUserData();
    supportedApps = await getSupportedApps();

    await globalStorage.write(key: StorageKey.userData, value: jsonEncode(userData));

    await globalStorage.write(
        key: StorageKey.userSupportedApplets, value: jsonEncode(supportedApps));
  }

  ///Fetches the school's accent color and saves it to the storage.
  Future<void> getSchoolTheme() async {
    debugPrint("Trying to get a school accent color.");

    if (await globalStorage.read(key: StorageKey.schoolAccentColor) == "") {
      try {
        dynamic schoolInfo = await client.getSchoolInfo(schoolID);

        int schoolColor = int.parse("FF${schoolInfo["Farben"]["bg"].substring(1)}", radix: 16);

        Themes.schoolTheme = Themes.getNewTheme(Color(schoolColor));

        if ((await globalStorage.read(key: StorageKey.settingsSelectedColor)) == "school") {
          ColorModeNotifier.set("school", Themes.schoolTheme);
        }

        await globalStorage.write(key: StorageKey.schoolAccentColor, value: schoolColor.toString());
      } on Exception catch (_) {}
    }
  }

  ///Fetches the school's image and saves it to the storage.
  Future<String> savePersistentImage(String url, String fileName) async {
    try {
      final Directory dir = await getApplicationDocumentsDirectory();

      String savePath = "${dir.path}/$fileName";

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
    var app = supportedApps.where((element) => element["link"].toString() == feature.php).singleOrNull;
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
    client.applets = null;

    var tempDir = await getTemporaryDirectory();
    await deleteSubfoldersAndFiles(tempDir);
  }

  ///downloads a file from an URL and returns the path of the file.
  ///
  ///The file is stored in the temporary directory of the device.
  ///So calling the same URL twice will result in the same file and one Download.
  Future<String> downloadFile(String url, String filename) async {
    String generateUniqueHash(String source) {
      var bytes = utf8.encode(source);
      var digest = sha256.convert(bytes);

      var shortHash = digest.toString().replaceAll(RegExp(r'[^A-z0-9]'), '').substring(0, 6);

      return shortHash;
    }

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
}

SPHclient client = SPHclient();
