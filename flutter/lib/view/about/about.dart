import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    double padding = 10.0;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Made with love by Alessio Caputo'),
            onTap: () {
              launchUrl(Uri.parse("https://github.com/alessioC42"));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report a Bug'),
            onTap: () {
              // Navigate to the bug report URL
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_comment),
            title: const Text('Feature Request'),
            onTap: () {
              launchUrl(Uri.parse("https://github.com/alessioC42/SPH-vertretungsplan/issues/new/choose"));
            },
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Last Release'),
            onTap: () {
              launchUrl(Uri.parse("https://github.com/alessioC42/SPH-vertretungsplan/issues/new/choose"));
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('GitHub Repository'),
            onTap: () {
              launchUrl(Uri.parse("https://github.com/alessioC42/SPH-vertretungsplan"));
            },
          ),
        ],
      ),
    );
  }
}
