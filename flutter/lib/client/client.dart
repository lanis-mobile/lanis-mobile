import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dart_date/dart_date.dart';

class SPHclient {
  String username = "";
  String password = "";
  int    schoolID = 5182;
  final  dio = Dio();

  SPHclient(this.username, this.password, this.schoolID){
    dio.interceptors.add(CookieManager(PersistCookieJar()));
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) => status != null && (status == 200 || status == 302);
  }

  void overwriteCredits(String username, String password, int schoolID) {
    this.username = username;
    this.password = password;
    this.schoolID = schoolID;
  }

  void loadCreditsFromStorage() {

  }

  Future<int> login() async {
    dio.options.validateStatus = (status) => status != null && (status == 200 || status == 302);
    try {
      if (username.isNotEmpty && password.isNotEmpty) {
        final response1 = await dio.post("https://login.schulportal.hessen.de/?i=$schoolID", queryParameters: {
          "user": '$schoolID.$username',
          "user2": username,
          "password": password
        }, options: Options(contentType: "application/x-www-form-urlencoded"));
        if (response1.headers.value(HttpHeaders.locationHeader) != null){
          //credits are valid
          final response2 = await dio.get("https://connect.schulportal.hessen.de");

          String location2 = response2.headers.value(HttpHeaders.locationHeader) ?? "";
          await dio.get(location2);
          return 0;
          //login successful
        } else {
          return -1;
          //wrong credits
        }
      } else {
        return -2;
        //no username or password or schoolID defined.
      }
    } on SocketException {
      return -3;
      //network error
    } catch (e) {
      return -4;
      //unknown error;
    }
  }

}
