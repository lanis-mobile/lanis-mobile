import 'package:flutter/material.dart';
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
          done: const Text("zum Login"),
          onDone: () {
            setState(() {
              currentPage = "login";
            });
          },
          dotsDecorator:
              DotsDecorator(activeColor: Theme.of(context).colorScheme.primary),
          pages: intoScreenPageViewModels);
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
        pages: setupScreenPageViewModels,
        dotsFlex: 2,
        dotsDecorator:
            DotsDecorator(activeColor: Theme.of(context).colorScheme.primary),
      );
    }

    return const Center(child: Text("Etwas ist schief gelaufen!"));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: buildBody());
  }
}
