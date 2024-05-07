import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sph_plan/view/login/setup_screen_page_view_models.dart';
import 'auth.dart';
import 'intro_screen_page_view_models.dart';

class WelcomeLoginScreen extends StatefulWidget {
  const WelcomeLoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeLoginScreenState();
}

class _WelcomeLoginScreenState extends State<WelcomeLoginScreen> {
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
          done: const Text("Login"),
          onDone: () {
            setState(() {
              currentPage = "login";
            });
          },
          dotsDecorator: const DotsDecorator(
            spacing: EdgeInsets.all(2.0),
          ),
          pages: intoScreenPageViewModels(context));
    } else if (currentPage == "login") {
      return Scaffold(
        body: LoginForm(
          afterLogin: () {
            setState(() {
              currentPage = "setup";
            });
          },
        ),
      );
    } else if (currentPage == "setup") {
      return IntroductionScreen(
        done: const Text("Fertig"),
        showNextButton: false,
        onDone: () {
          setState(() {
            Navigator.pop(context);
          });
        },
        dotsDecorator: DotsDecorator(
          spacing: const EdgeInsets.all(2.0),
          activeColor: Theme.of(context).colorScheme.primary
        ),
        pages: setupScreenPageViewModels(context),
        dotsFlex: 2,
      );
    }

    return const Center(child: Text("This should not happen"));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: buildBody());
  }
}
