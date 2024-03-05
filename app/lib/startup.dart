import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sph_plan/home_page.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:sph_plan/shared/whats_new.dart';
import 'package:sph_plan/view/bug_report/send_bugreport.dart';
import 'package:sph_plan/view/login/screen.dart';

import 'client/client.dart';
import 'client/fetcher.dart';

/// Just a collection of possible messages for the bottom progress indicator, so we that we have not magic strings.
class Message {
  static String initialise = "Initialisieren...";
  static String login = "Einloggen...";
  static String load = "Lade Apps...";
  static String finalise = "Finalisieren...";
  static String error = "Beim Laden ist ein Fehler passiert!";
}

/// Status of each step
enum Status {
  waiting,
  loading,
  finished,
  error;
}

/// Collection of steps so we don't have magic strings.
class Step {
  static String login = "Login";
  // The rest is now dynamic, gotten by [client.loadApps]
}

/// More advanced class, so we can have a tidy and clean progress indicator of the steps.
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

/// Possible applet which will be fetched by [fetchApplet].
class Applet {
  final Fetcher? fetcher;
  final String step;
  final String finishMessage;

  Applet(
      {required this.fetcher, required this.step, required this.finishMessage});
}

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  ValueNotifier<String> loadingMessage =
      ValueNotifier<String>(Message.initialise);

  final List<Applet> appletFetchers = [];
  final List<String> steps = [Step.login];
  late final ProgressNotifier progress;

  ValueNotifier<bool> noConnection = ValueNotifier<bool>(false);
  ValueNotifier<bool> isError = ValueNotifier<bool>(false);
  final Map<String, LanisException?> errors = {Step.login: null};

  // We need to load storage first, so we have to wait before everything.
  ValueNotifier<bool> finishedLoadingStorage = ValueNotifier<bool>(false);

  void openWelcomeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeLoginScreen()),
    ).then((_) async {
      client.initialiseLoadApps();
      await client.prepareDio();

      // Context should be mounted
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
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

        if (data.content is NoConnectionException) {
          noConnection.value = true;
        }

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
    // It doesn't show it immediately but a lot faster than before.
    // I think this check is enough.
    await client.prepareDio();
    if (client.username == "") {
      openWelcomeScreen();
      return;
    }

    // Step 2 (if this fails, show login screen or notify error)
    loadingMessage.value = Message.login;
    progress.set(Step.login, Status.loading);
    try {
      await client.login();
      client.initialiseLoadApps();
      progress.set(Step.login, Status.finished);

      loadingMessage.value = Message.load;

      // Step 4 (fetch everything async)
      await Future.wait(List.generate(appletFetchers.length,
          (index) => fetchApplet(appletFetchers[index])));

      // Step 5 (finish)
      if (!isError.value) {
        loadingMessage.value = Message.finalise;
        whatsNew().then((value) {
          if (value != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReleaseNotesScreen(value)),
            ).then((_) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                ));
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        });
      }
      return;
    } on WrongCredentialsException {
      openWelcomeScreen();
    } on CredentialsIncompleteException {
      openWelcomeScreen();
    } on LanisException catch (e, stack) {
      debugPrint(stack.toString());
      errors[Step.login] = e;
      isError.value = true;
      progress.set(Step.login, Status.error);

      if (e is NoConnectionException) {
        noConnection.value = true;
      }

      loadingMessage.value = Message.error;
    }
  }

  // Handy functions
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
    // So that we begin loading instantly on startup.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // We need to load this first so that everything works.
      client.loadFromStorage().then((_) {
        // Show welcome screen nearly instantly.
        if (client.username == "") {
          performLogin();
          return;
        }

        finishedLoadingStorage.value = true;

        if (client.applets != null) {
          for (final loadApp in client.applets!.keys) {
            final currentLoadApp = client.applets![loadApp];

            if (currentLoadApp!.shouldFetch == true) {
              steps.add(currentLoadApp.applet.fullName);
              for (final fetcher in currentLoadApp.fetchers) {
                appletFetchers.add(Applet(
                    fetcher: fetcher,
                    step: currentLoadApp.applet.fullName,
                    finishMessage:
                        "${currentLoadApp.applet.fullName} wurde(n) fertig geladen!"));
              }
            }

            errors.addEntries([MapEntry(currentLoadApp.applet.fullName, null)]);
          }
        }

        progress = ProgressNotifier(steps);

        performLogin();
      });
    });

    super.initState();
  }

  /// Either school image or app version.
  Widget schoolLogo() {
    var darkMode = Theme.of(context).brightness == Brightness.dark;

    Widget deviceInfo = FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, packageInfo) {
        return Text(
          "lanis-mobile ${packageInfo.data?.version}",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25)),
        );
      },
    );

    return CachedNetworkImage(
      imageUrl:
          "https://startcache.schulportal.hessen.de/exporteur.php?a=schoollogo&i=${client.schoolID}",
      fadeInDuration: const Duration(milliseconds: 100),
      placeholder: (context, url) => deviceInfo,
      errorWidget: (context, url, error) => deviceInfo,
      imageBuilder: (context, imageProvider) => ColorFiltered(
        colorFilter: darkMode
            ? const ColorFilter.matrix([
                -1,
                0,
                0,
                0,
                255,
                0,
                -1,
                0,
                0,
                255,
                0,
                0,
                -1,
                0,
                255,
                0,
                0,
                0,
                1,
                0,
              ])
            : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
        child: Image(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget currentSteps() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(16.0)),
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 84),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                  valueListenable: finishedLoadingStorage,
                  builder: (context, _finishedLoadingStorage, _) {
                    if (_finishedLoadingStorage) {
                      // Show all steps like login, vp, ...
                      return ListenableBuilder(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 4.0),
                                            child: Icon(
                                              getIcon(status),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                            ),
                                          ),
                                          Text(step,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary)),
                                        ],
                                      ),
                                      Text(getProgressMessage(status),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary))
                                    ],
                                  );
                                });
                          });
                    }
                    // Show only that client.loadFromStorage() is being executed.
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Lade gespeicherte Daten...",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary))
                      ],
                    );
                  })
            ],
          )),
    );
  }

  Widget errorButtons() {
    return ValueListenableBuilder(
        valueListenable: isError,
        builder: (context, _isError, _) {
          if (_isError) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                      valueListenable: noConnection,
                      builder: (context, _noInternet, _) {
                        if (_noInternet) {
                          return const SizedBox.shrink();
                        }
                        return FilledButton(
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
                                    builder: (context) => BugReportScreen(
                                        generatedMessage:
                                            "AUTOMATISCH GENERIERT (LOGIN PAGE):\n$errorInfo\nMehr Details von dir:\n")),
                              );
                            },
                            child: const Text("Fehlerbericht senden"));
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: OutlinedButton(
                        onPressed: () async {
                          // Reset
                          progress.reset();
                          errors.updateAll((key, value) => value = null);
                          isError.value = false;
                          noConnection.value = false;
                          loadingMessage.value = "Initialisieren...";

                          await performLogin();
                        },
                        child: const Text("Erneut versuchen")),
                  )
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }

  /// The bottom thing that shows a message and a "big" progress indicator.
  Widget progressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16.0)),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.all(12),
          child: Row(
            children: [
              ValueListenableBuilder(
                  valueListenable: loadingMessage,
                  builder: (context, _loadingMessage, _) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text(_loadingMessage,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: isError,
                  builder: (context, _isError, _) {
                    if (_isError) {
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
                  })
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            schoolLogo(),
            Column(
              children: [
                // Greeting message
                Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16.0)),
                    padding: const EdgeInsets.all(12.0),
                    child: ValueListenableBuilder(
                      valueListenable: noConnection,
                      builder: (context, noConnection, _) {
                        if (noConnection) {
                          return Text("Keine Verbindung!",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary));
                        }
                        return Text("Willkommen zurück!",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary));
                      },
                    )),
                currentSteps(),
                errorButtons(),
              ],
            ),
            progressIndicator()
          ],
        ),
      ),
    );
  }
}
