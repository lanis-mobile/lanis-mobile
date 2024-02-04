import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sph_plan/shared/apps.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:sph_plan/view/login/screen.dart';

import 'client/client.dart';
import 'client/fetcher.dart';

/* TODO:
 * Whats new
 * Perform login function
 * openLoginScreen(), push home page, ...
 * global error var?
*/

enum Status {
  waiting,
  loading,
  finished,
  error,
  notSupported;
}

class Step {
  static String login = "Login";
  static String substitutions = "Vertretungsplan";
  static String meinUnterricht = "Mein Unterricht";
  static String conversations = "Nachrichten";
  static String calendar = "Kalender";
}

class ProgressNotifier with ChangeNotifier {
  /*final Map<String, Status> _steps = {
    Steps.login: Status.waiting,
    Steps.substitutions: Status.waiting,
    Steps.meinUnterricht: Status.waiting,
    Steps.conversations: Status.waiting,
    Steps.calendar: Status.waiting
  };*/
  final Map<String, Status> _steps = {};

  Map<String, Status> get steps => _steps;

  void set(String step, Status status) {
    _steps[step] = status;
    notifyListeners();
  }

  ProgressNotifier(List<String> steps) {
    for (String step in steps) {
      _steps.addEntries([MapEntry(step, Status.waiting)]);
    }
  }
}

class Applet {
  final Fetcher? fetcher;
  final String step;
  final String finishMessage;

  Applet({required this.fetcher, required this.step, required this.finishMessage});
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ValueNotifier loadingMessage = ValueNotifier<String>("Initialisieren...");

  final List<Applet> appletFetchers = [];
  final List<String> steps = [Step.login];
  late final ProgressNotifier progress;


  void openLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeLoginScreen()),
    ).then((result) {
      /*setState(() {
        isLoading = false;
      });*/
      client.prepareFetchers();
      //openFeature(getDefaultFeature());
    });
  }

  Future<void> fetchApplet(Applet applet) async {
    progress.set(applet.step, Status.loading);

    await applet.fetcher!.fetchData(forceRefresh: true);

    await for (dynamic data in applet.fetcher!.stream) {
      if (data.status == FetcherStatus.error) {
        progress.set(applet.step, Status.error);
        loadingMessage.value = "Beim Laden ist ein Fehler passiert!";
        //error = LanisException(data.content);
        return;
      } else if (data.status == FetcherStatus.done) {
        progress.set(applet.step, Status.finished);
        loadingMessage.value = applet.finishMessage;
        break;
      }
    }

    progress.set(applet.step, Status.finished);
  }

  void performLogin() async {
    // Step 1
    await client.loadFromStorage();
    await client.prepareDio();

    // Step 2 (if this fails, show login screen or notify error)
    loadingMessage.value = "Einloggen...";
    progress.set(Step.login, Status.loading);
    try {
      await client.login();
      client.prepareFetchers();
      progress.set(Step.login, Status.finished);

      // Step 3 (only load vp)
      if (client.loadMode == "fast") {
        loadingMessage.value = "Vertretungsplan laden...";
        if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
          await fetchApplet(Applet(fetcher: client.substitutionsFetcher, step: Step.substitutions, finishMessage: "Vertretungen wurden geladen!"));
        }

        loadingMessage.value = "Finalisieren...";
        return;
      }

      loadingMessage.value = "Lade Apps...";

      // Step 4 (fetch everything async)
      await Future.wait(List.generate(appletFetchers.length, (index) => fetchApplet(appletFetchers[index])));

      // Step 5 (finish)
      loadingMessage.value = "Finalisieren...";
      return;
    } on WrongCredentialsException {
      openLoginScreen();
    } on CredentialsIncompleteException {
      openLoginScreen();
    } on LanisException catch (e) {
      progress.set(Step.login, Status.error);
      //error = e;
    }
  }

  IconData getIcon(Status status) {
    switch (status) {
      case Status.finished:
        return Icons.check;
      case Status.waiting:
        return Icons.pending_outlined;
      case Status.loading:
        return Icons.sync;
      case Status.error:
        return Icons.error_outline;
      default:
        throw ArgumentError("Status can't be Status.notSupported");
    }
  }

  String getProgressMessage(Status status) {
    switch (status) {
      case Status.finished:
        return "Fertig";
      case Status.waiting:
        return "Warten";
      case Status.loading:
        return "Laden";
      case Status.error:
        return "Fehler";
      default:
        throw ArgumentError("Status can't be Status.notSupported");
    }
  }

  @override
  void initState() {
    if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
      steps.add(Step.substitutions);
      appletFetchers.add(Applet(fetcher: client.substitutionsFetcher, step: Step.substitutions, finishMessage: "Vertretungen wurden geladen!"));
    }

    if (client.loadMode == "full") {
      if (client.doesSupportFeature(SPHAppEnum.meinUnterricht)) {
        steps.add(Step.meinUnterricht);
        appletFetchers.add(Applet(fetcher: client.meinUnterrichtFetcher, step: Step.meinUnterricht, finishMessage: "Mein Unterricht wurde geladen!"));
      }
      if (client.doesSupportFeature(SPHAppEnum.nachrichten)) {
        steps.add(Step.conversations);
        appletFetchers.add(Applet(fetcher: client.invisibleConversationsFetcher, step: Step.conversations, finishMessage: "Nachrichten wurden geladen! (1/2)"));
        appletFetchers.add(Applet(fetcher: client.visibleConversationsFetcher, step: Step.conversations, finishMessage: "Nachrichten wurden geladen! (2/2)"));
      }
      if (client.doesSupportFeature(SPHAppEnum.kalender)) {
        steps.add(Step.calendar);
        appletFetchers.add(Applet(fetcher: client.calendarFetcher, step: Step.calendar, finishMessage: "Kalender wurde geladen!"));
      }
    }

    progress = ProgressNotifier(steps);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      performLogin();

      /*whatsNew().then((value) {
        if (value != null) {
          openReleaseNotesModal(context, value);
        }
      });*/
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*var brightness = View.of(context).platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;*/

    return Scaffold(
      body: Stack(
        children: [
          /*ColorFiltered(
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.surface,
                BlendMode.color
            ),
            child: Image.network(
              "https://startcache.schulportal.hessen.de/img/schulbg/6091/f2c6de2fbc74486e5b8f60443f62b50e-lg.jpg",
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: double.maxFinite,
              opacity: AlwaysStoppedAnimation(isDarkMode ? .065 : .085), // light: .085, dark: .065
            ),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.surface.withOpacity(isDarkMode ? .6 : .4), // light: 0.4, dark: 0.6
                    ]
                )
            ),
          ),*/
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (client.schoolLogo == null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, packageInfo) {
                          return Text(
                            "lanis-mobile ${packageInfo.data?.version}",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25)),
                          );
                        },
                      )
                    ],
                  ),
                ] else ...[
                  Image.file(
                    File(client.schoolLogo!),
                  ),
                ],
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(16.0)
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                          "Willkommen zurück!",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(16.0)
                          ),
                          padding: const EdgeInsets.all(12.0),
                          margin: const EdgeInsets.symmetric(horizontal: 84),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListenableBuilder(
                                  listenable: progress,
                                  builder: (context, _) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                        itemCount: steps.length,
                                        itemBuilder: (context, index) {
                                          final String step = steps[index];
                                          final Status status = progress.steps[step]!;
                                          if (status != Status.notSupported) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 4.0),
                                                      child: Icon(
                                                        getIcon(status),
                                                        color: Theme.of(context).colorScheme.onSecondary,
                                                      ),
                                                    ),
                                                    Text(
                                                        step,
                                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondary)
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                    getProgressMessage(status),
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSecondary)
                                                )
                                              ],
                                            );
                                          }
                                          return null;
                                        }
                                    );
                                  }
                              ),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(16.0)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      margin: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: ValueListenableBuilder(
                              valueListenable: loadingMessage,
                              builder: (context, value, _) {
                                return Text(
                                    value,
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary)
                                );
                              },
                            )
                          ),
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
