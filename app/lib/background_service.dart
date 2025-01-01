import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:sph_plan/utils/logger.dart';
import 'package:workmanager/workmanager.dart';

import 'core/database/account_database/account_db.dart' show AccountDatabase, ClearTextAccount, accountDatabase;
import 'core/sph/sph.dart' show SPH;

const identifier = "io.github.alessioc42.pushservice";

Future<void> setupBackgroundService(AccountDatabase accountDatabase) async {
  if (!Platform.isAndroid) return; //iOS currently experimental/not supported

  if ((await Permission.notification.isDenied)) {
    await Workmanager().cancelAll();
    return;
  }

  final accounts = await (accountDatabase.select(accountDatabase.accountsTable)).get();
  for (final account in accounts) {
    final ClearTextAccount clearTextAccount = await AccountDatabase.getAccountFromTableData(account);
    final sph = SPH(account: clearTextAccount);
    if (await sph.prefs.kv.get('notifications-allow')) {
      await Workmanager().cancelAll();
      return;
    }
  }

  await Workmanager().initialize(callbackDispatcher,
      isInDebugMode: kDebugMode);
  final workManagerConstraints = Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
  );

  if (Platform.isAndroid) {
    final int min = await accountDatabase.kv.get('notifications-android-target-interval-minutes');
    await Workmanager().registerPeriodicTask(identifier, identifier,
      frequency: Duration(minutes: min),
      constraints: workManagerConstraints,
      initialDelay: const Duration(minutes: 0),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  if (Platform.isIOS) {
    try {
      await Workmanager().registerPeriodicTask(identifier, identifier,
          constraints: workManagerConstraints,
      );
    } catch (e, s) {
      backgroundLogger.e(e, stackTrace: s);
    }
  }
}

Future<void> initializeNotifications() async {
  try {
  FlutterLocalNotificationsPlugin().initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true
      ),
    ),
  );} catch (e, s) {
    backgroundLogger.e(e, stackTrace: s);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    try {
      backgroundLogger.i("Background fetch triggered");
      initializeNotifications();

      AccountDatabase accountDatabase = AccountDatabase();

      if (!await isTaskWithinConstraints(accountDatabase)) {
        return Future.value(false);
      }

      final accounts = await (accountDatabase.select(accountDatabase.accountsTable)).get();
      for (final account in accounts) {
        final ClearTextAccount clearTextAccount = await AccountDatabase.getAccountFromTableData(account);
        final sph = SPH(account: clearTextAccount);
        if (await sph.prefs.kv.get('notifications-allow')) {
          sph.prefs.close();
          continue;
        }
        bool authenticated = false;
        for (final applet in AppDefinitions.applets.where((a) => a.notificationTask != null)) {
          if (applet.supportedAccountTypes.contains(sph.session.accountType)
           && (await sph.prefs.kv.get('notification-${applet.appletPhpUrl}') ?? true)
          ) {
            if (!authenticated) {
              await sph.session.prepareDio();
              await sph.session.authenticate(withoutData: true);
              authenticated = true;
            }
            if (!sph.session.doesSupportFeature(applet)) {
              continue;
            }
            await applet.notificationTask!(sph, sph.session.accountType, BackgroundTaskToolkit(sph, applet.appletPhpUrl, multiAccount: accounts.length > 1));
          }
        }
        if (authenticated) {
          await sph.session.deAuthenticate();
        }
        sph.prefs.close();
      }
      return Future.value(true);
    } catch (e, s) {
      backgroundLogger.f('Error in background fetch');
      backgroundLogger.e(e, stackTrace: s);
    }
    return Future.value(false);
  });
}

class BackgroundTaskToolkit {
  bool multiAccount = false;
  String appletId;
  final SPH _sph;

  BackgroundTaskToolkit(this._sph, this.appletId, {this.multiAccount = false});

  int _seedId(int id) {
    return id + _sph.account.localId * 10000;
  }

  Future<void> sendMessage(String title, String message, {int id = 0, bool avoidDuplicateSending = false}) async {
    id = _seedId(id);
    message = multiAccount ? '${_sph.account.username.toLowerCase()}@${_sph.account.schoolName}\n$message' : message;
    if (avoidDuplicateSending) {
      final hash = hashString(message);
      final lastMessage = await _sph.prefs.getNotificationDuplicates(id, appletId);
      if (lastMessage?.hash == hash) {
        return;
      }

      await _sph.prefs.updateNotificationDuplicate(id, appletId, hash);
    }
    try {
      final androidDetails = AndroidNotificationDetails(
        'io.github.alessioc42.sphplan', 'lanis-mobile',
        channelDescription: "SPH Benachrichtigungen",
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(message),
        ongoing: false,
      );
      const iOSDetails = DarwinNotificationDetails(
        presentAlert: false, presentBadge: true,
      );
      var platformDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);
      await FlutterLocalNotificationsPlugin()
          .show(id, title, message, platformDetails);
    } catch (e,s) {
      backgroundLogger.e(e, stackTrace: s);
    }
  }

  String hashString(String input) {
    var bytes = utf8.encode(input);
    var hashed = sha256.convert(bytes);
    return hashed.toString();
  }
}

Future<bool> isTaskWithinConstraints(AccountDatabase accountDB) async {
  final globalSettings =
      await accountDatabase.kv.getMultiple(
      ['notifications-android-allowed-days',
        'notifications-android-start-time',
        'notifications-android-end-time']);
  TimeOfDay currentTime = TimeOfDay.now();
  TimeOfDay startTime = TimeOfDay(hour: globalSettings['notifications-android-start-time'][0], minute: globalSettings['notifications-android-start-time'][1]);
  TimeOfDay endTime = TimeOfDay(hour: globalSettings['notifications-android-end-time'][0], minute: globalSettings['notifications-android-end-time'][1]);
  if (currentTime.hour < startTime.hour || currentTime.hour > endTime.hour) {
    return false;
  }
  int currentDayIndex = DateTime.now().weekday - 1;
  return globalSettings['notifications-android-allowed-days'][currentDayIndex];
}
