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
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoginButtonEnabled = true;


  double spinnerSize = 0;
  String loginStatusText = "";
  List schoolList = ["Error: Not able to load schools. Use school id instead!"];
  String dropDownSelectedItem = "Max-Planck-Schule - Rüsselsheim (5182)";

  void login(String username, String password, String schoolID) async {
    setState(() {
      spinnerSize = 100;
      loginStatusText = "Melde Benutzer an...";
      isLoginButtonEnabled = false; // Disable Button
    });

    await client.overwriteCredits(username, password, schoolID, dropDownSelectedItem);
    var loginCode = await client.login(userLogin: true);

    debugPrint("Login statuscode: ${loginCode.toString()}");

    setState(() {
      spinnerSize = 0;
      if (loginCode == 0) {
        loginStatusText = "Anmeldung erfolgreich!";
        isLoginButtonEnabled = false;
        Navigator.pop(context);
      } else {
        loginStatusText = "Anmeldung fehlgeschlagen!\nFehler: ${client.statusCodes[loginCode]} ($loginCode)";
        isLoginButtonEnabled = true;
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
      isLoginButtonEnabled = false;
    });
    await client.loadFromStorage();
    bool isAuth = await client.isAuth();
    setState(() {
      spinnerSize = 0;
      if (isAuth) {
        loginStatusText = "Eingeloggt.";
        isLoginButtonEnabled = false;
      } else {
        loginStatusText = "Nicht Eingeloggt oder Offline";
        isLoginButtonEnabled = true;
      }
    });
  }

  void loadSchoolList() {
    DefaultAssetBundle.of(context).loadString("assets/school_list.json").then((String str) {
      setState(() {
        schoolList = jsonDecode(str);
      });

    });
  }

  @override
  void initState() {
    super.initState();
    loadCredits();
    loadSchoolList();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    double padding = 10.0;
    return PopScope(
        canPop: !isLoginButtonEnabled,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("SPH Login"),
              automaticallyImplyLeading: !isLoginButtonEnabled
          ),
          body: ListView(
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
                child: ElevatedButton(
                  onPressed: isLoginButtonEnabled
                      ? () {
                    login(
                      _userController.text,
                      _passwordController.text,
                      extractNumber(dropDownSelectedItem),
                    );
                  }
                      : null, // Set onPressed to null when button is disabled
                  child: const Text('Login'),
                ),
              ),
              SpinKitDancingSquare(
                size: spinnerSize,
                color: Colors.black,
              ),
              Center(
                child:  Text(loginStatusText),
              ),
              const SizedBox(height: 10,),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text("Information"),
                subtitle: Text("Melde dich mit deinen Lanis/Schulportal/Moodle-Logindaten an. Jegliche Daten werden ausschließlich lokal gespeichert."),
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text("Disclaimer"),
                subtitle: Text("Diese Software steht in keinerlei Verbindung zu den Entwicklern des SPH. Es besteht keine Garantie oder Gewährleistung."),
              )
            ],
          ),
        ),
    );
  }
}

String extractNumber(str){
  RegExp numberPattern = RegExp(r'\((\d+)\)');

  Match match = numberPattern.firstMatch(str) as Match;
  return match.group(1)!;
}

