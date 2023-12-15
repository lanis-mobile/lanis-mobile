import 'dart:async';
import 'dart:ui';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:sph_plan/themes/dark_theme.dart';
import 'package:sph_plan/themes/light_theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/view/calendar/calendar.dart';
import 'package:sph_plan/view/conversations/conversations.dart';
import 'package:sph_plan/view/mein_unterricht/mein_unterricht.dart';
import 'package:sph_plan/view/settings/settings.dart';
import 'package:sph_plan/view/bug_report/send_bugreport.dart';
import 'package:sph_plan/view/settings/subsettings/user_login.dart';
import 'package:sph_plan/view/vertretungsplan/vertretungsplan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'background_service/service.dart' as background_service;

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PermissionStatus? notificationsPermissionStatus;

  await Permission.notification.isDenied.then((value) async {
    if (value) {
      notificationsPermissionStatus = await Permission.notification.request();
    }
  });

  bool enableNotifications =
      (await globalStorage.read(key: "settings-push-service-on") ?? "true") ==
          "true";
  int notificationInterval = int.parse(
      await globalStorage.read(key: "settings-push-service-interval") ?? "15");

  await Workmanager().cancelAll();
  if ((notificationsPermissionStatus ?? PermissionStatus.granted).isGranted &&
      enableNotifications) {
    await Workmanager().initialize(background_service.callbackDispatcher,
        isInDebugMode: false);
    await Workmanager().registerPeriodicTask(
        "sphplanfetchservice-alessioc42-github-io",
        "sphVertretungsplanUpdateService",
        frequency: Duration(minutes: notificationInterval));
  }

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(App(
    savedThemeMode: savedThemeMode,
  ));
}

class App extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const App({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'lanis mobile',
        theme: theme,
        darkTheme: darkTheme,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Feature {
  substitutions("Vertretungsplan"),
  calendar("Kalendar"),
  conversations("Nachrichten"),
  lessons("Mein Unterricht"),
  lanisBrowser(null),
  settings(null),
  reportBug("Fehlerbericht senden");

  const Feature(this.value);

  final String? value;
}

enum Status {
  loadUserData("Lade Benutzerdaten..."),
  login("Einloggen..."),
  errorLogin("Beim Einloggen ist ein Fehler passiert!"),
  finalize("Finalisieren...");

  const Status(this.message);

  final String? message;
}

class _HomePageState extends State<HomePage> {
  Feature selectedFeature = Feature.substitutions;

  String userName =
      "${client.userData["nachname"] ?? ""}, ${client.userData["vorname"] ?? ""}";
  String schoolName = client.schoolName;

  bool isLoading = true;

  // For status messages
  late final StreamController statusController;
  late int errorCode;

  static List<Widget> featureScreens() {
    return <Widget>[
      const VertretungsplanAnsicht(),
      const CalendarAnsicht(),
      const ConversationsAnsicht(),
      const MeinUnterrichtAnsicht(),
    ];
  }

  @override
  void initState() {
    statusController = StreamController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      performLogin();
    });

    super.initState();
  }

  Future<void> performLogin() async {
    statusController.add(Status.loadUserData);
    await client.loadFromStorage();

    await client.prepareDio();

    statusController.add(Status.login);
    int loginCode = await client.login();

    statusController.add(Status.finalize);
    if (loginCode == -1  || loginCode == -2) {
      selectedFeature = Feature.substitutions;

      openLoginScreen();
    } else if (loginCode <= -3) {
      statusController.add(Status.errorLogin);
      errorCode = loginCode;
    } else {
      userName =
          "${client.userData["nachname"] ?? ""}, ${client.userData["vorname"] ?? ""}";
      schoolName = client.schoolName;

      setState(() {
        isLoading = false;
      });
    }
  }


  void openLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
    ).then((result) {
      setState(() {
        isLoading = false;
      });

      openFeature(Feature.substitutions);
    });
  }

  void openLanisInBrowser() {
    client.getLoginURL().then((response) {
      if (response is String) {
        launchUrl(Uri.parse(response));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(client.statusCodes[response] ?? "Unbekannter Fehler!"),
          duration: const Duration(seconds: 1),
          action: SnackBarAction(
            label: 'ACTION',
            onPressed: () {},
          ),
        ));
      }
    });
  }

  void loadUserData() {
    setState(() {
      userName =
          "${client.userData["nachname"] ?? ""}, ${client.userData["vorname"] ?? ""}";
      schoolName = client.schoolName;
    });
  }

  // Open specified feature without popping the navigator.
  void openFeature(Feature currentFeature) {
    setState(() {
      loadUserData();

      userName =
          "${client.userData["nachname"] ?? ""}, ${client.userData["vorname"] ?? ""}";

      switch (currentFeature) {
        case (Feature.lanisBrowser):
          openLanisInBrowser();
          break;
        case (Feature.settings):
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          ).then((result) {
            openFeature(selectedFeature);
          });
          break;
        case (Feature.reportBug):
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BugReportScreen()),
          ).then((result) {
            openFeature(selectedFeature);
          });
          break;
        default:
          selectedFeature = currentFeature;
          break;
      }
    });
  }

  // Only used by NavigationDrawer
  void onNavigationItemTapped(int index) {
    Navigator.pop(context);
    openFeature(Feature.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    final Color imageColor = Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5);
    final Color textColor = imageColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

    return isLoading
        ? loadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(selectedFeature
                  .value!), // We could also use a list with all title names, but a empty title should be always the first page (Vp)
            ),
            body: Center(
              child: featureScreens()[selectedFeature.index],
            ),
            drawer: NavigationDrawer(
              onDestinationSelected: onNavigationItemTapped,
              selectedIndex: selectedFeature.index,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      ClipRRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(imageColor, BlendMode.srcOver),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.file(
                                File(client.schoolImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schoolName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: textColor
                              ),
                            ),
                            Text(
                              userName,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textColor
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                NavigationDrawerDestination(
                  enabled: client.doesSupportFeature("Vertretungsplan"),
                  icon: const Icon(Icons.group),
                  selectedIcon: const Icon(Icons.group_outlined),
                  label: const Text('Vertretungsplan'),
                ),
                NavigationDrawerDestination(
                  enabled: client.doesSupportFeature("Kalender"),
                  icon: const Icon(Icons.calendar_today),
                  selectedIcon: const Icon(Icons.calendar_today_outlined),
                  label: const Text('Kalender'),
                ),
                NavigationDrawerDestination(
                  enabled:
                      client.doesSupportFeature("Nachrichten - Beta-Version"),
                  icon: const Icon(Icons.forum),
                  selectedIcon: const Icon(Icons.forum_outlined),
                  label: const Text('Nachrichten'),
                ),
                NavigationDrawerDestination(
                  enabled: client.doesSupportFeature("Mein Unterricht") ||
                      client.doesSupportFeature("mein Unterricht"),
                  icon: const Icon(Icons.school),
                  selectedIcon: const Icon(Icons.school_outlined),
                  label: const Text('Mein Unterricht'),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.open_in_new),
                  label: Text('Im Browser öffnen'),
                ),
                const Divider(),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Einstellungen'),
                ),
                const NavigationDrawerDestination(
                  enabled: true,
                  icon: Icon(Icons.bug_report),
                  selectedIcon: Icon(Icons.bug_report_outlined),
                  label: Text('Fehlerbericht senden'),
                ),
              ],
            ),
          );
  }

  Widget loadingScreen() {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
              stream: statusController.stream,
              builder: (context, status) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, packageInfo) {
                          return Text(
                            "SPH-Vertretungsplan ${packageInfo.data?.version}",
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Willkommen zurück!",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Row(
                            children: [
                              Text(
                                'Wenn du irgendwelche Fehler entdeckst,\nbitte melde sie im Menü via "Fehlerbericht senden".',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    (status.data == null
                                        ? -1
                                        : status.data.index) <=
                                        Status.loadUserData.index
                                        ? const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                        : const Icon(
                                      Icons.check,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        "Benutzerdaten",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Row(
                                    children: [
                                      (status.data == null
                                          ? -1
                                          : status.data.index) <=
                                          Status.login.index
                                          ? const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child:
                                          CircularProgressIndicator(),
                                        ),
                                      )
                                          : status.data == Status.errorLogin ? const Icon(Icons.error, size: 20) : const Icon(Icons.check, size: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          "Login",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (status.data == (Status.errorLogin)) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      FilledButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => BugReportScreen(generatedMessage: "AUTOMATISCH GENERIERT:\nLogin Page: ${status.data.message}\n$errorCode: ${client.statusCodes[errorCode]}\n\nMehr Details von dir:\n")),
                                            ).then((result) {
                                              openFeature(selectedFeature);
                                            });
                                          },
                                          child: const Text("Fehlerbericht senden")
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: OutlinedButton(
                                            onPressed: () async {
                                              await performLogin();
                                            },
                                            child: const Text("Erneut versuchen")
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          status.data == null
                              ? "Initialisieren..."
                              : status.data.message,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 28.0, bottom: 28.0, top: 28.0),
                          child: status.data == (Status.errorLogin) ? const Icon(Icons.error, size: 30) : const CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ],
                );
              })),
    );
  }
}
