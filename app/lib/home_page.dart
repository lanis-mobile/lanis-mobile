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

  const Feature(this.title);

  final String? title;
}

class Helper {
  final Icon icon;
  final Icon selectedIcon;

  Helper({required this.icon, required this.selectedIcon});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Feature defaultFeature;
  late Feature selectedFeature;

  final List<int?> supportedFeatures = [];

  // We don't want firstname.lastname
  final String formattedUsername =
      "${client.userData["nachname"] ?? ""}, ${client.userData["vorname"] ?? ""}";

  Map<SPHAppEnum, Helper> appletHelpers = {
    SPHAppEnum.vertretungsplan: Helper(icon: const Icon(Icons.group), selectedIcon: const Icon(Icons.group_outlined)),
    SPHAppEnum.kalender: Helper(icon: const Icon(Icons.calendar_today), selectedIcon: const Icon(Icons.calendar_today_outlined)),
    SPHAppEnum.nachrichten: Helper(icon: const Icon(Icons.forum), selectedIcon: const Icon(Icons.forum_outlined)),
    SPHAppEnum.meinUnterricht: Helper(icon: const Icon(Icons.school), selectedIcon: const Icon(Icons.school_outlined)),
  };

  static final List<Widget> featureScreens = <Widget>[
    const VertretungsplanAnsicht(),
    const CalendarAnsicht(),
    const ConversationsAnsicht(),
    const MeinUnterrichtAnsicht(),
  ];

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

  // Open specified feature without popping the navigator.
  void openFeature(Feature currentFeature) {
    setState(() {
      switch (currentFeature) {
        case (Feature.lanisBrowser):
          openLanisInBrowser();
          break;
        case (Feature.moodleBrowser):
          launchUrl(Uri.parse("https://mo${client.schoolID}.schulportal.hessen.de"));
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

  Center noAppsSupported() {
    return Center(
      // In case no feature is supported at all just show an open in browser button.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.disabled_by_default_outlined, size: 150,),
          const Padding(padding: EdgeInsets.all(8), child: Text("Es scheint so, als ob dein Account oder deine Schule keine Features dieser App direkt unterstützt! Stattdessen kannst du Lanis noch im Browser öffnen."),),
          ElevatedButton(onPressed: openLanisInBrowser, child: const Text("Im Browser öffnen"))
        ],
      ),
    );
  }

  NavigationBar navigationBar() {
    List<NavigationDestination> navigationDestinations = [];

    for (final i in supportedFeatures) {
      final applet = SPHAppEnum.values[supportedFeatures.indexOf(i)];

      navigationDestinations.add(NavigationDestination(
          icon: appletHelpers[applet]!.icon,
          selectedIcon: appletHelpers[applet]!.selectedIcon,
          label: applet.fullName
      ));
    }

    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: supportedFeatures[selectedFeature.index]!,
      onDestinationSelected: (index) => openFeature(Feature
          .values[supportedFeatures.indexOf(index)]),
      destinations: navigationDestinations
    );
  }

  NavigationDrawer navigationDrawer() {
    // Complex calculation but it shouldn't be played multiple times.
    final Color imageColor =
    Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5);
    final Color textColor =
    imageColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

    List<NavigationDrawerDestination> navigationDrawerDestination = [];

    for (final i in supportedFeatures) {
      final applet = SPHAppEnum.values[supportedFeatures.indexOf(i)];

      navigationDrawerDestination.add(NavigationDrawerDestination(
          icon: appletHelpers[applet]!.icon,
          selectedIcon: appletHelpers[applet]!.selectedIcon,
          label: Text(applet.fullName)
      ));
    }

    return NavigationDrawer(
      onDestinationSelected: onNavigationItemTapped,
      selectedIndex: supportedFeatures.indexOf(selectedFeature.index),
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
                      client.schoolName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: textColor),
                    ),
                    Text(
                      formattedUsername,
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
        ...navigationDrawerDestination,
        const NavigationDrawerDestination(
          icon: Icon(Icons.open_in_new),
          label: Text('Im Browser öffnen'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.open_in_new),
          label: Text('Moodle login öffnen'),
        ),
        const Divider(indent: 20, endIndent: 20,),
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
    );
  }

  @override
  void initState() {
    defaultFeature = getDefaultFeature();
    openFeature(defaultFeature);

    int supportedIndex = 0;
    for (final applet in SPHAppEnum.values) {
      if (applet.status == AppSupportStatus.supported) {
        if (client.doesSupportFeature(applet)) {
          supportedFeatures.add(supportedIndex);
          supportedIndex++;
        } else {
          supportedFeatures.add(null);
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InternetConnectionStatus>(
        stream: InternetConnectionChecker().onStatusChange,
        builder: (context, network) {
          return Scaffold(
            appBar: AppBar(
              title: Text(selectedFeature.title!),
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
            body: client.applets!.isNotEmpty ? featureScreens[selectedFeature.index] : noAppsSupported(),
            bottomNavigationBar: client.applets!.length > 2 ? navigationBar() : null,
            drawer: navigationDrawer()
          );
        }
    );
  }
}