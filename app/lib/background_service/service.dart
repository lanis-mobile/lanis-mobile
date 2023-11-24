import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

import '../client/client.dart';
import '../view/vertretungsplan/filterlogic.dart' as filter_logic;

AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);


final List<String> keysNotRender = [
  "Tag_en",
  "Stunde",
  "_sprechend",
  "_hervorgehoben",
  "Art",
  "Fach"
];

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await performBackgroundFetch();
    } catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(true);
  });
}

Future<void> performBackgroundFetch() async {
  var client = SPHclient();
  await client.prepareDio();
  await client.loadFromStorage();
  final loginCode = await client.login();
  if (loginCode == 0) {
    final vPlan = await client.getFullVplan();
    if (vPlan is! int) {
      final filteredPlan = await filter_logic.filter(vPlan);

      String messageBody = "";

      for (final entry in filteredPlan) {
        messageBody += "${entry["Stunde"]} Stunde - ${entry["Art"]} - ${entry["Fach"]} - ${entry["Lehrer"]} - ${filter_logic.formatDateString(entry["Tag_en"], entry["Tag"])}\n";
      }

      if (messageBody != "") {
        final messageUUID = generateUUID(messageBody);

        messageBody += "Letztes Update erhalten: ${DateFormat.Hm().format(DateTime.now())}";

        if (!(await isMessageAlreadySent(messageUUID))) {
          await sendMessage("${filteredPlan.length} Einträge im Vertretungsplan",
              messageBody);
          await markMessageAsSent(messageUUID);
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
      ongoing: true, //make notification persistent
      icon: "@mipmap/ic_launcher");
  var platformDetails = NotificationDetails(android: androidDetails);
  await FlutterLocalNotificationsPlugin()
      .show(id, title, message, platformDetails);
}

String generateUUID(String input) {
  // Use a hash function (MD5) to generate a unique identifier for the message
  final uuid = md5.convert(utf8.encode(input)).toString();
  return uuid;
}

Future<void> markMessageAsSent(String uuid) async {
  await filter_logic.storage.write(
    key: 'background-service-notifications',
    value: uuid,
      aOptions: _getAndroidOptions()
  );
}

Future<bool> isMessageAlreadySent(String uuid) async {
  // Read the existing JSON from secure storage
  String storageValue =
      await filter_logic.storage.read(key: 'background-service-notifications', aOptions: _getAndroidOptions()) ?? '{}';
  return storageValue == uuid;
}
