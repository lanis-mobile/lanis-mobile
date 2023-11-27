import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../client/client.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  _AccountSettingsScreenState() {
    loadCredits();
  }

  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  double spinnerSize = 0;
  String loginStatusText = "";
  List schoolList = ["Error: Not able to load schools."];
  String dropDownSelectedItem = "Max-Planck-Schule - Rüsselsheim (5182)";

  void login(String username, String password, String schoolID) async {
    setState(() {
      spinnerSize = 100;
      loginStatusText = "Melde Benutzer an...";
    });
    await client.overwriteCredits(username, password, schoolID, dropDownSelectedItem);
    var loginCode = await client.login();

    debugPrint("Login statuscode: ${loginCode.toString()}");

    setState(() {
      spinnerSize = 0;
      if (loginCode == 0) {
        loginStatusText = "Anmeldung erfolgreich!";
        Navigator.pop(context);
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
    dropDownSelectedItem = await client.getSchoolIDHelperString();
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

  void loadSchoolList() {
    DefaultAssetBundle.of(context).loadString("lib/assets/school_list.json").then((String str) {
      setState(() {
        schoolList = jsonDecode(str);
      });

    });
  }

  @override
  void initState() {
    super.initState();
    loadSchoolList();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    double padding = 10.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Einstellungen"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: DropdownSearch(
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchDelay: Duration(milliseconds: 200)
              ),
              items: schoolList,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Schule auswählen"
                )
              ),
              selectedItem: dropDownSelectedItem,
              onChanged: (value){
                dropDownSelectedItem = value;

              }
            )
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
                    login(
                        _userController.text,
                        _passwordController.text,
                        extractNumber(dropDownSelectedItem)
                    );
                  },
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await client.deleteAllSettings();
                    setState(() {
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

String extractNumber(str){
  RegExp numberPattern = RegExp(r'\((\d+)\)');

  Match match = numberPattern.firstMatch(str) as Match;
  return match.group(1)!;
}