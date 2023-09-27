import 'package:flutter/material.dart';
import 'package:sph_plan/client/client.dart';
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
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      )
    );
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

  static List<Widget> _widgetOptions(SPHclient client) {
    return <Widget>[
      const VertretungsplanAnsicht(),
      const Text("About page einrichten"),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
              ),
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Text("Alessio Caputo", style: TextStyle(
                          fontSize: 32
                        )),
                        Text("Max-Planck-Schule")
                      ],
                    )
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child:                   FloatingActionButton(
                      onPressed: () {
                        _onItemTapped(2);
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.manage_accounts),
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

