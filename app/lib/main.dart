import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:sph_plan/themes/dark_theme.dart';
import 'package:sph_plan/themes/light_theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/view/calendar/calendar.dart';
import 'package:sph_plan/view/debug/debug.dart';
import 'package:sph_plan/view/settings/settings.dart';
import 'package:sph_plan/view/settings/subsettings/user_login.dart';
import 'package:sph_plan/view/vertretungsplan/vertretungsplan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';
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

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String userName = "${client.userData["nachname"]??""}, ${client.userData["vorname"] ?? ""}";
  String schoolName = client.schoolName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performLogin();
    });
  }

  Future<void> _performLogin() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Anmeldung läuft...'),
            content: SpinKitCubeGrid(
              color: Colors.black,
              size: 30,
            ),
          );
        });

    await client.loadFromStorage();
    await client.prepareDio();
    int loginCode = await client.login();
    if (loginCode != 0) {
      _selectedIndex = 0;
      _completeLogin();
      openLoginScreen();
    } else {
      userName = "${client.userData["nachname"]??""}, ${client.userData["vorname"] ?? ""}";
      schoolName = client.schoolName;
      _completeLogin();
    }
  }

  void openSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    ).then((result){
      _onItemTapped(0, "");
    });
  }

  void openDebugScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DebugScreen()),
    ).then((result){
      _onItemTapped(0, "");
    });
  }

  void openLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
    ).then((result){
      _onItemTapped(0, "");
    });
  }

  void _completeLogin() {
    Navigator.of(context).pop(); // Close the dialog
    setState(() {
      _isLoading = false;
    });
  }

  static List<Widget> _widgetOptions() {
    return <Widget>[
      const VertretungsplanAnsicht(),
      const CalendarAnsicht(),
    ];
  }

  void _onItemTapped(int index, String title) {
    setState(() {
      loadUserData();
      _selectedIndex = index;
      userName = client.username;
    });
  }

  void loadUserData() {
    setState(() {
      userName = "${client.userData["nachname"]??""}, ${client.userData["vorname"] ?? ""}";
      schoolName = client.schoolName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const LoadingScreen() : Scaffold(
      appBar: AppBar(
          title: const Text("SPH"),
        actions: <IconButton>[
          if (kReleaseMode == false) ...[
            IconButton(
              icon: const Icon(Icons.bug_report),
              tooltip: 'Debug',
              onPressed: openDebugScreen,
            ),
          ],
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Einstellungen',
            onPressed: openSettingsScreen,
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions()[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                image: DecorationImage(
                  image: AssetImage("assets/blackboard_background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schoolName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      shadows: [Shadow(color: Colors.white, blurRadius: 30)],
                    ),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      shadows: [Shadow(color: Colors.white, blurRadius: 30)],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: client.doesSupportFeature("Vertretungsplan"),
              child: ListTile(
                title: const Text('Vertretungsplan'),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0, "Vertretungsplan");
                  Navigator.pop(context);
                },
              )
            ),
            Visibility(
              visible: client.doesSupportFeature("Kalender"),
              child: ListTile(
                title: const Text('Kalender'),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1, "Kalender");
                  Navigator.pop(context);
                },
              )
            ),
            ListTile(
              title: const Text('Schulportal öffnen'),
              onTap: () {
                client.getLoginURL().then((response) {
                  if (response is String) {
                    launchUrl(Uri.parse(response));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(client.statusCodes[response]??"Unbekannter Fehler!"),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'ACTION',
                        onPressed: () { },
                      ),
                    ));
                }
                  Navigator.pop(context);
                });
              },
            ),
            Visibility(
              visible: false, // client.doesSupportFeature("SchulMoodle")
              child: ListTile(
                title: const Text("SchulMoodle öffnen"),
                onTap: (){
                  //todo add support for moodle direct login
                },
              )
            )
          ],
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
        child: CircularProgressIndicator(),
        )
    );
  }
}
