import 'dart:async';
import 'dart:io';

import 'package:countly_flutter_np/countly_flutter.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sph_plan/themes.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:sph_plan/startup.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'background_service/service.dart' as background_service;
import 'client/connection_checker.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return errorWidget(details);
  };

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    /* periodic background fetching is not supported on IOS due to battery saving restrictions
    *  a workaround would be to use an external push service, but that would require the users to
    *  transfer their passwords to a third party service, which is not acceptable.
    *  Maybe someone will find a better solution in the future. It would be possible to provide a 
    *  self-hosted solution per school, but that's some unlikely idea for the future.
    */
    if (Platform.isAndroid) {
      PermissionStatus? notificationsPermissionStatus;

      await Permission.notification.isDenied.then((value) async {
        if (value) {
          notificationsPermissionStatus =
              await Permission.notification.request();
        }
      });
      debugPrint(
          "Notifications permission status: $notificationsPermissionStatus");
      bool enableNotifications =
          await globalStorage.read(key: StorageKey.settingsPushService) ==
              "true";
      debugPrint("------------------------");
      int notificationInterval = int.parse(await globalStorage.read(
          key: StorageKey.settingsPushServiceIntervall));

      await Workmanager().cancelAll();
      if ((notificationsPermissionStatus ?? PermissionStatus.granted)
              .isGranted &&
          enableNotifications) {
        await Workmanager().initialize(background_service.callbackDispatcher,
            isInDebugMode: kDebugMode);

        await Workmanager().registerPeriodicTask(
            "sphplanfetchservice-alessioc42-github-io",
            "sphVertretungsplanUpdateService",
            frequency: Duration(minutes: notificationInterval));
      }
    }

    await initializeDateFormatting();
    if (!kDebugMode &&
        (await globalStorage.read(key: StorageKey.settingsUseCountly)) ==
            "true") {
      const String duckDNS =
          "duckdns.org"; //so web crawlers do not parse the URL from gh
      CountlyConfig config = CountlyConfig("https://lanis-mobile.$duckDNS",
          "4e7059ab732b4db3baaf75a6b3e1eef6d4aa3927");
      config.enableCrashReporting();
      await Countly.initWithConfig(config);

      String schoolID = await globalStorage.read(key: StorageKey.userSchoolID);
      if (schoolID != "") {
        Countly.instance.views.startView(schoolID);
      }

      FlutterError.onError = (errorDetails) async {
        Countly.recordDartError(errorDetails.exception, errorDetails.stack!);
      };
    }

    ThemeModeNotifier.init();
    ColorModeNotifier.init();

    runApp(const App());
  }, (obj, stack) async {
    if (!kDebugMode &&
        await globalStorage.read(key: StorageKey.settingsUseCountly) ==
            "true") {
      await Countly.recordDartError(obj, stack);
    }
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      if (lightDynamic != null && darkDynamic != null) {
        Themes.dynamicTheme = Themes.getNewTheme(lightDynamic.primary);
        if (globalStorage.prefs.getString("color") == "dynamic")
          ColorModeNotifier.set("dynamic", Themes.dynamicTheme);
      }

      return ValueListenableBuilder<Themes>(
          valueListenable: ColorModeNotifier.notifier,
          builder: (_, theme, __) {
            return ValueListenableBuilder<ThemeMode>(
                valueListenable: ThemeModeNotifier.notifier,
                builder: (_, mode, __) {
                  return MaterialApp(
                    title: 'lanis mobile',
                    theme: theme.lightTheme,
                    darkTheme: theme.darkTheme,
                    themeMode: mode,
                    home: const StartupScreen(),
                  );
                });
          });
    });
  }
}

Widget errorWidget(FlutterErrorDetails details) {
  return Container(
    color: Colors.red.withOpacity(0.1),
    child: Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 32.0, bottom: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning,
            size: 60,
          ),
          const Padding(
            padding: EdgeInsets.all(35),
            child: Text("Ups, es ist ein Fehler aufgetreten!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: Text(
              "Problem: ${details.exception.toString()}",
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: FilledButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(
                      text: Trace.from(details.stack!).terse.toString()));
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.redAccent;
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.white;
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.redAccent;
                    }
                    return Colors.red;
                  }),
                ),
                child: const Text(
                  "Fehlerdetails kopieren",
                )),
          ),
          const Text(
            "Solche Fehler werden normalerweise automatisch an den Entwickler gesendet.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w400),
          )
        ],
      ),
    ),
  );
}
