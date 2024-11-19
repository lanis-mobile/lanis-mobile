import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:sph_plan/background_service.dart';
import 'package:sph_plan/shared/apps.dart';
import 'package:sph_plan/shared/exceptions/client_status_exceptions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:sph_plan/shared/widgets/whats_new.dart';
import 'package:sph_plan/utils/cached_network_image.dart';
import 'package:sph_plan/view/calendar/calendar.dart';
import 'package:sph_plan/view/conversations/overview.dart';
import 'package:sph_plan/view/data_storage/data_storage.dart';
import 'package:sph_plan/view/mein_unterricht/mein_unterricht.dart';
import 'package:sph_plan/view/moodle.dart';
import 'package:sph_plan/view/settings/settings.dart';
import 'package:sph_plan/view/timetable/stream.dart';
import 'package:sph_plan/view/substitutions/stream.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sph_plan/core/connection_checker.dart';

import 'core/sph/sph.dart';

class Destination {
  final Icon icon;
  final Icon selectedIcon;
  final bool enableBottomNavigation;
  final bool enableDrawer;
  final bool addDivider;
  final Function label;
  final Function? action;
  final Widget? body;
  late final bool isSupported;

  Destination(
      {this.body,
      this.action,
      this.addDivider = false,
      required this.isSupported,
      required this.enableBottomNavigation,
      required this.enableDrawer,
      required this.icon,
      required this.selectedIcon,
      required this.label});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedDestinationDrawer;
  late bool doesSupportAnyApplet = false;

  @override
  void initState() {
    super.initState();
    setDefaultDestination();
    showUpdateInfoIfRequired(context);
  }

  List<Destination> destinations = [
    Destination(
        label: (context) => AppLocalizations.of(context)!.openMoodle,
        icon: const Icon(Icons.open_in_new),
        selectedIcon: const Icon(Icons.open_in_new),
        isSupported: true,
        enableBottomNavigation: false,
        enableDrawer: true,
        action: (context) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MoodleWebView())
        )),
    Destination(
        label: (context) => AppLocalizations.of(context)!.openLanisInBrowser,
        icon: const Icon(Icons.open_in_new),
        selectedIcon: const Icon(Icons.open_in_new),
        isSupported: true,
        enableBottomNavigation: false,
        enableDrawer: true,
        action: (context) {
          sph!.session.getLoginURL().then((response) {
            launchUrl(Uri.parse(response));
          });
        }),
    Destination(
        label: (context) => AppLocalizations.of(context)!.settings,
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


  void openLanisInBrowser(BuildContext? context) {
    sph!.session.getLoginURL().then((response) {
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
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(AppLocalizations.of(context)!.noSupportOpenInBrowser),
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
          label: Text(destination.label(context)),
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
                          imageUrl: Uri.parse("https://startcache.schulportal.hessen.de/exporteur.php?a=schoolbg&i=${client.schoolID}&s=xs"),
                          placeholder: const Image(
                            image: AssetImage("assets/icon.png"),
                            fit: BoxFit.cover,
                          ),
                          builder: (BuildContext context, ImageProvider<Object> imageProvider) {
                            return Image(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            );
                          },
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
          label: destination.label(context),
          icon: destination.icon,
          selectedIcon: destination.selectedIcon,
          enabled: destination.isSupported,
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
    return StreamBuilder<ConnectionStatus>(
        stream: connectionChecker.statusStream,
        builder: (context, network) {
          return Scaffold(
              appBar: AppBar(
                title: Text(doesSupportAnyApplet
                    ? destinations[selectedDestinationDrawer].label(context)
                    : AppLocalizations.of(context)!.openLanisInBrowser),
                bottom: network.data == ConnectionStatus.disconnected
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
                                AppLocalizations.of(context)!
                                    .noInternetConnection1,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
                actions: [
                  if (kDebugMode) ...[
                    IconButton(
                      onPressed: (){
                      throw ErrorDescription("Test Error in debug mode");
                      }, icon: const Icon(Icons.nearby_error),
                      tooltip: "Throw test Error",
                    ),
                    IconButton(
                      onPressed: (){
                        updateNotifications();
                      }, icon: const Icon(Icons.notifications),
                      tooltip: "Simulate notification update"
                    )
                  ]
                ],
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
