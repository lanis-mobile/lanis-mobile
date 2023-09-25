import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sph_plan/client/client.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _schoolController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double padding = 10.0;
    const subHeaderStyle = TextStyle(
      fontSize: 24,
    );

    return Scaffold(
      body: Column(
        children: [
          const Text("Account", style: subHeaderStyle),
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextFormField(
              controller: _schoolController,
              decoration: const InputDecoration(labelText: 'Schulnummer (eg 5182)'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextFormField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Benutzername (user.name)'),
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
            child: ElevatedButton(
              onPressed: () {
                login(_userController.text, _passwordController.text, _schoolController.text);
              },
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}

void login(String username, String password, String schoolID) async {
  final client = SPHclient();
  await client.overwriteCredits(username, password, schoolID);

  //var code = await client.login();
  //debugPrint("Login status: ${client.statusCodes[code]}");
  var result = await client.getFullVplan();
  debugPrint(jsonEncode(result));
}
