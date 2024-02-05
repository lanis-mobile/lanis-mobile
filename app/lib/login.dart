import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sph_plan/shared/apps.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:sph_plan/view/bug_report/send_bugreport.dart';
import 'package:sph_plan/view/login/screen.dart';

import 'client/client.dart';
import 'client/fetcher.dart';

/* TODO:
 * Whats new
 * Perform login function
 * openLoginScreen(), push home page, ...
 * global error var?
*/

class Message {
  static String initialise = "Initialisieren...";
  static String login = "Einloggen...";
  static String load = "Lade Apps...";
  static String loadFast = "Lade Vertretungsplan...";
  static String finalise = "Finalisieren...";
  static String error = "Beim Laden ist ein Fehler passiert!";
}

enum Status {
  waiting,
  loading,
  finished,
  error;
}

class Step {
  static String login = "Login";
  static String substitutions = "Vertretungsplan";
  static String meinUnterricht = "Mein Unterricht";
  static String conversations = "Nachrichten";
  static String calendar = "Kalender";
}

class ProgressNotifier with ChangeNotifier {
  final Map<String, Status> _steps = {};

  Map<String, Status> get steps => _steps;

  void set(String step, Status status) {
    _steps[step] = status;
    notifyListeners();
  }

  void reset() {
    _steps.updateAll((_, value) => value = Status.waiting);
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
  ValueNotifier<String> loadingMessage = ValueNotifier<String>(Message.initialise);

  final List<Applet> appletFetchers = [];
  final List<String> steps = [Step.login];
  late final ProgressNotifier progress;

  ValueNotifier<bool> isError = ValueNotifier<bool>(false);
  final Map<String, LanisException?> errors = {Step.login: null};

  void openWelcomeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeLoginScreen()),
    ).then((_) {
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
        loadingMessage.value = Message.error;
        isError.value = true;
        errors[applet.step] = data.content;
        return;
      } else if (data.status == FetcherStatus.done) {
        progress.set(applet.step, Status.finished);
        loadingMessage.value = applet.finishMessage;
        break;
      }
    }

    progress.set(applet.step, Status.finished);
  }

  Future<void> performLogin() async {
    // Step 1
    await client.loadFromStorage();

    // It doesn't show it immediately but faster than before.
    // I think this check is enough.
    if (client.username == "") {
      openWelcomeScreen();
    }

    await client.prepareDio();

    // Step 2 (if this fails, show login screen or notify error)
    loadingMessage.value = Message.login;
    progress.set(Step.login, Status.loading);
    try {
      await client.login();
      client.prepareFetchers();
      progress.set(Step.login, Status.finished);

      // Step 3 (only load vp)
      if (client.loadMode == "fast") {
        loadingMessage.value = Message.loadFast;
        if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
          await fetchApplet(Applet(fetcher: client.substitutionsFetcher, step: Step.substitutions, finishMessage: "Vertretungen wurden geladen!"));
        }

        loadingMessage.value = Message.finalise;
        return;
      }

      loadingMessage.value = Message.load;

      // Step 4 (fetch everything async)
      await Future.wait(List.generate(appletFetchers.length, (index) => fetchApplet(appletFetchers[index])));

      // Step 5 (finish)
      loadingMessage.value = Message.finalise;
      return;
    } on WrongCredentialsException {
      openWelcomeScreen();
    } on CredentialsIncompleteException {
      openWelcomeScreen();
    } on LanisException catch (e) {
      errors[Step.login] = e;
      isError.value = true;
      loadingMessage.value = Message.error;
      progress.set(Step.login, Status.error);
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
    }
  }

  @override
  void initState() {
    if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
      steps.add(Step.substitutions);
      appletFetchers.add(Applet(fetcher: client.substitutionsFetcher, step: Step.substitutions, finishMessage: "Vertretungen wurden geladen!"));
      errors.addEntries([MapEntry(Step.substitutions, null)]);
    }

    if (client.loadMode == "full") {
      if (client.doesSupportFeature(SPHAppEnum.meinUnterricht)) {
        steps.add(Step.meinUnterricht);
        appletFetchers.add(Applet(fetcher: client.meinUnterrichtFetcher, step: Step.meinUnterricht, finishMessage: "Mein Unterricht wurde geladen!"));
        errors.addEntries([MapEntry(Step.meinUnterricht, null)]);
      }
      if (client.doesSupportFeature(SPHAppEnum.nachrichten)) {
        steps.add(Step.conversations);
        appletFetchers.add(Applet(fetcher: client.invisibleConversationsFetcher, step: Step.conversations, finishMessage: "Nachrichten wurden geladen! (1/2)"));
        appletFetchers.add(Applet(fetcher: client.visibleConversationsFetcher, step: Step.conversations, finishMessage: "Nachrichten wurden geladen! (2/2)"));
        errors.addEntries([MapEntry(Step.conversations, null)]);
      }
      if (client.doesSupportFeature(SPHAppEnum.kalender)) {
        steps.add(Step.calendar);
        appletFetchers.add(Applet(fetcher: client.calendarFetcher, step: Step.calendar, finishMessage: "Kalender wurde geladen!"));
        errors.addEntries([MapEntry(Step.calendar, null)]);
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (client.schoolLogo == "") ...[
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
                File(client.schoolLogo),
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
                                return ListView.separated(
                                  shrinkWrap: true,
                                    itemCount: steps.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 8,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final String step = steps[index];
                                      final Status status = progress.steps[step]!;
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
                                );
                              }
                          ),
                        ],
                      )
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: isError,
                    builder: (context, value, _) {
                      if (value) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FilledButton(
                                  onPressed: () {
                                    // Prepare error message
                                    String errorInfo = "";
                                    errors.forEach((key, value) {
                                      if (value == null) {
                                        return;
                                      }
                                      errorInfo += "$key - ${value.cause}\n";
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BugReportScreen(
                                                  generatedMessage:
                                                  "AUTOMATISCH GENERIERT (LOGIN PAGE):\n$errorInfo\nMehr Details von dir:\n")),
                                    );
                                  },
                                  child: const Text(
                                      "Fehlerbericht senden")),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: OutlinedButton(
                                    onPressed: () async {
                                      // Reset
                                      progress.reset();
                                      errors.updateAll((key, value) => value = null);
                                      isError.value = false;
                                      loadingMessage.value = "Initialisieren...";

                                      await performLogin();
                                    },
                                    child:
                                    const Text("Erneut versuchen")),
                              )
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }
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
                      ValueListenableBuilder(
                        valueListenable: loadingMessage,
                        builder: (context, value, _) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Text(
                                value,
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary)
                            ),
                          );
                        }
                      ),
                      ValueListenableBuilder(
                          valueListenable: isError,
                          builder: (context, value, _) {
                            if (value) {
                              return Icon(
                                Icons.error,
                                color: Theme.of(context).colorScheme.onPrimary,
                              );
                            }
                            return SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            );
                          }
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
