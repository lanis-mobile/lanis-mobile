import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../client/client.dart';
import '../../client/storage.dart';

class LoginForm extends StatefulWidget {
  final Function() afterLogin;
  final bool relogin;

  const LoginForm({super.key, required this.afterLogin, this.relogin = false});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  static const double padding = 10.0;

  final _formKey = GlobalKey<FormState>();

  TextEditingController schoolIDController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool dseAgree = false;
  bool countlyAgree = false;

  String selectedSchoolID = "5182";
  List<String> schoolList = [];
  String dropDownSelectedItem = "Max Planck Schule - Rüsselsheim (5182)";

  Future<void> loadSchoolList() async {
    try {
      final dio = Dio();
      final response = await dio.get(
          "https://startcache.schulportal.hessen.de/exporteur.php?a=schoollist");
      List<dynamic> data = jsonDecode(response.data);
      List<String> result = [];
      for (var elem in data) {
        for (var schule in elem['Schulen']) {
          String name = schule['Name'].replaceAll("-", " ").replaceAll("\n", " ");
          result.add('$name - ${schule['Ort']} (${schule['Id']})');
        }
      }
      result.sort();
      setState(() {
        schoolList = result;
      });
    } catch (e) {
      // Show a SnackBar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.authFailedLoadingSchools),
          duration: const Duration(seconds: 10),
        ),
      );
      Future.delayed(const Duration(seconds: 10), loadSchoolList);
    }
  }

  void login(String username, String password, String schoolID) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.logInTitle),
              content: const Center(
                heightFactor: 1.2,
                child: CircularProgressIndicator(),
              ),
            ));
    await client.temporaryOverwriteCredits(username, password, schoolID);
    try {
      await client.login(userLogin: true);
      await client.overwriteCredits(username, password, schoolID);
      setState(() {
        Navigator.pop(context); //pop dialog
        widget.afterLogin();
      });
    } on LanisException catch (ex) {
      setState(() {
        Navigator.pop(context); //pop dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.error),
            content: Text(ex.cause),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadSchoolList();
  }

  @override
  void dispose() {
    schoolIDController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.relogin) {
      dropDownSelectedItem = "${client.schoolName} (${client.schoolID})";
      selectedSchoolID = client.schoolID;
      dseAgree = true;
      usernameController.text = client.username;
    }

    return Padding(
      padding: const EdgeInsets.all(padding),
      child: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: padding,
                ),
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.person, size: 70),
                      Text(
                        AppLocalizations.of(context)!.logIn,
                        style: const TextStyle(fontSize: 35),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: padding * 5,
                ),
                DropdownSearch(
                  popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      searchDelay: Duration(milliseconds: 150)),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.selectSchool)),
                  selectedItem: dropDownSelectedItem,
                  enabled: !widget.relogin,
                  onChanged: (value) {
                    dropDownSelectedItem = value;
                    selectedSchoolID = extractNumber(value);
                  },
                  items: schoolList,
                ),
                const SizedBox(
                  height: padding,
                ),
                TextFormField(
                  controller: usernameController,
                  autocorrect: false,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.authUsernameHint),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.authValidationError;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: padding,
                ),
                TextFormField(
                  controller: passwordController,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.authPasswordHint,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.authValidationError;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: padding,
                ),
                Visibility(
                  visible: !widget.relogin,
                  child: Column(
                    children: [
                      ExcludeSemantics(
                        child: CheckboxListTile(
                          value: countlyAgree,
                          title: RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .authSendBugReports,
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Countly',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launchUrl(
                                        Uri.parse("https://countly.com/lite")),
                                ),
                                const TextSpan(
                                  text: ')',
                                ),
                              ],
                            ),
                          ),
                          onChanged: (val) async {
                            setState(() {
                              countlyAgree = val!;
                            });
                            await globalStorage.write(
                                key: StorageKey.settingsUseCountly,
                                value: val.toString());
                          },
                        ),
                      ),
                      ExcludeSemantics(
                        child: CheckboxListTile(
                          value: dseAgree,
                          title: RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context)!.authIAccept,
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .authTermsOfService,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launchUrl(Uri.parse(
                                        "https://github.com/alessioC42/lanis-mobile/blob/main/SECURITY.md")),
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .authOfLanisMobile,
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: padding,
                ),
                ElevatedButton(
                  onPressed: dseAgree
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            login(usernameController.text,
                                passwordController.text, selectedSchoolID);
                          }
                        }
                      : null,
                  child: Text(AppLocalizations.of(context)!.logIn),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => launchUrl(Uri.parse(
                            "https://start.schulportal.hessen.de/benutzerverwaltung.php?a=userPWreminder&i=$selectedSchoolID")),
                        child: Text(
                            AppLocalizations.of(context)!.authResetPassword))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String extractNumber(str) {
  RegExp numberPattern = RegExp(r'(?<=\()\d+(?=\))');

  Match match = numberPattern.firstMatch(str) as Match;
  return match.group(0)!;
}
