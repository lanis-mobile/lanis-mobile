import 'package:sph_plan/view/settings/subsettings/about.dart';
import 'package:sph_plan/view/settings/subsettings/countly_analysis.dart';
import 'package:sph_plan/view/settings/subsettings/start_apps.dart';
import 'package:sph_plan/view/settings/subsettings/notifications.dart';
import 'package:sph_plan/view/settings/subsettings/supported_features.dart';
import 'package:sph_plan/view/settings/subsettings/theme_changer.dart';
import 'package:sph_plan/view/settings/subsettings/userdata.dart';

import '../../shared/apps.dart';
import '../login/screen.dart';
import '../../client/client.dart';

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Einstellungen"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person_pin),
            title: const Text('Benutzerdaten'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserdataAnsicht()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.apps),
            title: const Text('Unterstützung für deine Schule'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const SupportedFeaturesOverviewScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.landscape_rounded),
            title: const Text('Aussehen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AppearanceSettingsScreen()),
              );
            },
          ),
          if (client.doesSupportFeature(SPHAppEnum.vertretungsplan)) ...[
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Benachrichtigungen'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsSettingsScreen()),
                );
              },
            ),
          ],
          if (client.applets!.isNotEmpty) ...[
            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Startapps'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoadModeScreen()),
                );
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Countly Bugreports'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CountlySettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_outlined),
            title: const Text('Über die App'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('App Zurücksetzen | Ausloggen'),
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Wirklich zurücksetzen?'),
                content: const Text('Alle Einstellungen werden Gelöscht.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Abbrechen'),
                    child: const Text('Abbrechen'),
                  ),
                  TextButton(
                    onPressed: () {
                      client.deleteAllSettings().then((_) {
                        Navigator.pop(context, 'OK');
                        Navigator.push(
                          context,
                            MaterialPageRoute(
                                builder: (context) => const WelcomeLoginScreen()
                            )
                        );
                      });
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
