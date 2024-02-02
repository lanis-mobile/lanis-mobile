import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../client/storage.dart';

class CountlySettingsScreen extends StatelessWidget {
  const CountlySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Countly"),
        ),
        body: const Body()
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool enabled = true;

  @override
  void initState() {
    super.initState();
    globalStorage.read(key: StorageKey.settingsUseCountly).then((value) {
      enabled = value == "true";
      setState(() {});
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Countly Server'),
          subtitle: const Text('Wir nutzen Countly um anonyme Bugreports automatisch an die Entwickler zu senden. Dabei werden keine Daten an dritte weitergegeben.'),
          onTap: () {
            launchUrl(Uri.parse("https://countly.com/lite")
            );
          },
        ),
        SwitchListTile(
            value: enabled,
            title: const Text("Anonyme Bugreports senden"),
            onChanged: (state) async {
          setState(() {
            enabled = state;
          });
          await globalStorage.write(key: StorageKey.settingsUseCountly, value: state.toString());
        }),
      ],
    );
  }
}

