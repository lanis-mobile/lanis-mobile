import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:sph_plan/startup.dart';
import 'package:sph_plan/themes.dart';
import 'package:sph_plan/utils/logger.dart';
import 'package:sph_plan/view/conversations/shared.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return errorWidget(details);
  };

  await globalStorage.initialize();

  await applyEnvironmentVariables();

  await initializeNotifications();
  await setupBackgroundService();

  await initializeDateFormatting();

  ThemeModeNotifier.init();
  ColorModeNotifier.init();
  AmoledNotifier.init();

  await setupProxy();

  Connectivity()
      .onConnectivityChanged
      .listen((List<ConnectivityResult> result) async {
    if (result.isNotEmpty && result.first != ConnectivityResult.none) {
      await setupProxy();
    }
  });

  runApp(const App());
}

Future<void> setupProxy() async {
  logger.d("Running setupProxy()...");
  try {
    HttpProxy httpProxy = await HttpProxy.createHttpProxy();
    HttpOverrides.global = httpProxy;
  } catch (e) {
    debugPrint("Error setting up proxy: $e");
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      if (lightDynamic != null && darkDynamic != null) {
        Themes.dynamicTheme = Themes.getNewTheme(lightDynamic.primary);
        if (globalStorage.prefs!.getString("color") == "dynamic") {
          ColorModeNotifier.set("dynamic", Themes.dynamicTheme);
        }
      }

      return ValueListenableBuilder<Themes>(
          valueListenable: ColorModeNotifier.notifier,
          builder: (_, theme, __) {
            return ValueListenableBuilder<ThemeMode>(
                valueListenable: ThemeModeNotifier.notifier,
                builder: (_, mode, __) {
                  return ValueListenableBuilder<bool>(
                      valueListenable: AmoledNotifier.notifier,
                      builder: (_, isAmoled, __) {
                        ThemeData darkTheme = getAmoledTheme(theme, isAmoled);

                        if (mode == ThemeMode.light ||
                            mode == ThemeMode.system &&
                                MediaQuery.of(context).platformBrightness ==
                                    Brightness.light) {
                          BubbleStyles.init(theme.lightTheme!);
                        } else if (mode == ThemeMode.dark ||
                            mode == ThemeMode.system &&
                                MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark) {
                          BubbleStyles.init(darkTheme);
                        }

                        return MaterialApp(
                          title: 'Lanis Mobile',
                          theme: theme.lightTheme,
                          darkTheme: darkTheme,
                          themeMode: mode,
                          localizationsDelegates: [
                            ...AppLocalizations.localizationsDelegates,
                            SfGlobalLocalizations.delegate
                          ],
                          supportedLocales: AppLocalizations.supportedLocales,
                          home: const StartupScreen(),
                        );
                      });
                });
          });
    });
  }
}

Widget errorWidget(FlutterErrorDetails details, {BuildContext? context}) {
  return ListView(children: [
    Container(
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
              child: Text("Whoops! An error occurred.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 35, left: 20, right: 20),
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
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    return Colors.redAccent;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    return Colors.white;
                  }),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.redAccent;
                    }
                    return Colors.red;
                  }),
                ),
                child: const Text(
                  "Copy error details to clipboard",
                ),
              ),
            ),
          ],
        ),
      ),
    )
  ]);
}

Future<void> applyEnvironmentVariables() async {
  if (kDebugMode) {
    if (!(const bool.fromEnvironment("SKIP_CONFIG"))) {
      const schoolID = String.fromEnvironment("ID");
      const username = String.fromEnvironment("USERNAME");
      const password = String.fromEnvironment("PASSWORD");
      if (schoolID != "" && username != "" && password != "") {
        // We could get the school name or just leave this "easter egg".
        await globalStorage.write(
            key: StorageKey.userSchoolName, value: "Ein Entwickler! $schoolID");

        await globalStorage.write(
            key: StorageKey.userSchoolID,
            value: const String.fromEnvironment("ID"));
        await globalStorage.write(
            key: StorageKey.userUsername,
            value: const String.fromEnvironment("USERNAME"));
        await globalStorage.write(
            key: StorageKey.userPassword,
            value: const String.fromEnvironment("PASSWORD"),
            secure: true);
      }

      const theme = String.fromEnvironment("THEME");
      if (theme != "") {
        if (theme == "amoled") {
          await globalStorage.write(
              key: StorageKey.settingsSelectedTheme, value: "dark");
          await globalStorage.write(
              key: StorageKey.settingsIsAmoled, value: "true");
        } else {
          await globalStorage.write(
              key: StorageKey.settingsIsAmoled, value: "false");
          await globalStorage.write(
              key: StorageKey.settingsSelectedTheme, value: theme);
        }
      }

      const color = String.fromEnvironment("COLOR");
      if (color != "") {
        await globalStorage.write(
            key: StorageKey.settingsSelectedColor, value: color);
      }

      const notificationsString = String.fromEnvironment("NOTIFICATIONS");
      if (notificationsString != "") {
        const notifications =
            bool.fromEnvironment("NOTIFICATIONS", defaultValue: true);
        await globalStorage.write(
            key: StorageKey.settingsPushService,
            value: notifications.toString());
      }
    }
  }
}
