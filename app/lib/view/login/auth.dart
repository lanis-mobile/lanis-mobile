import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../client/client.dart';

class LoginForm extends StatefulWidget {
  final Function() afterLogin;

  const LoginForm({super.key, required this.afterLogin});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  double padding = 10.0;


  final _formKey = GlobalKey<FormState>();

  TextEditingController schoolIDController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool dseAgree = false;


  String selectedSchoolID = "5182";
  List<String> schoolList = ["Error: Not able to load schools. Use school id instead!"];
  String dropDownSelectedItem = "Max Planck Schule - Rüsselsheim (5182)";


  Future<void> loadSchoolList() async {
    final String data = await DefaultAssetBundle.of(context).loadString("assets/school_list.json");

    setState(() {
      schoolList = List<String>.from(jsonDecode(data));
    });
  }


  void login(String username, String password, String schoolID) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=> const AlertDialog(
          title: Text("Anmeldung"),
          content: Center(
            heightFactor: 1.2,
            child: CircularProgressIndicator(),
          ),
        )
    );

    await client.overwriteCredits(username, password, schoolID);
    var loginCode = await client.login(userLogin: true);

    setState(() {
      Navigator.pop(context); //pop dialog
      if (loginCode == 0) {
        widget.afterLogin();
      } else {
        showDialog(
            context: context,
            builder: (context)=> AlertDialog(
              title: const Text("Fehler!"),
              content: Text(client.statusCodes[loginCode]!),
              actions: [
                TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("OK"))
              ],
            ),
        );
      }
    });
  }


  @override
  void initState() {
    super.initState();
    loadSchoolList();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(height: padding*5,),
            const Center(
              child: Column(
                children: [
                  Icon(Icons.person, size: 70),
                  Text("Login", style: TextStyle(fontSize: 35),)
                ],
              ),
            ),
            SizedBox(height: padding,),
            DropdownSearch(
                popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    searchDelay: Duration(milliseconds: 150)
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        labelText: "Schule auswählen"
                    )
                ),
                selectedItem: dropDownSelectedItem,
                onChanged: (value){
                  debugPrint("changed!");
                  dropDownSelectedItem = value;
                  selectedSchoolID = extractNumber(value);
                  debugPrint(selectedSchoolID);
                },
              items: schoolList,
            ),
            SizedBox(height: padding,),
            TextFormField(
              controller: usernameController,
              autocorrect: false,
              decoration: const InputDecoration(
                  labelText: "vorname.nachname (oder Kürzel)"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte fülle dieses Feld aus';
                }
                return null;
              },
            ),
            SizedBox(height: padding,),
            TextFormField(
              controller: passwordController,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "passwort",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte fülle dieses Feld aus';
                }
                return null;
              },
            ),
            CheckboxListTile(
              value: dseAgree,
              title: RichText(
                text: TextSpan(
                  text: 'Ich stimme der ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Datenschutzerklärung',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchUrl(Uri.parse("https://github.com/alessioC42/lanis-mobile/blob/main/SECURITY.md")),
                    ),
                    const TextSpan(
                      text: ' von lanis-mobile zu.',
                    ),
                  ],
                ),
              ),
              onChanged: (val) {
                setState(() {
                  dseAgree = val!;
                });
              },
            ),
            SizedBox(height: padding,),
            ElevatedButton(
              onPressed:dseAgree? () {
                if (_formKey.currentState!.validate()) {
                  login(
                    usernameController.text,
                    passwordController.text,
                    selectedSchoolID
                  );
                }
              } : null,
              child: const Text('Anmelden'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => launchUrl(Uri.parse("https://start.schulportal.hessen.de/benutzerverwaltung.php?a=userPWreminder&i=$selectedSchoolID")),
                    child: const Text("Passwort zurücksetzen")
                )
              ],
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