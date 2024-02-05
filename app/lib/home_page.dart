import 'dart:ui';
import 'dart:io';

import 'package:sph_plan/shared/apps.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/view/calendar/calendar.dart';
import 'package:sph_plan/view/conversations/conversations.dart';
import 'package:sph_plan/view/mein_unterricht/mein_unterricht.dart';
import 'package:sph_plan/view/settings/settings.dart';
import 'package:sph_plan/view/bug_report/send_bugreport.dart';
import 'package:sph_plan/view/vertretungsplan/vertretungsplan.dart';
import 'package:url_launcher/url_launcher.dart';

enum Feature {
  substitutions("Vertretungsplan"),
  calendar("Kalender"),
  conversations("Nachrichten"),
  lessons("Mein Unterricht"),
  lanisBrowser(null),
  moodleBrowser(null),
  settings(null),
  reportBug("Fehlerbericht senden");

  const Feature(this.value);

  final String? value;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Feature defaultFeature;
  late Feature selectedFeature;

  String userName =
      "${client.userData["nachname"] ?? ""}, ${client.userData["vorname"] ?? ""}";
  String schoolName = client.schoolName;

  Feature getDefaultFeature() {
    if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) {
      return Feature.substitutions;
    } else if (client.doesSupportFeature(SPHAppEnum.kalender)) {
      return Feature.calendar;
    } else if (client.doesSupportFeature(SPHAppEnum.meinUnterricht)) {
      return Feature.lessons;
    } else {
      return Feature.conversations;
    }
  }

  static List<Widget> featureScreens() {
    return <Widget>[
      const VertretungsplanAnsicht(),
      const CalendarAnsicht(),
      const ConversationsAnsicht(),
      const MeinUnterrichtAnsicht(),
    ];
  }

  @override
  void initState() {
    defaultFeature = getDefaultFeature();
    openFeature(defaultFeature);

    super.initState();
  }

  void openLanisInBrowser() {
    client.getLoginURL().then((response) {
      launchUrl(Uri.parse(response));
    }).catchError((ex) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ex.cause),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'ACTION',
          onPressed: () {},
        ),
      ));
    }, test: (e) => e is LanisException);
  }

  void loadUserData() {
    setState(() {
      userName =
      "${client.userData["nachname"] ?? ""}, ${client.userData["vorname"] ?? ""}";
      schoolName = client.schoolName;
    });
  }

  // Open specified feature without popping the navigator.
  void openFeature(Feature currentFeature) {
    setState(() {
      loadUserData();

      userName =
      "${client.userData["nachname"] ?? ""}, ${client.userData["vorname"] ?? ""}";

      switch (currentFeature) {
        case (Feature.lanisBrowser):
          openLanisInBrowser();
          break;
        case (Feature.moodleBrowser):
          launchUrl(Uri.parse("https://mo${client.schoolID}.schule.hessen.de"));
          //todo change to .schulportal.hessen.de when changes apply to SPH servers
          //https://info.schulportal.hessen.de/veraenderungen-bei-schulmoodle-und-schulmahara-ab-08-01-2024/
          break;
        case (Feature.settings):
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          ).then((result) {
            openFeature(selectedFeature);
          });
          break;
        case (Feature.reportBug):
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BugReportScreen()),
          ).then((result) {
            openFeature(selectedFeature);
          });
          break;
        default:
          selectedFeature = currentFeature;
          break;
      }
    });
  }

  // Only used by NavigationDrawer
  void onNavigationItemTapped(int index) {
    Navigator.pop(context);
    openFeature(Feature.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    final Color imageColor =
    Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5);
    final Color textColor =
    imageColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

    List<int?> bottomNavbarNavigationTranslation = [];

    int helpIndex = 0;
    for (var supported in [
      client.doesSupportFeature(SPHAppEnum.vertretungsplan),
      client.doesSupportFeature(SPHAppEnum.kalender),
      client.doesSupportFeature(SPHAppEnum.nachrichten),
      client.doesSupportFeature(SPHAppEnum.meinUnterricht)
    ]) {
      if (supported) {
        bottomNavbarNavigationTranslation.add(helpIndex);
        helpIndex += 1;
      } else {
        bottomNavbarNavigationTranslation.add(null);
      }
    }

    return StreamBuilder<InternetConnectionStatus>(
        stream: InternetConnectionChecker().onStatusChange,
        builder: (context, network) {
          return Scaffold(
            appBar: AppBar(
              title: Text(selectedFeature
                  .value!), // We could also use a list with all title names, but a empty title should be always the first page (Vp)
              bottom: network.data == InternetConnectionStatus.disconnected ? PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.signal_wifi_off),
                      ),
                      Text(
                        "Kein Internet! Geladene Daten sind noch aufrufbar!",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ) : null,
            ),
            body: Center(
              child: helpIndex != 0 ? featureScreens()[selectedFeature.index] : Center(
                //in case no feature is supported at all just show an open in browser button.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.disabled_by_default_outlined, size: 150,),
                    const Padding(padding: EdgeInsets.all(8), child: Text("Es scheint so, als ob dein Account oder deine Schule keine Features dieser App direkt unterstützt! Stattdessen kannst du Lanis noch im Browser öffnen."),),
                    ElevatedButton(onPressed: openLanisInBrowser, child: const Text("Im browser öffnen"))
                  ],
                ),
              ),
            ),
            bottomNavigationBar: helpIndex > 1 ? NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex:
              bottomNavbarNavigationTranslation[selectedFeature.index]!,
              onDestinationSelected: (index) => openFeature(Feature
                  .values[bottomNavbarNavigationTranslation.indexOf(index)]),
              destinations: [
                if (client.doesSupportFeature(SPHAppEnum.vertretungsplan))
                  const NavigationDestination(
                    icon: Icon(Icons.group),
                    selectedIcon: Icon(Icons.group_outlined),
                    label: 'Vertretungen',
                  ),
                if (client.doesSupportFeature(SPHAppEnum.kalender))
                  const NavigationDestination(
                    icon: Icon(Icons.calendar_today),
                    selectedIcon: Icon(Icons.calendar_today_outlined),
                    label: 'Kalender',
                  ),
                if (client.doesSupportFeature(SPHAppEnum.nachrichten))
                  const NavigationDestination(
                    icon: Icon(Icons.forum),
                    selectedIcon: Icon(Icons.forum_outlined),
                    label: 'Nachrichten',
                  ),
                if (client.doesSupportFeature(SPHAppEnum.meinUnterricht))
                  const NavigationDestination(
                    icon: Icon(Icons.school),
                    selectedIcon: Icon(Icons.school_outlined),
                    label: 'Mein Unterricht',
                  ),
              ],
            ) : null,
            drawer: NavigationDrawer(
              onDestinationSelected: onNavigationItemTapped,
              selectedIndex: selectedFeature.index,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      ClipRRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: ColorFiltered(
                            colorFilter:
                            ColorFilter.mode(imageColor, BlendMode.srcOver),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.file(
                                File(client.schoolImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schoolName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: textColor),
                            ),
                            Text(
                              userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                NavigationDrawerDestination(
                  enabled: client.doesSupportFeature(SPHAppEnum.vertretungsplan),
                  icon: const Icon(Icons.group),
                  selectedIcon: const Icon(Icons.group_outlined),
                  label: const Text('Vertretungsplan'),
                ),
                NavigationDrawerDestination(
                  enabled: client.doesSupportFeature(SPHAppEnum.kalender),
                  icon: const Icon(Icons.calendar_today),
                  selectedIcon: const Icon(Icons.calendar_today_outlined),
                  label: const Text('Kalender'),
                ),
                NavigationDrawerDestination(
                  enabled:
                  client.doesSupportFeature(SPHAppEnum.nachrichten),
                  icon: const Icon(Icons.forum),
                  selectedIcon: const Icon(Icons.forum_outlined),
                  label: const Text('Nachrichten'),
                ),
                NavigationDrawerDestination(
                  enabled: client.doesSupportFeature(SPHAppEnum.meinUnterricht),
                  icon: const Icon(Icons.school),
                  selectedIcon: const Icon(Icons.school_outlined),
                  label: const Text('Mein Unterricht'),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.open_in_new),
                  label: Text('Im Browser öffnen'),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.open_in_new),
                  label: Text('Moodle login öffnen'),
                ),
                const Divider(),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Einstellungen'),
                ),
                const NavigationDrawerDestination(
                  enabled: true,
                  icon: Icon(Icons.bug_report),
                  selectedIcon: Icon(Icons.bug_report_outlined),
                  label: Text('Fehlerbericht senden'),
                ),
              ],
            ),
          );
        }
    );
  }
}