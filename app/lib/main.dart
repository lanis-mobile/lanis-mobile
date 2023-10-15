import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/view/about/about.dart';
import 'package:sph_plan/view/calendar/calendar.dart';
import 'package:sph_plan/view/settings/settings.dart';
import 'package:sph_plan/view/userdata/userdata.dart';
import 'package:sph_plan/view/vertretungsplan/vertretungsplan.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPH - Vertretungsplan',
      home: const HomePage(),
      theme: ThemeData(
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
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

    // Replace this with your actual authentication logic
    await client.loadFromStorage();
    await client.prepareDio();
    int loginCode = await client.login();
    if (loginCode != 0) {
      _selectedIndex = 3;
      _completeLogin();
      openSettingsScreen();
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
      const UserdataAnsicht(),
      const AboutScreen(),
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
                  image: AssetImage("lib/assets/blackboard_backgroud.jpg"),
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
            ListTile(
              title: const Text('Vertretungsplan'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0, "Vertretungsplan");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Kalender'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1, "Kalender");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Benutzerdaten'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2, "Benutzerdaten");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Über SPHplan'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3, "Über SPHplan");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Im Browser Öffnen'),
              selected: _selectedIndex == -1,
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
