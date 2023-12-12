import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:sph_plan/themes/dark_theme.dart';
import 'package:sph_plan/themes/light_theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/view/calendar/calendar.dart';
import 'package:sph_plan/view/conversations/conversations.dart';
import 'package:sph_plan/view/mein_unterricht/mein_unterricht.dart';
import 'package:sph_plan/view/settings/settings.dart';
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

  bool enableNotifications = (await globalStorage.read(key: "settings-push-service-on") ?? "true") == "true";
  int notificationInterval = int.parse(await globalStorage.read(key: "settings-push-service-interval") ?? "15");

  await Workmanager().cancelAll();
  if ((notificationsPermissionStatus ?? PermissionStatus.granted).isGranted && enableNotifications) {
    await Workmanager().initialize(
        background_service.callbackDispatcher,
        isInDebugMode: false
    );
    await Workmanager().registerPeriodicTask(
        "sphplanfetchservice-alessioc42-github-io",
        "sphVertretungsplanUpdateService",
      frequency: Duration(minutes: notificationInterval)
    );
  }

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(App(savedThemeMode: savedThemeMode,));
}

class App extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const App({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          title: 'SPH - Vertretungsplan',
          theme: theme,
          darkTheme: darkTheme,
          home: const HomePage(),
        ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

class _HomePageState extends State<HomePage> {
  Feature selectedFeature = Feature.substitutions;

  String userName = "${client.userData["nachname"]??""}, ${client.userData["vorname"] ?? ""}";
  String schoolName = client.schoolName;
  bool _isLoading = true;

  static List<Widget> appletScreens() {
    return <Widget>[
      const VertretungsplanAnsicht(),
      const CalendarAnsicht(),
      const ConversationsAnsicht(),
      const MeinUnterrichtAnsicht()
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      performLogin();
    });
  }

  Future<void> performLogin() async {
    await client.loadFromStorage();
    await client.prepareDio();
    int loginCode = await client.login();
    if (loginCode != 0) {
      selectedFeature = Feature.substitutions;

      setState(() {
        _isLoading = false;
      });

      openLoginScreen();
    } else {
      userName = "${client.userData["nachname"]??""}, ${client.userData["vorname"] ?? ""}";
      schoolName = client.schoolName;

      setState(() {
        _isLoading = false;
      });
    }
  }

  void openSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    ).then((result){
      openApplet(selectedFeature);
    });
  }

  void openLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
    ).then((result){
      openApplet(Feature.substitutions);
    });
  }

  void openLanisInBrowser() {
    client.getLoginURL().then((response) {
      if (response is String) {
        launchUrl(Uri.parse(response));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              client.statusCodes[response] ?? "Unbekannter Fehler!"),
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
      userName = "${client.userData["nachname"]??""}, ${client.userData["vorname"] ?? ""}";
      schoolName = client.schoolName;
    });
  }

  // Open specified applet without popping the navigator.
  void openApplet(Feature currentApplet) {
    setState(() {
      loadUserData();

      userName = "${client.userData["nachname"]??""}, ${client.userData["vorname"] ?? ""}";

      switch (currentApplet) {
        case (Feature.lanisBrowser):
          openLanisInBrowser();
          break;
        case (Feature.settings):
          openSettingsScreen();
          break;
        default:
          selectedFeature = currentApplet;
          break;
      }
    });
  }

  // Only used by NavigationDrawer
  void onNavigationItemTapped(int index) {
    Navigator.pop(context);
    openApplet(Feature.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const LoadingScreen() : Scaffold(
      appBar: AppBar(
          title: Text(selectedFeature.value!), // We could also use a list with all title names, but a empty title should be always the first page (Vp)
      ),
      body: Center(
        child: appletScreens()[selectedFeature.index],
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: onNavigationItemTapped,
        selectedIndex: selectedFeature.index,
        children: [
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
            enabled: client.doesSupportFeature("Nachrichten - Beta-Version"),
            icon: const Icon(Icons.forum),
            selectedIcon: const Icon(Icons.forum_outlined),
            label: const Text('Nachrichten'),
          ),
          NavigationDrawerDestination(
            enabled: client.doesSupportFeature("Mein Unterricht") || client.doesSupportFeature("mein Unterricht"),
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
            enabled: false,
            icon: Icon(Icons.bug_report),
            selectedIcon: Icon(Icons.bug_report_outlined),
            label: Text('Fehlerbericht senden'),
          ),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SPH-Vertretungsplan ${snapshot.data?.version}",
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      ],
                    );
                  }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Willkommen zurück!\nBitte warte kurz.\n",
                      style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Auf Gnade des Schulportals hoffen..."), // TODO: CHANGING STATUS MESSAGE
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 28.0, bottom: 28.0, top: 28.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ],
          )
        ),
    );
  }
}