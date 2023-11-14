import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../client/client.dart';
import '../view/vertretungsplan/filterlogic.dart' as filterLogic;

AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);

Random random = Random();

final List<String> keysNotRender = [
  "Tag_en",
  "Stunde",
  "_sprechend",
  "_hervorgehoben",
  "Art",
  "Fach"
];

@pragma('vm:entry-point')
void backgroundFetchService() async {
  var client = SPHclient();
  await client.prepareDio();
  await client.loadFromStorage();
  final loginCode = await client.login();
  if (loginCode == 0) {
    final vPlan = await client.getFullVplan();
    if (vPlan is! int) {
      final filteredPlan = await filterLogic.filter(vPlan);

      for (final entry in filteredPlan) {
        // Check if the message with the given UUID has been sent before
        String entryJson = json.encode(entry);
        String entryUUID = generateUUID(entryJson);
        bool isMessageSent = await isMessageAlreadySent(entryUUID);

        if (!isMessageSent) {
          String textBody = "";

          entry.forEach((key, value) {
            if ((!keysNotRender.contains(key) && value != null && value != "")) {
              textBody += "$key: $value \n";
            }
          });

          textBody += "abgerufen: ${DateFormat().format(DateTime.now())}" ;

          sendMessage(
              "${entry["Stunde"]} Stunde - ${entry["Art"]} - ${entry["Fach"]} - ${entry["Lehrer"]} - ${entry["Tag"]}",
              textBody,
              id: random.nextInt(65535)); // I dont care, if IDs are the same. (0.0000023%)

          // Mark the message as sent
          await markMessageAsSent(entryUUID);
        }
      }
    }
  }
}

Future<void> sendMessage(String title, String message, {int id = 0}) async {
  var androidDetails = AndroidNotificationDetails(
      'io.github.alessioc42.sphplan', 'SPH-Vertretungsplan',
      channelDescription: "Benachrichtigungen über den Vertretungsplan",
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(message),
      icon: "@mipmap/ic_launcher");
  var platformDetails = NotificationDetails(android: androidDetails);
  await FlutterLocalNotificationsPlugin()
      .show(id, title, message, platformDetails);
}

String generateUUID(String input) {
  // Use a hash function (MD5) to generate a unique identifier for the message
  final uuid = md5.convert(utf8.encode(input)).toString();
  debugPrint("UUID: $uuid");
  return uuid;
}

Future<void> markMessageAsSent(String entryUUID) async {
  // Read the existing JSON from secure storage
  String jsonString = await filterLogic.storage.read(key: 'background-service-notifications', aOptions: _getAndroidOptions()) ?? '{}';
  Map<String, dynamic> storageMap = json.decode(jsonString);

  // Save the entryUUID to the JSON with the current timestamp
  storageMap[entryUUID] = DateTime.now().toIso8601String();

  // Save the updated JSON back to secure storage
  await filterLogic.storage.write(
    key: 'background-service-notifications',
    value: json.encode(storageMap),
      aOptions: _getAndroidOptions()
  );
}

Future<bool> isMessageAlreadySent(String entryUUID) async {
  // Read the existing JSON from secure storage
  String jsonString =
      await filterLogic.storage.read(key: 'background-service-notifications', aOptions: _getAndroidOptions()) ?? '{}';
  Map<String, dynamic> storageMap = json.decode(jsonString);

  debugPrint(jsonString);

  // Check if the entryUUID exists in the JSON
  if (storageMap[entryUUID]?.isNotEmpty ?? false) {
    return true;
  } else {
    return false;
  }
}
