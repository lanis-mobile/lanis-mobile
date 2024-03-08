import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:workmanager/workmanager.dart';

import '../client/client.dart';
import '../client/storage.dart';
import '../view/vertretungsplan/filterlogic.dart' as filter_logic;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      debugPrint(
          " >>>>>>>>>>>>>>>>>>>>>>>>>>>> Background fetch triggered <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
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
  try {
    await client.login();
    final vPlan =
        await client.substitutions.getAllSubstitutions(skipCheck: true);
    final List combinedVPlan = [];

    for (List plan in vPlan["entries"]) {
      combinedVPlan.addAll(plan);
    }

    final filteredPlan = await filter_logic.filter(combinedVPlan);

    String messageBody = "";

    for (final entry in filteredPlan) {
      final time =
          "${weekDayGer(entry["Tag"])} ${entry["Stunde"].replaceAll(" - ", "/")}";
      final type = entry["Art"] ?? "";
      final subject = entry["Fach"] ?? "";
      final teacher = entry["Lehrer"] ?? "";
      final classInfo = entry["Klasse"] ?? "";

      // Concatenate non-null values with separator "-"
      final entryText = [time, type, subject, teacher, classInfo]
          .where((e) => e.isNotEmpty)
          .join(" - ");

      messageBody += "$entryText\n";
    }

    if (messageBody != "") {
      final messageUUID = generateUUID(messageBody);

      messageBody +=
          "Letztes Update erhalten: ${DateFormat.Hm().format(DateTime.now())}";

      if (!(await isMessageAlreadySent(messageUUID))) {
        await sendMessage(
            "${filteredPlan.length} Einträge im Vertretungsplan", messageBody);
        await markMessageAsSent(messageUUID);
      }
    }
  } on LanisException {
    debugPrint("Exception in backgroundFetch");
    // former status-codes ignored
  }
}

Future<void> sendMessage(String title, String message, {int id = 0}) async {
  bool ongoingMessage =
      (await globalStorage.read(key: StorageKey.settingsPushServiceOngoing)) ==
          "true";

  var androidDetails = AndroidNotificationDetails(
      'io.github.alessioc42.sphplan', 'lanis-mobile',
      channelDescription: "Benachrichtigungen über den Vertretungsplan",
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(message),
      ongoing: ongoingMessage,
      icon: "@drawable/ic_launcher");
  var platformDetails = NotificationDetails(android: androidDetails);
  await FlutterLocalNotificationsPlugin()
      .show(id, title, message, platformDetails);
}

String generateUUID(String input) {
  // Use a hash function (MD5) to generate a unique identifier for the message
  final uuid = crypto.md5.convert(utf8.encode(input)).toString();
  return uuid;
}

Future<void> markMessageAsSent(String uuid) async {
  await globalStorage.write(key: StorageKey.lastPushMessageHash, value: uuid);
}

Future<bool> isMessageAlreadySent(String uuid) async {
  // Read the existing JSON from secure storage
  String storageValue =
      await globalStorage.read(key: StorageKey.lastPushMessageHash);
  return storageValue == uuid;
}

String weekDayGer(String dateString) {
  final inputFormat = DateFormat('dd.MM.yyyy');
  final dateTime = inputFormat.parse(dateString);

  final germanFormat = DateFormat('E', 'de');
  return germanFormat.format(dateTime);
}
