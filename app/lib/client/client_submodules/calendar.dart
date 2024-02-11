import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sph_plan/client/client.dart';

import '../../shared/apps.dart';
import '../../shared/exceptions/client_status_exceptions.dart';

class CalendarParser {
  late Dio dio;
  late SPHclient client;

  CalendarParser(Dio dioClient, this.client) {
    dio = dioClient;
  }

  Future<dynamic> getCalendar(String startDate, String endDate) async {
    if (!client.doesSupportFeature(SPHAppEnum.kalender)) {
      throw NotSupportedException();
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
      throw NetworkException();
    } catch (e, stack) {
      debugPrint("Calendar: -4");
      throw LoggedOffOrUnknownException();
    }
  }

  Future<dynamic> getEvent(String id) async {
    if (!(await InternetConnectionChecker().hasConnection)) {
      throw NoConnectionException();
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
      throw NetworkException();
    } catch (e, stack) {
      throw LoggedOffOrUnknownException();
    }
  }
}