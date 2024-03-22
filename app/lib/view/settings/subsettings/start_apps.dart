import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sph_plan/client/client.dart';
import 'package:sph_plan/shared/apps.dart';

import '../../../client/storage.dart';
import '../../../shared/types/startup_app.dart';
import '../info_button.dart';

class LoadModeScreen extends StatelessWidget {
  const LoadModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Startapps"),
          actions: [
            InfoButton(
                infoText:
                    "Anstatt Apps erst zu laden, wenn du sie verwendest, kannst du hier deine wichtigsten Apps auswählen, damit sie direkt bei App-Start geladen werden und du sie sofort verwenden kannst. Außerdem kannst du festlegen, wann sie automatisch geladen werden sollen, damit du immer auf dem neuesten Stand bist.",
                context: context),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: ListView(children: const [
            Column(
              children: [
                LoadModeElements(),
              ],
            )
          ]),
        ));
  }
}

class LoadModeElements extends StatefulWidget {
  const LoadModeElements({super.key});

  @override
  State<LoadModeElements> createState() => _LoadModeElementsState();
}

class _LoadModeElementsState extends State<LoadModeElements> {
  IconData getIcon(SPHAppEnum applet) {
    switch (applet) {
      case SPHAppEnum.vertretungsplan:
        return Icons.people;
      case SPHAppEnum.meinUnterricht:
        return Icons.school;
      case SPHAppEnum.nachrichten:
        return Icons.forum;
      case SPHAppEnum.kalender:
        return Icons.calendar_today;
      default:
        return Icons.help;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (client.applets.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text("Es werden keine Apps unterstützt!")],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: client.applets.length,
            itemBuilder: (context, index) {
              final LoadApp loadApp = client.applets.values.elementAt(index);
              return CheckboxListTile(
                  secondary: Icon(getIcon(loadApp.applet)),
                  subtitle: loadApp.applet == SPHAppEnum.kalender
                      ? const Text("Der Kalender wird nicht neu geladen.")
                      : null,
                  title: Text(loadApp.applet.fullName),
                  value: loadApp.shouldFetch,
                  onChanged: (value) async {
                    setState(() {
                      loadApp.shouldFetch = value!;
                    });

                    // To JSON
                    final Map<String, bool> jsonLoadApps = {};
                    for (final applet in client.applets.keys) {
                      jsonLoadApps.addEntries([
                        MapEntry(applet.name, client.applets[applet]!.shouldFetch)
                      ]);
                    }

                    await globalStorage.write(
                        key: StorageKey.settingsShouldFetchApplets,
                        value: json.encode(jsonLoadApps));
                  });
            }),
        ListTile(
          title: const Text('Update-Intervall'),
          trailing: Text('${client.updateAppsIntervall} min',
              style: const TextStyle(fontSize: 14)),
          subtitle: const Text(
              "Die App muss neu gestartet werden, damit eine Änderung wirksam wird."),
        ),
        Slider(
          value: client.updateAppsIntervall.toDouble(),
          min: 10,
          max: 45,
          onChanged: (double value) {
            setState(() {
              client.updateAppsIntervall = value.toInt(); // Umwandlung zu int
            });
          },
          onChangeEnd: (double value) async {
            await globalStorage.write(
                key: StorageKey.settingsUpdateAppsIntervall,
                value: client.updateAppsIntervall.toString());
          },
        ),
      ],
    );
  }
}
