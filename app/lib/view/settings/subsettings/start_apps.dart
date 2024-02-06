import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sph_plan/client/client.dart';

import '../../../client/storage.dart';

class LoadModeScreen extends StatelessWidget {
  const LoadModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Startapps"),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              LoadModeElements(),
            ],
          ),
        )
    );
  }
}

class LoadModeElements extends StatefulWidget {
  const LoadModeElements({super.key});

  @override
  State<LoadModeElements> createState() => _LoadModeElementsState();
}

class _LoadModeElementsState extends State<LoadModeElements> {
  IconData getIcon(String name) {
    switch (name) {
      case "Vertretungsplan":
        return Icons.people;
      case "Mein Unterricht":
        return Icons.school;
      case "Nachrichten":
        return Icons.forum;
      case "Kalender":
        return Icons.calendar_today;
      default:
        return Icons.help;
    }
  }

  @override
  void initState() {
    client.initialiseLoadApps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (client.loadApps!.isEmpty) {
      return const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Es werden keine Apps unterstützt!")
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: client.loadApps!.length,
            itemBuilder: (context, index) {
              final String name = client.loadApps!.keys.elementAt(index);
              final bool state = client.loadApps!.values.elementAt(index);
              return CheckboxListTile(
                secondary: Icon(getIcon(name)),
                subtitle: name == "Kalender" ? const Text("Der Kalender wird nicht neu geladen.") : null,
                title: Text(name),
                  value: state,
                  onChanged: (value) async {
                    setState(() {
                      client.loadApps![name] = value!;
                    });
                    await globalStorage.write(key: StorageKey.settingsLoadApps, value: json.encode(client.loadApps!));
                  }
              );
            }
        ),
        ListTile(
          title: const Text('Update-Intervall'),
          trailing: Text('${client.updateAppsIntervall} min', style: const TextStyle(fontSize: 14)),
          subtitle: const Text("Die App muss neugestartet werden, damit die Änderung in Kraft gesetzt wird."),
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
            await globalStorage.write(key: StorageKey.settingsUpdateAppsIntervall, value: client.updateAppsIntervall.toString());
          },
        ),
        const ListTile(
          leading: Icon(Icons.info),
          title: Text("Information"),
          subtitle: Text("Die hier ausgewählten Apps werden bei Appstart automatisch geladen, damit du deine wichtigsten Apps direkt sehen kannst. Außerdem kannst du sie einstellen, wann sie immer neu geladen werden sollen."),
        ),
      ],
    );
  }
}

