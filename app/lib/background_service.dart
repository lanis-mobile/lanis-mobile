import 'dart:convert';
import 'dart:io';
import 'package:background_fetch/background_fetch.dart' as bgf;
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:sph_plan/models/account_types.dart';
import 'package:sph_plan/utils/logger.dart';
import 'package:workmanager/workmanager.dart';

import 'core/database/account_database/account_db.dart' show AccountDatabase, ClearTextAccount;
import 'core/sph/sph.dart' show SPH;

const identifier = "io.github.alessioc42.pushservice";

Future<void> setupBackgroundService(AccountDatabase accountDatabase) async {
  //
  //
  // if (!Platform.isAndroid) return; //iOS currently experimental/not supported

  if ((await Permission.notification.isDenied)) {
    logger.d("User disallowed notifications");
    if(Platform.isAndroid) await Workmanager().cancelAll();
    return;
  }

  final accounts = await (accountDatabase.select(accountDatabase.accountsTable)).get();
  int disabledCount = 0;
  for (final account in accounts) {
    final ClearTextAccount clearTextAccount = await AccountDatabase.getAccountFromTableData(account);
    final sph = SPH(account: clearTextAccount);
    if (!await sph.prefs.kv.get('notifications-allow')) {
      disabledCount++;
    }
  }
  if (disabledCount == accounts.length) {
    logger.d("User disallowed notifications");
    if(Platform.isAndroid) await Workmanager().cancelAll();
    return;
  }

  if (Platform.isAndroid) {
    await Workmanager().initialize(callbackDispatcher,
        isInDebugMode: kDebugMode);
    final workManagerConstraints = Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    );

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
      await bgf.BackgroundFetch.configure(bgf.BackgroundFetchConfig(
          minimumFetchInterval: 15
      ), (String taskId) async {
        try {
          await generalDispatcher();
        } finally {
          bgf.BackgroundFetch.finish(taskId);
        }
      }, (String taskId) async {
        bgf.BackgroundFetch.finish(taskId);
      });

      await bgf.BackgroundFetch.scheduleTask(bgf.TaskConfig(
          taskId: "com.transistorsoft.notftask",
          delay: 10000
      ));
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
    return await generalDispatcher();
  });
}

Future<bool> generalDispatcher() async {

  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  try {
    backgroundLogger.i("Background fetch triggered");
    await initializeNotifications();

    AccountDatabase accountDatabase = AccountDatabase();

    if (!await isTaskWithinConstraints(accountDatabase)) {
      backgroundLogger.w('Task not within constraints... aborting');
      return Future.value(true);
    }

    final accounts = await (accountDatabase.select(accountDatabase.accountsTable)).get();
    for (final account in accounts) {
      final ClearTextAccount clearTextAccount = await AccountDatabase.getAccountFromTableData(account);
      final sph = SPH(account: clearTextAccount);
      if (!await sph.prefs.kv.get('notifications-allow')) {
        sph.prefs.close();
        continue;
      }
      bool authenticated = false;
      for (final applet in AppDefinitions.applets.where((a) => a.notificationTask != null)) {
        if (applet.supportedAccountTypes.contains(clearTextAccount.accountType)
            && (await sph.prefs.kv.get('notification-${applet.appletPhpUrl}') ?? true)
        ) {
          if (!authenticated) {
            await sph.session.prepareDio();
            await sph.session.authenticate(withoutData: true);
            authenticated = true;
          }
          if (!sph.session.doesSupportFeature(applet, overrideAccountType: clearTextAccount.accountType)) {
            continue;
          }
          await applet.notificationTask!(sph, clearTextAccount.accountType?? AccountType.student, BackgroundTaskToolkit(sph, applet.appletPhpUrl, multiAccount: accounts.length > 1));
        }
      }
      if (authenticated) {
        await sph.session.deAuthenticate();
      }
      sph.prefs.close();
    }
    accountDatabase.close();
    backgroundLogger.i("Background fetch completed");
    return Future.value(true);
  } catch (e, s) {
    backgroundLogger.f('Error in background fetch');
    backgroundLogger.e(e, stackTrace: s);
  }
  return Future.value(false);
}

class BackgroundTaskToolkit {
  bool multiAccount = false;
  String appletId;
  final SPH _sph;

  BackgroundTaskToolkit(this._sph, this.appletId, {this.multiAccount = false});

  int _seedId(int id) {
    return id + _sph.account.localId * 10000;
  }

  /// Sends a notification to the user
  ///
  /// [title] is the title of the notification
  /// [message] is the message of the notification
  /// [id] is the id of the notification, must be between 0 and 10000
  /// [avoidDuplicateSending] if true, the message will not be sent if the same message was sent before
  Future<void> sendMessage({required String title,required String message, int id = 0, bool avoidDuplicateSending = false, Importance importance = Importance.high, Priority priority = Priority.high}) async {
    if (id > 10000 || id < 0) {
      throw ArgumentError('id must be between 0 and 10000');
    }
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
        channelDescription: "Applet notifications",
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
      await accountDB.kv.getMultiple(
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
