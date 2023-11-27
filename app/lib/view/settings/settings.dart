import 'package:sph_plan/view/about/about.dart';
import 'package:sph_plan/view/settings/subsettings/notifications.dart';
import 'package:sph_plan/view/settings/subsettings/theme_changer.dart';
import 'package:sph_plan/view/userdata/userdata.dart';

import 'subsettings/user_login.dart';

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
            leading: const Icon(Icons.person),
            title: const Text('Account Einstellungen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_pin),
            title: const Text('Benutzerdaten'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserdataAnsicht()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.landscape_rounded),
            title: const Text('App Aussehen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppearanceSettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Benachrichtigungen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsSettingsScreen()),
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
        ],
      ),
    );
  }
}