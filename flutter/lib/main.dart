import 'package:flutter/material.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/view/about/about.dart';
import 'package:sph_plan/view/settings/settings.dart';
import 'package:sph_plan/view/vertretungsplan/vertretungsplan.dart';

void main() {
  runApp(App());
  client.prepareDio();
  client.loadCreditsFromStorage();
}

class App extends StatelessWidget {
  final SPHclient client = SPHclient();

  App({super.key});

  static const appTitle = 'SPH';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        home: MyHomePage(client, title: appTitle),
        theme: ThemeData(
          useMaterial3: true,
          inputDecorationTheme:
              const InputDecorationTheme(border: OutlineInputBorder()),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  final SPHclient client;

  const MyHomePage(this.client, {super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _HomePage();
}

class _HomePage extends State<MyHomePage> {
  SPHclient get client => widget.client;

  int _selectedIndex = 0;

  String userName = "user.name";
  String schoolName = "Example City School";

  static List<Widget> _widgetOptions(SPHclient client) {
    return <Widget>[
      const VertretungsplanAnsicht(),
      const AboutScreen(),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      userName = client.username;
      loadUserData();
    });
  }

  void loadUserData() {
    client.loadCreditsFromStorage().then((_) => {
      setState(() {
        userName = client.username;
        schoolName = client.schoolName;
      })
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
        child: _widgetOptions(client)[_selectedIndex],
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
                        _onItemTapped(2);
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
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Über SPHplan'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
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
