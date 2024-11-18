import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:html/parser.dart';

import '../../client/connection_checker.dart';
import '../../client/cryptor.dart';
import '../../shared/account_types.dart';
import '../../shared/exceptions/client_status_exceptions.dart';
import '../../themes.dart';
import '../../utils/logger.dart';
import 'sph.dart';

class SessionHandler {
  SPH sph;
  String? schoolName;
  
  late Cryptor cryptor = Cryptor();
  late CookieJar jar;
  final dio = Dio();
  Timer? preventLogoutTimer;
  /// a Map containing the user data parsed from
  /// 'https://start.schulportal.hessen.de/benutzerverwaltung.php?a=userData'
  Map<String, String> userData = {};

  /// Lanis fast travel menu obtained from
  /// 'https://start.schulportal.hessen.de/startseite.php?a=ajax&f=apps'
  List<dynamic> travelMenu = [];


  SessionHandler({required this.sph,});

  Future<void> prepareDio() async {
    jar = CookieJar();
    dio.interceptors.add(CookieManager(jar));
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        if (response.data != null) {
          connectionChecker.status = ConnectionStatus.connected;
        } else {
          connectionChecker.status = ConnectionStatus.disconnected;
        }
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          connectionChecker.status = ConnectionStatus.disconnected;
        }
        return handler.next(error);
      },
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        options.headers.addAll({
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
        });
        return handler.next(options); //continue
      },
    ));
    dio.options.followRedirects = false;
    dio.options.connectTimeout = Duration(seconds: 8);
    dio.options.validateStatus =
        (status) => status != null && (status == 200 || status == 302 || status == 503);
  }

  ///Logs the user in and fetches the necessary metadata.
  Future<void> authenticate({backgroundFetch = false}) async {
    if (!(await connectionChecker.connected)) {
      throw NoConnectionException();
    }

    jar.deleteAll();
    dio.options.validateStatus =
        (status) => status != null && (status == 200 || status == 302 || status == 503);

    try {
      String loginURL = await getLoginURL();
      await dio.get(loginURL);

      preventLogoutTimer?.cancel();
      preventLogoutTimer = Timer.periodic(
          const Duration(seconds: 10), (timer) => preventLogout());

      if (!backgroundFetch) {
        travelMenu = await getFastTravelMenu();
        userData = await fetchUserData();
      }
      await getSchoolTheme();

      await cryptor.start(dio);

      return;
    } on LanisException {
      rethrow;
    } on SocketException {
      throw NetworkException();
    } on DioException {
      throw NetworkException();
    } catch (e) {
      throw UnknownException();
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
        (status) => status != null && (status == 200 || status == 302 || status == 503);

    final response1 = await dioHttp.post(
        "https://login.schulportal.hessen.de/?i=${sph.account.schoolID}",
        queryParameters: {
          "user": '${sph.account.schoolID}.${sph.account.password}',
          "user2": sph.account.username,
          "password": sph.account.password,
        },
        options: Options(contentType: "application/x-www-form-urlencoded"));

    if (response1.statusCode == 503) {
      throw LanisDownException();
    }

    final loginTimeout =
    parse(response1.data).getElementById("authErrorLocktime");

    if (response1.headers.value(HttpHeaders.locationHeader) != null) {
      //credits are valid
      final response2 =
      await dioHttp.get("https://connect.schulportal.hessen.de");

      String location2 =
          response2.headers.value(HttpHeaders.locationHeader) ?? "";

      return location2;
    } else if (loginTimeout != null) {
      throw LoginTimeoutException(loginTimeout.text,
          "Zu oft falsch eingeloggt! Für den nächsten Versuch musst du ${loginTimeout.text}s warten!");
    } else {
      throw WrongCredentialsException();
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
    logger.i("Refreshing session");
    try {
      var response = await dio.post("https://start.schulportal.hessen.de/ajax_login.php",
          queryParameters: {"name": sid},
          options: Options(contentType: "application/x-www-form-urlencoded"));
      if (response.statusCode == 503) {
        throw LanisDownException();
      }
    } on DioException {
      return;
    }
  }

  ///returns the lanis fast navigation menubar.
  Future<dynamic> getFastTravelMenu() async {
    final response = await dio.get(
        "https://start.schulportal.hessen.de/startseite.php?a=ajax&f=apps");
    return jsonDecode(response.data.toString())["entrys"];
  }

  ///parsed personal information of the user.
  Future<Map<String, String>> fetchUserData() async {
    final response = await dio.get(
        "https://start.schulportal.hessen.de/benutzerverwaltung.php?a=userData");
    var document = parse(response.data);
    var userDataTableBody =
    document.querySelector("div.col-md-12 table.table.table-striped tbody");

    if (userDataTableBody != null) {
      Map<String, String> result = {};

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

  ///Fetches the school's accent color and saves it to the storage.
  Future<void> getSchoolTheme() async {
    if (await globalStorage.read(key: StorageKey.schoolAccentColor) == "") {
      try {
        final response = await dio.get(
            "https://startcache.schulportal.hessen.de/exporteur.php?a=school&i=$schoolID");
        final schoolInfo = jsonDecode(response.data.toString());

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


  AccountType getAccountType() {
    if (userData.containsKey("klasse")) {
      return AccountType.student;
    } else {
      return AccountType.teacher;
    }
  }
}