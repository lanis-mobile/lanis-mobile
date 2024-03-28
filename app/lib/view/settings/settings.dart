import 'package:sph_plan/view/settings/subsettings/about.dart';
import 'package:sph_plan/view/settings/subsettings/clear_cache.dart';
import 'package:sph_plan/view/settings/subsettings/countly_analysis.dart';
import 'package:sph_plan/view/settings/subsettings/notifications.dart';
import 'package:sph_plan/view/settings/subsettings/supported_features.dart';
import 'package:sph_plan/view/settings/subsettings/theme_changer.dart';
import 'package:sph_plan/view/settings/subsettings/userdata.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person_pin),
            title: Text(AppLocalizations.of(context)!.userData),
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
            title: Text(AppLocalizations.of(context)!.personalSchoolSupport),
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
            title: Text(AppLocalizations.of(context)!.appearance),
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
              title: Text(AppLocalizations.of(context)!.notifications),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const NotificationsSettingsScreen()),
                );
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.storage),
            title: Text(AppLocalizations.of(context)!.clearCache),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClearCacheScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: Text(AppLocalizations.of(context)!.telemetry),
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
            title: Text(AppLocalizations.of(context)!.about),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.reallyReset),
                content: Text(AppLocalizations.of(context)!.allSettingsWillBeLost),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, AppLocalizations.of(context)!.cancel),
                    child:  Text(AppLocalizations.of(context)!.cancel),
                  ),
                  TextButton(
                    onPressed: () {
                      client.deleteAllSettings().then((_) {
                        Navigator.pop(context, 'OK');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const WelcomeLoginScreen()));
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
