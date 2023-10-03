import 'package:flutter/material.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/view/about/about.dart';
import 'package:sph_plan/view/calendar/calendar.dart';
import 'package:sph_plan/view/settings/settings.dart';
import 'package:sph_plan/view/userdata/userdata.dart';
import 'package:sph_plan/view/vertretungsplan/vertretungsplan.dart';

void main() {
  runApp(App());
  client.prepareDio();
  client.loadFromStorage();
}

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String _appTitle = 'SPH - Vertretungsplan';

  void updateTitle(String newTitle) {
    setState(() {
      _appTitle = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _appTitle,
        home: HomePage(title: _appTitle, updateTitle: updateTitle),
        theme: ThemeData(
          useMaterial3: true,
          inputDecorationTheme:
          const InputDecorationTheme(border: OutlineInputBorder()),
        ));
  }
}

class HomePage extends StatefulWidget {
  final String title;
  final Function(String) updateTitle;

  const HomePage({Key? key, required this.title, required this.updateTitle}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 0;

  String userName = "${client.userData["nachname"]??""}, ${client.userData["vorname"] ?? ""}";
  String schoolName = client.schoolName;

  static List<Widget> _widgetOptions() {
    return <Widget>[
      const VertretungsplanAnsicht(),
      const CalendarAnsicht(),
      const UserdataAnsicht(),
      const AboutScreen(),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index, String title) {
    setState(() {
      widget.updateTitle("SPH - $title");
      _selectedIndex = index;
      userName = client.username;
      loadUserData();
    });
  }

  void loadUserData() {
    setState(() {
      client.loadFromStorage().then((_){
        userName = "${client.userData["nachname"]??""}, ${client.userData["vorname"] ?? ""}";
        schoolName = client.schoolName;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: FloatingActionButton(
                      onPressed: () {

                        _onItemTapped(4, "Einstellungen");
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.manage_accounts),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schoolName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                            shadows: [
                              Shadow(color: Colors.white, blurRadius: 30)
                            ],
                          ),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.black,
                            shadows: [
                              Shadow(color: Colors.white, blurRadius: 30)
                            ],
                          ),
                        ),
                      ],
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
                // Update the state of the app
                _onItemTapped(2, "Benutzerdaten");
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Über SPHplan'),
              selected: _selectedIndex == 3,
              onTap: () {
                // Update the state of the app
                _onItemTapped(3, "Über SPHplan");
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
