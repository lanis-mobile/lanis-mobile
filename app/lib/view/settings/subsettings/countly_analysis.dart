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
            onChanged: (state){
          setState(() async {
            enabled = state;
            await globalStorage.write(key: "enable-countly", value: state.toString());
          });
        }),
      ],
    );
  }
}

