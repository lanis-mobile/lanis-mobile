import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:sph_plan/utils/logger.dart';
import 'package:workmanager/workmanager.dart';

import 'core/database/account_database/account_db.dart';
import 'core/sph/sph.dart' show SPH;

const identifier = "io.github.alessioc42.pushservice";

Future<void> setupBackgroundService() async {
  if (!Platform.isAndroid && !Platform.isIOS) return;


  if (Platform.isAndroid){
    PermissionStatus? notificationsPermissionStatus;
    await Permission.notification.isDenied.then((value) async {
      if (value) {
        notificationsPermissionStatus =
        await Permission.notification.request();
      }
    });
    if (!(notificationsPermissionStatus ?? PermissionStatus.granted).isGranted) return;
  }

  await Workmanager().cancelAll();

  await Workmanager().initialize(callbackDispatcher,
      isInDebugMode: kDebugMode);
  final workManagerConstraints = Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false
  );

  if (Platform.isAndroid) {
    await Workmanager().registerPeriodicTask(identifier, identifier,
        frequency: Duration(minutes: 15),
        constraints: workManagerConstraints,
        initialDelay: const Duration(minutes: 3)
    );
  }
  if (Platform.isIOS) {
    try {
      await Workmanager().registerPeriodicTask(identifier, identifier,
          constraints: workManagerConstraints,
      );
    } catch (e, s) {
      logger.e(e, stackTrace: s);
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
    logger.e(e, stackTrace: s);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      logger.i("Background fetch triggered");
      initializeNotifications();

      accountDatabase = AccountDatabase();
      final accounts = await (accountDatabase.select(accountDatabase.accountsTable)..where((tbl) => tbl.allowBackgroundFetch.equals(true))).get();
      for (final account in accounts) {

        final ClearTextAccount clearTextAccount = await AccountDatabase.getAccountFromTableData(account);
        final sph = SPH(account: clearTextAccount);
        bool authenticated = false;
        for (final applet in AppDefinitions.applets.where((a) => a.backgroundTask != null)) {
          if (applet.supportedAccountTypes.contains(sph.session.accountType)) {
            if (!authenticated) {
              await sph.session.prepareDio();
              await sph.session.authenticate();
              authenticated = true;
            }
            await applet.backgroundTask!(sph, sph.session.accountType, BackgroundTaskToolkit(sph));
          }
        }
        if (authenticated) {
          await sph.session.deAuthenticate();
        }
      }
      return Future.value(true);
    } catch (e, s) {
      logger.f('Error in background fetch');
      logger.e(e, stackTrace: s);
    }
    return Future.value(false);
  });
}

class BackgroundTaskToolkit {
  final SPH _sph;

  BackgroundTaskToolkit(this._sph);

  int _seedId(int id) {
    return id + _sph.account.localId * 10000;
  }

  Future<void> sendMessage(String title, String message, {id = 0}) async {
    id = _seedId(id);
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
      logger.e(e, stackTrace: s);
    }
  }
}

