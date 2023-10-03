import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../client/client.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  _SettingsScreenState() {
    loadCredits();
  }

  final _schoolController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  double spinnerSize = 0;
  String loginStatusText = "";

  void login(String username, String password, String schoolID) async {
    setState(() {
      spinnerSize = 100;
      loginStatusText = "Melde Benutzer an...";
    });
    await client.overwriteCredits(username, password, schoolID);
    var loginCode = await client.login();

    debugPrint("Login statuscode: ${loginCode.toString()}");

    setState(() {
      spinnerSize = 0;
      if (loginCode == 0) {
        loginStatusText = "Anmeldung erfolgreich!";
      } else {
        loginStatusText = "Anmeldung fehlgeschlagen!\nFehlercode: $loginCode";
      }
    });
  }

  void loadCredits() async {
    await client.loadFromStorage();
    var credits = await client.getCredits();

    _userController.text = credits["username"];
    _passwordController.text = credits["password"];
    _schoolController.text = credits["schoolID"];
  }

  void checkAuth() async {
    setState(() {
      spinnerSize = 100;
      loginStatusText = "Überprüfe authentifizierung...";
    });
    await client.loadFromStorage();
    bool isAuth = await client.isAuth();
    setState(() {
      spinnerSize = 0;
      if (isAuth) {
        loginStatusText = "Eingeloggt.";
      } else {
        loginStatusText = "Nicht Eingeloggt oder Offline";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    double padding = 10.0;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextFormField(
              controller: _schoolController,
              decoration:
                  const InputDecoration(labelText: 'Schulnummer (eg 5182)'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextFormField(
              controller: _userController,
              decoration:
                  const InputDecoration(labelText: 'Benutzername (user.name)'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    login(_userController.text, _passwordController.text,
                        _schoolController.text);
                  },
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await client.deleteAllSettings();
                    setState(() {
                      _schoolController.text = "";
                      _userController.text = "";
                      _passwordController.text = "";
                      loginStatusText = "Nicht Eingeloggt | Reset erfolgreich";
                    });
                  },
                  child: const Text('App zurücksetzen'),
                )
              ],
            ),
          ),
          SpinKitDancingSquare(
            size: spinnerSize,
            color: Colors.black,
          ),
          Text(loginStatusText)
        ],
      ),
    );
  }
}
