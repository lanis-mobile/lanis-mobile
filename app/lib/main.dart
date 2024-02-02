import 'dart:async';
import 'dart:ui';
import 'dart:io';

import 'package:countly_flutter_np/countly_flutter.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sph_plan/shared/apps.dart';
import 'package:sph_plan/shared/whats_new.dart';
import 'package:sph_plan/themes.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sph_plan/client/fetcher.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/view/calendar/calendar.dart';
import 'package:sph_plan/view/conversations/conversations.dart';
import 'package:sph_plan/view/mein_unterricht/mein_unterricht.dart';
import 'package:sph_plan/view/settings/settings.dart';
import 'package:sph_plan/view/bug_report/send_bugreport.dart';
import 'package:sph_plan/view/login/screen.dart';
import 'package:sph_plan/view/vertretungsplan/vertretungsplan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'background_service/service.dart' as background_service;


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
          notificationsPermissionStatus = await Permission.notification.request();
        }
      });
      debugPrint("Notifications permission status: $notificationsPermissionStatus");
      bool enableNotifications = await globalStorage.read(key: StorageKey.settingsPushService) == "true";
      debugPrint("------------------------");
      int notificationInterval = int.parse(
          await globalStorage.read(key: StorageKey.settingsPushServiceIntervall));

      await Workmanager().cancelAll();
      if ((notificationsPermissionStatus ?? PermissionStatus.granted).isGranted &&
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
    if (!kDebugMode && (await globalStorage.read(key: StorageKey.settingsUseCountly)) == "true") {
      const String duckDNS = "duckdns.org"; //so web crawlers do not parse the URL from gh
      CountlyConfig config = CountlyConfig("https://lanis-mobile.$duckDNS", "4e7059ab732b4db3baaf75a6b3e1eef6d4aa3927");
      config.enableCrashReporting();
      await Countly.initWithConfig(config);

      String schoolID = await globalStorage.read(key: StorageKey.userSchoolID);
      if (schoolID != "") {
        Countly.instance.views.startView(schoolID);
      }

      FlutterError.onError = (errorDetails) async {

          Countly.recordDartError(errorDetails.exception, errorDetails.stack!);

        debugPrint(errorDetails.exception.toString());
        debugPrintStack(
            stackTrace: errorDetails.stack!
        );
      };
    }

    ThemeModeNotifier.init();
    ColorModeNotifier.init();

    runApp(const App());

  }, (obj, stack) async {
    if (!kDebugMode && await globalStorage.read(key: StorageKey.settingsUseCountly) == "true") {
      await Countly.recordDartError(obj, stack);
    }
  });
}

Widget errorWidget(FlutterErrorDetails details) {
  return Container(
    color: Colors.red.withOpacity(0.1),
    child: Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 32.0, bottom: 32.0),
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
            child: Text(
                "Ups, es ist ein Fehler aufgetreten!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: Text("Problem: ${details.exception.toString()}",
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: FilledButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: Trace.from(details.stack!).terse.toString()));
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.redAccent;
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.white;
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.redAccent;
                    }
                    return Colors.red;
                  }),
                ),
                child: const Text(
                    "Fehlerdetails kopieren",
                )
            ),
          ),
          const Text(
            "Solche Fehler werden normalerweise automatisch an den Entwickler gesendet.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w400
            ),
          )
        ],
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          if (lightDynamic != null && darkDynamic != null) {
            Themes.dynamicTheme = Themes.getNewTheme(lightDynamic.primary);
            if (globalStorage.prefs.getString("color") == "dynamic") ColorModeNotifier.set("dynamic", Themes.dynamicTheme);
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
                      home: const HomePage(),
                    );
                  }
              );
            }
          );
        }
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
  calendar("Kalender"),
  conversations("Nachrichten"),
  lessons("Mein Unterricht"),
  lanisBrowser(null),
  moodleBrowser(null),
  settings(null),
  reportBug("Fehlerbericht senden");

  const Feature(this.value);

  final String? value;
}

enum Status {
  loadUserData("Lade Benutzerdaten..."),
  login("Einloggen..."),
  errorLogin("Beim Einloggen ist ein Fehler passiert!"),
  substitution("Vertretungen laden..."),
  errorSubstitution("Beim Laden des Vp entstand ein Fehler!"),
  meinUnterricht("Mein Unterricht laden..."),
  errorMeinUnterricht("Beim Laden von MU entstand ein Fehler!"),
  conversations("Nachrichten laden..."),
  errorConversations("Beim Laden der Nachrichten entstand ein Fehler!"),
  calendar("Kalender laden..."),
  errorCalendar("Beim Laden des Kalenders entstand ein Fehler!"),
  finalize("Finalisieren...");

  const Status(this.message);

  final String? message;
}

class _HomePageState extends State<HomePage> {
  late Feature defaultFeature;
  late Feature selectedFeature;

  String userName =
      "${client.userData["nachname"] ?? ""}, ${client.userData["vorname"] ?? ""}";
  String schoolName = client.schoolName;

  bool isLoading = true;

  Feature getDefaultFeature() {
    if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
      return Feature.substitutions;
    } else if (client.doesSupportFeature(SPHAppEnum.kalender)) {
      return Feature.calendar;
    } else if (client.doesSupportFeature(SPHAppEnum.meinUnterricht)) {
      return Feature.lessons;
    } else {
      return Feature.conversations;
    }
  }


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
      
      whatsNew().then((value) {
        if (value != null) {
          openReleaseNotesModal(context, value);
        }
      });
      
    });

    super.initState();
  }

  // We also could use maps for better readability but I am lazy.
  Future<void> fetchFeature(List<dynamic> features) async {
    // 0: status loading
    // 1: status error
    // 2: fetcher

    for (dynamic feature in features) {
      statusController.add(feature[0]);

      await feature[2].fetchData(forceRefresh: true);

      await for (dynamic data in feature[2].stream) {
        if (data.status == FetcherStatus.error) {
          statusController.add(feature[1]);
          errorCode = data.content;
          return;
        } else if (data.status == FetcherStatus.done) {
          statusController.add(feature[0]);
          break;
        }
      }
    }

    return;
  }

  Future<void> performLogin() async {
    statusController.add(Status.loadUserData);
    await client.loadFromStorage();

    await client.prepareDio();

    statusController.add(Status.login);
    int loginCode = await client.login();

    selectedFeature = getDefaultFeature();

    client.prepareFetchers();

    if (loginCode == -1 || loginCode == -2) {
      openLoginScreen();

      return;
    } else if (loginCode <= -3) {
      statusController.add(Status.errorLogin);
      errorCode = loginCode;

      return;
    } else {
      userName =
          "${client.userData["nachname"] ?? ""}, ${client.userData["vorname"] ?? ""}";
      schoolName = client.schoolName;

      if (client.loadMode == "fast") {
        if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
          await fetchFeature([[Status.substitution, Status.errorSubstitution, client.substitutionsFetcher]]);
        }

        statusController.add(Status.finalize);
        setState(() {
          isLoading = false;
        });
        return;
      }

      // This is horrible. (it was even more horrible before)

      final features = [];

      if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
        features.add([
          Status.substitution,
          Status.errorSubstitution,
          client.substitutionsFetcher
        ]);
      }
      if (client.doesSupportFeature(SPHAppEnum.meinUnterricht)) {
        features.add([
          Status.meinUnterricht,
          Status.errorMeinUnterricht,
          client.meinUnterrichtFetcher
        ]);
      }
      if (client.doesSupportFeature(SPHAppEnum.nachrichten)) {
        features.add([
          Status.conversations,
          Status.errorConversations,
          client.visibleConversationsFetcher
        ]);
        features.add([
          Status.conversations,
          Status.errorConversations,
          client.invisibleConversationsFetcher
        ]);
      }
      if (client.doesSupportFeature(SPHAppEnum.kalender)) {
        features.add([
          Status.calendar,
          Status.errorCalendar,
          client.calendarFetcher
        ]);
      }

      await fetchFeature(features);

      statusController.add(Status.finalize);
      setState(() {
        isLoading = false;
      });
    }
  }

  void openLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeLoginScreen()),
    ).then((result) {
      setState(() {
        isLoading = false;
      });
      client.prepareFetchers();
      openFeature(getDefaultFeature());
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
        case (Feature.moodleBrowser):
          launchUrl(Uri.parse("https://mo${client.schoolID}.schule.hessen.de"));
          //todo change to .schulportal.hessen.de when changes apply to SPH servers
          //https://info.schulportal.hessen.de/veraenderungen-bei-schulmoodle-und-schulmahara-ab-08-01-2024/
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
    final Color imageColor =
        Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5);
    final Color textColor =
        imageColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

    List<int?> bottomNavbarNavigationTranslation = [];

    int helpIndex = 0;
    for (var supported in [
      client.doesSupportFeature(SPHAppEnum.vertretungsplan),
      client.doesSupportFeature(SPHAppEnum.kalender),
      client.doesSupportFeature(SPHAppEnum.nachrichten),
      client.doesSupportFeature(SPHAppEnum.meinUnterricht)
    ]) {
      if (supported) {
        bottomNavbarNavigationTranslation.add(helpIndex);
        helpIndex += 1;
      } else {
        bottomNavbarNavigationTranslation.add(null);
      }
    }

    //bottomNavigationBar requires at least 2 entries.


    return isLoading
        ? loadingScreen()
        : StreamBuilder<InternetConnectionStatus>(
          stream: InternetConnectionChecker().onStatusChange,
          builder: (context, network) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(selectedFeature
                      .value!), // We could also use a list with all title names, but a empty title should be always the first page (Vp)
                  bottom: network.data == InternetConnectionStatus.disconnected ? PreferredSize(
                    preferredSize: const Size.fromHeight(40),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.signal_wifi_off),
                          ),
                          Text(
                            "Kein Internet! Geladene Daten sind noch aufrufbar!",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ) : null,
                ),
                body: Center(
                  child: helpIndex != 0 ? featureScreens()[selectedFeature.index] : Center(
                    //in case no feature is supported at all just show an open in browser button.
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.disabled_by_default_outlined, size: 150,),
                        const Padding(padding: EdgeInsets.all(8), child: Text("Es scheint so, als ob dein Account oder deine Schule keine Features dieser App direkt unterstützt! Stattdessen kannst du Lanis noch im Browser öffnen."),),
                        ElevatedButton(onPressed: openLanisInBrowser, child: const Text("Im browser öffnen"))
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: helpIndex > 1 ? NavigationBar(
                   labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                   selectedIndex:
                   bottomNavbarNavigationTranslation[selectedFeature.index]!,
                   onDestinationSelected: (index) => openFeature(Feature
                       .values[bottomNavbarNavigationTranslation.indexOf(index)]),
                   destinations: [
                     if (client.doesSupportFeature(SPHAppEnum.vertretungsplan))
                       const NavigationDestination(
                         icon: Icon(Icons.group),
                         selectedIcon: Icon(Icons.group_outlined),
                         label: 'Vertretungen',
                       ),
                     if (client.doesSupportFeature(SPHAppEnum.kalender))
                       const NavigationDestination(
                         icon: Icon(Icons.calendar_today),
                         selectedIcon: Icon(Icons.calendar_today_outlined),
                         label: 'Kalender',
                       ),
                     if (client.doesSupportFeature(SPHAppEnum.nachrichten))
                       const NavigationDestination(
                         icon: Icon(Icons.forum),
                         selectedIcon: Icon(Icons.forum_outlined),
                         label: 'Nachrichten',
                       ),
                     if (client.doesSupportFeature(SPHAppEnum.meinUnterricht))
                       const NavigationDestination(
                         icon: Icon(Icons.school),
                         selectedIcon: Icon(Icons.school_outlined),
                         label: 'Mein Unterricht',
                       ),
                   ],
                 ) : null,
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
                                colorFilter:
                                    ColorFilter.mode(imageColor, BlendMode.srcOver),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: textColor),
                                ),
                                Text(
                                  userName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    NavigationDrawerDestination(
                      enabled: client.doesSupportFeature(SPHAppEnum.vertretungsplan),
                      icon: const Icon(Icons.group),
                      selectedIcon: const Icon(Icons.group_outlined),
                      label: const Text('Vertretungsplan'),
                    ),
                    NavigationDrawerDestination(
                      enabled: client.doesSupportFeature(SPHAppEnum.kalender),
                      icon: const Icon(Icons.calendar_today),
                      selectedIcon: const Icon(Icons.calendar_today_outlined),
                      label: const Text('Kalender'),
                    ),
                    NavigationDrawerDestination(
                      enabled:
                          client.doesSupportFeature(SPHAppEnum.nachrichten),
                      icon: const Icon(Icons.forum),
                      selectedIcon: const Icon(Icons.forum_outlined),
                      label: const Text('Nachrichten'),
                    ),
                    NavigationDrawerDestination(
                      enabled: client.doesSupportFeature(SPHAppEnum.meinUnterricht),
                      icon: const Icon(Icons.school),
                      selectedIcon: const Icon(Icons.school_outlined),
                      label: const Text('Mein Unterricht'),
                    ),
                    const NavigationDrawerDestination(
                      icon: Icon(Icons.open_in_new),
                      label: Text('Im Browser öffnen'),
                    ),
                    const NavigationDrawerDestination(
                      icon: Icon(Icons.open_in_new),
                      label: Text('Moodle login öffnen'),
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
        );
  }

  Widget getIcon(Status? status, Status normal, Status error, SPHAppEnum feature) {
    int currentStatus = status == null ? -1 : status.index;

    if (!(client.doesSupportFeature(feature))) {
      return const Icon(Icons.not_interested);
    } else if (currentStatus <= normal.index) {
      return const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child:
            CircularProgressIndicator(),
          )
      );
    } else if (status == error) {
      return const Icon(Icons.error, size: 20);
    } else {
      return const Icon(Icons.check, size: 20);
    }
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
                            "lanis-mobile ${packageInfo.data?.version}",
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (status.data == Status.errorLogin) && (errorCode == -9) ? "Kein Internet!" : "Willkommen zurück!",
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
                                              child:
                                                  CircularProgressIndicator(),
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
                                          : status.data == Status.errorLogin
                                              ? const Icon(Icons.error,
                                                  size: 20)
                                              : const Icon(Icons.check,
                                                  size: 20),
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Row(
                                    children: [
                                      getIcon(status.data, Status.substitution, Status.errorSubstitution, SPHAppEnum.vertretungsplan),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          "Vertretungsplan",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                if (client.loadMode == "full") ...[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Row(
                                      children: [
                                        getIcon(status.data, Status.meinUnterricht, Status.errorMeinUnterricht, SPHAppEnum.meinUnterricht),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Text(
                                            "Mein Unterricht",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Row(
                                      children: [
                                        getIcon(status.data, Status.conversations, Status.errorConversations, SPHAppEnum.nachrichten),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            "Nachrichten",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Row(
                                      children: [
                                        getIcon(status.data, Status.calendar, Status.errorCalendar, SPHAppEnum.kalender),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            "Kalender",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                          if (status.data == Status.errorLogin ||
                              status.data == Status.errorSubstitution ||
                              status.data == Status.errorMeinUnterricht ||
                              status.data == Status.errorConversations ||
                              status.data == Status.errorCalendar) ...[
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
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BugReportScreen(
                                                          generatedMessage:
                                                              "AUTOMATISCH GENERIERT:\nLogin Page: ${status.data.message}\n$errorCode: ${client.statusCodes[errorCode]}\n\nMehr Details von dir:\n")),
                                            ).then((result) {
                                              openFeature(selectedFeature);
                                            });
                                          },
                                          child: const Text(
                                              "Fehlerbericht senden")),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: OutlinedButton(
                                            onPressed: () async {
                                              await performLogin();
                                            },
                                            child:
                                                const Text("Erneut versuchen")),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                          child: status.data == Status.errorLogin ||
                                  status.data == Status.errorSubstitution ||
                                  status.data == Status.errorMeinUnterricht ||
                                  status.data == Status.errorConversations ||
                                  status.data == Status.errorCalendar
                              ? const Icon(Icons.error, size: 30)
                              : const CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ],
                );
              })),
    );
  }
}
