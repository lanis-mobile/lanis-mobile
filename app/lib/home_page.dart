import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:sph_plan/shared/apps.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';

import 'package:flutter/material.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/view/calendar/calendar.dart';
import 'package:sph_plan/view/conversations/conversations.dart';
import 'package:sph_plan/view/data_storage/data_storage.dart';
import 'package:sph_plan/view/mein_unterricht/mein_unterricht.dart';
import 'package:sph_plan/view/settings/settings.dart';
import 'package:sph_plan/view/bug_report/send_bugreport.dart';
import 'package:sph_plan/view/timetable/timetable.dart';
import 'package:sph_plan/view/vertretungsplan/vertretungsplan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sph_plan/client/connection_checker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class Destination {
  final String label;
  final Icon icon;
  final Icon selectedIcon;
  final bool isSupported;
  final bool enableBottomNavigation;
  final bool enableDrawer;
  final bool addDivider;
  final Function? action;
  final Widget? body;

  //Either a body or an action has to be provided!
  Destination(
      {this.body,
      this.action,
      this.addDivider = false,
      required this.enableBottomNavigation,
      required this.enableDrawer,
      required this.label,
      required this.isSupported,
      required this.icon,
      required this.selectedIcon});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedDestinationDrawer;
  late bool doesSupportAnyApplet = false;

  ///The UI is build dynamically based on this list.
  ///Applets with destination.enableBottomNavigation enabled have to be placed at the beginning of the list or the bottom navigation bar will break.
  List<Destination> destinations = [
    Destination(
        label: "Vertretungsplan",
        icon: const Icon(Icons.group),
        selectedIcon: const Icon(Icons.group_outlined),
        isSupported: client.doesSupportFeature(SPHAppEnum.vertretungsplan),
        enableBottomNavigation: true,
        enableDrawer: true,
        body: const VertretungsplanAnsicht()),
    Destination(
        label: "Kalender",
        icon: const Icon(Icons.calendar_today),
        selectedIcon: const Icon(Icons.calendar_today_outlined),
        isSupported: client.doesSupportFeature(SPHAppEnum.kalender),
        enableBottomNavigation: true,
        enableDrawer: true,
        body: const CalendarAnsicht()),
    Destination(
      label: "Stundenplan",
      icon: const Icon(Icons.timelapse),
      selectedIcon: const Icon(Icons.timelapse),
      isSupported: client.doesSupportFeature(SPHAppEnum.stundenplan),
      enableBottomNavigation: true,
      enableDrawer: true,
      body: const TimetableAnsicht(),
    ),
    Destination(
        label: "Nachrichten",
        icon: const Icon(Icons.forum),
        selectedIcon: const Icon(Icons.forum_outlined),
        isSupported: client.doesSupportFeature(SPHAppEnum.nachrichten),
        enableBottomNavigation: true,
        enableDrawer: true,
        body: const ConversationsAnsicht()),
    Destination(
        label: "Mein Unterricht",
        icon: const Icon(Icons.school),
        selectedIcon: const Icon(Icons.school_outlined),
        isSupported: client.doesSupportFeature(SPHAppEnum.meinUnterricht),
        enableBottomNavigation: true,
        enableDrawer: true,
        body: const MeinUnterrichtAnsicht()),
    Destination(
        label: "Dateispeicher",
        icon: const Icon(Icons.folder_copy),
        selectedIcon: const Icon(Icons.folder_copy_outlined),
        isSupported: client.doesSupportFeature(SPHAppEnum.dateispeicher),
        enableBottomNavigation: false,
        enableDrawer: true,
        action: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DataStorageAnsicht()),
        )),
    Destination(
        label: "Lanis im Browser öffnen",
        icon: const Icon(Icons.open_in_new),
        selectedIcon: const Icon(Icons.open_in_new),
        isSupported: true,
        enableBottomNavigation: false,
        enableDrawer: true,
        action: (context) {
          client.getLoginURL().then((response) {
            launchUrl(Uri.parse(response));
          });
        }),
    Destination(
        label: "Moodle Login öffnen",
        icon: const Icon(Icons.open_in_new),
        selectedIcon: const Icon(Icons.open_in_new),
        isSupported: true,
        enableBottomNavigation: false,
        enableDrawer: true,
        action: (context) => launchUrl(
            Uri.parse("https://mo${client.schoolID}.schulportal.hessen.de"))),
    Destination(
        label: "Einstellungen",
        icon: const Icon(Icons.settings),
        selectedIcon: const Icon(Icons.settings),
        isSupported: true,
        enableBottomNavigation: false,
        enableDrawer: true,
        addDivider: true,
        action: (context) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            )),
    Destination(
      label: "Fehlerbericht senden",
      icon: const Icon(Icons.bug_report),
      selectedIcon: const Icon(Icons.bug_report_outlined),
      isSupported: true,
      enableBottomNavigation: false,
      enableDrawer: true,
      action: (context) => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BugReportScreen())),
    ),
  ];

  void setDefaultDestination() {
    for (var destination in destinations) {
      if (destination.isSupported && destination.enableBottomNavigation) {
        selectedDestinationDrawer = destinations.indexOf(destination);
        doesSupportAnyApplet = true;
        return;
      }
    }
    selectedDestinationDrawer = -1;
  }

  @override
  void initState() {
    super.initState();
    setDefaultDestination();
  }

  void openLanisInBrowser(BuildContext? context) {
    client.getLoginURL().then((response) {
      launchUrl(Uri.parse(response));
    }).catchError((ex) {
      if (context == null) return;
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

  Widget noAppsSupported() {
    return Center(
      // In case no feature is supported at all just show an open in browser button.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.disabled_by_default_outlined,
            size: 150,
          ),
          const Padding(
            padding: EdgeInsets.all(32),
            child: Text(
                "Es scheint so, als ob dein Account oder deine Schule keine Features dieser App direkt unterstützt! Stattdessen kannst du Lanis noch im Browser öffnen."),
          ),
          ElevatedButton(
              onPressed: () => openLanisInBrowser(context),
              child: const Text("Im Browser öffnen"))
        ],
      ),
    );
  }

  void openDestination(int index, bool fromDrawer) {
    if (destinations[index].action != null) {
      destinations[index].action!(context);
    } else {
      setState(() {
        selectedDestinationDrawer = index;
        if (fromDrawer) Navigator.pop(context);
      });
    }
  }

  NavigationDrawer navDrawer(context) {
    List<Widget> drawerDestinations = [];

    for (var destination in destinations) {
      if (destination.enableDrawer) {
        if (destination.addDivider) {
          drawerDestinations.add(const Divider());
        }
        drawerDestinations.add(NavigationDrawerDestination(
          label: Text(destination.label),
          icon: destination.icon,
          selectedIcon: destination.selectedIcon,
          enabled: destination.isSupported,
        ));
      }
    }

    final Color imageColor =
        Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5);
    final Color textColor =
        imageColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

    return NavigationDrawer(
        selectedIndex: selectedDestinationDrawer,
        onDestinationSelected: (int index) => openDestination(index, true),
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
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://startcache.schulportal.hessen.de/exporteur.php?a=schoolbg&i=${client.schoolID}&s=xs",
                          fadeInDuration: const Duration(milliseconds: 0),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Image(
                            image: AssetImage("assets/icon.png"),
                            fit: BoxFit.cover,
                          ),
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
                        "${client.userData["nachname"]}, ${client.userData["vorname"]}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold, color: textColor),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          ...drawerDestinations,
        ]);
  }

  NavigationBar navBar(context) {
    List<NavigationDestination> barDestinations = [];

    for (var destination in destinations) {
      if (destination.enableBottomNavigation && destination.isSupported) {
        barDestinations.add(NavigationDestination(
          label: destination.label,
          icon: destination.icon,
          selectedIcon: destination.selectedIcon,
          enabled: destination.isSupported,
          tooltip: destination.label,
        ));
      }
    }

    List<int?> indexNavbarTranslationLayer = [];

    int helpIndex = 0;
    for (var destination in destinations) {
      if (destination.enableBottomNavigation && destination.isSupported) {
        indexNavbarTranslationLayer.add(helpIndex);
        helpIndex += 1;
      } else {
        indexNavbarTranslationLayer.add(null);
      }
    }
    return NavigationBar(
      destinations: barDestinations,
      selectedIndex: indexNavbarTranslationLayer[selectedDestinationDrawer]!,
      onDestinationSelected: (int index) =>
          openDestination(indexNavbarTranslationLayer.indexOf(index), false),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InternetStatus>(
        stream: connectionChecker.onStatusChange,
        builder: (context, network) {
          return Scaffold(
              appBar: AppBar(
                title: Text(doesSupportAnyApplet
                    ? destinations[selectedDestinationDrawer].label
                    : "Im Browser öffnen"),
                bottom: network.data == InternetStatus.disconnected
                    ? PreferredSize(
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
                                "Keine Verbindung! Geladene Daten sind noch aufrufbar!",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
              body: doesSupportAnyApplet
                  ? destinations[selectedDestinationDrawer].body
                  : noAppsSupported(),
              bottomNavigationBar:
                  doesSupportAnyApplet ? navBar(context) : null,
              drawer: navDrawer(context));
        });
  }
}