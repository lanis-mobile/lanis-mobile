import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../client/client.dart';
import 'auth.dart';
import 'intro_screen_page_view_models.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {

  String currentPage = "intro";
  List<String> schoolList = [];

  @override
  void initState() {
    super.initState();
  }

  Widget buildBody() {
    if (currentPage == "intro") {
      return IntroductionScreen(
          next: const Icon(Icons.arrow_forward),
          done: const Text("zum Login"),
          onDone: () {
            setState(() {
              currentPage = "login";
            });
          },
          pages: intoScreenPageViewModels
      );
    } else if (currentPage == "login") {
      return const Scaffold(
        body: LoginForm(onSuccess: null,),
      );
    }

    return const Center(child: Text("Etwas ist schief gelaufen!"));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
        child: buildBody()
    );
  }
}

String extractNumber(str){
  RegExp numberPattern = RegExp(r'\((\d+)\)');

  Match match = numberPattern.firstMatch(str) as Match;
  return match.group(1)!;
}

