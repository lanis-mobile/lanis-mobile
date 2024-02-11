import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../shared/apps.dart';
import '../../shared/exceptions/client_status_exceptions.dart';
import '../client.dart';
import '../connection_checker.dart';

class ConversationsParser {
  late Dio dio;
  late SPHclient client;

  ConversationsParser(Dio dioClient, this.client) {
    dio = dioClient;
  }

  Future<dynamic> getOverview(bool invisible) async {
    if (!(client.doesSupportFeature(SPHAppEnum.nachrichten))) {
      throw NotSupportedException();
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
      client.cryptor.decryptString(encryptedJSON["rows"]);

      if (decryptedConversations == null) {
        throw UnsaltedOrUnknownException();
      }

      return jsonDecode(decryptedConversations);
    } on (SocketException, DioException) {
      throw NetworkException();
    } on LanisException {
      rethrow;
    } catch (e) {
      throw LoggedOffOrUnknownException();
    }
  }

  Future<dynamic> getSingleConversation(String uniqueID) async {
    if (!(await connectionChecker.hasInternetAccess)) {
      throw NoConnectionException();
    }

    try {
      final encryptedUniqueID = client.cryptor.encryptString(uniqueID);

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
      client.cryptor.decryptString(encryptedJSON["message"]);

      if (decryptedConversations == null) {
        throw UnsaltedOrUnknownException();
      }

      return jsonDecode(decryptedConversations);
    } on (SocketException, DioException) {
      throw NetworkException();
    }
  }
}