import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sph_plan/startup.dart';
import 'package:sph_plan/themes.dart';
import 'package:sph_plan/utils/logger.dart';
import 'package:sph_plan/utils/authentication_state.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'applets/conversations/view/shared.dart';
import 'background_service.dart';
import 'core/database/account_database/account_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return errorWidget(details);
  };
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  accountDatabase = AccountDatabase();

  authenticationState.login();

  await setupBackgroundService(accountDatabase);
  await initializeNotifications();
  await initializeDateFormatting();

  await setupProxy();

  Connectivity()
      .onConnectivityChanged
      .listen((List<ConnectivityResult> result) async {
    if (result.isNotEmpty && result.first != ConnectivityResult.none) {
      await setupProxy();
    }
  });

  runApp(
    Phoenix(
      child: const App(),
    ),
  );
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
    return StreamBuilder(
      stream: accountDatabase.kv.subscribeMultiple(['color', 'theme', 'isAmoled']),
      builder: (BuildContext context, AsyncSnapshot<Map<String, String?>> snapshot) {
        late ThemeMode mode;
        late Themes theme;
        if (snapshot.hasData) {
          mode = snapshot.data!['theme'] == 'system' ? ThemeMode.system : snapshot.data!['theme'] == 'dark' ? ThemeMode.dark : ThemeMode.light;

          if (snapshot.data!['color'] == 'standard') {
            theme = Themes.standardTheme;
          } else if (snapshot.data!['color'] != 'standard' && snapshot.data!['color'] != 'dynamic') {
            theme = Themes.flutterColorThemes[snapshot.data!['color']!]!;
          } else {
            theme = Themes.standardTheme;
          }
          if (snapshot.data!['isAmoled'] == 'true') {
            theme = Themes.getAmoledThemes();
          }
        } else {
          mode = ThemeMode.system;
          theme = Themes.standardTheme;
        }
        return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
          if (lightDynamic != null && darkDynamic != null) {
            Themes.dynamicTheme = Themes.getNewTheme(lightDynamic.primary);
          }
          if (snapshot.data?['color'] == 'dynamic') {
            theme = Themes.dynamicTheme;
          }

          if (mode == ThemeMode.light ||
              mode == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness ==
                      Brightness.light) {
            BubbleStyles.init(theme.lightTheme!);
          } else if (mode == ThemeMode.dark ||
              mode == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness ==
                      Brightness.dark) {
            BubbleStyles.init(theme.darkTheme ?? Themes.standardTheme.darkTheme!);
          }

          return MaterialApp(
            title: 'Lanis Mobile',
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,
            themeMode: mode,
            localizationsDelegates: [
              ...AppLocalizations.localizationsDelegates,
              SfGlobalLocalizations.delegate
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold( 
              body: StartupScreen(status: authenticationState.status, exception: authenticationState.exception,),
            ),
          );
        });
      },
    );
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
